The **[progressr]** package provides a minimal API for reporting progress updates in [R](https://www.r-project.org/).  The design is to separate the representation of progress updates from how they are presented.  What type of progress to signal is controlled by the developer.  How these progress updates are rendered is controlled by the end user.  For instance, some users may prefer visual feedback such as a horizontal progress bar in the terminal, whereas others may prefer auditory feedback.

Design motto:

> The developer is responsible for providing progress updates but it's only the end user who decides if, when, and how progress should be presented. No exceptions will be allowed.


## A simple example

Assume that we have a function `slow_sum()` for adding up the values in a vector.  It is so slow, that we like to provide progress updates to whoever might be interested in it.  With the **progressr** package, this can be done as:

```r
slow_sum <- function(x) {
  progress <- progressr::progressor(length(x))
  sum <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    sum <- sum + x[kk]
    progress(message = sprintf("Added %g", x[kk]))
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
  |=====================                                |  40%
```


## Customizing how progress is reported

The default is to present progress via `utils::txtProgressBar()`, which is available on all R installations.  To change the default, to, say, `progress_bar()` by the **[progress]** package, set the following R option(\*):

```r
options(progressr.handlers = progress_handler)
```
This progress handler will present itself as:
```r
> with_progress(y <- slow_sum(1:10))
[==================>---------------------------]  40% Added 4
```


### Auditory progress updates

Note all progress updates have to be presented visually. This can equally well be done auditory. For example, using:

```r
options(progressr.handlers = beepr_handler)
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
options(progressr.handlers = list(txtprogressbar_handler, beepr_handler))
```


## Support for progressr elsewhere

### The plyr package

The functions in the [**plyr**](https://cran.r-project.org/package=plyr) package take argument `.progress`, which can be used to produce progress updates.  To have them generate **progressr** 'progression' updates, use `.progress = "progressr"`. For example,
```r
library(progressr)
with_progress({
  y <- plyr::l_ply(1:5, function(x, ...) {
    Sys.sleep(1)
    sqrt(x)
  }, .progress = "progressr")
})
## |=====================                                |  40%
```


## Appendix

### Debugging

To debug progress updates, use:
```r
> options(progressr.handlers = debug_handler)
> with_progress(y <- slow_sum(1:10))
[13:33:50.776] (1.033s => +0.001s) shutdown: 10/10 (+0) '' {clear=TRUE, enabled=TRUE, status=ok}
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
```

<small>
(*) To set the default progress handler in all your R sessions, set this option in your <code>~/.Rprofile</code> file.
</small>



[progressr]: https://github.com/HenrikBengtsson/progressr/
[beepr]: https://cran.r-project.org/package=beepr
[progress]: https://cran.r-project.org/package=progress

