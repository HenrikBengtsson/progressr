.onLoad <- function(libname, pkgname) {
  if (in_r_cmd_check()) {
    msg <- sprintf("%s:::.onLoad(): Detected 'R CMD check'", pkgname)
    packageStartupMessage(msg)
    options(progressr.demo.delay = 0.0)
  }
}