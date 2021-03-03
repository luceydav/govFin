#' Wrapper for all full data prep process
#'
#' @description
#' Runs get_govfin_data(), unzip_govfin_data(), load_and_clean_govcensus_csv(),
#' then make_sqlite_db() builds database in inst/extdata with
#' make_sqlite_table() and create_sqlite_id()
#'
#' @examples
#' \dontrun{
#' load_and_clean_govcensus_csv(path = "data")}
#'
#' @export
full_gov_census_db_wrapper <- function(){
  get_govfin_data()
  unzip_govfin_data(path = "inst/extdata")
  gov_census <- load_and_clean_govcensus_csv(path = "inst/extdata")
  make_sqlite_db(data = gov_census)
}
