# CRAN submission progressr 0.11.0

on 2022-09-02

I've verified this submission has no negative impact on any of the 61 reverse package dependencies available on CRAN and Bioconductor.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version     | GitHub | R-hub    | mac/win-builder |
| ------------- | ------ | -------- | --------------- |
| 3.5.x         | L      |          |                 |
| 3.6.x         | L      |          |                 |
| 4.0.x         | L      |          |                 |
| 4.1.x         | L      |          |                 |
| 4.2.x         | L M W  | . . . .  | M1 W            |
| devel         | L M W  | .        |    W            |

*Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows*


R-hub checks:

```r
res <- rhub::check(platform = c(
  "debian-clang-devel", "debian-gcc-patched",
  # "linux-x86_64-rocker-gcc-san", ## PREPERROR
  "macos-highsierra-release-cran", "macos-m1-bigsur-release",
  "windows-x86_64-release"))
print(res)
```

gives

```
── progressr 0.10.1-9006: OK

  Build ID:   progressr_0.10.1-9006.tar.gz-9a50bd7d1bd04eb2b2f26521d3b80341
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  10h 2m 43.2s ago
  Build time: 41m 6.7s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.1-9006: OK

  Build ID:   progressr_0.10.1-9006.tar.gz-9524e554921844788cb6f3b5325ee6f4
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  10h 2m 43.2s ago
  Build time: 39m 3.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.1-9006: OK

  Build ID:   progressr_0.10.1-9006.tar.gz-74b5766086104d47993c7dc416fb91d8
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  10h 2m 43.3s ago
  Build time: 4m 12.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.1-9006: OK

  Build ID:   progressr_0.10.1-9006.tar.gz-b75132d3ceae4752b3fd777aeb31d8c9
  Platform:   Apple Silicon (M1), macOS 11.6 Big Sur, R-release
  Submitted:  10h 2m 43.3s ago
  Build time: 2m 54.6s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.1-9006: OK

  Build ID:   progressr_0.10.1-9006.tar.gz-19507b52da6a431badc50d8e42b10974
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  10h 2m 43.3s ago
  Build time: 9m 2.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
