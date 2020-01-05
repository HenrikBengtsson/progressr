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


message("handlers() ... DONE")

source("incl/end.R")
