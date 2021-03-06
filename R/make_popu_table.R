
#' Function to make table of population and enrollment
#'
#' @description
#' Takes population, enrollment and year_pop and creates table
#'
#' @param conn Database connection
#' @param data data.table from Willamette (gov_fin_data.csv)
#'
#' @examples
#' \dontrun{
#' make_popu_table(conn = conn, data = data)}
#'
#' @export
make_popu_table <- function(conn = conn, data = data) {

  # Select cols
  cols <- c("id", "year4", "year_pop", "population", "enrollment")
  popu <- data[, cols, with = FALSE]

  # Add id_cols table
  DBI::dbCreateTable(conn, "popu", popu)
  DBI::dbExecute(conn, "CREATE INDEX popu_id ON popu (id)")
  DBI::dbAppendTable(conn, "popu", popu, overwrite = TRUE)

}
