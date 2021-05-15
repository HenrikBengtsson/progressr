#' Create a Progressor Function that Signals Progress Updates
#'
#' @inheritParams progression
#'
#' @param steps (integer) Number of progressing steps.
#'
#' @param along (vector; alternative) Alternative that sets
#' `steps = length(along)`.
#'
#' @param offset,scale (integer; optional) scale and offset applying transform
#' `steps <- scale * steps + offset`.
#'
#' @param transform (function; optional) A function that takes the effective
#' number of `steps` as input and returns another finite and non-negative
#' number of steps.
#'
#' @param label (character) A label.
#'
#' @param initiate (logical) If TRUE, the progressor will signal a
#' [progression] 'initiate' condition when created.
#'
#' @param auto_finish (logical) If TRUE, then the progressor will signal a
#' [progression] 'finish' condition as soon as the last step has been reached.
#'
#' @param enable (logical) If TRUE, [progression] conditions are signaled when
#' calling the progressor function created by this function.
#' If FALSE, no [progression] conditions is signaled because the progressor
#' function is an empty function that does nothing.
#'
#' @param on_exit,envir (logical) If TRUE, then the created progressor will
#' signal a [progression] 'finish' condition when the calling frame exits.
#' This is ignored if the calling frame (`envir`) is the global environment.
#'
#' @return A function of class `progressor`.
#'
#' @export
progressor <- local({
  progressor_count <- 0L

  void_progressor <- function(...) NULL
  environment(void_progressor)$enable <- FALSE
  class(void_progressor) <- c("progressor", class(void_progressor))

  function(steps = length(along), along = NULL, offset = 0L, scale = 1L, transform = function(steps) scale * steps + offset, message = character(0L), label = NA_character_, initiate = TRUE, auto_finish = TRUE, on_exit = !identical(envir, globalenv()), enable = getOption("progressr.enable", TRUE), envir = parent.frame()) {
    stop_if_not(is.logical(enable), length(enable) == 1L, !is.na(enable))

    ## Quickly return a moot progressor function?
    if (!enable) return(void_progressor)
    
    stop_if_not(!is.null(steps) || !is.null(along))
    stop_if_not(length(steps) == 1L, is.numeric(steps), !is.na(steps),
                steps >= 0)
    stop_if_not(length(offset) == 1L, is.numeric(offset), !is.na(offset))
    stop_if_not(length(scale) == 1L, is.numeric(scale), !is.na(scale))
    stop_if_not(is.function(transform))

    label <- as.character(label)
    stop_if_not(length(label) == 1L)

    steps <- transform(steps)
    stop_if_not(length(steps) == 1L, is.numeric(steps), !is.na(steps),
                steps >= 0)

    stop_if_not(is.logical(on_exit), length(on_exit) == 1L, !is.na(on_exit))

    if (identical(envir, globalenv())) {
      if (!progressr_in_globalenv()) {
        stop("A progressor must not be created in the global environment unless wrapped in a with_progress() or without_progress() call. Alternatively, create it inside a function or in a local() environment to make sure there is a finite life span of the progressor")
      }
      if (on_exit) {
        stop("It is not possible to create a progressor in the global environment with on_exit = TRUE")
      }
    }

    owner_session_uuid <- session_uuid(attributes = TRUE)
    progressor_count <<- progressor_count + 1L
    progressor_uuid <- progressor_uuid(progressor_count)
    progression_index <- 0L
    
    fcn <- function(message = character(0L), ..., type = "update") {
      progression_index <<- progression_index + 1L
      cond <- progression(
        type = type,
        message = message,
        ...,
        progressor_uuid = progressor_uuid,
        progression_index = progression_index,
        owner_session_uuid = owner_session_uuid,
        call = sys.call()
      )
      withRestarts(
        signalCondition(cond),
        muffleProgression = function(p) NULL
      )
      invisible(cond)
    }
    formals(fcn)$message <- message
    class(fcn) <- c("progressor", class(fcn))
  
    if (initiate) {
      fcn(
        type = "initiate",
        steps = steps,
        auto_finish = auto_finish
      )
    }

    ## Is there already be an active '...progressr'?
    ## If so, make sure it is finished and then remove it
    if (exists("...progressor", mode = "function", envir = envir)) {
      ...progressor <- get("...progressor", mode = "function", envir = envir)
      
      ## Ideally, we produce a warning or an error here if the existing
      ## progressor is not finished.  Currently, we don't have a way to
      ## query that, so we leave that for the future. /HB 2021-02-28

      ## Finish it (although it might already have been done via auto-finish)
      ...progressor(type = "finish")

      ## Remove it (while avoiding false 'R CMD check' NOTE)
      do.call(unlockBinding, args = list("...progressor", env = envir))
      rm("...progressor", envir = envir)
    }

    ## Add on.exit(...progressor(type = "finish"))
    if (on_exit) {
      assign("...progressor", value = fcn, envir = envir)
      lockBinding("...progressor", env = envir)
      call <- call("...progressor", type = "finish")
      do.call(base::on.exit, args = list(call, add = TRUE), envir = envir)
    }

    fcn
  }
})



#' @export
print.progressor <- function(x, ...) {
  s <- sprintf("%s:", class(x)[1])
  e <- environment(x)
  pe <- parent.env(e)

  s <- c(s, paste("- label:", e$label))
  s <- c(s, paste("- steps:", e$steps))
  s <- c(s, paste("- initiate:", e$initiate))
  s <- c(s, paste("- auto_finish:", e$auto_finish))

  if (is.function(e$message)) {
    message <- "<a function>"
  } else {
    message <- hpaste(deparse(e$message))
  }
  s <- c(s, paste("- default message:", message))

  call <- vapply(e$calls, FUN = function(call) deparse(call[1]), FUN.VALUE = "")
  s <- c(s, paste("- call stack:", paste(call, collapse = " -> ")))

  s <- c(s, paste("- progressor_uuid:", e$progressor_uuid))
  s <- c(s, paste("- progressor_count:", pe$progressor_count))
  s <- c(s, paste("- progression_index:", e$progression_index))
  owner_session_uuid <- e$owner_session_uuid
  s <- c(s, paste("- owner_session_uuid:", owner_session_uuid))
  
  s <- c(s, paste("- enable:", e$enable))

  s <- paste(s, collapse = "\n")
  cat(s, "\n", sep = "")
  
  invisible(x)
}


progressr_in_globalenv <- local({
  state <- FALSE
  
  function(action = c("query", "allow", "disallow")) {
    action <- match.arg(action)
    if (action == "query") return(state)
    old_state <- state
    state <<- switch(action, allow = TRUE, disallow = FALSE)
    invisible(old_state)
  }
})
