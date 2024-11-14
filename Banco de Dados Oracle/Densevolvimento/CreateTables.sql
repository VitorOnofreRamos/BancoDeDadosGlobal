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

CREATE TABLE Alert (
    ID_Alert                    NUMBER PRIMARY KEY,
    AlertDescription            VARCHAR2(100) NOT NULL,
    TriggeredAt                 TIMESTAMP DEFAULT SYSDATE NOT NULL,
    ResolvedAt                  TIMESTAMP,
    IsResolved                  CHAR(1) DEFAULT '0' NOT NULL,
    id_analysis                 NUMBER NOT NULL,
    FOREIGN KEY (id_analysis) REFERENCES Analysis(ID_Analysis)
);

CREATE SEQUENCE seq_nuclearplant    START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_metric          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_sensor          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_analysis        START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_alert           START WITH 1 INCREMENT BY 1;