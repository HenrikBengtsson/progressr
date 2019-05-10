library(progressr)

if (requireNamespace("plyr", quietly = TRUE)) {
  with_progress({
    y <- plyr::l_ply(1:10, function(...) Sys.sleep(0.01), .progress = "progressr")
  })
}
