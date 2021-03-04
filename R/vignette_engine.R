register_vignette_engine_during_build_only <- function(pkgname) {
  # Are vignette engines supported?
  if (getRversion() < "3.0.0") return() # Nope!

  ## HACK: Only register vignette engine 'selfonly' during R CMD build
  if (Sys.getenv("R_CMD") == "") return()

  tools::vignetteEngine("selfonly", package = pkgname, pattern = "[.]md$",
    weave = function(file, ...) {
      output <- sprintf("%s.html", tools::file_path_sans_ext(basename(file)))
      md <- readLines(file)

      title <- grep("%\\VignetteIndexEntry{", md, fixed = TRUE, value = TRUE)
      title <- gsub(".*[{](.*)[}].*", "\\1", title)

      ## Inject vignette title
      md <- c(sprintf("# %s\n\n", title), md)

      html <- commonmark::markdown_html(md,
                                        smart = FALSE,
                                        extensions = "table",
                                        normalize = FALSE)
      
      ## Embed images as <img src="data:image/png;base64...">
      mimes <- list(
        gif = "image/gif",
        jpg = "image/jpeg",
        png = "image/png",
        svg = "image/svg+xml"
      )
      html <- unlist(strsplit(html, split = "\n", fixed = TRUE))
      for (ext in names(mimes)) {
        mime <- mimes[[ext]]
        pattern <- sprintf('(.*[ ]src=")([^"]+[.]%s)(".*)', ext)
        idxs <- grep(pattern, html)
        if (length(idxs) == 0) next
        if (!requireNamespace(stealth <- "base64enc", quietly = TRUE)) {
          stop("This vignette requires the ", sQuote(stealth), 
               " package because it contains a ", sQuote(toupper(ext)), 
               " image")
        }
        ns <- getNamespace(stealth)
        dataURI <- get("dataURI", mode = "function", envir = ns)
        for (idx in idxs) {
          file <- gsub(pattern, "\\2", html[idx])
          uri <- dataURI(file = file, mime = mime)
          html[idx] <- gsub(pattern, sprintf("\\1%s\\3", uri), html[idx])
        }
      }

      ## Inject HTML environment
      html <- c("<!DOCTYPE html>",
                "<html lang=\"en\">",
                "<head>",
                sprintf("<title>%s</title>", title),
                "<style>",
                readLines("incl/clean.css", warn = FALSE),
                "</style>",
                "</head>",
                "<body>", html, "</body>",
                "</html>")

      writeLines(html, con = output)
      output
    },

    tangle = function(file, ...) {
      ## As of R 3.3.2, vignette engines must produce tangled output, but as
      ## long as it contains all comments then 'R CMD build' will drop it.
      output <- sprintf("%s.R", tools::file_path_sans_ext(basename(file)))
      cat(sprintf("### This is an R script tangled from %s\n",
                  sQuote(basename(file))), file = output)
      output
    }
  )
}
