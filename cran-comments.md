# CRAN submission progressr 0.6.0

on 2020-05-18

I've verified that this submission does not cause issues for the 6 reverse package dependency available on CRAN.

Thanks in advance


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version          | GitHub Actions | Travis CI | AppVeyor CI | Rhub      | Win-builder | Other  |
| ------------------ | -------------- | --------- | ----------- | --------- | ----------- | ------ |
| 3.4.4              | L              |           |             |           |             |        |
| 3.5.3              | L, M, W        |           |             |           |             |        |
| 3.6.3              | L, M, W        | L, M      | W           | L         |             |        |
| 4.0.0              | L, M, W        | L, M      | W           | S (32)    | W           |        |
| devel              |    M  W        | L         | W (32 & 64) | L, W      | W           |        |

*Legend: OS: L = Linux, S = Solaris, M = macOS, W = Windows.  Architecture: 32 = 32-bit, 64 = 64-bit*
