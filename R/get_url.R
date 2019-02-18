get_url <- function(url) {

  if(Sys.getenv("fannieapi_key") == "") {
    stop("Please set an API key with `fannieapi::set_api_key()`", call. = FALSE)
  }

  resp <- httr::GET(
    url,
    httr::add_headers(Authorization = Sys.getenv("fannieapi_key"), accept = "application/json")
  )

  if(httr::http_type(resp) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }

  parsed <- jsonlite::fromJSON(
    suppressMessages(httr::content(resp, "text")),
    simplifyVector = FALSE
  )

  if (httr::http_error(resp)) {
    stop(
      sprintf(
        "API request failed [%s]\n%s\nSee https://developer.theexchange.fanniemae.com/assets/pdf/FAQ.pdf for details.",
        httr::status_code(resp),
        parsed$message
      ),
      call. = FALSE
    )
  }

  list(
    content = parsed,
    url = url,
    response = resp
  )
}


# print.fannie_api <- function(x, ...) {
#   cat("<fannie_api", x$path, ">\n", sep = "")
#   cat("<", x$url, ">\n", sep="")
#   str(x$content, max.level = 1)
#   invisible(x)
# }

