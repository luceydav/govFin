
#' Function takes variable arguments and returns data for table
#'
#' @description
#' With input of table and fields, returns a data.frame
#'
#' @param conn Database connection
#' @param table Name of table
#' @param fields Vector of all fields
#'
#' @examples
#' \dontrun{
#' get_chart_data(
#'   conn = conn,
#'   table = table,
#'   fields = c("total_revenue", "total_taxes"))}
#'
#' @import duckdb
#' @import RSQLite
#' @import DBI
#'
#' @export
get_chart_data <- function(table, fields, popu = FALSE, state = list(1:51)) {

  conn <- DBI::dbConnect(RSQLite::SQLite(), here::here("data/gov_census.db"))
  on.exit(DBI::dbDisconnect(conn), add = TRUE)

  # Set default fields
  cols <- list(DBI::Id(table = "id_cols", column = "name"),
               DBI::Id(table = "id_cols", column = "state_code"),
               DBI::Id(table = "id_cols", column = "id"),
               DBI::Id(table = "id_cols", column = "fips_place"))

  # Get table columns
  table_fields <- DBI::dbListFields(conn, table)

  # Add variable fields
  for (field in fields) {
    if (field %in% table_fields) {
      cols <- append(cols, DBI::Id(table = table, column = field))
    }
  }

  # Query
    params <- ifelse(length(state) != 51, state)
    query <- glue::glue_sql(
      "SELECT {`cols`*}
        FROM {`table`}
        LEFT JOIN id_cols ON id_cols.id = {`table`}.id
        WHERE id_cols.state_code = ?",
      .con = conn)
    # resp <- DBI::dbSendQuery(conn, query, list = param)
    # d <- DBI::dbFetch(resp, n = -1)
    #DBI::dbClearResult(resp)
    d <- DBI::dbGetQuery(conn, query, params = params)
    d <- data.table::setDT(d, key = c("id", "year4"))

  # else {
    # params <- ifelse(length(state) != 51, state)
    # query <- glue::glue_sql(
    #   "SELECT {`cols`*}
    #     FROM {`table`}
    #     LEFT JOIN id_cols ON id_cols.id = {`table`}.id
    #     LEFT JOIN popu AS p ON p.id = {`table`}.id
    #     WHERE id_cols.state_code = ?",
    #   .con = conn)
    # # resp <- DBI::dbSendQuery(conn, query, list = param)
    # # d <- DBI::dbFetch(resp, n = -1)
    # #DBI::dbClearResult(resp)
    # d <- DBI::dbGetQuery(conn, query, params = params)
    # d <- data.table::setDT(d, key = c("id", "year4"))
  if (popu == TRUE) {
    # Query
    query <- glue::glue_sql(
      "SELECT p.year
              ,p.population
              ,p.enrollment
              ,p.id
      FROM population AS p
      LEFT JOIN ids AS i
      ON i.govs_id = p.govs_id",
      .con = conn)
    resp <- DBI::dbSendQuery(conn, query)
    pop <- DBI::dbFetch(resp, n = -1)
    pop <- data.table::setDT(pop, key = c("id", "year4"))
    DBI::dbClearResult(resp)
    d <- pop[d]
  }

  return(d)
}
