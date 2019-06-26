oopts <- handlers("txtprogressbar", "beepr", on_missing = "ignore")

x <- 1:10
with_progress({ y <- slow_sum(x) })
print(y)
