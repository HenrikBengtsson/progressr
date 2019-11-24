#' Create a Progressor Function
#'
#' @param steps (integer) The number progress steps, where each step has
#' the same length corresponding to `step_lengths = rep(1L, times = steps)`.
#'
#' @param along (vector; alternative) Corresponds to `steps = length(along)`
#' or, equivalently, `step_lengths = rep(1L, times = length(along))`.
#'
#' @param step_lengths (integer vector; alternative) Corresponds to
#' `steps = sum(step_lengths)` and where each step has different length.
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

  function(steps = NULL, along = NULL, step_lengths = NULL, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
    stop_if_not(!is.null(steps) || !is.null(along))
    if (!is.null(steps)) {
      stop_if_not(length(steps) == 1L, is.numeric(steps), !is.na(steps),
                  steps >= 0)
      step_lengths <- rep(1L, times = steps)
    } else if (!is.null(along)) {
      step_lengths <- rep(1L, times = length(along))
    } else if (!is.null(step_lengths)) {
      stop_if_not(is.numeric(step_lengths), length(step_lengths) >= 1L,
                  !anyNA(step_lengths), all(step_lengths >= 0))
      steps <- length(step_lengths)
    }
    
    label <- as.character(label)
    stop_if_not(length(label) == 1L)

    owner_session_uuid <- session_uuid(attributes = TRUE)
    progressor_count <<- progressor_count + 1L
    progressor_uuid <- progressor_uuid(progressor_count)
    progression_index <- 0L
    
    fcn <- function(..., type = "update") {
      progression_index <<- progression_index + 1L
      progress(type = type,
               ...,
               progressor_uuid = progressor_uuid,
               progression_index = progression_index,
               owner_session_uuid = owner_session_uuid)
    }
    class(fcn) <- c("progressor", class(fcn))
  
    if (initiate) fcn(type = "initiate", step_lengths = step_lengths, auto_finish = auto_finish)
    
    fcn
  }
})



#' @export
print.progressor <- function(x, ...) {
  s <- sprintf("%s:", class(x)[1])
  e <- environment(x)
  print(ls(e))
  pe <- parent.env(e)

  s <- c(s, paste("- label:", e$label))
  s <- c(s, sprintf("- step lengths: [n=%d] %s", length(e$step_lengths),
                    hpaste(e$step_lengths)))
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
