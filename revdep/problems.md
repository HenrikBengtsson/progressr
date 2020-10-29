# cSEM

<details>

* Version: 0.3.0
* GitHub: https://github.com/M-E-Rademaker/cSEM
* Source code: https://github.com/cran/cSEM
* Date/Publication: 2020-10-12 16:40:03 UTC
* Number of recursive dependencies: 116

Run `revdep_details(, "cSEM")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘Rdpack’
      All declared Imports should be used.
    ```

# econet

<details>

* Version: 0.1.92
* GitHub: NA
* Source code: https://github.com/cran/econet
* Date/Publication: 2020-09-02 11:20:02 UTC
* Number of recursive dependencies: 62

Run `revdep_details(, "econet")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    ...
    Error: processing vignette 'econet.tex' failed with diagnostics:
    Running 'texi2dvi' on 'econet.tex' failed.
    LaTeX errors:
    ! LaTeX Error: File `xpatch.sty' not found.
    
    Type X to quit or <RETURN> to proceed,
    or enter new name. (Default extension: sty)
    
    ! Emergency stop.
    <read *> 
             
    l.20 \makeatletter
                      ^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘econet.tex’
    
    SUMMARY: processing the following file failed:
      ‘econet.tex’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# EpiNow2

<details>

* Version: 1.2.1
* GitHub: NA
* Source code: https://github.com/cran/EpiNow2
* Date/Publication: 2020-10-20 14:50:09 UTC
* Number of recursive dependencies: 141

Run `revdep_details(, "EpiNow2")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘EpiSoon’
    ```

*   checking installed package size ... NOTE
    ```
      installed size is 107.4Mb
      sub-directories of 1Mb or more:
        help    2.3Mb
        libs  104.8Mb
    ```

# lmtp

<details>

* Version: 0.0.5
* GitHub: NA
* Source code: https://github.com/cran/lmtp
* Date/Publication: 2020-07-18 09:10:02 UTC
* Number of recursive dependencies: 77

Run `revdep_details(, "lmtp")` for more info

</details>

## In both

*   checking tests ...
    ```
    ...
      > 
      > test_check("lmtp")
      -- 1. Error: contrast output is correct (@test-contrasts.R#29)  ----------------
      unable to start device PNG
      Backtrace:
       1. testthat::verify_output(...)
       2. grDevices::png(filename = tempfile())
      
      -- 2. Error: create proper node lists, t > 1 (@test-node_list.R#5)  ------------
      unable to start device PNG
      Backtrace:
       1. testthat::verify_output(...)
       2. grDevices::png(filename = tempfile())
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      [ OK: 24 | SKIPPED: 0 | WARNINGS: 2 | FAILED: 2 ]
      1. Error: contrast output is correct (@test-contrasts.R#29) 
      2. Error: create proper node lists, t > 1 (@test-node_list.R#5) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Package which this enhances but not available for checking: ‘sl3’
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘R6’ ‘nnls’ ‘utils’
      All declared Imports should be used.
    ```

# modeltime

<details>

* Version: 0.3.0
* GitHub: https://github.com/business-science/modeltime
* Source code: https://github.com/cran/modeltime
* Date/Publication: 2020-10-28 14:00:07 UTC
* Number of recursive dependencies: 190

Run `revdep_details(, "modeltime")` for more info

</details>

## In both

*   checking tests ...
    ```
    ...
      
      The following object is masked from 'package:kernlab':
      
          error
      
      ── 1. Error: (unknown) (@test-results-forecast-plots.R#34)  ────────────────────
      unable to start device PNG
      Backtrace:
        1. base::suppressWarnings(...)
        2. dplyr::mutate_at(., vars(.value:.conf_hi), exp)
       10. modeltime::plot_modeltime_forecast(., .interactive = TRUE)
       13. plotly:::ggplotly.ggplot(g, dynamicTicks = TRUE)
       14. plotly::gg2list(...)
       15. grDevices:::dev_fun(...)
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      [ OK: 465 | SKIPPED: 7 | WARNINGS: 0 | FAILED: 1 ]
      1. Error: (unknown) (@test-results-forecast-plots.R#34) 
      
      Error: testthat unit tests failed
      Execution halted
    ```

# modeltime.ensemble

<details>

* Version: 0.2.0
* GitHub: https://github.com/business-science/modeltime.ensemble
* Source code: https://github.com/cran/modeltime.ensemble
* Date/Publication: 2020-10-09 10:20:02 UTC
* Number of recursive dependencies: 184

Run `revdep_details(, "modeltime.ensemble")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glmnet’ ‘parsnip’ ‘timetk’
      All declared Imports should be used.
    ```

# pavo

<details>

* Version: 2.4.0
* GitHub: https://github.com/rmaia/pavo
* Source code: https://github.com/cran/pavo
* Date/Publication: 2020-02-08 16:20:08 UTC
* Number of recursive dependencies: 90

Run `revdep_details(, "pavo")` for more info

</details>

## In both

*   checking whether package ‘pavo’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/c4/home/henrik/repositories/progressr/revdep/checks/pavo/new/pavo.Rcheck/00install.out’ for details.
    ```

