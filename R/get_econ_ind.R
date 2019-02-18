get_econ_ind <-
  function(indicator = c(
    'gross-domestic-product',
    'residential-fixed-investment',
    'business-fixed-investment',
    'government-consumption-and-investment',
    'net-exports',
    'change-in-business-inventories',
    'gdp-price-index',
    'consumer-price-index',
    'consumer-price-index-excl-food-and-energy',
    'unemployment-rate-percent',
    'employment-total-nonfarm-percent-change-quarterly-saar-annual-q4-q4',
    'federal-funds-rate',
    '1-year-treasury-note-yield',
    '10-year-treasury-bond-yield',
    'personal-consumption-expenditures',
    'personal-chain-expenditures-chain-price-index',
    'personal-chain-expenditures-chain-price-index-excl-food-and-energy',
    'gdp-percent-change-year-over-year'
  )) {
    url_path <- paste0(econ_ind_path, indicator)
    url_string <- httr::modify_url(api_url, path = url_path)

    response <- get_url(url_string)

    time_series <- response$content[["indicatorTimeSeries"]]


    tbl <- dplyr::tibble(l1 = time_series)

    tbl <- dplyr::mutate(
      tbl,
      name = purrr::map(l1, names)
    )

    tbl <- tidyr::unnest(tbl, l1, name, .id = "id")

    tbl <- tidyr::spread(tbl, name, l1)

    tbl <- janitor::clean_names(tbl, "snake")

    tbl <- tidyr::unnest(tbl, effective_date, indicator_name, .id = "id3")

    tbl <- tidyr::unnest(tbl, points, .id = "id4")

    tbl <- dplyr::mutate(
      tbl,
      point_names = purrr::map(points, ~ names(.x))
    )

    tbl <- tidyr::unnest(tbl, points, point_names, .id = "id5")

    tbl <- tidyr::spread(tbl, key = point_names, value = points)

    tbl <- tidyr::unnest(tbl, forecast, quarter, value, year)

    tbl <- dplyr::mutate(
      tbl,
      value = as.numeric(value),
      effective_date = as.Date(effective_date),
      quarter_num = substring(quarter, 2),
      month = dplyr::case_when(
        quarter_num == "1" ~ "Feb",
        quarter_num == "2" ~ "May",
        quarter_num == "3" ~ "Aug",
        quarter_num == "4" ~ "Nov",
        TRUE ~ "EOY"
      ),
      date = dplyr::if_else(
        month != "EOY",
        paste0(as.character(year), month, "15"),
        paste0(as.character(year), "Dec", "31")
      ),
      indicator_val_dt = as.Date(date, format = "%Y%b%d"),
      eoy_flag = dplyr::if_else(month == "EOY", TRUE, FALSE)
    )

    result <- dplyr::select(tbl, report_date = effective_date, indicator_name, forecast, indicator_val_dt, eoy_flag, value)

    result <- dplyr::arrange(result, report_date, indicator_val_dt)

    result <- dplyr::group_by(result, report_date)

    result

  }
