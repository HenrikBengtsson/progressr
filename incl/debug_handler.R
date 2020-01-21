res <- progressr:::query_r_cmd_check()
print(res)
str(res)
print(getOption("progressr.demo.delay", NA_real_))

handlers("debug")
with_progress({ y <- slow_sum(1:10) })
print(y)
