## Create a universally unique identifier (UUID) for an R object
#' @importFrom digest digest
uuid <- function(source, keep_source = FALSE) {
  uuid <- digest(source)
  uuid <- strsplit(uuid, split = "")[[1]]
  uuid <- paste(c(uuid[1:8], "-", uuid[9:12], "-", uuid[13:16], "-", uuid[17:20], "-", uuid[21:32]), collapse = "")
  if (keep_source) attr(uuid, "source") <- source
  uuid
} ## uuid()


## A universally unique identifier (UUID) for the current
## R process UUID. Generated only once per process ID 'pid'.
## The 'pid' may differ when using forked processes.
session_uuid <- local({
  uuids <- list()

  function(pid = Sys.getpid(), attributes = FALSE) {
    pidstr <- as.character(pid)
    uuid <- uuids[[pidstr]]
    if (is.null(uuid)) {
      info <- Sys.info()
      host <- Sys.getenv(c("HOST", "HOSTNAME", "COMPUTERNAME"))
      host <- host[nzchar(host)]
      host <- if (length(host) == 0L) info[["nodename"]] else host[1L]
      info <- list(
        host = host,
        info = info,
        time = Sys.time(),
        tempdir = tempdir(),
        pid = pid,
        random = stealth_sample.int(.Machine$integer.max, size = 1L)
      )
      uuid <- uuid(info, keep_source = TRUE)
      uuids[[pidstr]] <<- uuid
    }
    
    if (!attributes) attr(uuid, "source") <- NULL
    
    uuid
  }
})


progressor_uuid <- function(id, attributes = FALSE) {
  uuid(list(session_uuid = session_uuid(), id = id), keep_source = attributes)
}

## A version of base::sample.int() that does not change .Random.seed
stealth_sample.int <- function(...) {
  oseed <- .GlobalEnv$.Random.seed
  on.exit({
    if (is.null(oseed)) {
      rm(list = ".Random.seed", envir = .GlobalEnv, inherits = FALSE)
    } else {
      .GlobalEnv$.Random.seed <- oseed
    }
  })
  suppressWarnings(sample.int(...))
}
