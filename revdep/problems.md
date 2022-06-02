# AIPW

<details>

* Version: 0.6.3.2
* GitHub: https://github.com/yqzhong7/AIPW
* Source code: https://github.com/cran/AIPW
* Date/Publication: 2021-06-11 09:30:02 UTC
* Number of recursive dependencies: 99

Run `revdep_details(, "AIPW")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘Rsolnp’ ‘SuperLearner’ ‘future.apply’ ‘ggplot2’ ‘progressr’ ‘stats’
      ‘utils’
      All declared Imports should be used.
    ```

# baseballr

<details>

* Version: 1.2.0
* GitHub: https://github.com/BillPetti/baseballr
* Source code: https://github.com/cran/baseballr
* Date/Publication: 2022-04-25 07:20:12 UTC
* Number of recursive dependencies: 122

Run `revdep_details(, "baseballr")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘pitchRx’ ‘progressr’
      All declared Imports should be used.
    ```

# beer

<details>

* Version: 1.0.0
* GitHub: https://github.com/athchen/beer
* Source code: https://github.com/cran/beer
* Date/Publication: 2022-04-26
* Number of recursive dependencies: 124

Run `revdep_details(, "beer")` for more info

</details>

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘beer-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: brew
    > ### Title: Bayesian Enrichment Estimation in R (BEER)
    > ### Aliases: brew
    > 
    > ### ** Examples
    > 
    > sim_data <- readRDS(system.file("extdata", "sim_data.rds", package = "beer"))
    ...
    colData names(7): group n_init ... c pi
    beads-only name(4): beads> 
    > ## Snow
    > brew(sim_data, BPPARAM = BiocParallel::SnowParam())
    
    ── Running JAGS ────────────────────────────────────────────────────────────────
    Sample runs
    Error in loadNamespace(x) : there is no package called ‘codetools’
    Calls: brew ... loadNamespace -> withRestarts -> withOneRestart -> doWithOneRestart
    Execution halted
    ```

*   checking tests ...
    ```
      Running ‘spelling.R’
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 50 lines of output:
        8. │       ├─BiocParallel::bploop(...)
        9. │       └─BiocParallel:::bploop.lapply(...)
       10. │         └─BiocParallel:::.bploop_impl(...)
       11. │           └─BiocParallel:::.findVariables(FUN)
       12. └─base::loadNamespace(x)
    ...
        9. │       └─BiocParallel:::.bploop_impl(...)
       10. │         └─BiocParallel:::.findVariables(FUN)
       11. └─base::loadNamespace(x)
       12.   └─base::withRestarts(stop(cond), retry_loadNamespace = function() NULL)
       13.     └─base withOneRestart(expr, restarts[[1L]])
       14.       └─base doWithOneRestart(return(expr), restart)
      
      [ FAIL 3 | WARN 0 | SKIP 1 | PASS 54 ]
      Error: Test failures
      Execution halted
    ```

*   checking re-building of vignette outputs ... ERROR
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘beer.Rmd’ using rmarkdown
    
    Attaching package: 'dplyr'
    
    The following objects are masked from 'package:stats':
    
        filter, lag
    
    The following objects are masked from 'package:base':
    ...
    Quitting from lines 316-323 (beer.Rmd) 
    Error: processing vignette 'beer.Rmd' failed with diagnostics:
    there is no package called 'codetools'
    --- failed re-building ‘beer.Rmd’
    
    SUMMARY: processing the following file failed:
      ‘beer.Rmd’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# cfbfastR

<details>

* Version: 1.6.4
* GitHub: https://github.com/saiemgilani/cfbfastR
* Source code: https://github.com/cran/cfbfastR
* Date/Publication: 2021-10-27 12:30:02 UTC
* Number of recursive dependencies: 110

Run `revdep_details(, "cfbfastR")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘xgboost’
      All declared Imports should be used.
    ```

# cSEM

<details>

* Version: 0.4.0
* GitHub: https://github.com/M-E-Rademaker/cSEM
* Source code: https://github.com/cran/cSEM
* Date/Publication: 2021-04-19 22:00:18 UTC
* Number of recursive dependencies: 122

Run `revdep_details(, "cSEM")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘Rdpack’
      All declared Imports should be used.
    ```

# dipsaus

<details>

* Version: 0.2.1
* GitHub: https://github.com/dipterix/dipsaus
* Source code: https://github.com/cran/dipsaus
* Date/Publication: 2022-05-29 17:50:02 UTC
* Number of recursive dependencies: 72

Run `revdep_details(, "dipsaus")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  6.4Mb
      sub-directories of 1Mb or more:
        doc    1.1Mb
        libs   4.1Mb
    ```

# easyalluvial

<details>

* Version: 0.3.0
* GitHub: https://github.com/erblast/easyalluvial
* Source code: https://github.com/cran/easyalluvial
* Date/Publication: 2021-01-13 10:40:09 UTC
* Number of recursive dependencies: 146

Run `revdep_details(, "easyalluvial")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# econet

<details>

* Version: 1.0.0
* GitHub: NA
* Source code: https://github.com/cran/econet
* Date/Publication: 2022-04-28 00:00:02 UTC
* Number of recursive dependencies: 64

Run `revdep_details(, "econet")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    Error(s) in re-building vignettes:
      ...
    --- re-building ‘econet.tex’ using tex
    Error: processing vignette 'econet.tex' failed with diagnostics:
    Running 'texi2dvi' on 'econet.tex' failed.
    LaTeX errors:
    ! LaTeX Error: File `orcidlink.sty' not found.
    
    Type X to quit or <RETURN> to proceed,
    or enter new name. (Default extension: sty)
    ...
    l.5 \graphicspath
                     {{Figures/}}^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘econet.tex’
    
    SUMMARY: processing the following file failed:
      ‘econet.tex’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# EFAtools

<details>

* Version: 0.4.1
* GitHub: https://github.com/mdsteiner/EFAtools
* Source code: https://github.com/cran/EFAtools
* Date/Publication: 2022-04-24 14:40:02 UTC
* Number of recursive dependencies: 90

Run `revdep_details(, "EFAtools")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  7.4Mb
      sub-directories of 1Mb or more:
        libs   6.1Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# EpiNow2

<details>

* Version: 1.3.2
* GitHub: https://github.com/epiforecasts/EpiNow2
* Source code: https://github.com/cran/EpiNow2
* Date/Publication: 2020-12-14 09:00:15 UTC
* Number of recursive dependencies: 157

Run `revdep_details(, "EpiNow2")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘EpiSoon’
    ```

*   checking installed package size ... NOTE
    ```
      installed size is 225.9Mb
      sub-directories of 1Mb or more:
        libs  224.3Mb
    ```

# geocmeans

<details>

* Version: 0.2.0
* GitHub: https://github.com/JeremyGelb/geocmeans
* Source code: https://github.com/cran/geocmeans
* Date/Publication: 2021-08-23 07:11:35 UTC
* Number of recursive dependencies: 197

Run `revdep_details(, "geocmeans")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 12.7Mb
      sub-directories of 1Mb or more:
        data   2.3Mb
        doc    1.9Mb
        libs   7.4Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘rgdal’
      All declared Imports should be used.
    ```

# lava

<details>

* Version: 1.6.10
* GitHub: https://github.com/kkholst/lava
* Source code: https://github.com/cran/lava
* Date/Publication: 2021-09-02 14:50:18 UTC
* Number of recursive dependencies: 131

Run `revdep_details(, "lava")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking:
      'gof', 'lava.tobit', 'lavaSearch2'
    ```

# lightr

<details>

* Version: 1.7.0
* GitHub: https://github.com/ropensci/lightr
* Source code: https://github.com/cran/lightr
* Date/Publication: 2022-05-14 13:50:02 UTC
* Number of recursive dependencies: 75

Run `revdep_details(, "lightr")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘pavo’
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘pavo’
    ```

# metabolomicsR

<details>

* Version: 1.0.0
* GitHub: https://github.com/XikunHan/metabolomicsR
* Source code: https://github.com/cran/metabolomicsR
* Date/Publication: 2022-04-29 07:40:02 UTC
* Number of recursive dependencies: 163

Run `revdep_details(, "metabolomicsR")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘genuMet’
    ```

# modeltime.ensemble

<details>

* Version: 1.0.0
* GitHub: https://github.com/business-science/modeltime.ensemble
* Source code: https://github.com/cran/modeltime.ensemble
* Date/Publication: 2021-10-19 17:50:02 UTC
* Number of recursive dependencies: 216

Run `revdep_details(, "modeltime.ensemble")` for more info

</details>

## In both

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 50 lines of output:
      Ensemble of 3 Models (WEIGHTED)
      
      # Modeltime Table
      # A tibble: 3 × 4
        .model_id .model     .model_desc             .loadings
            <int> <list>     <chr>                       <dbl>
    ...
       13.     └─rlang::abort(bullets, call = error_call, parent = skip_internal_condition(e))
      ── Failure (test-panel-data.R:134:5): ensemble_weighted(): Forecast Jumbled ────
      accuracy_tbl$mae < 400 is not TRUE
      
      `actual`:   FALSE
      `expected`: TRUE 
      
      [ FAIL 2 | WARN 5 | SKIP 5 | PASS 86 ]
      Error: Test failures
      Execution halted
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘parsnip’
      All declared Imports should be used.
    ```

# modeltime.resample

<details>

* Version: 0.2.0
* GitHub: https://github.com/business-science/modeltime.resample
* Source code: https://github.com/cran/modeltime.resample
* Date/Publication: 2021-03-14 20:40:07 UTC
* Number of recursive dependencies: 214

Run `revdep_details(, "modeltime.resample")` for more info

</details>

## In both

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Last 50 lines of output:
      ✖ readr::edition_get()   masks testthat::edition_get()
      ✖ Matrix::expand()       masks tidyr::expand()
      ✖ dplyr::filter()        masks stats::filter()
      ✖ stringr::fixed()       masks recipes::fixed()
      ✖ purrr::is_null()       masks testthat::is_null()
      ✖ dplyr::lag()           masks stats::lag()
    ...
          ▆
       1. ├─m750_models_resample %>% ... at test-modeltime_fit_resamples.R:116:4
       2. └─modeltime.resample::plot_modeltime_resamples(., .interactive = TRUE)
       3.   └─rlang::sym(target_text)
       4.     └─rlang:::abort_coercion(x, "a symbol")
       5.       └─rlang::abort(msg, call = call)
      
      [ FAIL 3 | WARN 0 | SKIP 0 | PASS 7 ]
      Error: Test failures
      Execution halted
    ```

*   checking re-building of vignette outputs ... ERROR
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘getting-started.Rmd’ using rmarkdown
    ── Attaching packages ────────────────────────────────────── tidymodels 0.2.0 ──
    ✔ broom        0.8.0     ✔ recipes      0.2.0
    ✔ dials        0.1.1     ✔ rsample      0.1.1
    ✔ dplyr        1.0.9     ✔ tibble       3.1.7
    ✔ ggplot2      3.3.6     ✔ tidyr        1.2.0
    ✔ infer        1.0.0     ✔ tune         0.2.0
    ✔ modeldata    0.1.1     ✔ workflows    0.2.6
    ✔ parsnip      0.2.1     ✔ workflowsets 0.2.1
    ...
      no non-missing arguments to max; returning -Inf
    Warning in max(ids, na.rm = TRUE) :
      no non-missing arguments to max; returning -Inf
    --- finished re-building ‘panel-data.Rmd’
    
    SUMMARY: processing the following file failed:
      ‘getting-started.Rmd’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glue’ ‘parsnip’
      All declared Imports should be used.
    ```

# nflreadr

<details>

* Version: 1.2.0
* GitHub: https://github.com/nflverse/nflreadr
* Source code: https://github.com/cran/nflreadr
* Date/Publication: 2022-03-17 13:20:02 UTC
* Number of recursive dependencies: 70

Run `revdep_details(, "nflreadr")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘curl’ ‘qs’
      All declared Imports should be used.
    ```

# norgeo

<details>

* Version: 2.1.0
* GitHub: https://github.com/helseprofil/norgeo
* Source code: https://github.com/cran/norgeo
* Date/Publication: 2022-02-01 16:00:17 UTC
* Number of recursive dependencies: 83

Run `revdep_details(, "norgeo")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘progressr’ ‘vcr’
      All declared Imports should be used.
    ```

# pavo

<details>

* Version: 2.7.1
* GitHub: https://github.com/rmaia/pavo
* Source code: https://github.com/cran/pavo
* Date/Publication: 2021-09-21 13:10:21 UTC
* Number of recursive dependencies: 87

Run `revdep_details(, "pavo")` for more info

</details>

## In both

*   checking whether package ‘pavo’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/c4/home/henrik/repositories/progressr/revdep/checks/pavo/new/pavo.Rcheck/00install.out’ for details.
    ```

# poppr

<details>

* Version: 2.9.3
* GitHub: https://github.com/grunwaldlab/poppr
* Source code: https://github.com/cran/poppr
* Date/Publication: 2021-09-07 07:00:02 UTC
* Number of recursive dependencies: 98

Run `revdep_details(, "poppr")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘RClone’
    ```

# RAINBOWR

<details>

* Version: 0.1.29
* GitHub: NA
* Source code: https://github.com/cran/RAINBOWR
* Date/Publication: 2022-01-07 13:53:11 UTC
* Number of recursive dependencies: 147

Run `revdep_details(, "RAINBOWR")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 37.8Mb
      sub-directories of 1Mb or more:
        libs  36.6Mb
    ```

# remiod

<details>

* Version: 1.0.0
* GitHub: https://github.com/xsswang/remiod
* Source code: https://github.com/cran/remiod
* Date/Publication: 2022-03-14 08:50:02 UTC
* Number of recursive dependencies: 125

Run `revdep_details(, "remiod")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘reshape2’
      All declared Imports should be used.
    ```

# sentopics

<details>

* Version: 0.7.1
* GitHub: https://github.com/odelmarcelle/sentopics
* Source code: https://github.com/cran/sentopics
* Date/Publication: 2022-05-18 13:20:02 UTC
* Number of recursive dependencies: 161

Run `revdep_details(, "sentopics")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  8.1Mb
      sub-directories of 1Mb or more:
        data   1.2Mb
        libs   6.1Mb
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘lexicon’
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 3128 marked UTF-8 strings
    ```

# SeuratObject

<details>

* Version: 4.1.0
* GitHub: https://github.com/mojaveazure/seurat-object
* Source code: https://github.com/cran/SeuratObject
* Date/Publication: 2022-05-01 14:40:07 UTC
* Number of recursive dependencies: 57

Run `revdep_details(, "SeuratObject")` for more info

</details>

## In both

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘plotly’
    ```

# sphunif

<details>

* Version: 1.0.1
* GitHub: https://github.com/egarpor/sphunif
* Source code: https://github.com/cran/sphunif
* Date/Publication: 2021-09-02 07:40:02 UTC
* Number of recursive dependencies: 72

Run `revdep_details(, "sphunif")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 23.9Mb
      sub-directories of 1Mb or more:
        libs  23.1Mb
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 189 marked UTF-8 strings
    ```

# spNetwork

<details>

* Version: 0.4.3.2
* GitHub: https://github.com/JeremyGelb/spNetwork
* Source code: https://github.com/cran/spNetwork
* Date/Publication: 2022-05-14 12:00:02 UTC
* Number of recursive dependencies: 147

Run `revdep_details(, "spNetwork")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 25.0Mb
      sub-directories of 1Mb or more:
        doc       1.0Mb
        extdata   2.6Mb
        libs     20.0Mb
    ```

# SPQR

<details>

* Version: 0.1.0
* GitHub: https://github.com/stevengxu/SPQR
* Source code: https://github.com/cran/SPQR
* Date/Publication: 2022-05-02 20:02:03 UTC
* Number of recursive dependencies: 65

Run `revdep_details(, "SPQR")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘Rcpp’ ‘progress’
      All declared Imports should be used.
    ```

# targeted

<details>

* Version: 0.2.0
* GitHub: https://github.com/kkholst/targeted
* Source code: https://github.com/cran/targeted
* Date/Publication: 2021-10-26 14:40:02 UTC
* Number of recursive dependencies: 76

Run `revdep_details(, "targeted")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 16.4Mb
      sub-directories of 1Mb or more:
        libs  15.5Mb
    ```

# vmeasur

<details>

* Version: 0.1.4
* GitHub: NA
* Source code: https://github.com/cran/vmeasur
* Date/Publication: 2021-11-11 19:00:02 UTC
* Number of recursive dependencies: 123

Run `revdep_details(, "vmeasur")` for more info

</details>

## In both

*   checking whether package ‘vmeasur’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/c4/home/henrik/repositories/progressr/revdep/checks/vmeasur/new/vmeasur.Rcheck/00install.out’ for details.
    ```

