library(progressr)

message("progression() ...")

p <- progression()
print(p)
stopifnot(inherits(p, "progression"))

p <- progress()
print(p)
stopifnot(inherits(p, "progression"))

p2 <- progress(p)
print(p2)
stopifnot(identical(p2, p))

res <- tryCatch(progress(p), progression = function(p) TRUE)
print(res)
stopifnot(isTRUE(res))

res <- FALSE
withCallingHandlers(progress(p), progression = function(p) { res <<- TRUE })
print(res)
stopifnot(isTRUE(res))

message("progression() ... done")
