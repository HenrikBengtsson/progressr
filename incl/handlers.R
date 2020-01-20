handlers("txtprogressbar")
if (requireNamespace("beepr", quietly = TRUE))
  handlers("beepr", append = TRUE)

with_progress({ y <- slow_sum(10) })
print(y)
