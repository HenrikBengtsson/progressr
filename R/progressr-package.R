#' progressr: A Unifying API for Progress Updates
#'
#' The \pkg{progressr} package provides a minimal, unifying API for scripts
#' and packages to report progress updates from anywhere including when
#' using parallel processing.
#'
#' The package is designed such that _the developer_ can to focus on _what_
#' progress should be reported on without having to worry about _how_ to
#' present it.
#'
#' The _end user_ has full control of _how_, _where_, and _when_ to render
#' these progress updates.  For instance, they can chose to report progress
#' in the terminal using [utils::txtProgressBar()] or
#' [progress::progress_bar()] or via the graphical user interface (GUI)
#' using `utils::winProgressBar()` or [tcltk::tkProgressBar()].
#' An alternative to above visual rendering of progress, is to report it
#' using [beepr::beep()] sounds.
#' It is possible to use a combination of above progression handlers, e.g.
#' a progress bar in the terminal together with audio updates.
#' Besides the existing handlers, it is possible to develop custom
#' progression handlers.
#'
#' The \pkg{progressr} package uses R's condition framework for signaling
#' progress updated. Because of this, progress can be reported from almost
#' anywhere in R, e.g. from classical for and while loops, from map-reduce
#' APIs like the [lapply()] family of functions, \pkg{purrr}, \pkg{plyr}, and
#' \pkg{foreach}.
#' The \pkg{progressr} package will also work with parallel processing via
#' the \pkg{future} framework, e.g. [future.apply::future_lapply()],
#' [furrr::future_map()], and [foreach::foreach()] with \pkg{doFuture}.
#'
#' The \pkg{progressr} package is compatible with Shiny applications.
#'
#' @section Progression Handlers:
#'
#' In the terminal:
#' * [handler_txtprogressbar] (default)
#' * [handler_pbmcapply]
#' * [handler_progress]
#' * [handler_ascii_alert]
#' * [handler_debug]
#'
#' In the graphical user interface (GUI):
#' * [handler_tkprogressbar]
#' * [handler_winprogressbar]
#'
#' Via audio:
#' * [handler_beepr]
#' * [handler_ascii_alert]
#'
#' Via the file system:
#' * [handler_filesize]
#'
#' In Shiny:
#' * [withProgressShiny]
#'
#' @example incl/progressr-package.R
#'
#' @keywords programming iteration
#'
#' @docType package
#' @aliases progressr-package
#' @name progressr
NULL
