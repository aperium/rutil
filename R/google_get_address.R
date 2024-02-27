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



google_get_address <- function(query = NULL) {
  query <- query |> stringr::str_replace_all("[:space:]","*")
  uniquery <- query |> stringr::str_unique()
  # tmp_join <- function(...) dplyr::full_join(..., by = dplyr::join_by(.data$query, .data$result))
  b <- chromote::ChromoteSession$new()
  i<- NULL  #resolves warning at package check.
  results <- foreach::foreach(i=1:length(uniquery), .combine = rbind, .multicombine = FALSE) %do% {
    b$Page$navigate(paste0("https://www.google.com/search?q=",uniquery[i],"*va&sclient=gws-wiz-serp"))
    b$Page$loadEventFired()
    x<-NA
    try(x <- b$DOM$getDocument() %>% { b$DOM$querySelector(.$root$nodeId, ".LrzXr") } %>% { b$DOM$getOuterHTML(.$nodeId) } |> unlist() |> stringr::str_trim() |> stringr::str_remove_all("(<.*>(?=[^$]))|((?<=[^^])<.*>)"), silent = TRUE)
    tibble::tibble_row(query=uniquery[i],result=x)
  } |>
    dplyr::right_join(query |> tibble::as_tibble_col(column_name = "query")) |>  #, by = dplyr::join_by(.data$query)
    dplyr::pull(.data$result)
  b$close()
  return(results)
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


