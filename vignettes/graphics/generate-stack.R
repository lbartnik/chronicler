library(ggplot2)
library(glue)
library(png)
library(RColorBrewer)
library(tibble)
library(withr)


text_to_png <- function (input, output) {
  nch <- vapply(readLines(input), nchar, integer(1))
  size   <- 20
  width  <- max(nch) * 11
  height <- length(nch) * 22
  system2("convert",
          glue("-size {width}x{height} -fill black -font Ubuntu-Mono-Bold -pointsize {size} caption:@'{input}' {output}.png"))
}

pick_ds <- function (minrow = 15, mincol = 6) {
  while (42) {
    nm  <- sample(as_tibble(data()$results)$Item, 1)
    ans <- get(strsplit(nm, " ", fixed = TRUE)[[1]][[1]])
    if (is.data.frame(ans) && nrow(ans) >= minrow && ncol(ans) >= mincol) return(ans)
  }
}

ds_subset <- function (data, minrow = 15, mincol = 6) {
  stopifnot(is.data.frame(data))
  nrow <- sample.int(nrow(data) - minrow + 1, 1) + minrow - 1
  ncol <- sample.int(ncol(data) - mincol + 1, 1) + mincol - 1
  data <- data[sample.int(nrow(data), nrow), sample.int(ncol(data), ncol)]
  as_tibble(data)
}

sample_data_printout <- function (data) {
  pth <- tempfile(fileext = '.txt')
  with_output_sink(pth, print(ds_subset(data)))
  pth
}

sample_data_png <- function (out_dir) {
  set <- ds_subset(pick_ds())
  p <- sample_data_printout(set)
  text_to_png(p, file.path(out_dir, basename(p)))
}

pick_code <- function () {
  e <- asNamespace("tools")
  nms <- ls(envir = e)
  nms <- Filter(function (n) {
    x <- get(n, envir = e, inherits = FALSE)
    is.function(x) && !is.primitive(x)
  }, nms)
  get(sample(nms, 1), envir = e)
}

code_subset <- function (code, minlines = 15) {
  lines <- deparse(code)
  maxbg <- max(1, length(lines) - minlines)
  begin <- sample.int(maxbg, 1)
  mxend <- length(lines) - begin
  end   <- sample.int(mxend, 1) + begin
  lines[seq(from = begin, to = end)]
}

code_printout <- function (lines) {
  p <- tempfile(fileext = '.txt')
  writeLines(lines, p)
  p
}

sample_code_png <- function (out_dir) {
  set <- code_subset(pick_code())
  p <- code_printout(set)
  text_to_png(p, file.path(out_dir, basename(p)))
}

sample_plot_png <- function (out_dir) {
  ds <- pick_ds(mincol = 2)
  ds <- ds[, sample.int(ncol(ds), 2)]
  with_png(tempfile(tmpdir = out_dir, fileext = '.png'), {
    p <- ggplot(aes_string(x = names(ds)[1], y = names(ds)[2]),
           data = ds) +
      geom_point(color = sample(brewer.pal(5, "RdBu"), 1)) +
      theme_bw()
    # geom_point(color = sample(topo.colors(7), 1))
    # scale_color_manual(values = rainbow(25))
    # plot(ds[,1], ds[,2], xlab = names(ds)[1], ylab = names(ds)[2], col = pick_color())
    print(p)
  }, width = 300, height = 300)
}

pick_color <- function() sample(colors(), 1)

generate_pngs <- function (out_dir) {
  for (i in seq(25)) {
    sample_data_png(out_dir)
  }
  for (i in seq(25)) {
    sample_code_png(out_dir)
  }
  for (i in seq(50)) {
    sample_plot_png(out_dir)
  }
}

generate_stack <- function (out_dir) {
  outer <- 1000
  inner <- 250
  with_png("vignettes/graphics/stack.png", width = outer, height = outer, {
    paths <- list.files(out_dir, full.names = TRUE, include.dirs = FALSE)

#    coords <- matrix(rnorm(2*length(paths), outer/2, outer/3), ncol = 2)
    coords <- matrix(runif(2*length(paths), 0, outer), ncol = 2)
    coords <- as.data.frame(coords[order(sqrt(apply((coords-outer/2)**2, 1, sum)), decreasing = TRUE), ])

    par(mai = c(0, 0, 0, 0))
    plot(1:1000, axes = FALSE, col = "white")

    apply(cbind(path = paths, coords), 1, function (row) {
      img <- readPNG(row[[1]])
      r <- dim(img) / max(dim(img)/inner) / 2
      yb <- as.numeric(row[[2]])-r[1]
      xl <- as.numeric(row[[3]])-r[2]
      yt <- as.numeric(row[[2]])+r[1]
      xr <- as.numeric(row[[3]])+r[2]
      rasterImage(img, xl, yb, xr, yt)
      rect(xl, yb, xr, yt, border = 'black', density = -1, lwd = 2)
    })
    invisible()
  })
}


set.seed(837491)
out_dir <- "vignettes/graphics/stack"

generate_pngs(out_dir)

set.seed(837)
generate_stack(out_dir)
