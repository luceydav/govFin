#' Wrapper for all full data prep process
#'
#' @description
#' Runs get_govfin_data(), unzip_govfin_data(), load_and_clean_govcensus_csv(),
#' then make_db() builds database in datawith make_table()
#'
#' @examples
#' \dontrun{
#' load_and_clean_govcensus_csv(path = "data")}
#'
#' @export
full_gov_census_db_wrapper <- function(){
  get_govfin_data()
  unzip_govfin_data(path = "data")
  gov_census_list <-
    load_and_clean_govcensus_csv(path = "data")
  make_db(data = gov_census_list)
}
