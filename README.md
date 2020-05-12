# progressr: A Inclusive, Unifying API for Progress Updates

![Life cycle: experimental](vignettes/imgs/lifecycle-experimental-orange.svg)

The **[progressr]** package provides a minimal API for reporting progress updates in [R](https://www.r-project.org/).  The design is to separate the representation of progress updates from how they are presented.  What type of progress to signal is controlled by the developer.  How these progress updates are rendered is controlled by the end user.  For instance, some users may prefer visual feedback such as a horizontal progress bar in the terminal, whereas others may prefer auditory feedback.


<img src="vignettes/imgs/three_in_chinese.gif" alt="Three strokes writing three in Chinese" style="float: right; margin-right: 1ex; margin-left: 1ex;"/>

Design motto:

> The developer is responsible for providing progress updates but it's only the end user who decides if, when, and how progress should be presented. No exceptions will be allowed.


## Two Minimal APIs

 | Developer's API               | End-user's API              |
 |-------------------------------|-----------------------------|
 | `p <- progressor(n)`          | `with_progress(expr)`       |
 | `p <- progressor(along = x)`  | `handlers(...)`             |
 | `p(msg, ...)`                 |                             |



## A simple example

Assume that we have a function `slow_sum()` for adding up the values in a vector.  It is so slow, that we like to provide progress updates to whoever might be interested in it.  With the **progressr** package, this can be done as:

```r
slow_sum <- function(x) {
  p <- progressr::progressor(along = x)
  sum <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    sum <- sum + x[kk]
    p(message = sprintf("Added %g", x[kk]))
  }
  sum
}
```

Note how there are _no_ arguments in the code that specifies how progress is presented.  The only task for the developer is to decide on where in the code it makes sense to signal that progress has been made.  As we will see next, it is up to the end user of this code to decide whether they want to receive progress updates or not, and, if so, in what format.


### Without reporting progress

When calling this function as in:
```r
> y <- slow_sum(1:10)
> y
[1] 55
>
```
it will behave as any function and there will be no progress updates displayed.


### Reporting progress

To get progress updates, we can call it as:
```r
> library(progressr)
> with_progress(y <- slow_sum(1:10))
  |====================                               |  40%
```


## Customizing how progress is reported

The default is to present progress via `utils::txtProgressBar()`, which is available on all R installations.  To change the default, to, say, `progress_bar()` by the **[progress]** package, set:

```r
handlers("progress")
```
This progress handler will present itself as:
```r
> with_progress(y <- slow_sum(1:10))
[=================>---------------------------]  40% Added 4
```

To set the default progress handler(s) in all your R sessions, call `progressr::handlers(...)` in your <code>~/.Rprofile</code> file.



### Auditory progress updates

Progress updates do not have to be presented visually. They can equally well be communicated via audio. For example, using:

```r
handlers("beepr")
```
will present itself as sounds played at the beginning, while progressing, and at the end (using different **[beepr]** sounds).  There will be _no_ output written to the terminal;
```r
> with_progress(y <- slow_sum(1:10))
> y
[1] 55
>
```


### Concurrent auditory and visual progress updates

It is possible to have multiple progress handlers presenting progress updates at the same time.  For example, to get both visual and auditory updates, use:
```r
handlers("txtprogressbar", "beepr")
```


### Silence all progress

To silence all progress updates, use:

```r
handlers("void")
```


### Further configuration of progress handlers

Above we have seen examples where the `handlers()` takes one or more strings as input, e.g. `handlers(c("progress", "beepr"))`.  This is short for a more flexible specification where we can pass a list of handler functions, e.g.

```r
handlers(list(
  handler_progress(),
  handler_beepr()
))
```

With this construct, we can make adjustments to the default behavior of these progress handlers.  For example, we can configure the `width` and the `complete` arguments of `progress::progress_bar$new()`, and tell **beepr** to use a different `finish` sound and generate sounds at most every two seconds by setting:

```r
handlers(list(
  handler_progress(width = 40, complete = "+"),
  handler_beepr(finish = 9, interval = 2.0)
))
```


## Sticky messages

As seen above, some progress handlers present the progress message as part of its output, e.g. the "progress" handler will display the message as part of the progress bar.  It is also possible to "push" the message up together with other terminal output.  This can be done by adding class attribute `"sticky"` to the progression signaled.  This works for several progress handlers that output to the terminal.  For example, with:

```r
slow_sum <- function(x) {
  p <- progressr::progressor(along = x)
  sum <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    sum <- sum + x[kk]
    p(sprintf("Step %d", kk), class = if (kk %% 5 == 0) "sticky", amount = 0)
    p(message = sprintf("Added %g", x[kk]))
  }
  sum
}
```
we get
```r
> handlers("txtprogressbar")
> with_progress(y <- slow_sum(1:30))
Step 5
Step 10
  |====================                               |  43%
```

and

```r
> handlers("progress")
> with_progress(y <- slow_sum(1:30))
Step 5
Step 10
[================>---------------------------]  43% Added 13
```


## Use regular output as usual alongside progress updates

In contrast to other progress-bar frameworks, output from `message()`, `cat()`, `print()` and so on, will _not_ interfere with progress reported via **progressr**.  For example, say we have:

```r
slow_sqrt <- function(xs) {
  p <- progressor(along = xs)
  lapply(xs, function(x) {
    message("Calculating the square root of ", x)
    Sys.sleep(2)
    p(sprintf("x=%g", x))
    sqrt(x)
  })
}
```

we will get:

```r
> library(progressr)
> handlers("progress")
> with_progress(y <- slow_sqrt(1:8))
Calculating the square root of 1
Calculating the square root of 2
[===========>-------------------------------------]  25% x=2
```

This works because `with_progress()` will briefly buffer any output internally and only release it when the next progress update is received just before the progress is re-rendered in the terminal.  This is why you see a two second delay when running the above example.  Note that, if we use progress handlers that do not output to the terminal, such as `handlers("beepr")`, then output does not have to be buffered and will appear immediately.


_Comment_: When signaling a warning using `warning(msg, immediate. = TRUE)` the message is immediately outputted to the standard-error stream.  However, this is not possible to emulate when warnings are intercepted using calling handlers, which are used by `with_progress()`.  This is a limitation of R that cannot be worked around.  Because of this, the above call will behave the same as `warning(msg)` - that is, all warnings will be buffered by R internally and released only when all computations are done.


## Support for progressr elsewhere

Note that progression updates by **progressr** is designed to work out of the box for any iterator framework in R.  Below is an set of examples for the most common ones.


### Base R Apply Functions

```r
library(progressr)

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- lapply(xs, function(x) {
    p(sprintf("x=%g", x))
    Sys.sleep(0.1)
    sqrt(x)
  })
})
#  |====================                               |  40%
```

### The foreach package

```r
library(foreach)
library(progressr)

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- foreach(x = xs) %do% {
    p(sprintf("x=%g", x))
    Sys.sleep(0.1)
    sqrt(x)
  }
})
#  |====================                               |  40%
```

### The purrr package

```r
library(purrr)
library(progressr)

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- map(xs, function(x) {
    p(sprintf("x=%g", x))
    Sys.sleep(0.1)
    sqrt(x)
  })
})
#  |====================                               |  40%
```


### The plyr package

```r
library(plyr)
library(progressr)

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- llply(xs, function(x, ...) {
    p(sprintf("x=%g", x))
    Sys.sleep(0.1)
    sqrt(x)
  })
})
#  |====================                               |  40%
```

_Note:_ This solution does not involved the `.progress = TRUE` argument that **plyr** implements.  Because **progressr** is more flexible, and because `.progress` is automatically disabled when running in parallel (see below), I recommended to use the above **progressr** approach instead.  Having said this, as proof-of-concept, the **progressr** package implements support `.progress = "progressr"` if you still prefer the **plyr** way of doing it.


## Parallel processing and progress updates

The **[future]** framework, which provides a unified API for parallel and distributed processing in R, has built-in support for the kind of progression updates produced by the **progressr** package.  This means that you can use it with for instance **[future.apply]**, **[furrr]**, and **[foreach]** with **[doFuture]**, and **[plyr]** with **doFuture**.


### future_lapply() - parallel lapply()

Here is an example that uses `future_lapply()` of the **[future.apply]** package to parallelize on the local machine while at the same time signaling progression updates:

```r
library(future.apply)
plan(multisession)

library(progressr)
handlers("progress", "beepr")

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- future_lapply(xs, function(x, ...) {
    p(sprintf("x=%g", x))
    Sys.sleep(6.0-x)
    sqrt(x)
  })
})
# [=================>------------------------------]  40% x=2
```


### foreach() with doFuture

Here is an example that uses `foreach()` of the **[foreach]** package to parallelize on the local machine (via **[doFuture]**) while at the same time signaling progression updates:

```r
library(doFuture)
registerDoFuture()
plan(multisession)

library(progressr)
handlers("progress", "beepr")

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- foreach(x = xs) %dopar% {
    p(sprintf("x=%g", x))
    Sys.sleep(6.0-x)
    sqrt(x)
  }
})
# [=================>------------------------------]  40% x=2
```


### future_map() - parallel purrr::map()

Here is an example that uses `future_map()` of the **[furrr]** package to parallelize on the local machine while at the same time signaling progression updates:

```r
library(furrr)
plan(multisession)

library(progressr)
handlers("progress", "beepr")

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- future_map(xs, function(x) {
    p(sprintf("x=%g", x))
    Sys.sleep(6.0-x)
    sqrt(x)
  })
})
# [=================>------------------------------]  40% x=2
```

_Note:_ This solution does not involved the `.progress = TRUE` argument that **furrr** implements.  Because **progressr** is more generic and because `.progress = TRUE` only works for certain future backends and produces errors on others, I recommended to stop using `.progress = TRUE` and use the **progressr** package instead.


### plyr::llply(..., .parallel = TRUE) with doFuture

Here is an example that uses `llply()` of the **[plyr]** package to parallelize on the local machine while at the same time signaling progression updates:

```r
library(plyr)
library(doFuture)
registerDoFuture()
plan(multisession)

library(progressr)
handlers("progress", "beepr")

xs <- 1:5

with_progress({
  p <- progressor(along = xs)
  y <- llply(xs, function(x, ...) {
    p(sprintf("x=%g", x))
    Sys.sleep(0.1)
    sqrt(x)
  }, .parallel = TRUE)
})
# [=================>------------------------------]  40% x=2
```

_Note:_ Although **progressr** implements support for using `.progress = "progressr"` with **plyr**, unfortunately, this will _not_ work when using `.parallel = TRUE`.  This is because **plyr** resets `.progress` to the default `"none"` internally regardless how we set `.progress`. See <https://github.com/HenrikBengtsson/progressr/issues/70> for details and a hack that works around this limitation.


### Near-live versus buffered progress updates with futures

As of May 2020, there are three types of **future** backends that are known(*) to provide near-live progress updates:

 1. `sequential`,
 2. `multisession`, and
 3. `cluster` (local and remote)

Here "near-live" means that the progress handlers will report on progress almost immediately when the progress is signaled on the worker.   For all other future backends, the progress updates are only relayed back to the main machine and reported together with the results of the futures.  For instance, if `future_lapply(X, FUN)` chunks up the processing of, say, 100 elements in `X` into eight futures, we will see progress from each of the 100 elements as they are done when using a future backend supporting "near-live" updates, whereas we will only see those updated to be flushed eight times when using any other types of future backends.


(*) Other future backends may gain support for "near-live" progress updating later.  Adding support for those is independent of the **progressr** package.  Feature requests for adding that support should go to those future-backend packages.



## Note of caution - sending progress updates too frequently

Signaling progress updates comes with some overhead.  In situation where we use progress updates, this overhead is typically much smaller than the task we are processing in each step.  However, if the task we iterate over is quick, then the extra time induced by the progress updates might end up dominating the overall processing time.  If that is the case, a simple solution is to only signal progress updates every n:th step.  Here is a version of `slow_sum()` that signals progress every 10:th iteration:
```
slow_sum <- function(x) {
  p <- progressr::progressor(length(x) / 10)
  sum <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    sum <- sum + x[kk]
    if (kk %% 10 == 0) p(message = sprintf("Added %g", x[kk]))
  }
  sum
}
```

The overhead of progress signaling may depend on context.  For example, in parallel processing with near-live progress updates via 'multisession' futures, each progress update is communicated via a socket connections back to the main R session.  These connections might become clogged up if progress updates are too frequent.


## Progress updates in non-interactive mode ("batch mode")

When running R from the command line, R runs in a non-interactive mode
(`interactive()` returns `FALSE`).  The default behavior of `with_progress()`
is to _not_ report on progress in non-interactive mode.
To reported on progress also then, set R options `progressr.enable` or
environment variable `R_PROGRESSR_ENABLE` to `TRUE`.  For example,

```sh
$ Rscript -e "library(progressr)" -e "with_progress(y <- slow_sum(1:10))"
```
will _not_ report on progress, whereas
```sh
$ export R_PROGRESSR_ENABLE=TRUE
$ Rscript -e "library(progressr)" -e "with_progress(y <- slow_sum(1:10))"
```
will.



## Roadmap

Because this project is under active development, the progressr API is currently kept at a very minimum.  This will allow for the framework and the API to evolve while minimizing the risk for breaking code that depends on it.  The roadmap for developing the API is roughly:

1. Provide minimal API for producing progress updates, i.e. `progressor()` and `with_progress()`
   
2. Add support for nested progress updates

3. Add API to allow users and package developers to design additional progression handlers

For a more up-to-date view on what features might be added, see <https://github.com/HenrikBengtsson/progressr/issues>.


## Appendix

### Under the hood

When using the **progressr** package, progression updates are communicated via R's condition framework, which provides methods for creating, signaling, capturing, muffling, and relaying conditions.  Progression updates are of classes `progression` and `immediateCondition`(\*).  The below figure gives an example how progression conditions are created, signaled, and rendered.

(\*) The `immediateCondition` class of conditions are relayed as soon as possible by the **[future]** framework, which means that progression updates produced in parallel workers are reported to the end user as soon as the main R session have received them.




![](vignettes/imgs/slow_sum.svg)

_Figure: Sequence diagram illustrating how signaled progression conditions are captured by `with_progress()` and relayed to the two progression handlers 'progress' (a progress bar in the terminal) and 'beepr' (auditory) that the end user has chosen._


### Debugging

To debug progress updates, use:
```r
> handlers("debug")
> with_progress(y <- slow_sum(1:10))
[13:33:49.743] (0.000s => +0.002s) initiate: 0/10 (+0) '' {clear=TRUE, enabled=TRUE, status=}
[13:33:49.847] (0.104s => +0.001s) update: 1/10 (+1) 'Added 1' {clear=TRUE, enabled=TRUE, status=}
[13:33:49.950] (0.206s => +0.001s) update: 2/10 (+1) 'Added 2' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.052] (0.309s => +0.000s) update: 3/10 (+1) 'Added 3' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.154] (0.411s => +0.001s) update: 4/10 (+1) 'Added 4' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.257] (0.514s => +0.001s) update: 5/10 (+1) 'Added 5' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.361] (0.618s => +0.002s) update: 6/10 (+1) 'Added 6' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.464] (0.721s => +0.001s) update: 7/10 (+1) 'Added 7' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.567] (0.824s => +0.001s) update: 8/10 (+1) 'Added 8' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.670] (0.927s => +0.001s) update: 9/10 (+1) 'Added 9' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.773] (1.030s => +0.001s) update: 10/10 (+1) 'Added 10' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.774] (1.031s => +0.003s) update: 10/10 (+0) 'Added 10' {clear=TRUE, enabled=TRUE, status=}
[13:33:50.776] (1.033s => +0.001s) shutdown: 10/10 (+0) '' {clear=TRUE, enabled=TRUE, status=ok}
```



[progressr]: https://cran.r-project.org/package=progressr
[beepr]: https://cran.r-project.org/package=beepr
[progress]: https://cran.r-project.org/package=progress
[purrr]: https://cran.r-project.org/package=purrr
[future]: https://cran.r-project.org/package=future
[foreach]: https://cran.r-project.org/package=foreach
[future.apply]: https://cran.r-project.org/package=future.apply
[doParallel]: https://cran.r-project.org/package=doParallel
[doFuture]: https://cran.r-project.org/package=doFuture
[foreach]: https://cran.r-project.org/package=foreach
[furrr]: https://cran.r-project.org/package=furrr
[pbapply]: https://cran.r-project.org/package=pbapply
[pbmcapply]: https://cran.r-project.org/package=pbmcapply
[plyr]: https://cran.r-project.org/package=plyr

## Installation
R package progressr is available on [CRAN](https://cran.r-project.org/package=progressr) and can be installed in R as:
```r
install.packages("progressr")
```

### Pre-release version

To install the pre-release version that is available in Git branch `develop` on GitHub, use:
```r
remotes::install_github("HenrikBengtsson/progressr@develop")
```
This will install the package from source.  



## Contributions

This Git repository uses the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) branching model (the [`git flow`](https://github.com/petervanderdoes/gitflow-avh) extension is useful for this).  The [`develop`](https://github.com/HenrikBengtsson/progressr/tree/develop) branch contains the latest contributions and other code that will appear in the next release, and the [`master`](https://github.com/HenrikBengtsson/progressr) branch contains the code of the latest release, which is exactly what is currently on [CRAN](https://cran.r-project.org/package=progressr).

Contributing to this package is easy.  Just send a [pull request](https://help.github.com/articles/using-pull-requests/).  When you send your PR, make sure `develop` is the destination branch on the [progressr repository](https://github.com/HenrikBengtsson/progressr).  Your PR should pass `R CMD check --as-cran`, which will also be checked by <a href="https://travis-ci.org/HenrikBengtsson/progressr">Travis CI</a> and <a href="https://ci.appveyor.com/project/HenrikBengtsson/progressr">AppVeyor CI</a> when the PR is submitted.


## Software status

| Resource      | CRAN        | GitHub Actions      | Travis CI       | AppVeyor CI      |
| ------------- | ------------------- | ------------------- | --------------- | ---------------- |
| _Platforms:_  | _Multiple_          | _Multiple_          | _Linux & macOS_ | _Windows_        |
| R CMD check   | <a href="https://cran.r-project.org/web/checks/check_results_progressr.html"><img border="0" src="http://www.r-pkg.org/badges/version/progressr" alt="CRAN version"></a> | <a href="https://github.com/HenrikBengtsson/progressr/actions?query=workflow%3AR-CMD-check"><img src="https://github.com/HenrikBengtsson/progressr/workflows/R-CMD-check/badge.svg?branch=develop" alt="Build status"></a>       | <a href="https://travis-ci.org/HenrikBengtsson/progressr"><img src="https://travis-ci.org/HenrikBengtsson/progressr.svg" alt="Build status"></a>   | <a href="https://ci.appveyor.com/project/HenrikBengtsson/progressr"><img src="https://ci.appveyor.com/api/projects/status/github/HenrikBengtsson/progressr?svg=true" alt="Build status"></a> |
| Test coverage |                     |                     | <a href="https://codecov.io/gh/HenrikBengtsson/progressr"><img src="https://codecov.io/gh/HenrikBengtsson/progressr/branch/develop/graph/badge.svg" alt="Coverage Status"/></a>     |                  |
