

DROP SEQUENCE IF EXISTS office_of_id_seq
;

DROP SEQUENCE IF EXISTS organisation_org_id_seq
;

DROP SEQUENCE IF EXISTS user_u_id_seq
;

/* Drop Tables */

DROP TABLE IF EXISTS country CASCADE
;

DROP TABLE IF EXISTS docexmplr CASCADE
;

DROP TABLE IF EXISTS doctype CASCADE
;

DROP TABLE IF EXISTS office CASCADE
;

DROP TABLE IF EXISTS organisation CASCADE
;

DROP TABLE IF EXISTS "user" CASCADE
;

/* Create Tables */

CREATE TABLE country
(
	c_id integer NOT NULL,
	c_name varchar(50) NOT NULL,
	c_code integer NOT NULL
)
;

CREATE TABLE docexmplr
(
	de_id integer NOT NULL,
	de_doctype integer NOT NULL,
	de_docnumber integer NOT NULL,
	de_docdate date NOT NULL
)
;

CREATE TABLE doctype
(
	dt_id integer NOT NULL,
	dt_name varchar(50) NOT NULL,
	dt_code integer NOT NULL
)
;

CREATE TABLE office
(
	of_id integer NOT NULL   DEFAULT NEXTVAL(('"office_of_id_seq"'::text)::regclass),
	of_orgid integer NOT NULL,
	of_docid integer NOT NULL,
	of_name varchar(50) NOT NULL,
	of_address varchar(50) NOT NULL,
	of_phone varchar(50) NULL,
	of_isactive boolean NOT NULL
)
;

CREATE TABLE organisation
(
	org_id integer NOT NULL   DEFAULT NEXTVAL(('"organisation_org_id_seq"'::text)::regclass),
	org_name varchar(50) NOT NULL,
	org_fullname varchar(50) NOT NULL,
	org_isactive boolean NOT NULL,
	org_inn varchar(50) NOT NULL,
	org_kpp varchar(50) NOT NULL,
	org_address varchar(50) NOT NULL,
	org_phone varchar(50) NULL,
	org_director varchar(50) NOT NULL
)
;

CREATE TABLE "user"
(
	u_id integer NOT NULL   DEFAULT NEXTVAL(('"user_u_id_seq"'::text)::regclass),
	u_officeid integer NULL,
	u_docid integer NULL,
	u_citizenshipcode integer NULL,
	u_firstname varchar(50) NOT NULL,
	u_middlename varchar(50) NULL,
	u_lastname varchar(50) NOT NULL,
	u_position varchar(50) NULL,
	u_isidentified boolean NOT NULL
)
;

/* Create Primary Keys, Indexes, Uniques, Checks */

ALTER TABLE country ADD CONSTRAINT "PK_country"
	PRIMARY KEY (c_id)
;

ALTER TABLE country 
  ADD CONSTRAINT "UNQ_name" UNIQUE (c_name)
;

ALTER TABLE docexmplr ADD CONSTRAINT "PK_docexemplar"
	PRIMARY KEY (de_id)
;

CREATE INDEX "IXFK_docexmplr_doctype" ON docexmplr (de_doctype ASC)
;

ALTER TABLE doctype ADD CONSTRAINT "PK_doctype"
	PRIMARY KEY (dt_id)
;

ALTER TABLE office ADD CONSTRAINT "PK_office"
	PRIMARY KEY (of_id)
;

CREATE INDEX "IXFK_office_organisation" ON office (of_orgid ASC)
;

ALTER TABLE organisation ADD CONSTRAINT "PK_organisation"
	PRIMARY KEY (org_id)
;

ALTER TABLE organisation 
  ADD CONSTRAINT "UNQ_inn" UNIQUE (org_inn)
;

ALTER TABLE "user" ADD CONSTRAINT "PK_user"
	PRIMARY KEY (u_id)
;

CREATE INDEX "IXFK_user_country" ON "user" (u_citizenshipcode ASC)
;

CREATE INDEX "IXFK_user_docexmplr" ON "user" (u_docid ASC)
;

CREATE INDEX "IXFK_user_office" ON "user" (u_officeid ASC)
;

/* Create Foreign Key Constraints */

ALTER TABLE docexmplr ADD CONSTRAINT "FK_docexmplr_doctype"
	FOREIGN KEY (de_doctype) REFERENCES doctype (dt_id) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE office ADD CONSTRAINT "FK_office_organisation"
	FOREIGN KEY (of_orgid) REFERENCES organisation (org_id) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE "user" ADD CONSTRAINT "FK_user_country"
	FOREIGN KEY (u_citizenshipcode) REFERENCES country (c_id) ON DELETE No Action ON UPDATE No Action
;

ALTER TABLE "user" ADD CONSTRAINT "FK_user_docexmplr"
	FOREIGN KEY (u_docid) REFERENCES docexmplr (de_id) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE "user" ADD CONSTRAINT "FK_user_office"
	FOREIGN KEY (u_officeid) REFERENCES office (of_id) ON DELETE Cascade ON UPDATE Cascade
;

/* Create Table Comments, Sequences for Autonumber Columns */

COMMENT ON TABLE country
	IS 'Страна'
;

COMMENT ON TABLE office
	IS 'Офис'
;

CREATE SEQUENCE office_of_id_seq INCREMENT 1 START 1
;

COMMENT ON TABLE organisation
	IS 'Организация'
;

CREATE SEQUENCE organisation_org_id_seq INCREMENT 1 START 1
;

COMMENT ON TABLE "user"
	IS 'Абонент'
;

CREATE SEQUENCE user_u_id_seq INCREMENT 1 START 1
;
