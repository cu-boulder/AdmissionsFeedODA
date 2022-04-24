/******************************
*
* Admissions Daily Load for ODA 
* DDL
*
*******************************/
 
 CREATE TABLE ADMDAILYODA (
	emplid varchar2(20),
	adm_appl_nbr varchar2(20),
	admit_term varchar2(5),
	admit_type varchar2(10),
	prog_status varchar2(10),
	AP varchar(3),
	institution varchar(20),
	acad_prog varchar(10),
	admit varchar(3),
	completed varchar2(3),
	high_school varchar2(75),
	home_state varchar(20 CHAR),
	residency varchar2(3 CHAR)
 
--	CONSTRAINT ADMDAILYODA PRIMARY KEY (emplid)
 )