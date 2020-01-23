.onLoad <- function(libname, pkgname) {
  if (in_r_cmd_check()) {
    options(progressr.demo.delay = 0.0)
  }
  register_vignette_engine_during_build_only(pkgname)
}
