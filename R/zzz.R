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
    ## UPDATE It is not possible to register a global calling handler when
    ## there is already an active condition handler as it is here because
    ## loadNamespace()/library() uses tryCatch() internally.  If attempted,
    ## we'll get an error "should not be called with handlers on the stack".
    ## /HB 2020-11-19
#    register_global_progression_handler()
  }
}


