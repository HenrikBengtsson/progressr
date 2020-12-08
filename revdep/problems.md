# cSEM

<details>

* Version: 0.3.0
* GitHub: https://github.com/M-E-Rademaker/cSEM
* Source code: https://github.com/cran/cSEM
* Date/Publication: 2020-10-12 16:40:03 UTC
* Number of recursive dependencies: 119

Run `revdep_details(, "cSEM")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘Rdpack’
      All declared Imports should be used.
    ```

# EFAtools

<details>

* Version: 0.3.0
* GitHub: https://github.com/mdsteiner/EFAtools
* Source code: https://github.com/cran/EFAtools
* Date/Publication: 2020-11-04 18:00:02 UTC
* Number of recursive dependencies: 88

Run `revdep_details(, "EFAtools")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  7.4Mb
      sub-directories of 1Mb or more:
        doc    1.0Mb
        libs   5.5Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘progress’
      All declared Imports should be used.
    ```

# EpiNow2

<details>

* Version: 1.3.1
* GitHub: NA
* Source code: https://github.com/cran/EpiNow2
* Date/Publication: 2020-11-22 14:20:05 UTC
* Number of recursive dependencies: 149

Run `revdep_details(, "EpiNow2")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘EpiSoon’
    ```

*   checking installed package size ... NOTE
    ```
      installed size is 137.8Mb
      sub-directories of 1Mb or more:
        libs  136.4Mb
    ```

# lmtp

<details>

* Version: 0.0.5
* GitHub: NA
* Source code: https://github.com/cran/lmtp
* Date/Publication: 2020-07-18 09:10:02 UTC
* Number of recursive dependencies: 86

Run `revdep_details(, "lmtp")` for more info

</details>

## In both

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

* Version: 0.4.0
* GitHub: https://github.com/business-science/modeltime
* Source code: https://github.com/cran/modeltime
* Date/Publication: 2020-11-23 08:50:05 UTC
* Number of recursive dependencies: 195

Run `revdep_details(, "modeltime")` for more info

</details>

## In both

*   checking tests ...
    ```
    ...
      Error: unable to start device PNG
      Backtrace:
          █
       1. ├─base::suppressWarnings(...) test-results-forecast-plots.R:34:0
       2. │ └─base::withCallingHandlers(...)
       3. ├─forecast_tbl %>% mutate_at(vars(.value:.conf_hi), exp) %>% plot_modeltime_forecast(.interactive = TRUE) test-results-forecast-plots.R:36:4
       4. └─modeltime::plot_modeltime_forecast(., .interactive = TRUE)
       5.   ├─plotly::ggplotly(g, dynamicTicks = TRUE)
       6.   └─plotly:::ggplotly.ggplot(g, dynamicTicks = TRUE)
       7.     └─plotly::gg2list(...)
       8.       └─grDevices:::dev_fun(...)
      
      ── Skipped tests  ──────────────────────────────────────────────────────────────
      ● On CRAN (7)
      
      ══ testthat results  ═══════════════════════════════════════════════════════════
      ERROR (test-results-forecast-plots.R:34:1): (code run outside of `test_that()`)
      
      [ FAIL 1 | WARN 0 | SKIP 7 | PASS 473 ]
      Error: Test failures
      Execution halted
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘slider’
      All declared Imports should be used.
    ```

# modeltime.ensemble

<details>

* Version: 0.3.0
* GitHub: https://github.com/business-science/modeltime.ensemble
* Source code: https://github.com/cran/modeltime.ensemble
* Date/Publication: 2020-11-06 18:00:02 UTC
* Number of recursive dependencies: 190

Run `revdep_details(, "modeltime.ensemble")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glmnet’ ‘parsnip’ ‘progressr’ ‘utils’
      All declared Imports should be used.
    ```

# modeltime.resample

<details>

* Version: 0.1.0
* GitHub: https://github.com/business-science/modeltime.resample
* Source code: https://github.com/cran/modeltime.resample
* Date/Publication: 2020-11-05 07:40:09 UTC
* Number of recursive dependencies: 194

Run `revdep_details(, "modeltime.resample")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘crayon’ ‘dials’ ‘glue’ ‘parsnip’
      All declared Imports should be used.
    ```

# pavo

<details>

* Version: 2.5.0
* GitHub: https://github.com/rmaia/pavo
* Source code: https://github.com/cran/pavo
* Date/Publication: 2020-11-12 09:00:02 UTC
* Number of recursive dependencies: 101

Run `revdep_details(, "pavo")` for more info

</details>

## In both

*   checking whether package ‘pavo’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
    See ‘/c4/home/henrik/repositories/progressr/revdep/checks/pavo/new/pavo.Rcheck/00install.out’ for details.
    ```

