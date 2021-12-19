#' Options and environment variables used by the 'progressr' packages
#'
#' Below are environment variables and \R options that are used by the
#' \pkg{progressr} package.
#
#' Below are all \R options that are currently used by the \pkg{progressr} package.\cr
#' \cr
#' \emph{WARNING: Note that the names and the default values of these options may change in future versions of the package.  Please use with care until further notice.}
#'
#'
#' @section Options for controlling progression reporting:
#'
#' \describe{
#'   \item{\option{progressr.handlers}:}{
#'     (function or list of functions)
#'     Zero or more progression handlers that will report on any progression updates.  If empty list, progress updates are ignored.  If NULL, the default (`handler_txtprogressbar`) progression handlers is used.  The recommended way to set this option is via [progressr::handlers()]. (Default: NULL)
#'   }
#' }
#'
#'
#' @section Options for controlling progression handlers:
#'
#' \describe{
#'   \item{\option{progressr.clear}:}{
#'     (logical)
#'     If TRUE, any output, typically visual, produced by a reporter will be cleared/removed upon completion, if possible. (Default: TRUE)
#'   }
#'
#'   \item{\option{progressr.enable}:}{
#'     (logical)
#'     If FALSE, then progress is not reported.
#'     (Default: TRUE)
#'   }
#'
#'   \item{\option{progressr.enable_after}:}{
#'     (numeric)
#'     Delay (in seconds) before progression updates are reported.
#'     (Default: `0.0`)
#'   }
#'
#'   \item{\option{progressr.times}:}{
#'     (numeric)
#'     The maximum number of times a handler should report progression updates. If zero, then progress is not reported.
#'     (Default: `+Inf`)
#'   }
#'
#'   \item{\option{progressr.interval}:}{
#'     (numeric)
#'     The minimum time (in seconds) between successive progression updates from this handler.
#'     (Default: `0.0`)
#'   }
#'
#'   \item{\option{progressr.intrusiveness}:}{
#'     (numeric)
#'     A non-negative scalar on how intrusive (disruptive) the reporter to the user. This multiplicative scalar applies to the _interval_ and _times_ parameters. (Default: `1.0`)\cr
#'   
#'     \describe{
#'       \item{\option{progressr.intrusiveness.auditory}:}{(numeric) intrusiveness for auditory progress handlers (Default: `5.0`)}
#'       \item{\option{progressr.intrusiveness.file}:}{(numeric) intrusiveness for file-based progress handlers (Default: `5.0`)}
#'       \item{\option{progressr.intrusiveness.gui}:}{(numeric) intrusiveness for graphical-user-interface progress handlers (Default: `1.0`)}
#'       \item{\option{progressr.intrusiveness.notifier}:}{(numeric) intrusiveness for progress handlers that creates notifications (Default: `10.0`)}
#'       \item{\option{progressr.intrusiveness.terminal}:}{(numeric) intrusiveness for progress handlers that outputs to the terminal (Default: `1.0`)}
#'       \item{\option{progressr.intrusiveness.debug}:}{(numeric) intrusiveness for "debug" progress handlers (Default: `0.0`)}
#'     }
#'   }
#' }
#'
#' @section Options for controlling how standard output and conditions are relayed:
#'
#' \describe{
#'   \item{\option{progressr.delay_conditions}:}{
#'     (character vector)
#'     condition classes to be captured and relayed at the end after any captured standard output is relayed. (Default: `c("condition")`)
#'   }
#'
#'   \item{\option{progressr.delay_stdout}:}{
#'     (logical)
#'     If TRUE, standard output is captured and relayed at the end just before any captured conditions are relayed. (Default: TRUE)
#'   }
#' }
#'
#' @section Options for controlling interrupts:
#'
#' \describe{
#'   \item{\option{progressr.interrupts}:}{
#'     (logical)
#'     Controls whether interrupts should be detected or not.
#'     If FALSE, then interrupts are not detected and progress information
#'     is generated. (Default: `TRUE`)
#'   }
#'
#'   \item{\option{progressr.delay_stdout}:}{
#'     (logical)
#'     If TRUE, standard output is captured and relayed at the end just before any captured conditions are relayed. (Default: TRUE)
#'   }
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
#' @section Environment variables that set R options:
#' Some of the above \R \option{progressr.*} options can be set by corresponding
#' environment variable \env{R_PROGRESSR_*} _when the \pkg{progressr} package
#' is loaded_.
#' For example, if `R_PROGRESSR_ENABLE = "true"`, then option
#' \option{progressr.enable} is set to `TRUE` (logical).
#' For example, if `R_PROGRESSR_ENABLE_AFTER = "2.0"`, then option
#' \option{progressr.enable_after} is set to `2.0` (numeric).
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
#' progressr.interrupts
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


get_package_option <- function(name, default = NULL, package = .packageName) {
  if (!is.null(package)) {
    name <- paste(package, name, sep = ".")
  }
  getOption(name, default = default)
}

# Set an R option from an environment variable
update_package_option <- function(name, mode = "character", default = NULL, package = .packageName, split = NULL, trim = TRUE, disallow = c("NA"), force = FALSE, debug = FALSE) {
  if (!is.null(package)) {
    name <- paste(package, name, sep = ".")
  }

  mdebugf("Set package option %s", sQuote(name))

  ## Already set? Nothing to do?
  value <- getOption(name, NULL)
  if (!force && !is.null(value)) {
    mdebugf("Already set: %s", sQuote(value))
    return(getOption(name))
  }

  ## name="Pkg.foo.Bar" => env="R_PKG_FOO_BAR"
  env <- gsub(".", "_", toupper(name), fixed = TRUE)
  env <- paste("R_", env, sep = "")

  env_value <- value <- Sys.getenv(env, unset = NA_character_)
  if (is.na(value)) {  
    if (debug) mdebugf("Environment variable %s not set", sQuote(env))
    
    ## Nothing more to do?
    if (is.null(default)) return(getOption(name))

    if (debug) mdebugf("Use argument 'default': ", sQuote(default))
    value <- default
  }

  if (debug) mdebugf("%s=%s", env, sQuote(value))

  ## Trim?
  if (trim) value <- trim(value)

  ## Nothing to do?
  if (!nzchar(value)) return(getOption(name, default = default))

  ## Split?
  if (!is.null(split)) {
    value <- strsplit(value, split = split, fixed = TRUE)
    value <- unlist(value, use.names = FALSE)
    if (trim) value <- trim(value)
  }

  ## Coerce?
  mode0 <- storage.mode(value)
  if (mode0 != mode) {
    suppressWarnings({
      storage.mode(value) <- mode
    })
    if (debug) {
      mdebugf("Coercing from %s to %s: %s", mode0, mode, commaq(value))
    }
  }

  if (length(disallow) > 0) {
    if ("NA" %in% disallow) {
      if (any(is.na(value))) {
        stop(sprintf("Coercing environment variable %s=%s to %s would result in missing values for option %s: %s", sQuote(env), sQuote(env_value), sQuote(mode), sQuote(name), commaq(value)))
      }
    }
    if (is.numeric(value)) {
      if ("non-positive" %in% disallow) {
        if (any(value <= 0, na.rm = TRUE)) {
          stop(sprintf("Environment variable %s=%s specifies a non-positive value for option %s: %s", sQuote(env), sQuote(env_value), sQuote(name), commaq(value)))
        }
      }
      if ("negative" %in% disallow) {
        if (any(value < 0, na.rm = TRUE)) {
          stop(sprintf("Environment variable %s=%s specifies a negative value for option %s: %s", sQuote(env), sQuote(env_value), sQuote(name), commaq(value)))
        }
      }
    }
  }
  
  if (debug) {
    mdebugf("=> options(%s = %s) [n=%d, mode=%s]",
            dQuote(name), commaq(value),
            length(value), storage.mode(value))
  }

  do.call(options, args = structure(list(value), names = name))
  
  getOption(name, default = default)
}


## Set package options based on environment variables
update_package_options <- function(debug = FALSE) {
  update_package_option("demo.delay", mode = "numeric", debug = debug)

  ## make_progression_handler() arguments
  update_package_option("clear", mode = "logical", default = TRUE, debug = debug)
  update_package_option("enable", mode = "logical", default = interactive(), debug = debug)
  update_package_option("enable_after", mode = "numeric", default = 0.0, debug = debug)
  update_package_option("interval", mode = "numeric", default = 0.0, debug = debug)
  update_package_option("times", mode = "numeric", default = +Inf, debug = debug)
  update_package_option("interrupts", mode = "logical", default = TRUE, debug = debug)
  update_package_option("interrupt.message", mode = "character", default = "interrupt detected", debug = debug)

  ## Life-cycle, e.g. deprecation an defunct
  update_package_option("lifecycle.progress", mode = "character", default = "deprecated", debug = debug)

  ## However, not used
  update_package_option("global.handler", mode = "logical", debug = debug)
}
