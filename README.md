
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
#>   report_date indicator_name       forecast indicator_val_dt eoy_flag value
#>   <date>      <chr>                <lgl>    <date>           <lgl>    <dbl>
#> 1 2019-02-11  housing-starts-sing… FALSE    2004-02-15       FALSE    1558.
#> 2 2019-02-11  housing-starts-sing… FALSE    2004-05-15       FALSE    1608 
#> 3 2019-02-11  housing-starts-sing… FALSE    2004-08-15       FALSE    1640.
#> 4 2019-02-11  housing-starts-sing… FALSE    2004-11-15       FALSE    1611.
#> 5 2019-02-11  housing-starts-sing… FALSE    2005-02-15       FALSE    1705.
#> 6 2019-02-11  housing-starts-sing… FALSE    2005-05-15       FALSE    1697
```

Economic indicators are typically broader macroeconomic indicators such as GDP or unemployment rate:

``` r
ur_data <- get_indicator("economic", "unemployment-rate-percent")
head(ur_data)
#> # A tibble: 6 x 6
#>   report_date indicator_name       forecast indicator_val_dt eoy_flag value
#>   <date>      <chr>                <lgl>    <date>           <lgl>    <dbl>
#> 1 2019-02-11  unemployment-rate-p… FALSE    2004-02-15       FALSE      5.7
#> 2 2019-02-11  unemployment-rate-p… FALSE    2004-05-15       FALSE      5.6
#> 3 2019-02-11  unemployment-rate-p… FALSE    2004-08-15       FALSE      5.4
#> 4 2019-02-11  unemployment-rate-p… FALSE    2004-11-15       FALSE      5.4
#> 5 2019-02-11  unemployment-rate-p… FALSE    2005-02-15       FALSE      5.3
#> 6 2019-02-11  unemployment-rate-p… FALSE    2005-05-15       FALSE      5.1
```

Functionalities also exist for obtaining data from the following data sources:

-   Mortgage Lender Sentiment Survey -- `get_lender_sentiment`
-   National Housing Survey -- `get_nhs_data`
-   Home Purchase Sentiment Index -- `get_hpsi_data`

For the survey data, I stored details on the survey questions into two different datasets: `nhs_questions` for the National Housing Survey and `lender_sentiment_questions` for the Mortgage Lender Sentiment Survey.
