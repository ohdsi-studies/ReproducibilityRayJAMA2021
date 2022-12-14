Reproducibility_Ray JAMA2021
==============================

<img src="https://img.shields.io/badge/Study%20Status-Started-blue.svg" alt="Study Status: Started">

- Analytics use case(s): **Population Level Estimation**
- Study type: **Clinical Application**
- Tags: **Reproducibility**, **DOACs**
- Study lead: **Asieh Golozar**
- Study lead forums tag: **https://forums.ohdsi.org/u/agolozar**
- Study start date: **April 2022**
- Study end date: **-**
- Protocol: **DRAFT**: **[DOACs REPLICATION_Protocol_DRAFT_April 2022.docx](https://github.com/ohdsi-studies/ReproducibilityRayJAMA2021/tree/master/documents/DOACs.REPLICATION_Protocol_DRAFT_April.2022.docx)**
- Publications: **-**
- Results explorer: **-**
- Description: Recently, a high-quality observational comparative cohort study conducted using a nation-wide sample of U.S. administrative claims was recently published in JAMA demonstrating a significantly increased risk of major ischemic or hemorrhagic events associated with treatment with rivaroxaban compared with apixaban. This study aims to independently replicate the original study according to its description in the recent publication and supplemental materials, using a similar database as was used in the original study. Additionally, we plan to evaluate the robustness of the study findings by conducting sensitivity analyses, assessing: 1) changes to definitions of exposure and outcome phenotypes, 2) calibration of effect estimates using empirical null distributions, and 3) observable study diagnostics that inform the validity of a given analysis. Finally, we plan to explore the generalizability of the findings by executing the analysis on several study databases that vary with respect to the populations they include (e.g. U.S. and non-U.S.) and their mechanisms of data capture (e.g. administrative claims, electronic health records data).


Requirements
============

- A database in [Common Data Model version 5](https://github.com/OHDSI/CommonDataModel) in one of these platforms: SQL Server, Oracle, PostgreSQL, IBM Netezza, Apache Impala, Amazon RedShift, Google BigQuery, or Microsoft APS.
- R version 3.5.0 or newer
- On Windows: [RTools](http://cran.r-project.org/bin/windows/Rtools/)
- [Java](http://java.com)
- 25 GB of free disk space

How to run
==========
1. Follow [these instructions](https://ohdsi.github.io/Hades/rSetup.html) for seting up your R environment, including RTools and Java. 

2. Open your study package in RStudio. Use the following code to install all the dependencies:

	```r
	renv::restore()
	```

3. In RStudio, select 'Build' then 'Install and Restart' to build the package.

3. Once installed, you can execute the study by modifying and using the code below. For your convenience, this code is also provided under `extras/CodeToRun.R`:

	```r
	library(Reproducibility)
	
  # Optional: specify where the temporary files (used by the Andromeda package) will be created:
  options(andromedaTempFolder = "c:/andromedaTemp")
	
	# Maximum number of cores to be used:
	maxCores <- parallel::detectCores()
	
	# Minimum cell count when exporting data:
	minCellCount <- 5
	
	# The folder where the study intermediate and result files will be written:
	outputFolder <- "c:/Reproducibility"
	
	# Details for connecting to the server:
	# See ?DatabaseConnector::createConnectionDetails for help
	connectionDetails <- DatabaseConnector::createConnectionDetails(dbms = "postgresql",
									server = "some.server.com/ohdsi",
									user = "joe",
									password = "secret")
	
	# The name of the database schema where the CDM data can be found:
	cdmDatabaseSchema <- "cdm_synpuf"
	
	# The name of the database schema and table where the study-specific cohorts will be instantiated:
	cohortDatabaseSchema <- "scratch.dbo"
	cohortTable <- "my_study_cohorts"
	
	# Some meta-information that will be used by the export function:
	databaseId <- "Synpuf"
	databaseName <- "Medicare Claims Synthetic Public Use Files (SynPUFs)"
	databaseDescription <- "Medicare Claims Synthetic Public Use Files (SynPUFs) were created to allow interested parties to gain familiarity using Medicare claims data while protecting beneficiary privacy. These files are intended to promote development of software and applications that utilize files in this format, train researchers on the use and complexities of Centers for Medicare and Medicaid Services (CMS) claims, and support safe data mining innovations. The SynPUFs were created by combining randomized information from multiple unique beneficiaries and changing variable values. This randomization and combining of beneficiary information ensures privacy of health information."
	
	# For Oracle: define a schema that can be used to emulate temp tables:
	oracleTempSchema <- NULL
	
	execute(connectionDetails = connectionDetails,
            cdmDatabaseSchema = cdmDatabaseSchema,
            cohortDatabaseSchema = cohortDatabaseSchema,
            cohortTable = cohortTable,
            oracleTempSchema = oracleTempSchema,
            outputFolder = outputFolder,
            databaseId = databaseId,
            databaseName = databaseName,
            databaseDescription = databaseDescription,
            createCohorts = TRUE,
            synthesizePositiveControls = TRUE,
            runAnalyses = TRUE,
            packageResults = TRUE,
            maxCores = maxCores)
	```

4. Upload the file ```export/Results_<DatabaseId>.zip``` in the output folder to the study coordinator:

	```r
	uploadResults(outputFolder, privateKeyFileName = "<file>", userName = "<name>")
	```
	
	Where ```<file>``` and ```<name<``` are the credentials provided to you personally by the study coordinator.
		
5. To view the results, use the Shiny app:

	```r
	prepareForEvidenceExplorer("Result_<databaseId>.zip", "/shinyData")
	launchEvidenceExplorer("/shinyData", blind = TRUE)
	```
  
  Note that you can save plots from within the Shiny app. It is possible to view results from more than one database by applying `prepareForEvidenceExplorer` to the Results file from each database, and using the same data folder. Set `blind = FALSE` if you wish to be unblinded to the final results.

License
=======
The Reproducibility package is licensed under Apache License 2.0

Development
===========
Reproducibility was developed in ATLAS and R Studio.

### Development status

Unknown
