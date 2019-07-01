hdlrs <- "txtprogressbar"
if (requireNamespace("beepr", quietly = TRUE)) hdlrs <- c(hdlrs, "beepr")
handlers(hdlrs)

with_progress({ y <- slow_sum(10) })
print(y)
