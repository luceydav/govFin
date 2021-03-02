
#' Function to create id_cols table within database
#'
#' @description
#' Selects unchanging identifier columns including name, fips identifiers
#' There are no params given, but gov_census must be in global env
#' The name of table to "id_cols" and index is set to "id" automatically
#'
#' @param conn Database connection
#' @param data data.table from Willamette (gov_fin_data.csv)
#'
#' @examples
#' \dontrun{
#' create_identifiers()}
#'
#' @export
create_sqlite_id <- function(conn = conn, data = gov_census) {

  ids <- names(data)[c(1, 3:10)]
  id_cols <- unique(data[, ids, with = FALSE], by = "id")
  DBI::dbCreateTable(conn, "id_cols", id_cols)
  DBI::dbExecute(conn, "CREATE UNIQUE INDEX unique_id ON id_cols (id)")
  DBI::dbWriteTable(conn, "id_cols", id_cols, append = TRUE)
}
