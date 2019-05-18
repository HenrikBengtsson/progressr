library(progressr)

options(progressr.enable = TRUE)
options(delay = 0.0)


message("Exceptions ...")

message("- with_progress()")

invalid <- progression(type = "unknown", session_uuid = "dummy", progressor_uuid = "dummy", progression_index = 0L)
print(invalid)
res <- tryCatch(with_progress({
  signalCondition(invalid)
}, handlers = debug_handler), error = identity)
str(res)
stopifnot(inherits(res, "error"))


message("- progress_aggregator()")

invalid <- progression(type = "unknown", session_uuid = "dummy", progressor_uuid = "dummy", progression_index = 0L)
print(invalid)
progress <- progress_aggregator(progressor(2L))
res <- tryCatch(progress({
  signalCondition(invalid)
}), error = identity)
str(res)
stopifnot(inherits(res, "error"))


message("Exceptions ... done")