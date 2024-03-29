% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_popu_table.R
\name{make_popu_table}
\alias{make_popu_table}
\title{Function to make table of population and enrollment}
\usage{
make_popu_table(conn = conn, data = data)
}
\arguments{
\item{conn}{Database connection}

\item{data}{data.table from Willamette (gov_fin_data.csv)}
}
\description{
Takes population, enrollment and year_pop and creates table
}
\examples{
\dontrun{
make_popu_table(conn = conn, data = data)}

}
