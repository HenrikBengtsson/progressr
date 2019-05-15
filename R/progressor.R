#' Create a Progressor Function
#'
#' @param steps (integer) Maximum number of steps.
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
  
  function(steps, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
    label <- as.character(label)
    stop_if_not(length(label) == 1L)

    session_uuid <- session_uuid()
    progressor_count <<- progressor_count + 1L
    progressor_uuid <- progressor_uuid(progressor_count)
    progression_index <- 0L
    
    fcn <- function(..., type = "update") {
      progression_index <<- progression_index + 1L
      progress(type = type,
               ...,
               progressor_uuid = progressor_uuid,
               progression_index = progression_index,
               session_uuid = session_uuid)
    }
    class(fcn) <- c("progressor", class(fcn))
  
    if (initiate) fcn(type = "initiate", steps = steps, auto_finish = auto_finish)
    
    fcn
  }
})
