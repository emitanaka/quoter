
<!-- README.md is generated from README.Rmd. Please edit that file -->

# quoter

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The `quoter` R package generates a random quote sourced from various
sources. You can use this, say, to output an inspirational quote every
time your R starts.

## Installation

You can install the released version of quoter with

``` r
remotes::install_github("emitanaka/quoter")
```

## Example

Get a random quote that are sourced from [brainy](brainyquote.com),
[statquotes](https://github.com/friendly/statquotes) or
[dadjoke](https://github.com/jhollist/dadjoke).

``` r
quoter::quotes(source = "brainy")
#> Failure is nature's plan to prepare you for great 
#> responsibilities. 
#> --- Napoleon Hill
```

You can get a decorated one. The color output will show on terminal.

TODO: need to add dark/light themes. Also ability to customise output
easily.

``` r
quoter::decorate(quoter::quotes())
#> ----------------------------------------
#> To understand God's thoughts we must study statistics, for these
#> are the measure of His purpose.
#>          -- Florence Nightingale
#> ----------------------------------------
```

## Show quote on R start-up

To show quote on R start-up, you will need a special function ot the
`.Rprofile` file. The easiest way to access the `.Rprofile` is to use

``` r
usethis::edit_r_profile()
```

In the `.Rprofile` file add below to get a quotation for every start-up.

``` r
.First <- function() {
  quoter::decorate(quoter::quotes())
}
```
