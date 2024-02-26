#' XLSX Flex Read
#'
#' Author: Daniel R. Williams
#' Date: 16 Feb 2024
#'
#' @importFrom readxl read_xls
#' @importFrom openxlsx read.xlsx
#' @importFrom xlsx read.xlsx
#' @importFrom rlang is_null
#' @export 
#' @description
#' This aims to provide a common interface for all three main XLSX reading functions. It defaults to this order, choosing the first available:
#' 1. readxl::read_xlsx()
#' 2. openxlsx::read.xlsx()
#' 3. xlsx::read.xlsx()
#' 
#' @keywords xlsx read 
#' @param path path to the file to read as character vector.
#' @param sheet the workbook sheet as an index number or name of the sheet.
#' @param range A cell range to read. Only implemented for readxl::read_xlsx().
#' @param col_names Binary indicator to use thte first row as column names.  
#' @returns A data.frame or tibble
#' @title XLSX Flex Read
#' @docType package
#'


# xlsx_flex_read <- function(path, sheet = NULL, range = NULL, col_names = TRUE, ...) {
#   if(nzchar(find.package("readxl"))) use_which <- "readxl"
#   else if (nzchar(find.package("openxlsx"))) use_which <- "openxlsx"
#   else if (nzchar(find.package("xlsx"))) use_which <- "xlsx"
#   else return("please install one of: readxl, openxlsx, xlsx")
#   #
#   sheet_index <- switch (typeof(sheet),
#                          "NULL" = 1,
#                          "double" = sheet,
#                          "integer" = sheet,
#                          "numeric" = sheet,
#                          "character" = NULL
#   )
#   sheet_name <- switch (typeof(sheet),
#                         "NULL" = NULL,
#                         "double" = NULL,
#                         "integer" = NULL,
#                         "numeric" = NULL,
#                         "character" = sheet
#   )
#   # use_which <- "readxl"
#   switch (use_which,
#           "readxl" = readxl::read_xlsx(path = path, sheet = sheet, range = range, col_names = col_names, guess_max = Inf, ...),
#           "openxlsx" = openxlsx::read.xlsx(xlsxFile = path, sheet = ifelse(!rlang::is_null(sheet_index), sheet_index, 1) , colNames = col_names, check.names = FALSE, sep.names = " ", ...),
#           "xlsx" = xlsx::read.xlsx(file = path, sheetIndex = sheet_index, sheetName = sheet_name, header = col_names, as.data.frame=TRUE, check.names = FALSE, ...)
#   )
# }
