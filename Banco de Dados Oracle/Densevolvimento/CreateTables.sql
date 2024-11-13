DROP TABLE nuclearplant cascade constraints;
DROP TABLE metric       cascade constraints;
DROP TABLE sensor       cascade constraints;
DROP TABLE analysis     cascade constraints;
DROP TABLE alert        cascade constraints;

DROP SEQUENCE seq_nuclearplant;
DROP SEQUENCE seq_metric;
DROP SEQUENCE seq_sensor;
DROP SEQUENCE seq_analysis;
DROP SEQUENCE seq_alert;

CREATE TABLE NuclearPlant (
    ID_NuclearPlant             NUMBER PRIMARY KEY,
    PlantName                   VARCHAR2(50) NOT NULL,
    FullCapacity                NUMBER NOT NULL,
    NumberOfReactors            NUMBER NOT NULL
);

CREATE TABLE Metric (
    ID_Metric                   NUMBER PRIMARY KEY,
    MetricDate                  TIMESTAMP DEFAULT SYSDATE NOT NULL,
    ElectricityProvided         NUMBER NOT NULL,
    NuclearParticipation        NUMBER NOT NULL,
    OperationalEfficiency       NUMBER NOT NULL,
    id_nuclearplant             NUMBER NOT NULL,
    FOREIGN KEY (id_nuclearplant) REFERENCES NuclearPlant (ID_NuclearPlant)
);

CREATE TABLE Sensor (
    ID_Sensor                   NUMBER PRIMARY KEY,
    SensorName                  VARCHAR2(50) NOT NULL,
    MachinaryLocation           VARCHAR2(50) NOT NULL,
    Status                      CHAR(1) NOT NULL,
    id_nuclearplant             NUMBER NOT NULL,
    FOREIGN KEY (id_nuclearplant) REFERENCES NuclearPlant (ID_NuclearPlant)
);

CREATE TABLE Analysis (
    ID_Analysis                 NUMBER PRIMARY KEY,
    AnalysisValue               NUMBER NOT NULL,
    AnalysisTimestamp           TIMESTAMP DEFAULT SYSDATE NOT NULL,
    id_sensor                   NUMBER NOT NULL,
    FOREIGN KEY (id_sensor) REFERENCES Sensor(ID_Sensor)
);

CREATE TABLE alert (
    ID_Alert                    NUMBER PRIMARY KEY,
    AlertDescription            VARCHAR2(100) NOT NULL,
    TriggeredAt                 TIMESTAMP DEFAULT SYSDATE NOT NULL,
    ResolvedAt                  TIMESTAMP,
    IsResolved                  CHAR(1) DEFAULT 'N' NOT NULL,
    id_analysis                 NUMBER NOT NULL,
    FOREIGN KEY (id_analysis) REFERENCES Analysis(ID_Analysis)
);

CREATE SEQUENCE seq_nuclearplant    START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_metric          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sensor          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_analysis        START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_alert           START WITH 1 INCREMENT BY 1;

-- Oracle SQL Developer Data Modeler Summary Report: 
-- 
-- CREATE TABLE                             5
-- CREATE INDEX                             0
-- ALTER TABLE                              9
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0