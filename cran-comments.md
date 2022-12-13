# CRAN submission progressr 0.12.0

on 2022-12-12

I've verified this submission has no negative impact on any of the 68 reverse package dependencies available on CRAN (n = 65) and Bioconductor (n = 3).

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub  | mac/win-builder |
| --------- | ------ | ------ | --------------- |
| 3.5.x     | L      |        |                 |
| 3.6.x     | L      |        |                 |
| 4.0.x     | L      |        |                 |
| 4.1.x     | L      |   M    |                 |
| 4.2.x     | L M W  | L   W  | M1 W            |
| devel     | L M W  | L      | M1 W            |

*Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows*


R-hub checks:

```r
res <- rhub::check(platforms = c(
  "debian-clang-devel", 
  "debian-gcc-patched", 
  "fedora-gcc-devel",
  "macos-highsierra-release-cran",
  "windows-x86_64-release"
))
print(res)
```

gives

```
── progressr 0.11.0-9022: OK

  Build ID:   progressr_0.11.0-9022.tar.gz-4495cb1f89ba4215a7482a9bf192d745
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  1h 2m 16.7s ago
  Build time: 1h 2m 1.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.11.0-9022: OK

  Build ID:   progressr_0.11.0-9022.tar.gz-b6893af73912457687fe361c284573fd
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  1h 2m 16.8s ago
  Build time: 1h 44.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.11.0-9022: OK

  Build ID:   progressr_0.11.0-9022.tar.gz-ca6f0eafe67b4e3ebace034e71bf9b83
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  1h 2m 16.8s ago
  Build time: 55m 3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.11.0-9022: OK

  Build ID:   progressr_0.11.0-9022.tar.gz-d5cd6ade429a4f9ba9757669a4cb6ddd
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  1h 2m 16.8s ago
  Build time: 4m 38.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.11.0-9022: OK

  Build ID:   progressr_0.11.0-9022.tar.gz-6d42bbd8887a4c16936b7c88d8b07b0b
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  1h 2m 16.8s ago
  Build time: 5m 21.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
