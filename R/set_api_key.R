set_api_key <- function(api_key) {
  if(!is.character(api_key)) stop("api_key must be a character")
  Sys.setenv(fannieapi_key = api_key)
}
