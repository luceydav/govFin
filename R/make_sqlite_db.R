#' Function builds SQLite database from Census Type Codes (ie: Federal, State, etc)
#'
#' @description
#' Loads the .csv download as data.table, separates identifying columns
#' uses make_sqlite_table() to add tables for each type code including:
#' fedl, state, local, special and school.
#' Finally adds table for identifier columns with create_sqlite_id(), closes conn and deletes .csv
#'
#' @examples
#' \dontrun{
#' make_sqlite_db())}
#'
#' @importFrom utils download.file
#'
#' @export
make_sqlite_db <- function() {

  # Load as data.table
  gov_census <- load_and_clean_govcensus_csv()

  # Connect to database
  conn <- DBI::dbConnect(RSQLite::SQLite(), "inst/extdata/gov_census.db")

  # Build database
  codes <- c("0", "1" , c("2", "3"), "4" , "5", "6")
  table_names <- c("state", "county", "local", "special", "school", "fedl")
  mapply(
    make_sqlite_table,
    type = codes,
    name = table_names,
    MoreArgs = list(conn = conn,
                    data = gov_census))
  create_sqlite_id(conn = conn, data = gov_census)

  # Disconnect
  DBI::dbDisconnect(conn)

  # Clean up disc
  file.remove("inst/extdata/gov_fin_data.csv")

}
