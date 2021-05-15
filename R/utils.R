## From R.utils 2.0.2 (2015-05-23)
hpaste <- function(..., sep = "", collapse = ", ", lastCollapse = NULL, maxHead = if (missing(lastCollapse)) 3 else Inf, maxTail = if (is.finite(maxHead)) 1 else Inf, abbreviate = "...") {
  if (is.null(lastCollapse)) lastCollapse <- collapse

  # Build vector 'x'
  x <- paste(..., sep = sep)
  n <- length(x)

  # Nothing todo?
  if (n == 0) return(x)
  if (is.null(collapse)) return(x)

  # Abbreviate?
  if (n > maxHead + maxTail + 1) {
    head <- x[seq_len(maxHead)]
    tail <- rev(rev(x)[seq_len(maxTail)])
    x <- c(head, abbreviate, tail)
    n <- length(x)
  }

  if (!is.null(collapse) && n > 1) {
    if (lastCollapse == collapse) {
      x <- paste(x, collapse = collapse)
    } else {
      xT <- paste(x[1:(n-1)], collapse = collapse)
      x <- paste(xT, x[n], sep = lastCollapse)
    }
  }

  x
} # hpaste()

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

mdebugf <- mprintf

mprint <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture_output(print(...)), sep = "", collapse = "\n"), appendLF = appendLF)
}

#' @importFrom utils str
mstr <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture_output(str(...)), sep = "", collapse = "\n"), appendLF = appendLF)
}

comma <- function(x, sep = ", ") paste(x, collapse = sep)

commaq <- function(x, sep = ", ") paste(sQuote(x), collapse = sep)

trim <- function(s) sub("[\t\n\f\r ]+$", "", sub("^[\t\n\f\r ]+", "", s))

stop_if_not <- function(..., calls = sys.calls()) {
  res <- list(...)
  n <- length(res)
  if (n == 0L) return()

  for (ii in 1L:n) {
    res_ii <- .subset2(res, ii)
    if (length(res_ii) != 1L || is.na(res_ii) || !res_ii) {
        mc <- match.call()
        call <- deparse(mc[[ii + 1]], width.cutoff = 60L)
        if (length(call) > 1L) call <- paste(call[1L], "...")
        msg <- sprintf("%s is not TRUE", sQuote(call))
        if (FALSE) {
          callstack <- paste(as.character(calls), collapse = " -> ")
          msg <- sprintf("%s [call stack: %s]", msg, callstack)
        }
        stop(msg, call. = FALSE, domain = NA)
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

known_progression_handlers <- function(exclude = NULL) {
  ns <- asNamespace(.packageName)
  handlers <- ls(envir = ns, pattern = "^handler_")
  handlers <- setdiff(handlers, c("handler_backend_args", "make_progression_handler", "print.progression_handler"))
  handlers <- setdiff(handlers, exclude)
  handlers <- mget(handlers, envir = ns, inherits = FALSE)
  handlers
}


`%||%` <- function(lhs, rhs) {
  if (is.null(lhs)) rhs else lhs
}


## From R.utils 2.7.0 (2018-08-26)
query_r_cmd_check <- function(...) {
  evidences <- list()

  # Command line arguments
  args <- commandArgs()

  evidences[["vanilla"]] <- is.element("--vanilla", args)

  # Check the working directory
  pwd <- getwd()
  dirname <- basename(pwd)
  parent <- basename(dirname(pwd))
  pattern <- ".+[.]Rcheck$"

  # Is 'R CMD check' checking tests?
  evidences[["tests"]] <- (
    grepl(pattern, parent) && grepl("^tests(|_.*)$", dirname)
  )

  # Is the current working directory as expected?
  evidences[["pwd"]] <- (evidences[["tests"]] || grepl(pattern, dirname))

  # Is 'R CMD check' checking examples?
  evidences[["examples"]] <- is.element("CheckExEnv", search())
  
  # SPECIAL: win-builder?
  evidences[["win-builder"]] <- (.Platform$OS.type == "windows" && grepl("Rterm[.]exe$", args[1]))

  if (evidences[["win-builder"]]) {
    n <- length(args)
    if (all(c("--no-save", "--no-restore", "--no-site-file", "--no-init-file") %in% args)) {
      evidences[["vanilla"]] <- TRUE
    }

    if (grepl(pattern, parent)) {
      evidences[["pwd"]] <- TRUE
    }
  }


  if (!evidences$vanilla || !evidences$pwd) {
    res <- "notRunning"
  } else if (evidences$tests) {
    res <- "checkingTests"
  } else if (evidences$examples) {
    res <- "checkingExamples"
  } else {
    res <- "notRunning"
  }

  attr(res, "evidences") <- evidences
  
  res
}

in_r_cmd_check <- function() { query_r_cmd_check() != "notRunning" }
