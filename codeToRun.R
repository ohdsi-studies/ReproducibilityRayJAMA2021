######################################################
# Cohort Diagnostics Script for Ray Jama
# Developed by Martin Lavallee
# Questions contact: martin.lavallee@odysseusinc.com
####################################################


## Step 0 - R session set up 
library(CirceR)
library(CohortGenerator)
library(CohortDiagnostics)
library(DatabaseConnector)

## Step 1 - set up database connections and point to schemas

# for each parameter with carrots insert your credentials 

connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "<dbms>",
  user = "<user>",
  password = "<password>",
  server = "<server>",
  port = "<port>"
)

studySite <- "<studySite>"
studyName <- "rayJama"
cdmDatabaseSchema <- "<cdmSchema>"
vocabularyDatabaseSchema <- cdmDatabaseSchema
resultsDatabaseSchema <- "<resultsSchema>"

#create cohort table names in a dedicated results schema, must have write access
cohortTableNames <- purrr::map(CohortGenerator::getCohortTableNames(),
                               ~paste(.x, studySite, studyName, sep = "_"))

CohortGenerator::createCohortTables(connectionDetails = connectionDetails,
                                    cohortDatabaseSchema = resultsDatabaseSchema,
                                    cohortTableNames = cohortTableNames)

## Step 2 -- Generate cohorts

#get names from json files
ll2 <- list.files("json", full.names = TRUE)
nn2 <- gsub("json/", "", tools::file_path_sans_ext(ll2))
#get json files
json <- purrr::map_chr(ll2, 
                       ~readr::read_file(.x))
#create ohdisql
sql <- purrr::map_chr(json, 
                      ~CirceR::buildCohortQuery(.x, 
                                                options = CirceR::createGenerateOptions(generateStats = TRUE)))

#build cohortdefinition Dataframe
cohortDefinitionSet <- data.frame(
  'cohortId' = seq_along(ll2),
  'cohortName' = nn2,
  'json' = json,
  'sql' = sql)

#generate cohorts
CohortGenerator::generateCohortSet(
  connectionDetails = connectionDetails,
  cdmDatabaseSchema = cdmDatabaseSchema,
  cohortDatabaseSchema = resultsDatabaseSchema,
  cohortTableNames = cohortTableNames,
  cohortDefinitionSet = cohortDefinitionSet
)

#Step 3 -- Run cohortDiagnostics

#execute cohort diagnostics
CohortDiagnostics::executeDiagnostics(cohortDefinitionSet = cohortDefinitionSet,
                   exportFolder = "diagnostics",
                   databaseId = "<database>",
                   cohortDatabaseSchema = resultsDatabaseSchema,
                   connectionDetails = connectionDetails,
                   cdmDatabaseSchema = cdmDatabaseSchema,
                   cohortTableNames = cohortTableNames)

#create files
sqliteDbPath <- paste0(studySite, "_", studyName, ".sqlite")
zipPath <- paste0(studySite, "_", studyName, ".zip")

#merge diagnostics
CohortDiagnostics::createMergedResultsFile(dataFolder = "diagnostics",
                                           sqliteDbPath = sqliteDbPath,
                                           overwrite = TRUE)

#launch diagnostics in shiny
CohortDiagnostics::launchDiagnosticsExplorer(sqliteDbPath)

createDiagnosticsExplorerZip(outputZipfile = zipPath, 
                             sqliteDbPath = sqliteDbPath)