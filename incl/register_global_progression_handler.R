\dontshow{if (getRversion() >= "4.0.0" && !is.element("pkgdown", loadedNamespaces()))}
handlers(global = TRUE)

## This renders progress updates for each of the three calls slow_sum()
for (ii in 1:3) {
  xs <- seq_len(ii + 3)
  message(sprintf("%d. slow_sum()", ii))
  y <- slow_sum(xs, stdout = TRUE, message = TRUE)
  print(y)
}

\dontshow{if (getRversion() >= "4.0.0" && !is.element("pkgdown", loadedNamespaces()))}
handlers(global = FALSE)
