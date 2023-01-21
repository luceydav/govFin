#' Function builds SQLite database from Census Type Codes (ie: Federal, State, etc)
#'
#' @description
#' Loads the .csv download as data.table, separates identifying columns
#' uses make_sqlite_table() to add tables for each type code including:
#' fedl, state, local, special and school.
#' Finally adds table for identifier columns with create_sqlite_id(), closes conn and deletes .csv
#'
#' @param data Census data.table
#' @param connect Type of connection (duckdb or sqlite)
#'
#' @examples
#' \dontrun{
#' make_sqlite_db())}
#'
#' @import duckdb
#' @import RSQLite
#' @import DBI
#'
#' @export
make_db <- function(data = gov_census_list, connect="duckdb"){

  for (i in seq_len(length(data))){

    # Connect to database
    if (connect == "sqlite"){
      conn <-
        DBI::dbConnect(RSQLite::SQLite(), "data/gov_census.db")
    } else {
      conn <-
        DBI::dbConnect(duckdb::duckdb(), "data/gov_census.db")
    }

    # Make table with name and data
    make_table(
      conn=conn,
      name=names(data)[i],
      data = data[[i]]
      )

    # Shutdown on disconnect if duckdb
    if (connect == "sqlite"){
      DBI::dbDisconnect(conn)
    } else {
      DBI::dbDisconnect(conn, shutdown=TRUE)
    }
  }

  # Clean up disc
  file.remove("data/gov_fin_data.csv")

}
