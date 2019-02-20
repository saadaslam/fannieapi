#' Call a particular URL from Fannie Mae's public API.
#'
#' @param url The URL. This should start with "https://api.theexchange.fanniemae.com/".
#'
#' @return A list with the following elements:
#' * content -- The parsed JSON returned from API call.
#'   Note that the object is returned as a nested list.
#' * url -- The URL used to make the call
#' * response -- The response object created by `httr::GET`
#' @export
#'
#' @examples
#' get_url("https://api.theexchange.fanniemae.com/v1/mortgage-lender-sentiment/results")
get_url <- function(url) {

    if (Sys.getenv("fannieapi_key") == "") {
        stop("Please set an API key with `fannieapi::set_api_key()`", call. = FALSE)
    }

    resp <- httr::GET(url, httr::add_headers(Authorization = Sys.getenv("fannieapi_key"), accept = "application/json"))

    if (httr::http_type(resp) != "application/json") {
        stop("API did not return JSON", call. = FALSE)
    }

    parsed <- jsonlite::fromJSON(suppressMessages(httr::content(resp, "text")), simplifyVector = FALSE)

    if (httr::http_error(resp)) {
        stop(sprintf("API request failed [%s]\n
                     %s\n
                     See https://developer.theexchange.fanniemae.com/assets/pdf/FAQ.pdf for details.",
            httr::status_code(resp), parsed$message), call. = FALSE)
    }

    list(content = parsed, url = url, response = resp)
}
