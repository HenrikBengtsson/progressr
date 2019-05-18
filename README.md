# progressr - A Unifying API for Progress Updates

The **[progressr]** package provides a minimal API for reporting progress updates in [R](https://www.r-project.org/).  The design is to separate the representation of progress updates from how they are presented.  What type of progress to signal is controlled by the developer.  How these progress updates are rendered is controlled by the end user.  For instance, some users may prefer visual feedback such as a horizontal progress bar in the terminal, whereas others may prefer auditory feedback.

Design motto:

> The developer is responsible for providing progress updates but it's only the end user who decides if, when, and how progress should be presented. No exceptions will be allowed.


## A simple example

Assume that we have a function `slow_sum()` for adding up the values in a vector.  It is so slow, that we like to provide progress updates to whoever might be interested in it.  With the **progressr** package, this can be done as:

```r
slow_sum <- function(x) {
  progress <- progressr::progressor(length(x))
  res <- 0
  for (kk in seq_along(x)) {
    Sys.sleep(0.1)
    res <- res + x[kk]
    progress()
  }
  res
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


### Customizing how progress is reported

The default is to present progress via `utils::txtProgressBar()`, which is available on all R installations.  To change the default, to, say, `progress_bar()` by the **[progress]** package, set the following R option(\*):

```r
options(progressr.handlers = progress_handler)
```
This progress handler will present itself as:
```r
> with_progress(y <- slow_sum(1:10))
[=====================>--------------------------------]  40%
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


### Auditory and visual progress updates

It is possible to have multiple progress handlers presenting progress updates at the same time.  For example, to get both visual and auditory updates, use:
```r
options(progressr.handlers = list(txtprogress_barhandler, beepr_handler))
```

<small>
(*) To set the default progress presenter in all R session, set this option in your '~/.Rprofile' file.
</small>



[progressr]: https://github.com/HenrikBengtsson/progressr/
[beepr]: https://cran.r-project.org/package=beepr
[progress]: https://cran.r-project.org/package=progress

