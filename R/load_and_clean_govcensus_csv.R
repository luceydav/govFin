#' Function to load downloaded, unpacked .csv and prepare for database
#'
#' @description
#' Loads downloaded .csv as data.table, cleans names,
#'
#' @param path Location to store data
#'
#' @examples
#' \dontrun{
#' load_and_clean_govcensus_csv(path = "data")}
#'
#' @import data.table
#' @importFrom janitor clean_names
#' @importFrom re2 re2_replace re2_detect
#'
#' @export
load_and_clean_govcensus_csv <- function(path = "data") {

  # Load with fread
  if (re2::re2_detect(getwd(), "vignette")) {

    gov_census <-
      data.table::fread(gsub("vignettes/", "", here::here(path, "gov_fin_data.csv"))
                        , colClasses = list(character = c(1:14, 16))
                        , key = "Type_Code")

  } else {

    gov_census <-
      data.table::fread(here::here(path, "gov_fin_data.csv")
                        , colClasses = list(character = c(1:14, 16))
                        , key = "Type_Code")

  }

  # Clean names
  names(gov_census)[1:5] <-
    c("govs_id", "fips_id", "year", "state", "type")
  gov_census <- janitor::clean_names(gov_census)

  # Move id cols to left
  id_cols <-
    names(gov_census)[sapply(gov_census, class) == "character"]
  num_cols <-
    names(gov_census)[sapply(gov_census, class) != "character"]
  data.table::setcolorder(gov_census, c(id_cols, num_cols))

  # Clean up state names
  gov_census[, name := re2::re2_replace(name, " STATE GOVT", "") ]

  # Drop 3 entities without govs_id
  gov_census <- gov_census[govs_id != ""]

  #Separate id_data, convert missing to NA_character, select unique
  id_cols <-
    names(gov_census)[sapply(gov_census, class) == "character"]
  id_cols <- setdiff(
    id_cols,
    c("year_pop", "fy_end_date", "sch_lev_code", "function_code", "year"))
  convert_missing <- function(row) data.table::fifelse(row == "", NA_character_, row)
  gov_census[
    , (id_cols) := lapply(.SD, convert_missing)
    , .SDcols = id_cols]
  id_data <-
    gov_census[, .SD, .SDcols = id_cols]
  id_data <- unique(id_data, by = "govs_id")

  # Separate population
  # Select cols
  pop_cols <-
    c("govs_id", "year", "year_pop", "population", "enrollment")
  popu <- gov_census[, .SD, .SDcols = pop_cols]
  popu <- unique(popu, by = c("govs_id", "year"))

  # Split into lists and name
  drops <- setdiff(id_cols, c("govs_id", "type"))
  drops <-
    c(drops, "population", "year_pop", "enrollment")
  gov_census <-
    gov_census[, .SD, .SDcols = !drops]
  gov_census[
    , type := data.table::fifelse(type == "3", "2", type)]
  gov_census_list <-
    split(gov_census, by = "type", keep.by = FALSE)
  names(gov_census_list) <-
    c("state", "county", "local", "special", "school", "federal")

  # Function to drop cols which sum to zero
  drop_all_empty <- function(data) {
    drops <- data[
      , which(colSums(.SD, na.rm = TRUE) == 0)
      , .SDcols = is.numeric]
    data <- data[, .SD, .SDcols = !drops]
    return(data)
  }

  # Apply drop_all_empty() and add final tables
  gov_census_list <-
    lapply(gov_census_list, drop_all_empty)
  final_tables <- list(popu, id_data)
  names(final_tables) <- c("population", "ids")
  gov_census_list <-
    append(gov_census_list, final_tables)

  return(gov_census_list)
}

