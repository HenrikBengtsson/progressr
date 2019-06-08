# More efficient than the default utils::capture.output()
#' @importFrom utils capture.output
capture_output <- function(expr, envir = parent.frame(), ...) {
  res <- eval({
    file <- rawConnection(raw(0L), open = "w")
    on.exit(close(file))
    capture.output(expr, file = file)
    rawToChar(rawConnectionValue(file))
  }, envir = envir, enclos = baseenv())
  unlist(strsplit(res, split = "\n", fixed = TRUE), use.names = FALSE)
}

now <- function(x = Sys.time(), format = "[%H:%M:%OS3] ") {
  format(as.POSIXlt(x, tz = ""), format = format)
}

mdebug <- function(..., debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(now(), ...)
}

mprintf <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(now(), sprintf(...), appendLF = appendLF)
}

mprint <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture_output(print(...)), sep = "", collapse = "\n"), appendLF = appendLF)
}

#' @importFrom utils str
mstr <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture_output(str(...)), sep = "", collapse = "\n"), appendLF = appendLF)
}

stop_if_not <- function(...) {
  res <- list(...)
  n <- length(res)
  if (n == 0L) return()

  for (ii in 1L:n) {
    res_ii <- .subset2(res, ii)
    if (length(res_ii) != 1L || is.na(res_ii) || !res_ii) {
        mc <- match.call()
        call <- deparse(mc[[ii + 1]], width.cutoff = 60L)
        if (length(call) > 1L) call <- paste(call[1L], "...")
        stop(sQuote(call), " is not TRUE", call. = FALSE, domain = NA)
    }
  }
}


## Used for package testing purposes only when we want to perform
## everything except the last part where the backend is called
## This allows us to cover more of the code in package tests
is_fake <- local({
  cache <- list()
  function(name) {
    fake <- cache[[name]]
    if (is.null(fake)) {
      fake <- name %in% getOption("progressr.tests.fake_handlers")
      cache[[name]] <<- fake
    }
    fake
  }
})

known_progression_handlers <- function() {
  ns <- asNamespace(.packageName)
  handlers <- ls(envir = ns, pattern = "_handler$")
  handlers <- setdiff(handlers, "progression_handler")
  mget(handlers, envir = ns, inherits = FALSE)
}
