
<!-- README.md is generated from README.Rmd. Please edit that file -->
fannieapi
=========

The `fannieapi` package is an R interface to [Fannie Mae's public API](https://developer.theexchange.fanniemae.com). The package may be used to access Fannie Mae's publicly available datasets on macroeconomic and housing industry specific indicators, as well as survey results from the national housing survey and data points for the home purchase sentiment index.

Installation
------------

This package is not available on CRAN and is under development. You may install it via `devtools::install_github`.

``` r
devtools::install_github("saadaslam/fannieapi")
```

Example
-------

The interface can currently interact with the housing and economic indicators data. This may be utilized using the `get_indicator` function. The first argument specifies whether you'd like economic or housing indicators. The second argument specifies the indicator within the housing/economic category.

You must first create an account for free at the [API's website](https://developer.theexchange.fanniemae.com). Once an account is created, you must set your API key via the `set_api_key` function before pulling any data.

``` r
set_api_key("YOUR_API_KEY_HERE")
```

Once this is done, you may run the `get_indicator` function to get, for example, single family housing starts:

``` r
sf_starts <- get_indicator('housing', 'housing-starts-single-family')
head(sf_starts)
#> # A tibble: 6 x 6
#> # Groups:   report_date [1]
#>   report_date indicator_name       forecast indicator_val_dt eoy_flag value
#>   <date>      <chr>                <lgl>    <date>           <lgl>    <dbl>
#> 1 2017-01-10  housing-starts-sing… FALSE    2003-02-15       FALSE    1412.
#> 2 2017-01-10  housing-starts-sing… FALSE    2003-05-15       FALSE    1426 
#> 3 2017-01-10  housing-starts-sing… FALSE    2003-08-15       FALSE    1525.
#> 4 2017-01-10  housing-starts-sing… FALSE    2003-11-15       FALSE    1657.
#> 5 2017-01-10  housing-starts-sing… FALSE    2003-12-31       TRUE     1499 
#> 6 2017-01-10  housing-starts-sing… FALSE    2004-02-15       FALSE    1558.
```

Economic indicators are typically broader macroeconomic indicators such as GDP or unemployment rate:

``` r
ur_data <- get_indicator("economic", "unemployment-rate-percent")
head(ur_data)
#> # A tibble: 6 x 6
#> # Groups:   report_date [1]
#>   report_date indicator_name       forecast indicator_val_dt eoy_flag value
#>   <date>      <chr>                <lgl>    <date>           <lgl>    <dbl>
#> 1 2017-01-10  unemployment-rate-p… FALSE    2003-02-15       FALSE      5.9
#> 2 2017-01-10  unemployment-rate-p… FALSE    2003-05-15       FALSE      6.2
#> 3 2017-01-10  unemployment-rate-p… FALSE    2003-08-15       FALSE      6.1
#> 4 2017-01-10  unemployment-rate-p… FALSE    2003-11-15       FALSE      5.8
#> 5 2017-01-10  unemployment-rate-p… FALSE    2003-12-31       TRUE       6  
#> 6 2017-01-10  unemployment-rate-p… FALSE    2004-02-15       FALSE      5.7
```

<!-- ## Example -->
<!-- This is a basic example which shows you how to solve a common problem: -->
<!-- ```{r example} -->
<!-- ## basic example code -->
<!-- ``` -->
<!-- What is special about using `README.Rmd` instead of just `README.md`? You can include R chunks like so: -->
<!-- ```{r cars} -->
<!-- summary(cars) -->
<!-- ``` -->
<!-- You'll still need to render `README.Rmd` regularly, to keep `README.md` up-to-date. -->
<!-- You can also embed plots, for example: -->
<!-- ```{r pressure, echo = FALSE} -->
<!-- plot(pressure) -->
<!-- ``` -->
<!-- In that case, don't forget to commit and push the resulting figure files, so they display on GitHub! -->
