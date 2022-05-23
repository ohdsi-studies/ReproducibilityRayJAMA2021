Reproducibility_Ray JAMA 2021
=============

<img src="https://img.shields.io/badge/Study%20Status-Repo%20Created-lightgray.svg" alt="Study Status: Repo Created">

- Analytics use case(s): **-**
- Study type: **Clinical Application**
- Tags: **Reproducibilty**, **DOACs**
- Study lead: **Asieh Golozar**
- Study lead forums tag: **https://forums.ohdsi.org/u/agolozar**
- Study start date: **March 2022**
- Study end date: **-**
- Protocol **DRAFT**: **[DOACs REPLICATION_Protocol_May 2022 DRAFT 2.docx](https://github.com/ohdsi-studies/ReproducibilityRayJAMA2021/files/8758069/DOACs.REPLICATION_Protocol_May.2022.DRAFT.2.docx)**
- Publications: **-**
- Results explorer: **-**

Recently, a high-impact observational comparative cohort study was conducted and published in JAMA using a nation-wide sample of U.S. administrative claims. It demonstrated a significantly increased risk of major ischemic or hemorrhagic events associated with treatment of rivaroxaban compared to that of apixaban. This study aims to independently replicate that study using a similar database. It also aims to evaluate the robustness of the study findings by conducting sensitivity analyses, assessing: 1) changes to definitions of exposure and outcome phenotypes, 2) calibration of effect estimates using empirical null distributions, and 3) observable study diagnostics that inform the validity of a given analysis. Finally, it aims to explore the generalizability of the findings by executing the analysis on alternative databases with varying populations (U.S. and non-U.S.) and mechanisms of data capture (electronic health records data).

# Requirements 

- A database in [Common Data Model version 5](https://github.com/OHDSI/CommonDataModel) in one of these platforms: SQL Server, Oracle, PostgreSQL, IBM Netezza, Apache Impala, Amazon RedShift, Google BigQuery, or Microsoft APS.
- R version 4.0.0 or newer
- On Windows: [RTools](http://cran.r-project.org/bin/windows/Rtools/)
- [Java](http://java.com)
- [RStudio](https://www.rstudio.com/products/rstudio/download/)


# How to Run

1. Follow [these instructions](https://ohdsi.github.io/Hades/rSetup.html) for setting up your R environment, including RTools and Java.

2. Create an Rstudio project:
  - In Rstudio, click on File > New Project
  - New window asks to select the type of project; select Version COntrol > Git 
  - Clone an existing repository: 
    - In the textbox Repository URL place: https://github.com/ohdsi-studies/ReproducibilityRayJAMA2021.git
    - This will fill in a project directory name of: ReproducibilityRayJAMA2021
    - Identify directory where you want this project
    - The project will be cloned into the folder
    
3. Set up `renv`
  - If not already installed, run `install.packages("renv")`
  - Run `renv::restore()` in the R console. Enter `Y` if asks to activate.
  - For `renv` questions, review [collaboration documentation](https://rstudio.github.io/renv/articles/collaborating.html)
  
4. Run codeToRun.R File
  - Open codeToRun.R file
  - Replace any parameters surrounded by carrot brackets ("\<carrots\>") with your database details. See Example:
  
  ```
    ## Step 0 - R session set up 
    library(CirceR)
    library(CohortGenerator)
    library(CohortDiagnostics)
    library(DatabaseConnector)
    
    ## Step 1 - set up database connections and point to schemas
    
    # for each parameter with carrots insert your credentials 
    
    connectionDetails <- DatabaseConnector::createConnectionDetails(
      dbms = "postgresql",
      user = "user",
      password = "topSecret",
      server = "some.server.com/db",
      port = "5432"
    )
    
    studySite <- "MyStudySite"
    studyName <- "rayJama" # keep this name
    cdmDatabaseSchema <- "myCDM"
    vocabularyDatabaseSchema <- cdmDatabaseSchema
    resultsDatabaseSchema <- "myResults"
  ```
  - Run the codeToRun.R file. If there are any errors or questions contact: martin.lavallee@odysseusinc.com
  
5. Share Results:
  - This code will create a folder called *diagnostics*. In this folder there is a .zip file. 
  - Send the zip file to a.golozar@northeastern.edu
  
