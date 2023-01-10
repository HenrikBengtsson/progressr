#' Progression Handler: Progress Reported via 'cli' Progress Bars (Text) in the Terminal
#'
#' A progression handler for [cli::cli_progress_bar()].
#'
#' @inheritParams make_progression_handler
#'
#' @param show_after (numeric) Number of seconds to wait before displaying
#' the progress bar.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @section Requirements:
#' This progression handler requires the \pkg{cli} package.
#'
#' @section Appearance:
#' Below are a few examples on how to use and customize this progress handler.
#' In all cases, we use `handlers(global = TRUE)`.
#'
#' ```{asciicast handler_cli-default}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers("cli")
#' y <- slow_sum(1:25)
#' ```
#'
#' ```{asciicast handler_cli-format-1}
#' #| asciicast_at = "all",
#' #| asciicast_knitr_output = "svg",
#' #| asciicast_cursor = FALSE
#' handlers(handler_cli(format = "{cli::pb_spin} {cli::pb_bar} {cli::pb_current}/{cli::pb_total} {cli::pb_status}"))
#' y <- slow_sum(1:25)
#' ```
#'
#' @example incl/handler_cli.R
#'
#' @export
handler_cli <- function(show_after = 0.0, intrusiveness = getOption("progressr.intrusiveness.terminal", 1), target = "terminal", ...) {
  ## Additional arguments passed to the progress-handler backend
  backend_args <- handler_backend_args(...)

  if (!is_fake("handler_cli")) {
    cli_n_colors <- cli::num_ansi_colors()

    cli_freeze_color_options <- function() {      
      options(
        cli.num_colors = cli_n_colors,
        crayon.enabled = (cli_n_colors > 1L),
        crayon.colors = cli_n_colors
      )
    }

    cli_progress_call <- function(fun, ...) {
      opts <- cli_freeze_color_options()
      on.exit(options(opts), add = TRUE)

      withCallingHandlers({
        res <- fun(...)
      }, cliMessage = function(msg) {
        output <- conditionMessage(msg)
        ## WORKAROUND: cli_progress_done() outputs a newline
        ## at the end. This prevents us from (optionally)
        ## clearing the line afterward
        if (identical(fun, cli::cli_progress_done)) {
          output <- gsub("[\n\r]+$", "", output)
        }
        cat(output, file = stderr())
        invokeRestart("muffleMessage")
      })

      invisible(res)
    }

    cli_progress_bar <- function(total, ...) {
      ## WORKAROUND: Do no not involve 'cli' when total = 0
      if (total == 0) return(NA_character_)

      ## Make sure to always use the built-in 'cli' handler, no matter
      ## what 'cli.progress_handlers*' options might be set
      opts2 <- options(cli.progress_handlers_only = "cli")
      on.exit(options(opts2), add = TRUE)

      cli_progress_call(cli::cli_progress_bar, total = total, ...)
    }

    cli_progress_update <- function(id, ..., force = TRUE, .envir) {
      ## WORKAROUND: Do no not involve 'cli' when total = 0
      if (.envir$total == 0) return(id)
      cli_progress_call(cli::cli_progress_update, id = id, ..., force = force, .envir = .envir)
    }

    cli_progress_done <- function(id, ..., .envir) {
      ## WORKAROUND: Do no not involve 'cli' when total = 0
      if (.envir$total == 0) return(id)
      cli_progress_call(cli::cli_progress_done, id = id, ..., .envir = .envir)
    }

    erase_progress_bar <- function(pb) {
      if (is.null(pb)) return()
      stopifnot(is.character(pb$id), is.environment(pb$envir))
      pb_width <- local({
        oopts <- options(cli.width = NULL)
        on.exit(options(oopts))
        cli::console_width()
      }) - 1L
      msg <- c("\r", rep(" ", times = pb_width), "\r")
      msg <- paste(msg, collapse = "")
      cat(msg, file = stderr())
    }
    
    redraw_progress_bar <- function(pb) {
      if (is.null(pb)) return()
      stopifnot(is.character(pb$id), is.environment(pb$envir))
      cli_progress_update(id = pb$id, inc = 0, .envir = pb$envir)
    }
  } else {
    cli_progress_bar <- function(total, ...) "id-dummy"
    cli_progress_update <- function(id, ..., force = TRUE, .envir) "id-dummy"
    cli_progress_done <- function(id, ..., .envir) "id-dummy"
    erase_progress_bar <- function(pb) NULL
    redraw_progress_bar <- function(pb) NULL
  }

  reporter <- local({
    pb <- NULL
    
    make_pb <- function(total, clear, show_after, ...) {
      if (!is.null(pb)) return(pb)
      stop_if_not(
        is.numeric(total), length(total) == 1L, is.finite(total)
      )
      envir <- new.env()
      envir$total <- total
      args <- c(list(total = total, ..., .envir = envir), backend_args)
      args$clear <- FALSE
      args$auto_terminate <- FALSE
      args$.auto_close <- FALSE

      old_show_after <- getOption("cli.progress_show_after", NULL)
      options(cli.progress_show_after = show_after)
      on.exit(options(cli.progress_show_after = old_show_after))

      id <- do.call(cli_progress_bar, args = args)

      pb <<- list(id = id, total = total, envir = envir, show_after = show_after)
      stopifnot(is.character(pb$id), is.environment(pb$envir))
    }

    pb_tick <- function(pb, delta = 0, message = NULL, ...) {
      if (is.null(pb)) return()
      stopifnot(
        is.character(pb$id), length(pb$id) == 1L,
        is.numeric(delta), length(delta) == 1L, is.finite(delta),
        is.environment(pb$envir)
      )
      if (delta <= 0) return()

      old_show_after <- getOption("cli.progress_show_after", NULL)
      options(cli.progress_show_after = pb$show_after)
      on.exit(options(cli.progress_show_after = old_show_after))

      cli_progress_update(id = pb$id, inc = delta, status = message, .envir = pb$envir)
    }

    pb_update <- function(pb, ratio, message = NULL, ...) {
      if (is.null(pb)) return()
      stopifnot(is.character(pb$id), is.environment(pb$envir))

      old_show_after <- getOption("cli.progress_show_after", NULL)
      options(cli.progress_show_after = pb$show_after)
      on.exit(options(cli.progress_show_after = old_show_after))

      if (ratio >= 1.0) {
        cli_progress_done(id = pb$id, .envir = pb$envir)
        erase_progress_bar(pb)
      } else {
        set <- ratio * pb$total
        stopifnot(length(set) == 1L, is.numeric(set), is.finite(set),
                  set >= 0, set < pb$total)
        cli_progress_update(id = pb$id, set = set, status = message, .envir = pb$envir)
      }
    }

    list(
      reset = function(...) {
        pb <<- NULL
      },

      hide = function(...) {
        if (is.null(pb)) return()
        erase_progress_bar(pb)
      },

      unhide = function(...) {
        if (is.null(pb)) return()
        redraw_progress_bar(pb)
      },

      interrupt = function(config, state, progression, ...) {
        if (is.null(pb)) return()
        stopifnot(is.character(pb$id), is.environment(pb$envir))
        msg <- getOption("progressr.interrupt.message", "interrupt detected")
        msg <- paste(c("", msg, ""), collapse = "\n")
        cat(msg, file = stderr())
      },

      initiate = function(config, state, progression, ...) {
        if (!state$enabled || config$times == 1L) return()
        stop_if_not(is.null(pb))
        make_pb(total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        pb_tick(pb, delta = 0, message = state$message)
      },
        
      update = function(config, state, progression, ...) {
        if (!state$enabled || config$times <= 2L) return()
        if (progression$amount == 0) return()
        
        make_pb(total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        if (inherits(progression, "sticky") && length(state$message) > 0) {
          # FIXME: pb$message(state$message)
        }
        old_show_after <- getOption("cli.progress_show_after", NULL)
        options(cli.progress_show_after = pb$show_after)
        on.exit(options(cli.progress_show_after = old_show_after))

        cli_progress_update(id = pb$id, set = state$step, status = state$message, .envir = pb$envir)
      },
        
      finish = function(config, state, progression, ...) {
        ## Already finished?
        if (is.null(pb)) return()
        stopifnot(is.character(pb$id), is.environment(pb$envir))
        make_pb(total = config$max_steps,
                clear = config$clear, show_after = config$enable_after)
        reporter$update(config = config, state = state, progression = progression, ...)
        if (config$clear) {
          pb_update(pb, ratio = 1.0)
        } else {
          cat(file = stderr(), "\n")
        }
        
        pb <<- NULL
      }
    )
  })

  make_progression_handler("cli", reporter, intrusiveness = intrusiveness, target = target, ...)
}
