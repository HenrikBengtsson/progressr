% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/global_progression_handler.R
\name{register_global_progression_handler}
\alias{register_global_progression_handler}
\title{Add or Remove a Global 'progression' Handler}
\usage{
register_global_progression_handler(action = c("add", "remove", "query"))
}
\arguments{
\item{action}{(character string)
If \code{"add"}, a global handler is added.
If \code{"remove"}, it is removed, if it exists.
If \code{"query"}, checks whether a handler is registered or not.}
}
\value{
Returns TRUE if a handler is registered, otherwise FALSE.
If \code{action = "query"}, the value is visible, otherwise invisible.
}
\description{
Add or Remove a Global 'progression' Handler
}
\section{Requirements}{

This function requires R (>= 4.0.0) - the version in which global calling
handlers where introduces.
}

\examples{
\dontshow{if (getRversion() >= "4.0.0" && !is.element("pkgdown", loadedNamespaces()))}
handlers(global = TRUE)

## This renders progress updates for each of the three calls slow_sum()
for (ii in 1:3) {
  xs <- seq_len(ii + 3)
  message(sprintf("\%d. slow_sum()", ii))
  y <- slow_sum(xs, stdout = TRUE, message = TRUE)
  print(y)
}

\dontshow{if (getRversion() >= "4.0.0" && !is.element("pkgdown", loadedNamespaces()))}
handlers(global = FALSE)
}
\keyword{internal}
