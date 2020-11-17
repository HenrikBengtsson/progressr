source("incl/start.R")

message("progressor() ...")

local({
  p <- progressor(3L)
  print(p)
})

local({
  p <- progressor(along = 1:3)
  print(p)
})

message("progressor() ... DONE")

source("incl/end.R")
