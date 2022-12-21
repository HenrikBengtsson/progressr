pkg <- "RPushbullet"
if (requireNamespace(pkg, quietly = TRUE)) {

  handlers("rpushbullet")
  with_progress({ y <- slow_sum(1:10) })
  print(y)
  
}
