#' Create a Progressor Function that Signals Progress Updates
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
#' @return A function of class `progressor`.
#'
#' @export
progressor <- local({
  progressor_count <- 0L
  
  function(steps = length(along), along = NULL, offset = 0L, scale = 1L, transform = function(steps) scale * steps + offset, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
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
  
    if (initiate) fcn(type = "initiate", steps = steps, auto_finish = auto_finish)
    
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

  s <- c(s, paste("- progressor_uuid:", e$progressor_uuid))
  s <- c(s, paste("- progressor_count:", pe$progressor_count))
  s <- c(s, paste("- progression_index:", e$progression_index))
  owner_session_uuid <- e$owner_session_uuid
  s <- c(s, paste("- owner_session_uuid:", owner_session_uuid))

  s <- paste(s, collapse = "\n")
  cat(s, "\n", sep = "")
  
  invisible(x)
}
