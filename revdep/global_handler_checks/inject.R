#' Run Reverse Package Dependency Checks with the Global Progression Handler Enabled
#'
#' @usage
#' R_BASE_STARTUP="$PWD/revdep/global_handler_checks/inject.R" revdep/run.R
#'
#' @param R_BASE_STARTUP (environment variable) An absolute path to an R
#' script that should be loaded when the \pkg{base} package is loaded.
#'
#' @details
#' This script writes log output to the "${R_BASE_STARTUP}.log" file,
#' unless "${R_BASE_STARTUP_FILE}" is set in case that is used instead.
#'
#' @section Requirements:
#' For this to work, the \file{Rprofile} of the \pkg{base} package must
#' be tweaked. Specifically, append:
#'
#' ```
#' local(if(nzchar(f<-Sys.getenv("R_BASE_STARTUP"))) source(f))
#' ```
#' 
#' to file:
#'
#' ```
#' rprofile <- system.file(package = "base", "R", "Rprofile")
#' ```
#'
#' This requires write permissions to that file.
#'
#' @importFrom utils packageVersion
#' @importFrom progressr handlers
local({
  log_ <- function(..., prefix = sprintf("[%s/%d]: ", Sys.time(), Sys.getpid()), newline = TRUE, tee = stdout(), logfile = Sys.getenv("R_BASE_STARTUP_FILE")) {
    if (!nzchar(logfile)) {
      logfile <- Sys.getenv("R_BASE_STARTUP")
      logfile <- if (nzchar(logfile)) sprintf("%s.log", logfile) else NULL
    }
    msg <- sprintf(...)
    if (newline) msg <- paste(msg, "\n", sep = "")
    msg <- paste(prefix, msg, sep = "")
    msg <- paste(msg, collapse="")
    if (!is.null(tee)) cat(msg, file = tee, append = TRUE)
    if (!is.null(logfile)) cat(msg, file = logfile, append = TRUE)
  }

  debug <- nzchar(Sys.getenv("R_BASE_STARTUP_DEBUG"))
  if (debug) {
    log_("R_BASE_STARTUP_DEBUG=%s", Sys.getenv("R_BASE_STARTUP_DEBUG"))
    log_("R_BASE_STARTUP=%s", Sys.getenv("R_BASE_STARTUP"))
    log_("R_BASE_STARTUP_FILE=%s", Sys.getenv("R_BASE_STARTUP_FILE"))
  }

  ## R CMD check package tests?
  if (nzchar(testfile <- Sys.getenv("R_TESTS"))) {
    log_("commandArgs()=%s", paste(commandArgs(), collapse = " "))
    log_("R_LIBS_USER=%s", sQuote(Sys.getenv("R_LIBS_USER")))
    log_("R_LIBS_SITE=%s", sQuote(Sys.getenv("R_LIBS_SITE")))
    log_("R_LIBS=%s", sQuote(Sys.getenv("R_LIBS")))
    log_(".libPaths()=%s", paste(.libPaths(), collapse = " "))
    log_("R_TESTS=%s", sQuote(testfile))
    log_("getwd()=%s", getwd())

    ## Enable global progression handlers, if available
    if (requireNamespace("progressr", quietly = TRUE) && utils::packageVersion("progressr") >= "0.6.0-9001") {
      progressr::handlers(global = TRUE)
      log_("progressr::handlers(global=NA)=%s", progressr::handlers(global=NA))
    }
  }
})
