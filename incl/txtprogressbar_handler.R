handlers("txtprogressbar")
with_progress({ y <- slow_sum(1:10) })
print(y)
