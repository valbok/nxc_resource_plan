DROP TABLE IF EXISTS nxcplan_project;
CREATE TABLE nxcplan_project (
  id int(11) NOT NULL auto_increment,
  name varchar(255) default NULL,
  lead varchar(255) default NULL,
  jira_key varchar(255) NOT NULL default '',
  url varchar(255) NOT NULL default '',
  description varchar(255) default NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS nxcplan_department;
CREATE TABLE nxcplan_department (
  id int(11) NOT NULL auto_increment,
  name varchar(255) default NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB;

INSERT INTO nxcplan_department VALUES( 1, 'Unknown' );
INSERT INTO nxcplan_department VALUES( 2, 'Ålesund' );
INSERT INTO nxcplan_department VALUES( 3, 'Odessa' );
INSERT INTO nxcplan_department VALUES( 4, 'Uzhgorod' );
INSERT INTO nxcplan_department VALUES( 6, 'Kiev' );
INSERT INTO nxcplan_department VALUES( 7, 'Oslo' );
INSERT INTO nxcplan_department VALUES( 8, 'Switzerland' );
INSERT INTO nxcplan_department VALUES( 9, 'UK' );
INSERT INTO nxcplan_department VALUES( 10, 'Helsinki' );

DROP TABLE IF EXISTS nxcplan_employee;
CREATE TABLE nxcplan_employee (
  id int(11) NOT NULL auto_increment,
  name varchar(255) NOT NULL default '',
  full_name varchar(255) NOT NULL default '',
  department_id int(11) NOT NULL default '0',
  is_enabled int(11) NOT NULL default '1',
  PRIMARY KEY (id),
  KEY nxcplan_employee_department_id (department_id)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS nxcplan_projectplan;
CREATE TABLE nxcplan_projectplan (
  id int(11) NOT NULL auto_increment,
  project_id int(11) NOT NULL default '0',
  employee_id int(11) NOT NULL default '0',
  comment varchar(255) default NULL,
  start_week int(11) NOT NULL default '0',
  end_week int(11) NOT NULL default '0',
  year int(11) NOT NULL default '0',
  eah int(11) NOT NULL default '0',
  has_sow int(11) NOT NULL default '0',
  status int(11) NOT NULL default '0',
  PRIMARY KEY  (id),
  KEY nxcplan_projectplan_project_id (project_id),
  KEY nxcplan_projectplan_employee_id (employee_id)
) ENGINE=InnoDB;
