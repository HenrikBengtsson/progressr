#' Return a version of a known map-reduce function that supports progressr

#' @export
add_progressor <- function(fcn, ...) {
  stop_if_not(is.function(fcn))

  ## Supported or not?
  fcn_envir <- environment(fcn)
  fcn_envir_name <- environmentName(fcn_envir)

  injector <- NA
  if (fcn_envir_name == "base") {
    if (identical(fcn, base::lapply)) {
      injector <- inject_progressor_base_lapply
    }
  }

  if (is.function(injector)) {
    fcn2 <- injector(fcn)
    if (!is.function(fcn2)) {
      stop("Failed to inject progressr::progressor() to function: ", fcn_name)
    }
    return(fcn2)
  }
  
  if (is.na(injector)) {
    fcn_name <- deparse(substitute(fcn))
    stop("The provided function is not among known function for which we know we can or cannot inject support for progressor: ", fcn_name)
  }

  fcn_name <- deparse(substitute(fcn))
  stop("The provided function is unfortunately a function that is known to not be tweakable for progressor support: ", fcn_name)
}


inject_progressor_base_lapply <- function(fcn, ...) {
  stop_if_not(is.function(fcn))
  body <- body(fcn)
  n <- length(body)
  idx <- grep(".Internal(lapply(", body, fixed = TRUE)
  if (length(idx) != 1L) return(NULL)

  if (idx == 1L) {
    idxs <- c(NA_integer_, seq_len(n))
  } else {
    idxs <- c(seq_len(idx - 1L), NA_integer_, idx)
  }
  body <- body[idxs]

  body[[idx]] <- substitute(p <- progressr::progressor(along = X))

  body(fcn) <- body
  fcn
}
