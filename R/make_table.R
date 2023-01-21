
#' Function to subset of gov_census and loads into database
#'
#' @description
#' Given table type_code, name and database index (if required),
#' Selects non zero columns, filters and creates table
#' Must have data in global env and database connection
#'
#' @param name Name chr to give to table ("fedl", "local", etc)
#' @param conn Database connection
#' @param data data.table from Willamette (gov_fin_data.csv)
#'
#' @examples
#' \dontrun{
#' make_sqlite_table(conn = conn, name = "local", data = table)}
#'
#' @import DBI
#'
#' @export
make_table <-
  function (conn = conn, name, data = table)
  {
    if (!DBI::dbExistsTable(conn, name)) {
      DBI::dbCreateTable(conn, name, data)
      if (name == "ids"){
        DBI::dbExecute(
          conn,
          glue::glue("CREATE UNIQUE INDEX {name}_id ON {name} (govs_id)"))
        DBI::dbAppendTable(
          conn,
          name,
          unique(data, by = c("govs_id")),
          overwrite = TRUE)
      } else {
        DBI::dbExecute(
          conn,
          glue::glue("CREATE UNIQUE INDEX {name}_id ON {name} (govs_id, year)"))
        DBI::dbAppendTable(
          conn,
          name,
          unique(data, by = c("govs_id", "year")),
          overwrite = TRUE)
      }
    }
    else {
      if (name == "ids"){
        DBI::dbAppendTable(
          conn,
          name,
          unique(data, by = "govs_id"),
          append = TRUE)
      } else {
        DBI::dbAppendTable(
          conn,
          name,
          unique(data, by = c("govs_id", "year")),
          append = TRUE)
      }
    }
  }
