.onLoad <- function(libname, pkgname) {
  if (in_r_cmd_check()) {
    options(progressr.delay = 0.01)
  }
}