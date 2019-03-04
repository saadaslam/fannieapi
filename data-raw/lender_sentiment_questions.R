library(fannieapi)

## Make sure to set API key first

lender_s <- fannieapi::get_lender_sentiment()

questions <- dplyr::distinct(lender_s, question)

questions <- dplyr::mutate(
  questions,
  question_num = stringr::str_extract(question, "[0-9]+"),
  question_sub = as.factor(stringr::str_extract_all(question, "[a-zA-Z]+", simplify = TRUE)[,2]),
  question_num = as.integer(question_num),
  loan_type = dplyr::recode(
    question_sub,
    "a" = "GSE Elgible",
    "b" = "Non-GSE Eligible",
    "c" = "Government",
    .default = "N/A"
  ),
  question_short = dplyr::recode(
    question_num,
    `6` = "Purchase Mortgage Demand - Past 3 Months",
    `10` = "Refinance Mortgage Demand - Past 3 Months",
    `14` = "Purchase Mortgage Demand - Next 3 Months",
    `18` = "Refinance Mortgage Demand - Next 3 Months",
    `22` = "Expected Change in Profit Margins - Next 3 Months",
    `27` = "Change In Credit Standards - Past 3 Months",
    `31` = "Change in Credit Standards - Next 3 Months"
  )
)

lender_sentiment_questions <- dplyr::arrange(questions, question_num, question_sub)

readr::write_csv(lender_sentiment_questions, "data-raw/lender_sentiment_questions.csv")
usethis::use_data(lender_sentiment_questions, overwrite = T)
