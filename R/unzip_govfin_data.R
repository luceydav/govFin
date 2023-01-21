
#' Function to extract and rename .csv from downloaded zipped folder
#'
#' @description
#' Unzip folder as .csv but does not extract other documentation files
#'
#' @param path Folder in working dir where zip is stored
#'
#' @examples
#' \dontrun{
#' unzip_govfin_data(path = "data") }
#'
#' @importFrom utils unzip
#'
#' @export
unzip_govfin_data <- function(path = "data"){

  #https://willamette.edu/mba/research-impact/public-datasets/index.html

  # Set path to zip
  zip_file <- here::here(path, "gov_fin.zip")

  # Extract csv
  file <- "The Government Finance Database_All Data.csv"
  utils::unzip(
    zip_file,
    files = file,
    unzip = getOption("unzip"),
    exdir = path)

  file.rename(
    from = paste0(path, "/", list.files(path, pattern=".csv")),
    to = paste0(path, "/", "gov_fin_data.csv")
    )


}
