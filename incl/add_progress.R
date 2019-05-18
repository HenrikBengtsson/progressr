with_progress(add_progress({
  x <- 1:10
  y <- slow_sum(x)
  z <- slow_sum(x^2)
  mu <- mean(z - y^2)
}))
print(mu)
