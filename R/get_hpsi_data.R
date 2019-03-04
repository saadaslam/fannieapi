#' Get home purchase sentiment index data
#'
#' @param age_group a number between 1 and 4 which may be passed into the function
#'   as a character. By default, `age_group` is NULL, which specifies all ages aggregated
#'   into one group. Specifying an age group of 1 refers to the 18-34 years old, 2 refers
#'   to 35-44, 3 refers to 45-64, and 4 refers to 65 years old and older.
#'
#' @return A `tbl_df` with the columns `date`, `age_group`, and `hpsi_value`.
#' @export
#'
#' @details The home purchase sentiment index (HPSI) is an index calculated
#'   using Fannie Mae's National Housing Survey data to represent consumer's
#'   home purchase sentiment. Details can be found
#'   [here](http://www.fanniemae.com/resources/file/research/housingsurvey/pdf/hpsi-overview.pdf).
#'
#' @examples
#' ## This gets HPSI data for all ages aggregated
#' hpsi_all_ages <- get_hpsi_data()
#'
#' ## getting HPSI data for respondents aged 18-34 years old
#' hpsi_18_34 <- get_hpsi_data(age_group = 1)
#'
#' ## query the API 4 times to get data for all age groups unaggregated
#' hpsi_all_unagg <- purrr::map_dfr(1:4, get_hpsi_data)
#'
#' @seealso
#' [get_nhs_data]
get_hpsi_data <- function(age_group = NA) {

  if(!as.character(age_group) %in% c("1", "2", "3", "4") & !is.na(age_group)) {
    stop("`age_group` must be either 1, 2, 3, or 4", call. = FALSE)
  }

  if(is.na(age_group)) path <- glue::glue("/v1/nhs/hpsi")
  else path <- glue::glue("/v1/nhs/hpsi/age-groups/{as.character(age_group)}")

  get <- get_url(path)

  a <- dplyr::tibble(
    content = get$content
  )

  a <- dplyr::mutate(
    a,
    varname = map(content, names)
  )

  if(is.na(age_group)) age_group <- 0

  age <- dplyr::recode(
    as.character(age_group),
    "1" = "18-34",
    "2" = "35-44",
    "3" = "45-64",
    "4" = "65+",
    .default = "All Ages"
  )

  b <- tidyr::unnest(a, content, varname, .id = "id")
  b_spread <- tidyr::spread(b, varname, content)
  c <- dplyr::mutate(
    b_spread,
    date_raw = map_chr(date, ~ pluck(.x, 1)),
    hpsi_value = map_dbl(hpsiValue, ~ pluck(.x, 1)),
    date = as.Date(paste0('15-', date), '%d-%b-%y'),
    age_group = age
  )
  result <- select(
    c,
    date,
    age_group,
    hpsi_value
  )
  arrange(result, date)
}
