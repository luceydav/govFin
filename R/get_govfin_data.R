
#' Function to download multiple file zipped folder from Willamette
#'
#' @description
#' Downloads full zipped folder from Willamette including data in csv and documentation files
#'
#' @param path Folder in working dir to store data
#' @param time Timeout set 1000 seconds because default 60 too short
#'
#' @examples
#' \dontrun{
#' get_govfin_data(path = "data") }
#'
#' @importFrom utils download.file
#' @importFrom here here
#'
#' @export
get_govfin_data <- function(path = "data", time=1000){

  #https://willamette.edu/mba/research-impact/public-datasets/index.html
  url <-
    "https://willamette.edu/~kpierson/TheGovernmentFinanceDatabase_AllData.zip"

  # Create dir in working dir to store downloaded zip
  if (!dir.exists(here::here(path)) ) dir.create(here::here(path))

  # Set path to zip
  zip_file <- here::here(path, "gov_fin.zip")

  # Download file
  options(timeout = time)
  utils::download.file(url, destfile = zip_file)
  options(timeout = 60)

}
