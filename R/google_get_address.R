#' Google Get Address
#'
#' Author: Daniel R. Williams
#' Date: 14 Feb 2024
#'
#' @importFrom magrittr `%>%`
#' @importFrom foreach `%do%`
#' @importFrom plyr `.`
#' @importFrom rlang .data
#' @export
#' @description
#' quick using google to get the address from any text query. Works best if the query is a mostly complete address.
#' The plural version lets query be a list of strings. Internally reduce to unique queries and then re expand to same lenth as query for return.
#' 
#' @keywords scrape google address lookup validate zip
#' @param query A string or character vector containing the address or addresses to validate or complete
#' @returns A character vector containing the results in the same order as the query
#' @title Google validation of addresses
#' @docType package
#'

# google_get_address <- function(query = NULL) {
#   query <- query |> stringr::str_replace_all("[:space:]","+")
#   uniquery <- query |> stringr::str_unique()
#   # tmp_join <- function(...) dplyr::full_join(..., by = dplyr::join_by(.data$query, .data$result))
#   b <- chromote::ChromoteSession$new()
#   i<- NULL  #resolves warning at package check.
#   pre_results <- foreach::foreach(i=1:length(uniquery), .combine = dplyr::full_join, .multicombine = FALSE) %do% {
#     b$Page$navigate(paste0("https://www.google.com/search?q=",uniquery[i],"&sclient=gws-wiz-serp"))
#     b$Page$loadEventFired()
#     x<-NA
#     try(x <- b$DOM$getDocument() %>% { b$DOM$querySelector(.$root$nodeId, ".LrzXr") } %>% { b$DOM$getOuterHTML(.$nodeId) } |> unlist() |> stringr::str_trim() |> stringr::str_remove_all("(<.*>(?=[^$]))|((?<=[^^])<.*>)"), silent = TRUE)
#     tibble::tibble_row(query=uniquery[i],result=x)
#   } ##|>
#     # dplyr::right_join(query |> tibble::as_tibble_col(column_name = "query"), by=dplyr::join_by("query"=="query")) |>  #, by = dplyr::join_by(.data$query)
#   results <- query |>
#     tibble::as_tibble_col(column_name = "query") |>
#     dplyr::rowwise() %>%
#     mutate("result" = dplyr::slice(pre_results, .data$query |> purrr::detect_index(\(x) stringr::str_equal(x, pre_results$result, ignore_case = TRUE)))$result)
#     dplyr::pull(var = -1) 
#   b$close()
#   return(results)
# }


google_get_address <- function(query = NULL) {
  query <- query |> unlist() |> stringr::str_replace_all("[:space:]","+")
  uniquery <- query |> stringr::str_unique()
  # tmp_join <- function(...) dplyr::full_join(..., by = dplyr::join_by(.data$query, .data$result))
  b <- chromote::ChromoteSession$new()
  i<- NULL  #resolves warning at package check.
  pre_results <- foreach::foreach(i=1:length(uniquery), .combine = rbind, .multicombine = FALSE) %do% {
    b$Page$navigate(paste0("https://www.google.com/search?q=",uniquery[i],"&sclient=gws-wiz-serp"))
    b$Page$loadEventFired()
    x<-NA
    try(x <- b$DOM$getDocument() %>% { b$DOM$querySelector(.$root$nodeId, ".LrzXr") } %>% { b$DOM$getOuterHTML(.$nodeId) } |> unlist() |> stringr::str_trim() |> stringr::str_remove_all("(<.*>(?=[^$]))|((?<=[^^])<.*>)"), silent = TRUE)
    tibble::tibble_row(query=uniquery[i],result=x)
  }
  results <- query |> 
    tibble::as_tibble_col(column_name = "query") |> 
    # dplyr::mutate(result = NULL) |>
    dplyr::left_join(pre_results) |>  #, by = dplyr::join_by(.data$query)
    # dplyr::pull("result")  ## I think this is the error now... change to df[result]
    as.data.frame()
  b$close()
  return(results[["result"]])
}

google_get_address_single <- function(query = NULL) {
  query <- query |> stringr::str_replace_all("[:space:]","*")
  b <- chromote::ChromoteSession$new()
  b$Page$navigate(paste0("https://www.google.com/search?q=",query,"*va&sclient=gws-wiz-serp"))
  b$Page$loadEventFired()
  x <- b$DOM$getDocument() %>% { b$DOM$querySelector(.$root$nodeId, ".LrzXr") } %>% { b$DOM$getOuterHTML(.$nodeId) } |> unlist() |> stringr::str_trim() |> stringr::str_remove_all("(<.*>(?=[^$]))|((?<=[^^])<.*>)")
  b$close()
  return(x)
}

# Tests

# c("stats","magrittr","foreach","plyr","rlang") |>
#   sapply(require, character = TRUE)
# 
# c("greenstreet gardens lothian MD",
#   "merrywood gardens",
#   "greenstreet gardens alexandria VA",
#   "this is not an address") |>
#   google_get_address()

