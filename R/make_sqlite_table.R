
#' Function to subset of gov_census and loads into database
#'
#' @description
#' Given table type_code, name and database index (if required),
#' Selects non zero columns, filters and creates table
#' Must have data in global env and database connection
#'
#' @param type "Type Code" chr from Williamette data subsets ("0", "1", "2", "3, "4, "5", "6")
#' @param name Name chr to give to table ("fedl", "local", etc)
#' @param index Usually "id" variable common to all data subsets
#' @param conn Database connection
#' @param data data.table from Willamette (gov_fin_data.csv)
#'
#' @examples
#' \dontrun{
#' make_sqlite_table(type = c("2", "3"), name = "local", index = "id")}
#'
#' @export
make_sqlite_table <- function(conn = conn, data = gov_census, type, name, index = "") {

  # Check if type is a vector
  if ( length(type) == 1 ) type <- c(type)

  # Subset to needed columns
  keeps <-
    names(which(apply(data[type_code %in% type, -c(1:14), with = FALSE], 2, sum) > 0))
  ids <- names(data)[c(1:2, 11, 13:14)]
  data <-
    data[type_code %in% type, .SD, .SDcols = c(ids, keeps)]

  # Set up table
  if ( !DBI::dbExistsTable(conn, name) ) {
    DBI::dbCreateTable(conn, name, data)
  }
  if ( index != "" ) {
    DBI::dbExecute(conn, glue::glue("CREATE INDEX {name}_id ON {name} ({index})"))
  }
  DBI::dbWriteTable(conn, name, data, append = TRUE)
}
