#' Create a Progressor Function
#'
#' @param steps (integer) The number progress steps, where each step has
#' the same length corresponding to `step_sizes = rep(1L, times = steps)`.
#'
#' @param along (vector; alternative) Corresponds to `steps = length(along)`
#' or, equivalently, `step_sizes = rep(1L, times = length(along))`.
#'
#' @param step_sizes (integer vector; alternative) Corresponds to
#' `steps = sum(step_sizes)` and where each step has different length.
#'
#' @param label (character) A label.
#'
#' @param initiate (logical) If TRUE, the progressor will signal a
#' [progression] 'initiate' condition.
#'
#' @param auto_finish (logical) If TRUE, then the progressor will signal a
#' [progression] 'finish' condition as soon as the last step has been reached.
#'
#' @return A function of class `progressor`.
#'
#' @export
progressor <- local({
  progressor_count <- 0L

  function(steps = NULL, along = NULL, step_sizes = NULL, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
    stop_if_not(!is.null(steps) || !is.null(along) || !is.null(step_sizes))
    if (!is.null(steps)) {
      stop_if_not(length(steps) == 1L, is.numeric(steps), !is.na(steps),
                  steps >= 0)
      step_sizes <- rep(1L, times = steps)
    } else if (!is.null(along)) {
      step_sizes <- rep(1L, times = length(along))
    }

    stop_if_not(is.numeric(step_sizes), length(step_sizes) >= 1L,
                !anyNA(step_sizes), all(step_sizes >= 0))
    
    label <- as.character(label)
    stop_if_not(length(label) == 1L)

    owner_session_uuid <- session_uuid(attributes = TRUE)
    progressor_count <<- progressor_count + 1L
    progressor_uuid <- progressor_uuid(progressor_count)
    progression_index <- 0L
    
    fcn <- function(..., amount = NULL, type = "update") {
      on.exit(progression_index <<- progression_index + 1L)
      stop_if_not(progression_index >= 0L, progression_index < sum(step_sizes))
      if (type == "update") {
        amount <- if (is.null(amount)) step_sizes[progression_index] else 1.0
        stop_if_not(is.numeric(amount), length(amount) == 1L, !is.na(amount), is.finite(amount), amount >= 0.0)
      }
      
      progress(type = type,
               amount = amount,
	       ...,
               progressor_uuid = progressor_uuid,
               progression_index = progression_index,
               owner_session_uuid = owner_session_uuid)
    }
    class(fcn) <- c("progressor", class(fcn))
  
    if (initiate) fcn(type = "initiate", step_sizes = step_sizes, auto_finish = auto_finish)
    
    fcn
  }
})



#' @export
print.progressor <- function(x, ...) {
  s <- sprintf("%s:", class(x)[1])
  e <- environment(x)
  pe <- parent.env(e)

  s <- c(s, paste("- label:", e$label))
  s <- c(s, sprintf("- steps: %d", sum(e$step_sizes)))
  s <- c(s, sprintf("- step lengths: [n=%d] %s", length(e$step_sizes),
                    hpaste(e$step_sizes)))
  s <- c(s, paste("- initiate:", e$initiate))
  s <- c(s, paste("- auto_finish:", e$auto_finish))

  s <- c(s, paste("- progressor_uuid:", e$progressor_uuid))
  s <- c(s, paste("- progressor_count:", pe$progressor_count))
  s <- c(s, paste("- progression_index:", e$progression_index))
  owner_session_uuid <- e$owner_session_uuid
  s <- c(s, paste("- owner_session_uuid:", owner_session_uuid))

  s <- paste(s, collapse = "\n")
  cat(s, "\n", sep = "")
  
  invisible(x)
}
