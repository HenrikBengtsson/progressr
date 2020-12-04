.onLoad <- function(libname, pkgname) {
  ## R CMD check
  if (in_r_cmd_check()) {
    options(progressr.demo.delay = 0.0)
  }

  ## R CMD build
  register_vignette_engine_during_build_only(pkgname)

  ## Register a global progression handler on load?
  global <- Sys.getenv("R_PROGRESSR_GLOBAL_HANDLER", "FALSE")
  global <- getOption("progressr.global.handler", as.logical(global))
  if (isTRUE(global)) {
    utils::str(globalCallingHandlers())
    globalCallingHandlers(foo=function(c) utils::str(c))
#    register_global_progression_handler()
  }
}


