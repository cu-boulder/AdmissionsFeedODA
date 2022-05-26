# AdmissionsFeedODA

The Admissions Feed for ODA

Robert Stubbs, Pavan Kumar Narayanan, 2022

## Overview

Created using Perl, Mailtrap, PL/SQL, DDL and DML.

This pipeline is designed to extract data from ISISWHDB and SYSADM schemas to transform and load the result set to EDWARDS Schema.

To run this code, one has to perform the following:

1. clone the repostory 
2. make necessary changes to the path references
3. run the following command `perl main.pl` under PipelineAdmApp
4. Please point it to a different database other than CU_ODA_EDWARDS
5. To consume the data, please refer to ADMDAILYODA table under CU_ODA_EDWARDS

## Pipeline Architecture

IMG 

## Process Steps

The pipeline is divided into the following steps in that particular order:

1. connecting to database - making the connection
2. preprocessing - check if the table exists and drop if it does
3. actual pipeline exec - run the main pipeline
4. postprocessing - reserved for post processing 
5. program termination - disconnect from database

## Important Considerations

Secrets are not included/stored in the environment for security reasons

Paths are removed from the environment. Please set the paths before execution

Please contact the office of data analytics for more information
