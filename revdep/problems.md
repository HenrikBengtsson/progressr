# AIPW

<details>

* Version: 0.6.3.2
* GitHub: https://github.com/yqzhong7/AIPW
* Source code: https://github.com/cran/AIPW
* Date/Publication: 2021-06-11 09:30:02 UTC
* Number of recursive dependencies: 100

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

# cSEM

<details>

* Version: 0.5.0
* GitHub: https://github.com/M-E-Rademaker/cSEM
* Source code: https://github.com/cran/cSEM
* Date/Publication: 2022-11-24 17:50:05 UTC
* Number of recursive dependencies: 126

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

* Version: 0.2.5
* GitHub: https://github.com/dipterix/dipsaus
* Source code: https://github.com/cran/dipsaus
* Date/Publication: 2022-10-22 07:05:06 UTC
* Number of recursive dependencies: 72

Run `revdep_details(, "dipsaus")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  6.0Mb
      sub-directories of 1Mb or more:
        doc    1.1Mb
        libs   3.6Mb
    ```

# econet

<details>

* Version: 1.0.0
* GitHub: NA
* Source code: https://github.com/cran/econet
* Date/Publication: 2022-04-28 00:00:02 UTC
* Number of recursive dependencies: 63

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

* Version: 0.4.4
* GitHub: https://github.com/mdsteiner/EFAtools
* Source code: https://github.com/cran/EFAtools
* Date/Publication: 2023-01-06 14:50:40 UTC
* Number of recursive dependencies: 91

Run `revdep_details(, "EFAtools")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  7.4Mb
      sub-directories of 1Mb or more:
        libs   6.2Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# fabletools

<details>

* Version: 0.3.2
* GitHub: https://github.com/tidyverts/fabletools
* Source code: https://github.com/cran/fabletools
* Date/Publication: 2021-11-29 05:50:02 UTC
* Number of recursive dependencies: 102

Run `revdep_details(, "fabletools")` for more info

</details>

## In both

*   checking tests ...
    ```
      Running ‘testthat.R’
     ERROR
    Running the tests in ‘tests/testthat.R’ failed.
    Complete output:
      > library(testthat)
      > library(dplyr)
      
      Attaching package: 'dplyr'
      
      The following object is masked from 'package:testthat':
    ...
      ── Failure ('test-generate.R:12'): generate ────────────────────────────────────
      gen_multi$index not equal to yearmonth("1979 Jan") + rep(0:23, 2).
      'is.NA' value mismatch: 20 in current 0 in target
      ── Failure ('test-generate.R:17'): generate ────────────────────────────────────
      gen_complex$index not equal to yearmonth("1979 Jan") + rep(0:23, 2 * 2 * 3).
      'is.NA' value mismatch: 120 in current 0 in target
      
      [ FAIL 3 | WARN 5 | SKIP 1 | PASS 292 ]
      Error: Test failures
      Execution halted
    ```

# geocmeans

<details>

* Version: 0.3.2
* GitHub: https://github.com/JeremyGelb/geocmeans
* Source code: https://github.com/cran/geocmeans
* Date/Publication: 2023-01-08 21:40:02 UTC
* Number of recursive dependencies: 197

Run `revdep_details(, "geocmeans")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 14.4Mb
      sub-directories of 1Mb or more:
        doc       1.7Mb
        extdata   3.0Mb
        libs      8.1Mb
    ```

# ISAnalytics

<details>

* Version: 1.8.1
* GitHub: https://github.com/calabrialab/ISAnalytics
* Source code: https://github.com/cran/ISAnalytics
* Date/Publication: 2022-12-01
* Number of recursive dependencies: 171

Run `revdep_details(, "ISAnalytics")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  7.9Mb
      sub-directories of 1Mb or more:
        data   1.4Mb
        doc    4.4Mb
    ```

*   checking R code for possible problems ... NOTE
    ```
    .sh_row_permut: no visible global function definition for ‘.’
    .sharing_multdf_mult_key: no visible binding for global variable ‘.’
    .sharing_multdf_single_key: no visible binding for global variable ‘.’
    .sharing_singledf_mult_key: no visible binding for global variable ‘.’
    .sharing_singledf_single_key: no visible binding for global variable
      ‘.’
    cumulative_is: no visible binding for global variable ‘is’
    gene_frequency_fisher: no visible binding for global variable ‘.’
    Undefined global functions or variables:
      . is
    Consider adding
      importFrom("methods", "is")
    to your NAMESPACE file (and ensure that your DESCRIPTION Imports field
    contains 'methods').
    ```

# lightr

<details>

* Version: 1.7.0
* GitHub: https://github.com/ropensci/lightr
* Source code: https://github.com/cran/lightr
* Date/Publication: 2022-05-14 13:50:02 UTC
* Number of recursive dependencies: 77

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

* Version: 1.0.2
* GitHub: https://github.com/business-science/modeltime.ensemble
* Source code: https://github.com/cran/modeltime.ensemble
* Date/Publication: 2022-10-18 23:02:40 UTC
* Number of recursive dependencies: 220

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

* Version: 0.2.2
* GitHub: https://github.com/business-science/modeltime.resample
* Source code: https://github.com/cran/modeltime.resample
* Date/Publication: 2022-10-18 03:00:06 UTC
* Number of recursive dependencies: 218

Run `revdep_details(, "modeltime.resample")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glue’ ‘parsnip’
      All declared Imports should be used.
    ```

# oddsapiR

<details>

* Version: 0.0.2
* GitHub: https://github.com/sportsdataverse/oddsapiR
* Source code: https://github.com/cran/oddsapiR
* Date/Publication: 2023-01-05 18:10:02 UTC
* Number of recursive dependencies: 112

Run `revdep_details(, "oddsapiR")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘purrr’
      All declared Imports should be used.
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 4 marked UTF-8 strings
    ```

# pavo

<details>

* Version: 2.8.0
* GitHub: https://github.com/rmaia/pavo
* Source code: https://github.com/cran/pavo
* Date/Publication: 2022-08-16 13:00:20 UTC
* Number of recursive dependencies: 91

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
* Number of recursive dependencies: 97

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
* Number of recursive dependencies: 150

Run `revdep_details(, "RAINBOWR")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 37.8Mb
      sub-directories of 1Mb or more:
        libs  36.6Mb
    ```

# sentopics

<details>

* Version: 0.7.1
* GitHub: https://github.com/odelmarcelle/sentopics
* Source code: https://github.com/cran/sentopics
* Date/Publication: 2022-05-18 13:20:02 UTC
* Number of recursive dependencies: 165

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

# Seurat

<details>

* Version: 4.3.0
* GitHub: https://github.com/satijalab/seurat
* Source code: https://github.com/cran/Seurat
* Date/Publication: 2022-11-18 23:30:08 UTC
* Number of recursive dependencies: 259

Run `revdep_details(, "Seurat")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 14.5Mb
      sub-directories of 1Mb or more:
        R      1.4Mb
        libs  12.4Mb
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘Signac’
    ```

# SeuratObject

<details>

* Version: 4.1.3
* GitHub: https://github.com/mojaveazure/seurat-object
* Source code: https://github.com/cran/SeuratObject
* Date/Publication: 2022-11-07 18:50:02 UTC
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
* Number of recursive dependencies: 74

Run `revdep_details(, "sphunif")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 24.2Mb
      sub-directories of 1Mb or more:
        libs  23.4Mb
    ```

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 189 marked UTF-8 strings
    ```

# spNetwork

<details>

* Version: 0.4.3.6
* GitHub: https://github.com/JeremyGelb/spNetwork
* Source code: https://github.com/cran/spNetwork
* Date/Publication: 2022-11-11 08:10:02 UTC
* Number of recursive dependencies: 149

Run `revdep_details(, "spNetwork")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 25.4Mb
      sub-directories of 1Mb or more:
        doc       1.0Mb
        extdata   2.6Mb
        libs     20.4Mb
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

# squat

<details>

* Version: 0.1.0
* GitHub: NA
* Source code: https://github.com/cran/squat
* Date/Publication: 2022-12-22 11:20:02 UTC
* Number of recursive dependencies: 123

Run `revdep_details(, "squat")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 18.7Mb
      sub-directories of 1Mb or more:
        data   1.1Mb
        libs  16.7Mb
    ```

# targeted

<details>

* Version: 0.3
* GitHub: https://github.com/kkholst/targeted
* Source code: https://github.com/cran/targeted
* Date/Publication: 2022-10-25 20:30:02 UTC
* Number of recursive dependencies: 94

Run `revdep_details(, "targeted")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 16.9Mb
      sub-directories of 1Mb or more:
        libs  15.8Mb
    ```

# vmeasur

<details>

* Version: 0.1.4
* GitHub: NA
* Source code: https://github.com/cran/vmeasur
* Date/Publication: 2021-11-11 19:00:02 UTC
* Number of recursive dependencies: 121

Run `revdep_details(, "vmeasur")` for more info

</details>

## In both

*   checking whether package ‘vmeasur’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/c4/home/henrik/repositories/progressr/revdep/checks/vmeasur/new/vmeasur.Rcheck/00install.out’ for details.
    ```

