pkg <- "RPushbullet"
if (requireNamespace(pkg, quietly = TRUE)) {

  if (RPushbullet::pbValidateConf()) {
    handlers("rpushbullet")
  }
  
  with_progress({ y <- slow_sum(1:10) })
  print(y)
  
}
