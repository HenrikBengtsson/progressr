source("incl/start.R")

message("handlers() ...")

hs <- handlers()
print(hs)

hs <- handlers("txtprogressbar")
print(hs)
print(hs[[1]])

message("handlers() ... DONE")

source("incl/end.R")
