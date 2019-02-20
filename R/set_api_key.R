#' Set the API authorization key
#'
#' @description This function creates an R environment variable called `fannieapi_key`,
#'   which is used by subsequent functions to make API calls.
#'
#' @param api_key The API key or user token as a character. This can be obtained by
#'   from your account profile at <https://developer.theexchange.fanniemae.com/>.
#'
#' @return Invisibly returns the the R environment variable `fannieapi_key`,
#'   which is set as the `api_key` parameter in this function.
#' @export
#'
#' @examples
#' set_api_key("abc123")
#' Sys.getenv("fannieapi_key")
set_api_key <- function(api_key) {
    if (!is.character(api_key))
        stop("api_key must be a character")
    Sys.setenv(fannieapi_key = api_key)
    invisible(Sys.getenv("fannieapi_key"))
}
