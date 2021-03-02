#' Function to load downloaded, unpacked .csv and prepare for database
#'
#' @description
#' Loads downloaded .csv as data.table, cleans names,
#'
#' @param path Location to store data
#'
#' @examples
#' \dontrun{
#' load_and_clean_govcensus_csv(path = "data")}
#'
#' @export
load_and_clean_govcensus_csv <- function(path = "inst/extdata") {

  # Load with fread
  if ( stringr::str_detect(getwd(), "vignette") ) {
    gov_census <-
      data.table::fread(gsub("vignettes/", "", here::here(path, "gov_fin_data.csv")))
  } else {
    gov_census <-
      data.table::fread(here::here(path, "gov_fin_data.csv"))
  }

  # Clean names
  gov_census <- janitor::clean_names(gov_census)

  # Move id cols to left
  meta <- c(1:13, 15)
  num <- c(14, 16:592)
  data.table::setcolorder(gov_census, c(meta, num))

  # Clean up state names
  gov_census[,name := stringr::str_remove(name, " STATE GOVT") ]

  return(gov_census)
}
