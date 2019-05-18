library(progressr)

options(progressr.tests.fake_handlers = c("beepr_handler", "notifier_handler", "pbmcapply_handler", "progress_handler", "tkprogressbar_handler", "winprogressbar_handler"))
options(progressr.debug = TRUE)
options(progressr.enable = TRUE)
options(progressr.times = +Inf)
options(progressr.interval = 0.1)
options(delay = 0.0)

message("with_progress() - progressr.debug = TRUE ...")

options(progressr.handlers = list(
  ascii_alert_handler, beepr_handler, debug_handler, newline_handler, notifier_handler, pbmcapply_handler, progress_handler, tkprogressbar_handler, txtprogressbar_handler, winprogressbar_handler
))

with_progress({
  y <- slow_sum(1:10)
})

with_progress({
  progress <- progressor(steps = 1 + 2 + 1)
  relay_progress <- progress_aggregator(progress)
  p <- progress()
  progressr::progress(p) ## duplicated - will be ignored
  relay_progress(slow_sum(1:2))
  progress(type = "finish")
  progress() ## one too many - will be ignored
})

message("with_progress() - progressr.debug = TRUE ... done")
