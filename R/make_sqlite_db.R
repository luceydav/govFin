#' Function builds SQLite database from Census Type Codes (ie: Federal, State, etc)
#'
#' @description
#' Loads the .csv download as data.table, separates identifying columns
#' uses make_sqlite_table() to add tables for each type code including:
#' fedl, state, local, special and school.
#' Finally adds table for identifier columns with create_sqlite_id(), closes conn and deletes .csv
#'
#' @param data Census data.table
#'
#' @examples
#' \dontrun{
#' make_sqlite_db())}
#'
#' @importFrom utils download.file
#'
#' @export
make_sqlite_db <- function(data = gov_census) {

  # Load as data.table
  gov_census <- load_and_clean_govcensus_csv()

  # Connect to database
  conn <- DBI::dbConnect(RSQLite::SQLite(), "data/gov_census.db")

  # Build database
  codes <- list(0, 1, list(2, 3), 4 , 5, 6)
  table_names <- list("state", "county", "local", "special", "school", "federal")
  mapply(
    make_sqlite_table,
    type = codes,
    name = table_names,
    MoreArgs = list(conn = conn,
                    data = data))

  # Add identifier columns table as id_cols
  create_sqlite_id(conn = conn, data = data)

  # Add population table
  make_popu_table(conn = conn, data = data)

  # Disconnect db
  DBI::dbDisconnect(conn)

  # Clean up disc
  file.remove("data/gov_fin_data.csv")

}
