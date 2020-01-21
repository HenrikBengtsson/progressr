source("incl/start.R")

message("handlers() ...")

hs <- handlers()
print(hs)

for (kk in seq_along(hs)) {
  h <- hs[[kk]]
  print(h)
  handler <- h()
  print(handler)
}


hs <- handlers("txtprogressbar")
print(hs)

for (kk in seq_along(hs)) {
  h <- hs[[kk]]
  print(h)
  handler <- h()
  print(handler)
}

hs <- handlers("handler_txtprogressbar")
print(hs)

message("handlers() - exceptions ...")

## Will as a side-effect set an empty list of handlers()
res <- handlers("non-existing-handler", on_missing = "ignore")
res <- handlers()
stopifnot(is.list(res), length(res) == 0L)

res <- tryCatch({
  handlers("non-existing-handler", on_missing = "warning")
}, warning = identity)
stopifnot(inherits(res, "warning"))

res <- tryCatch({
  handlers("non-existing-handler", on_missing = "error")
}, error = identity)
stopifnot(inherits(res, "error"))


message("handlers() - exceptions ... DONE")

message("handlers() ... DONE")

source("incl/end.R")
