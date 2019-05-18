library(progressr)

mdebug <- progressr:::mdebug
mprint <- progressr:::mprint
mprintf <- progressr:::mprintf
mstr <- progressr:::mstr
stop_if_not <- progressr:::stop_if_not

message("*** utils ...")


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

message("*** utils ... DONE")
