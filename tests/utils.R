source("incl/start.R")

message("*** utils ...")


message("*** hpaste() ...")

# Some vectors
x <- 1:6
y <- 10:1
z <- LETTERS[x]

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Abbreviation of output vector
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf("x = %s.\n", hpaste(x))
## x = 1, 2, 3, ..., 6.

printf("x = %s.\n", hpaste(x, maxHead = 2))
## x = 1, 2, ..., 6.

printf("x = %s.\n", hpaste(x, maxHead = 3)) # Default
## x = 1, 2, 3, ..., 6.

# It will never output 1, 2, 3, 4, ..., 6
printf("x = %s.\n", hpaste(x, maxHead = 4))
## x = 1, 2, 3, 4, 5 and 6.

# Showing the tail
printf("x = %s.\n", hpaste(x, maxHead = 1, maxTail = 2))
## x = 1, ..., 5, 6.

# Turning off abbreviation
printf("y = %s.\n", hpaste(y, maxHead = Inf))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

## ...or simply
printf("y = %s.\n", paste(y, collapse = ", "))
## y = 10, 9, 8, 7, 6, 5, 4, 3, 2, 1

# Change last separator
printf("x = %s.\n", hpaste(x, lastCollapse = " and "))
## x = 1, 2, 3, 4, 5 and 6.

# No collapse
stopifnot(all(hpaste(x, collapse = NULL) == x))

# Empty input
stopifnot(identical(hpaste(character(0)), character(0)))

message("*** hpaste() ... DONE")


message("*** mdebug() ...")

mdebug("Hello #", 1)
mprint(1:3)
mprintf("Hello #%d", 1)
mstr(1:3)

options(progressr.debug = TRUE)
mdebug("Hello #", 2)
mprint(1:3)
mprintf("Hello #%d", 2)
mstr(1:3)

options(progressr.debug = FALSE)
mdebug("Hello #", 3)
mprint(1:3)
mprintf("Hello #%d", 3)
mstr(1:3)

message("*** mdebug() ... DONE")


message("*** stop_if_not() ...")

stop_if_not()
tryCatch(stop_if_not(c(1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10,1,2,3,4,5,6,7,8,9,10)), error = identity)

message("*** stop_if_not() ... done")


message("*** %||% ...")

print(NULL %||% TRUE)

print(TRUE %||% FALSE)

message("*** %||% ... done")

message("*** query_r_cmd_check() ...")

print(query_r_cmd_check())

cat("Command line arguments:\n")
args <- commandArgs()
print(args)

cat("Working directory:\n")
pwd <- getwd()
print(pwd)

message("*** query_r_cmd_check() ... done")

message("*** in_r_cmd_check() ...")

print(in_r_cmd_check())

message("*** in_r_cmd_check() ... done")


message("*** .onLoad() ...")

progressr:::.onLoad(pkgname = "progressr")

message("*** .onLoad() ... done")

message("*** known_progression_handlers() ...")

res <- known_progression_handlers()
str(res)

message("*** known_progression_handlers() ... done")

message("*** utils ... DONE")

source("incl/end.R")
