handlers("txtprogressbar")
if (requireNamespace("beepr", quietly = TRUE))
  handlers("beepr", append = TRUE)

with_progress({ y <- slow_sum(1:5) })
print(y)


if (getRversion() >= "4.0.0") {
  \dontshow{if (!is.element("pkgdown", loadedNamespaces()))}
  handlers(global = TRUE)
  y <- slow_sum(1:4)
  z <- slow_sum(6:9)
  \dontshow{if (!is.element("pkgdown", loadedNamespaces()))}
  handlers(global = FALSE)
}

