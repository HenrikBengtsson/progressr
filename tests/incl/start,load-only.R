## Record original state
ovars <- ls()
oenvs <- oenvs0 <- Sys.getenv()
oopts0 <- options()

## Default options for tests
oopts <- options()

## Private
mdebug <- progressr:::mdebug
mprint <- progressr:::mprint
mprintf <- progressr:::mprintf
mstr <- progressr:::mstr
stop_if_not <- progressr:::stop_if_not
known_progression_handlers <- progressr:::known_progression_handlers

non_supported_progression_handlers <- function() {
  names <- character(0L)
  for (pkg in c("beepr", "notifier", "pbmcapply", "progress", "shiny")) {
    if (!requireNamespace(pkg, quietly = TRUE))
      names <- c(names, pkg)
  }
  if (!"tcltk" %in% capabilities()) {
    names <- c(names, "tkprogressbar")
  }
  if (.Platform$OS.type != "windows") {
    names <- c(names, "winprogressbar")
  }
  paste0(names, "_handler")
}


## Settings
options(progressr.clear = TRUE)
options(progressr.debug = FALSE)
options(progressr.delay = 0.0)
options(progressr.enable = TRUE)
options(progressr.enable_after = 0.0)
options(progressr.interval = 0.1)
options(progressr.times = +Inf)


options(progressr.tests.fake_handlers = c(non_supported_progression_handlers(), "beepr_handler", "notifier_handler", "progress_handler"))


## WORKAROUND: Make sure tests also work with 'covr' package
covr <- ("covr" %in% loadedNamespaces())
if (covr) {
  globalenv <- function() parent.frame()
  baseenv <- function() environment(base::sample)
}

