#' Progression Handler: Progress Reported as the Size of a File on the File System
#'
#' @inheritParams make_progression_handler
#'
#' @param file (character) A filename.
#'
#' @param \ldots Additional arguments passed to [make_progression_handler()].
#'
#' @examples
#' \donttest{\dontrun{
#' handlers(handler_filesize(file = "myscript.progress"))
#' with_progress(y <- slow_sum(1:100))
#' print(y)
#' }}
#'
#' @details
#' This progression handler reports progress by updating the size of a file
#' on the file system. This provides a convenient way for an R script running
#' in batch mode to report on the progress such that the user can peek at the
#' file size (by default in 0-100 bytes) to assess the amount of the progress
#' made, e.g. `ls -l -- *.progress`.
#' If the \file{*.progress} file is accessible via for instance SSH, SFTP,
#' FTPS, HTTPS, etc., then progress can be assessed from a remote location.
#'
#' @importFrom utils file_test
#' @export
handler_filesize <- function(file = "default.progress", intrusiveness = getOption("progressr.intrusiveness.file", 5), target = "file", ...) {
  reporter <- local({
    set_file_size <- function(config, state, progression) {
      ratio <- state$step / config$max_steps
      size <- round(100 * ratio)
      current_size <- file.size(file)
      if (is.na(current_size)) file.create(file, showWarnings = FALSE)
      if (size == 0L) return()
      if (progression$amount == 0) return()          

      head <- sprintf("%g/%g: ", state$step, config$max_steps)
      nhead <- nchar(head)
      tail <- sprintf(" [%d%%]", round(100 * ratio))
      ntail <- nchar(tail)
      mid <- paste0(state$message, "")
      nmid <- nchar(mid)
      padding <- size - (nhead + nmid + ntail)
      if (padding <= 0) {
        msg <- paste(head, mid, tail, sep = "")
        if (padding < 0) msg <- substring(msg, first = 1L, last = size)
      } else if (padding > 0) {
        mid <- paste(c(mid, " ", rep(".", times = padding - 1L)), collapse = "")
        msg <- paste(head, mid, tail, sep = "")
      }
      
      cat(file = file, append = FALSE, msg)
    }
    
    list(
      initiate = function(config, state, progression, ...) {
        set_file_size(config = config, state = state, progression = progression)
      },
      
      update = function(config, state, progression, ...) {
        set_file_size(config = config, state = state, progression = progression)
      },
      
      finish = function(config, state, progression, ...) {
        if (config$clear) {
	  if (file_test("-f", file)) file.remove(file)
	} else {
          set_file_size(config = config, state = state, progression = progression)
	}
      }
    )
  })
  
  make_progression_handler("filesize", reporter, intrusiveness = intrusiveness, target = target, ...)
}
