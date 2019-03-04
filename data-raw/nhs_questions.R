library(fannieapi)

### Make sure to set API key first

get <- get_url("/v1/nhs/results")

a <- dplyr::tibble(content = get$content)

a <- dplyr::mutate(
  a,
  names = purrr::map(content, names)
)

a <- tidyr::unnest(a, names, content, .id = "id1")

a_spread <- tidyr::spread(
  a,
  names,
  content
)

a_spread <- tidyr::unnest(a_spread, questions, .id = "id2", .drop = FALSE)

a_spread <- dplyr::mutate(
  a_spread,
  question_names = purrr::map(questions, names),
  date = purrr::map_chr(date, purrr::pluck),
  date = as.Date(paste0(date, "-01"), "%b-%y-%d")
)

b <- tidyr::unnest(
  a_spread,
  questions,
  question_names,
  .id = "id3"
)

b_spread <- tidyr::spread(
  b,
  question_names,
  questions
)

b_spread <- dplyr::mutate(
  b_spread,
  description = trimws(purrr::map_chr(description, purrr::pluck)),
  id = purrr::map_chr(id, purrr::pluck)
)

b_spread <- tidyr::unnest(b_spread, responses)

b_spread <- dplyr::mutate(
  b_spread,
  response_names = purrr::map(responses, names)
)

b_spread <- rename(
  b_spread,
  question = description
)

c <- tidyr::unnest(b_spread, responses, response_names, .id = "id4")

c_spread <- tidyr::spread(
  c,
  response_names,
  responses
)

c_spread <- mutate(
  c_spread,
  description = trimws(purrr::map_chr(description, purrr::pluck)),
  percent = purrr::map_dbl(percent, purrr::pluck)
)

result <- dplyr::select(
  c_spread,
  survey_date = date,
  question_id = id,
  question_desc = question,
  question_ans = description,
  percent_ans = percent
)

nhs_data <- dplyr::arrange(
  result,
  survey_date,
  question_id
)

nhs_questions <- distinct(
  nhs_data,
  question_id,
  question_desc,
  question_ans
)

readr::write_csv(nhs_questions, "data-raw/nhs_questions.csv")
usethis::use_data(nhs_questions, overwrite = T)
