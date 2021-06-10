source("incl/start.R")

message("progressor() ...")

message("- basic")
local({
  p <- progressor(3L)
  print(p)
  p()
  p("A message")
})

message("- default message")
local({
  p <- progressor(along = 1:3, message = "A default message")
  print(p)
  p()
  p("A message")
})

message("- zero length")
local({
  p <- progressor(0L)
  print(p)
  p()
  p("A message")
})

message("- multiple consequtive progressors")
local({
  message("Progressor #1")
  p <- progressor(2L)
  for (kk in 1:2) p()

  message("Progressor #2")
  p <- progressor(3L)
  for (kk in 1:3) p()

  message("Done")
})

message("progressor() ... DONE")

source("incl/end.R")
