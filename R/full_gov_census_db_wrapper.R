#' Wrapper for all full data prep process
#'
#' @description
#' Runs get_govfin_data(), unzip_govfin_data(), load_and_clean_govcensus_csv(),
#' then make_db() builds database in datawith make_table()
#'
#' @param path Folder in working dir to store data
#' @param time Timeout set 1000 seconds because default 60 too short
#' @param connect Type of connection ("duckdb" or "sqlite")

#' @examples
#' \dontrun{
#' full_gov_census_db_wrapper(time = 1000, path = "data")}
#'
#' @export
full_gov_census_db_wrapper <- function(path = "data", time = 1000, connect = "duckdb"){
  get_govfin_data(path = path, time = time)
  unzip_govfin_data(path = "data")
  gov_census_list <-
    load_and_clean_govcensus_csv(path = "data")
  make_db(data = gov_census_list, connect = "duckdb")
}
