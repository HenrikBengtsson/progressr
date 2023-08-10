# CRAN submission progressr 0.14.0

on 2023-08-10

I've verified this submission has no negative impact on any of the 82 reverse package dependencies available on CRAN (n = 79) and Bioconductor (n = 3).

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub | mac/win-builder |
| --------- | ------ | ----- | --------------- |
| 3.5.x     | L      |       |                 |
| 4.0.x     | L      |       |                 |
| 4.1.x     | L      |       |                 |
| 4.2.x     | L      |       |                 |
| 4.3.x     | L M W  | L  W  | M1 W            |
| devel     | L M W  | L     |    W            |

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
── progressr 0.13.0-9013: OK

  Build ID:   progressr_0.13.0-9013.tar.gz-d76d5bc4979b480fa1e4bbe0c5d705a1
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  17m 26.7s ago
  Build time: 17m 23.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0-9013: OK

  Build ID:   progressr_0.13.0-9013.tar.gz-bbc8cdfc4d0241ebb3d0129420c7fed4
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  17m 26.7s ago
  Build time: 16m 17.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0-9013: OK

  Build ID:   progressr_0.13.0-9013.tar.gz-71676aa30ce74ff7931c996a95e7b327
  Platform:   Fedora Linux, R-devel, GCC
  Submitted:  17m 26.7s ago
  Build time: 15m 0.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.13.0-9013: OK

  Build ID:   progressr_0.13.0-9013.tar.gz-29b149c623ba4eea91841fd5a9fc6ac7
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  17m 26.7s ago
  Build time: 5m 50.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
