source("incl/start.R")

message("progressor() ...")

p <- progressor(3L)
print(p)

p <- progressor(along = 1:3)
print(p)

message("progressor() ... DONE")

source("incl/end.R")
