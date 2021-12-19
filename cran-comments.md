# CRAN submission progressr 0.10.0

on 2021-12-28

I've verified this submission has no negative impact on any of the 47 reverse package dependencies available on CRAN.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version | GitHub | R-hub    | {mac,win}-builder |
| --------- | ------ | -------- | ----------------- |
| 3.5.x     | L      |          |                   |
| 4.0.x     | L      |          |                   |
| 4.1.x     | L M W  | L M M1   | M1 W              |
| devel     | L M W  | L      W |    W              |

*Legend: OS: L = Linux, S = Solaris, M = macOS, M1 = macOS M1, W = Windows*


R-hub checks:

```r
res <- rhub::check(platform = c(
  "debian-clang-devel", "debian-gcc-patched", "linux-x86_64-centos-epel",
  "macos-highsierra-release-cran", "macos-m1-bigsur-release",
  "windows-x86_64-release"))
print(res)
```

gives

```
── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-fafd77723dda4ba39417818ed521cf3c
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  14m 14.6s ago
  Build time: 13m 58.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-28fe3432859d4ca5ad99cea0fdd71366
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  14m 14.7s ago
  Build time: 11m 19.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-3a23e51d9f3148b3b4f9ff82268fe1b2
  Platform:   CentOS 8, stock R from EPEL
  Submitted:  14m 14.7s ago
  Build time: 11m 19.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-ddc0f0c04f6e4371952376efb96730d6
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  14m 14.7s ago
  Build time: 3m 46.6s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-917ef27fdbcf41cea0162ab59eed04e1
  Platform:   Apple Silicon (M1), macOS 11.6 Big Sur, R-release
  Submitted:  14m 14.8s ago
  Build time: 2m 44.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── progressr 0.10.0: OK

  Build ID:   progressr_0.10.0.tar.gz-262a410d0102453eb1c337d6575a46d0
  Platform:   Windows Server 2008 R2 SP1, R-release, 32/64 bit
  Submitted:  14m 14.8s ago
  Build time: 5m 17.4s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```
