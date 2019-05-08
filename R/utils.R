hpaste <- function(..., sep="", collapse=", ", last_collapse=NULL,
                   max_head=if (missing(last_collapse)) 3 else Inf,
                   max_tail=if (is.finite(max_head)) 1 else Inf,
                   abbreviate="...") {
  max_head <- as.double(max_head)
  max_tail <- as.double(max_tail)
  if (is.null(last_collapse)) last_collapse <- collapse

  # Build vector 'x'
  x <- paste(..., sep = sep)
  n <- length(x)

  # Nothing todo?
  if (n == 0) return(x)
  if (is.null(collapse)) return(x)

  # Abbreviate?
  if (n > max_head + max_tail + 1) {
    head <- x[seq_len(max_head)]
    tail <- rev(rev(x)[seq_len(max_tail)])
    x <- c(head, abbreviate, tail)
    n <- length(x)
  }

  if (!is.null(collapse) && n > 1) {
    if (last_collapse == collapse) {
      x <- paste(x, collapse = collapse)
    } else {
      x_head <- paste(x[1:(n - 1)], collapse = collapse)
      x <- paste(x_head, x[n], sep = last_collapse)
    }
  }

  x
}

trim <- function(s) {
  sub("[\t\n\f\r ]+$", "", sub("^[\t\n\f\r ]+", "", s))
} # trim()

now <- function(x = Sys.time(), format = "[%H:%M:%OS3] ") {
  format(as.POSIXlt(x, tz = ""), format = format)
}

mdebug <- function(..., debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(now(), ...)
}

#' @importFrom utils capture.output
mprint <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture.output(print(...)), sep = "", collapse = "\n"), appendLF = appendLF)
}

#' @importFrom utils capture.output str
mstr <- function(..., appendLF = TRUE, debug = getOption("progressr.debug", FALSE)) {
  if (!debug) return()
  message(paste(now(), capture.output(str(...)), sep = "", collapse = "\n"), appendLF = appendLF)
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
