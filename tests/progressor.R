source("incl/start.R")

message("progressor() ...")

local({
  p <- progressor(3L)
  print(p)
  p()
  p("A message")
})

local({
  p <- progressor(along = 1:3, message = "A default message")
  print(p)
  p()
  p("A message")
})

message("progressor() ... DONE")

source("incl/end.R")
