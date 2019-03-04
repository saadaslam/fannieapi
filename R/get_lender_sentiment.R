#' Get Mortgage Lender Sentiment Survey data
#'
#' @return A `tbl_df` containing the following columns
#'   * `question` -- The question number on the survey
#'   * `lender_catg` -- A category defining the lender group.
#'   * `survey_date` -- The date of the survey
#'   * `percent_net_up` -- This is equivalent to `percent_went_up` minus `percent_went_down`
#'   * `percent_stays_the_same` -- The proportion of lenders that answered the question as
#'     "stays the same."
#'   * `percent_went_down` -- The proportion of lenders that answered the question as "went down."
#'   * `percent_went_up` -- The proportion of lenders that answered the question as "went up."
#' @export
#'
#' @details The questionnaire for the mortgage lender sentiment survey is available on the
#'   [Fannie Mae website](http://www.fanniemae.com/resources/file/research/mlss/pdf/mortgage-lender-sentiment-survey-questionnaire-q42018.pdf).
#' Available questions in the survey data are:
#'   * 6 -- Over the **past three months**, apart from normal seasonal variation,
#'     did your firm’s consumer demand for single-family **purchase** mortgages
#'     go up, go down, or stay the same?
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'
#'   * 10 -- Over the **past three months**, apart from normal seasonal variation,
#'     did your firm’s consumer demand for single-family **refinance** mortgages
#'     go up, go down, or stay the same?
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'
#'   * 14 -- Over the **next three months**, apart from normal seasonal variation,
#'     do you expect your firm’s consumer demand for single-family
#'     **purchase** mortgages to go up, go down, or stay the same?
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'
#'   * 18 -- Over the **next three months**, apart from normal seasonal variation,
#'     do you expect your firm’s consumer demand for single-family
#'     **refinance** mortgages to go up, go down, or stay the same?
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'
#'   * 22 -- Over the **next three months**, how much do you expect your firm's profit
#'     margin to change for its single-family mortgage production?
#'
#'   * 27 -- Over the **past three months**, how did your firm’s credit standards for
#'     approving consumer applications for mortgage loans change (across both
#'     purchase mortgages and refinance mortgages)? Please answer for GSE Eligible
#'     mortgages, Non-GSE Eligible mortgages, and Government mortgages.
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'       * Note that "up" refers to loosening of credit standards
#'         and "down" refers to tightening of credit standards.
#'
#'   * 31 -- Over the **next three months**, how did your firm’s credit standards for
#'     approving consumer applications for mortgage loans change (across both
#'     purchase mortgages and refinance mortgages)? Please answer for GSE Eligible
#'     mortgages, Non-GSE Eligible mortgages, and Government mortgages.
#'       * Part a refers to GSE Eligible mortgages
#'       * Part b refers to Non-GSE Eligible mortgages
#'       * Part c refers to government (i.e. Federal Housing Administration
#'         or Department of Veteran Affairs) mortgages.
#'       * Note that "up" refers to loosening of credit standards
#'         and "down" refers to tightening of credit standards.
#'
#' @examples
#' result <- get_lender_sentiment()
#' @seealso
#' [lender_sentiment_questions]
get_lender_sentiment <- function() {

  sentiment <- get_url("/v1/mortgage-lender-sentiment/results")

  a <- dplyr::tibble(content = sentiment$content)
  a <- dplyr::mutate(
    a,
    names = purrr::map(content, names)
  )
  a <- tidyr::unnest(a, content, names, .id = "id")

  a <- tidyr::spread(a, names, content)

  b <- dplyr::mutate_at(
    a,
    dplyr::vars(-id, -id1),
    unlist
  )

  b <- janitor::clean_names(b, "snake")

  b <- dplyr::mutate(
    b,
    month = dplyr::recode(
      quarter,
      `1` = "Feb",
      `2` = "May",
      `3` = "Aug",
      `4` = "Nov"
    ),
    survey_date = lubridate::ymd(paste0(as.character(year), month, "15"))
  )

  result <- dplyr::select(
    b,
    question,
    lender_catg = category,
    survey_date,
    percent_net_up,
    percent_stays_the_same,
    percent_went_down,
    percent_went_up
  )
  dplyr::arrange(result, lender_catg, question, desc(survey_date))
}
