#' Create a Progressor Function
#'
#' @param steps (integer) Maximum number of steps.
#'
#' @param along (vector; alternative) Corresponds to `steps = seq_along(along)`.
#'
#' @param extra (integer; optional) Extra steps in addition to what `steps`
#' or `along` specifies.
#'
#' @param transform (function; optional) A function that takes the number of
#' steps according to `steps` or `along` and returns another finite and
#' non-negative number of steps.
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
  
  function(steps = NULL, along = NULL, extra = 0L, transform = function(n) n + extra, label = NA_character_, initiate = TRUE, auto_finish = TRUE) {
    stop_if_not(!is.null(steps) || !is.null(along))
    if (!is.null(along)) steps <- length(along)
    stop_if_not(length(steps) == 1L, is.numeric(steps), !is.na(steps),
                steps >= 0)
    stop_if_not(length(extra) == 1L, is.numeric(extra), !is.na(extra))		
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
  print(ls(e))
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
