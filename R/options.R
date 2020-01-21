#' Options used for progressr
#'
#' Below are all \R options that are currently used by the \pkg{progressr} package.\cr
#' \cr
#' \emph{WARNING: Note that the names and the default values of these options may change in future versions of the package.  Please use with care until further notice.}
#'
#'
#' @section Options for controlling progression reporting:
#'
#' \describe{
#'  \item{\option{progressr.handlers}:}{(function or list of functions) Zero or more progression handlers that will report on any progression updates.  If empty list, progress updates are ignored.  If NULL, the default (`handler_txtprogressbar`) progression handlers is used.  The recommended way to set this option is via [progressr::handlers()]. (Default: NULL)}
#' }
#'
#'
#' @section Options for controlling progression handlers:
#'
#' \describe{
#'  \item{\option{progressr.clear}:}{(logical) If TRUE, any output, typically visual, produced by a reporter will be cleared/removed upon completion, if possible. (Default: TRUE)}
#'
#'  \item{\option{progressr.enable}:}{(logical) If FALSE, then progress is not reported. (Default: TRUE)}
#'
#'  \item{\option{progressr.enable_after}:}{(numeric) Delay (in seconds) before progression updates are reported. (Default: `0.0`)}
#'
#'  \item{\option{progressr.times}:}{(numeric) The maximum number of times a handler should report progression updates. If zero, then progress is not reported. (Default: `+Inf`)}
#'
#'  \item{\option{progressr.interval}:}{(numeric) The minimum time (in seconds) between successive progression updates from this handler. (Default: `0.0`)}
#'
#'  \item{\option{progressr.intrusiveness}:}{(numeric) A non-negative scalar on how intrusive (disruptive) the reporter to the user. This multiplicative scalar applies to the _interval_ and _times_ parameters. (Default: `1.0`)\cr
#'   
#'   \describe{
#'     \item{\option{progressr.intrusiveness.auditory}:}{(numeric) intrusiveness for auditory progress handlers (Default: `5.0`)}
#'     \item{\option{progressr.intrusiveness.file}:}{(numeric) intrusiveness for file-based progress handlers (Default: `5.0`)}
#'     \item{\option{progressr.intrusiveness.gui}:}{(numeric) intrusiveness for graphical-user-interface progress handlers (Default: `1.0`)}
#'     \item{\option{progressr.intrusiveness.notifier}:}{(numeric) intrusiveness for progress handlers that creates notifications (Default: `10.0`)}
#'     \item{\option{progressr.intrusiveness.terminal}:}{(numeric) intrusiveness for progress handlers that outputs to the terminal (Default: `1.0`)}
#'     \item{\option{progressr.intrusiveness.debug}:}{(numeric) intrusiveness for "debug" progress handlers (Default: `0.0`)}
#'   }
#'  }
#' }
#'
#' @section Options for controlling how standard output and conditions are relayed:
#'
#' \describe{
#'  \item{\option{progressr.delay_conditions}:}{(character vector) condition classes to be captured and relayed at the end after any captured standard output is relayed. (Default: `c("condition")`)}
#'
#'  \item{\option{progressr.delay_stdout}:}{(logical) If TRUE, standard output is captured and relayed at the end just before any captured conditions are relayed. (Default: TRUE)}
#' }
#'
#'
#' @section Options for debugging progression updates:
#'
#' \describe{
#'  \item{\option{progressr.debug}:}{(logical) If TRUE, extensive debug messages are generated. (Default: FALSE)}
#' }
#'
#'
#' @section Options for progressr examples and demos:
#'
#' \describe{
#'  \item{\option{progressr.demo.delay}:}{(numeric) Delay (in seconds) between each iteration of [slow_sum()]. (Default: `1.0`)}
#' }
#'
#'
#' @seealso
#' To set \R options when \R starts (even before the \pkg{progressr} package is loaded), see the \link[base]{Startup} help page.  The \href{https://cran.r-project.org/package=startup}{\pkg{startup}} package provides a friendly mechanism for configuring \R at startup.
#'
#' @aliases
#' progressr.clear
#' progressr.debug
#' progressr.demo.delay
#' progressr.delay_stdout progressr.delay_conditions
#' progressr.enable progressr.enable_after
#' progressr.interval
#' progressr.intrusiveness
#' progressr.intrusiveness.auditory
#' progressr.intrusiveness.debug
#' progressr.intrusiveness.file
#' progressr.intrusiveness.gui
#' progressr.intrusiveness.notifier
#' progressr.intrusiveness.terminal
#' progressr.handlers
#' progressr.times
#'
#' @keywords internal
#' @name progressr.options
NULL
