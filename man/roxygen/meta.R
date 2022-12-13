
if (exists(".knitr_asciicast_process", envir = .GlobalEnv)) {
  rm(list = ".knitr_asciicast_process", envir = .GlobalEnv)
}

asciicast::init_knitr_engine(
  echo = TRUE,
  echo_input = FALSE,
  interactive = TRUE,
  timeout = as.integer(Sys.getenv("ASCIICAST_TIMEOUT", 10)),
  startup = quote({
    library(progressr)
    options(width = 70)
    options(progressr.enable = TRUE)
    options(progressr.demo.delay = 0.15)
    options(progressr.show_after = 0.0)
    options(progressr.clear = FALSE)
    
    ## To simplify examples
    options(progressr.slow_sum.stdout = FALSE)
    options(progressr.slow_sum.message = FALSE)
    options(progressr.slow_sum.sticky = FALSE)
    
    handlers(global = TRUE)
  })
)

knitr::opts_chunk$set(
  asciicast_knitr_output = "html",
  asciicast_include_style = FALSE,
  asciicast_theme = "pkgdown"
)

list(
  markdown = TRUE,
  knitr_chunk_options = list(
    cache = TRUE,
    cache_lazy = FALSE,
    cache.path = file.path(getwd(), "man/_cache/"),
    fig.path = file.path(getwd(), "man/figures"),
    error = TRUE
  ),
  restrict_image_formats = TRUE
)
