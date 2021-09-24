# AIPW

<details>

* Version: 0.6.3.2
* GitHub: https://github.com/yqzhong7/AIPW
* Source code: https://github.com/cran/AIPW
* Date/Publication: 2021-06-11 09:30:02 UTC
* Number of recursive dependencies: 93

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

# bayesmove

<details>

* Version: 0.2.0
* GitHub: https://github.com/joshcullen/bayesmove
* Source code: https://github.com/cran/bayesmove
* Date/Publication: 2021-04-26 22:10:11 UTC
* Number of recursive dependencies: 144

Run `revdep_details(, "bayesmove")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘move’
      All declared Imports should be used.
    ```

# cSEM

<details>

* Version: 0.4.0
* GitHub: https://github.com/M-E-Rademaker/cSEM
* Source code: https://github.com/cran/cSEM
* Date/Publication: 2021-04-19 22:00:18 UTC
* Number of recursive dependencies: 121

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

* Version: 0.1.8
* GitHub: https://github.com/dipterix/dipsaus
* Source code: https://github.com/cran/dipsaus
* Date/Publication: 2021-09-06 11:50:02 UTC
* Number of recursive dependencies: 76

Run `revdep_details(, "dipsaus")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  6.7Mb
      sub-directories of 1Mb or more:
        doc    1.3Mb
        libs   3.5Mb
    ```

# easyalluvial

<details>

* Version: 0.3.0
* GitHub: https://github.com/erblast/easyalluvial
* Source code: https://github.com/cran/easyalluvial
* Date/Publication: 2021-01-13 10:40:09 UTC
* Number of recursive dependencies: 142

Run `revdep_details(, "easyalluvial")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘parcats’
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# econet

<details>

* Version: 0.1.94
* GitHub: NA
* Source code: https://github.com/cran/econet
* Date/Publication: 2021-05-24 13:50:06 UTC
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
    ! LaTeX Error: File `xpatch.sty' not found.
    
    Type X to quit or <RETURN> to proceed,
    or enter new name. (Default extension: sty)
    ...
    l.21 \makeatletter
                      ^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘econet.tex’
    
    SUMMARY: processing the following file failed:
      ‘econet.tex’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# EFAtools

<details>

* Version: 0.3.1
* GitHub: https://github.com/mdsteiner/EFAtools
* Source code: https://github.com/cran/EFAtools
* Date/Publication: 2021-03-27 08:40:42 UTC
* Number of recursive dependencies: 86

Run `revdep_details(, "EFAtools")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  8.0Mb
      sub-directories of 1Mb or more:
        doc    1.0Mb
        libs   5.6Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# elevatr

<details>

* Version: 0.4.1
* GitHub: https://github.com/jhollist/elevatr
* Source code: https://github.com/cran/elevatr
* Date/Publication: 2021-07-22 04:40:15 UTC
* Number of recursive dependencies: 78

Run `revdep_details(, "elevatr")` for more info

</details>

## In both

*   checking tests ...
    ```
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Complete output:
      > library(testthat)
      > library(elevatr)
      > 
      > test_check("elevatr")
      ══ Failed tests ════════════════════════════════════════════════════════════════
      ── Error (test-get_elev_point.R:11:1): (code run outside of `test_that()`) ─────
      Error: no arguments in initialization list
    ...
          █
       1. ├─sp::SpatialPoints(coordinates(pt_df), CRS(SRS_string = ll_prj)) test-internal.R:14:0
       2. │ └─methods::new("SpatialPoints", coords = coords, bbox = bbox, proj4string = proj4string)
       3. │   ├─methods::initialize(value, ...)
       4. │   └─methods::initialize(value, ...)
       5. └─sp::CRS(SRS_string = ll_prj)
      
      [ FAIL 3 | WARN 0 | SKIP 0 | PASS 0 ]
      Error: Test failures
      Execution halted
    ```

# EpiNow2

<details>

* Version: 1.3.2
* GitHub: https://github.com/epiforecasts/EpiNow2
* Source code: https://github.com/cran/EpiNow2
* Date/Publication: 2020-12-14 09:00:15 UTC
* Number of recursive dependencies: 154

Run `revdep_details(, "EpiNow2")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘EpiSoon’
    ```

*   checking installed package size ... NOTE
    ```
      installed size is 169.0Mb
      sub-directories of 1Mb or more:
        help    1.1Mb
        libs  166.7Mb
    ```

# fabletools

<details>

* Version: 0.3.1
* GitHub: https://github.com/tidyverts/fabletools
* Source code: https://github.com/cran/fabletools
* Date/Publication: 2021-03-16 22:10:03 UTC
* Number of recursive dependencies: 96

Run `revdep_details(, "fabletools")` for more info

</details>

## In both

*   checking LazyData ... NOTE
    ```
      'LazyData' is specified without a 'data' directory
    ```

# geocmeans

<details>

* Version: 0.2.0
* GitHub: https://github.com/JeremyGelb/geocmeans
* Source code: https://github.com/cran/geocmeans
* Date/Publication: 2021-08-23 07:11:35 UTC
* Number of recursive dependencies: 217

Run `revdep_details(, "geocmeans")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 13.7Mb
      sub-directories of 1Mb or more:
        data   4.3Mb
        doc    1.9Mb
        libs   6.1Mb
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
* Number of recursive dependencies: 130

Run `revdep_details(, "lava")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking: 'gof', 'lava.tobit'
    ```

*   checking installed package size ... NOTE
    ```
      installed size is  5.1Mb
      sub-directories of 1Mb or more:
        R     2.0Mb
        doc   2.1Mb
    ```

# lightr

<details>

* Version: 1.6.0
* GitHub: https://github.com/ropensci/lightr
* Source code: https://github.com/cran/lightr
* Date/Publication: 2021-07-22 10:50:03 UTC
* Number of recursive dependencies: 71

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

# lmtp

<details>

* Version: 0.9.1
* GitHub: https://github.com/nt-williams/lmtp
* Source code: https://github.com/cran/lmtp
* Date/Publication: 2021-08-18 09:10:02 UTC
* Number of recursive dependencies: 109

Run `revdep_details(, "lmtp")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘R6’ ‘nnls’ ‘utils’
      All declared Imports should be used.
    ```

# mikropml

<details>

* Version: 1.1.1
* GitHub: https://github.com/SchlossLab/mikropml
* Source code: https://github.com/cran/mikropml
* Date/Publication: 2021-09-14 06:50:02 UTC
* Number of recursive dependencies: 111

Run `revdep_details(, "mikropml")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  5.0Mb
      sub-directories of 1Mb or more:
        data   4.0Mb
    ```

# modeltime.ensemble

<details>

* Version: 0.4.2
* GitHub: https://github.com/business-science/modeltime.ensemble
* Source code: https://github.com/cran/modeltime.ensemble
* Date/Publication: 2021-07-16 12:10:02 UTC
* Number of recursive dependencies: 214

Run `revdep_details(, "modeltime.ensemble")` for more info

</details>

## In both

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
* Number of recursive dependencies: 212

Run `revdep_details(, "modeltime.resample")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glue’ ‘parsnip’
      All declared Imports should be used.
    ```

# nflreadr

<details>

* Version: 1.1.0
* GitHub: https://github.com/nflverse/nflreadr
* Source code: https://github.com/cran/nflreadr
* Date/Publication: 2021-09-02 04:40:02 UTC
* Number of recursive dependencies: 67

Run `revdep_details(, "nflreadr")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘curl’ ‘qs’
      All declared Imports should be used.
    ```

# pavo

<details>

* Version: 2.7.1
* GitHub: https://github.com/rmaia/pavo
* Source code: https://github.com/cran/pavo
* Date/Publication: 2021-09-21 13:10:21 UTC
* Number of recursive dependencies: 85

Run `revdep_details(, "pavo")` for more info

</details>

## In both

*   checking whether package ‘pavo’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/scratch/henrik/revdepcheck.extras/progressr/revdep/checks/pavo/new/pavo.Rcheck/00install.out’ for details.
    ```

# smoots

<details>

* Version: 1.1.1
* GitHub: NA
* Source code: https://github.com/cran/smoots
* Date/Publication: 2021-09-22 10:40:02 UTC
* Number of recursive dependencies: 66

Run `revdep_details(, "smoots")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# sphunif

<details>

* Version: 1.0.1
* GitHub: https://github.com/egarpor/sphunif
* Source code: https://github.com/cran/sphunif
* Date/Publication: 2021-09-02 07:40:02 UTC
* Number of recursive dependencies: 68

Run `revdep_details(, "sphunif")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 20.8Mb
      sub-directories of 1Mb or more:
        libs  19.6Mb
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 189 marked UTF-8 strings
    ```

# spNetwork

<details>

* Version: 0.1.1
* GitHub: https://github.com/JeremyGelb/spNetwork
* Source code: https://github.com/cran/spNetwork
* Date/Publication: 2021-01-21 23:30:02 UTC
* Number of recursive dependencies: 120

Run `revdep_details(, "spNetwork")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 10.3Mb
      sub-directories of 1Mb or more:
        extdata   5.6Mb
        libs      3.6Mb
    ```

*   checking LazyData ... NOTE
    ```
      'LazyData' is specified without a 'data' directory
    ```

