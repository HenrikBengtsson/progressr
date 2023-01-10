# CRAN submission progressr 0.13.0

on 2023-01-09

I've verified this submission has no negative impact on any of the 70 reverse package dependencies available on CRAN (n = 67) and Bioconductor (n = 3).

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
── progressr 0.13.0: OK

  Build ID:   progressr_0.13.0.tar.gz-d11f185b89e4479482ebfa691044c756
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  53m 44.4s ago
  Build time: 53m 37.5s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0: OK

  Build ID:   progressr_0.13.0.tar.gz-1edbec52c27c443c9ce9bd4154e92b8c
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  53m 44.4s ago
  Build time: 53m 10.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0: OK

  Build ID:   progressr_0.13.0.tar.gz-42ae3c8a45a84680a0ea83bfe24bf4e5
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  53m 44.4s ago
  Build time: 46m 26.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0: OK

  Build ID:   progressr_0.13.0.tar.gz-eaee37da30424bb5a71d134f77adfb98
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  53m 44.4s ago
  Build time: 4m 43.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0: OK

  Build ID:   progressr_0.13.0.tar.gz-95c2a5ae023b4c6793d4e986528cb55d
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  53m 44.4s ago
  Build time: 4m 19.7s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
