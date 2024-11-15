DROP TABLE nuclearplant cascade constraints;
DROP TABLE metric       cascade constraints;
DROP TABLE sensor       cascade constraints;
DROP TABLE sensortype   cascade CONSTRAINTS;
DROP TABLE analysis     cascade constraints;
DROP TABLE logalert        cascade constraints;

CREATE TABLE NuclearPlant (
    ID_NuclearPlant             NUMBER generated always as identity PRIMARY KEY,
    PlantName                   VARCHAR2(50) NOT NULL,
    FullCapacity                NUMBER NOT NULL,
    NumberOfReactors            NUMBER NOT NULL
);

CREATE TABLE Metric (
    ID_Metric                   NUMBER generated always as identity PRIMARY KEY,
    MetricDate                  TIMESTAMP DEFAULT SYSDATE NOT NULL,
    ElectricityProvided         NUMBER NOT NULL,
    NuclearParticipation        NUMBER NOT NULL,
    OperationalEfficiency       NUMBER NOT NULL,
    id_nuclearplant             NUMBER NOT NULL,
    FOREIGN KEY (id_nuclearplant) REFERENCES NuclearPlant (ID_NuclearPlant)
);

CREATE TABLE Sensor (
    ID_Sensor                   NUMBER generated always as identity PRIMARY KEY,
    SensorName                  VARCHAR2(50) NOT NULL,
    MachinaryLocation           VARCHAR2(50) NOT NULL,
    Status                      CHAR(1) NOT NULL,
    id_nuclearplant             NUMBER NOT NULL,
    FOREIGN KEY (id_nuclearplant) REFERENCES NuclearPlant (ID_NuclearPlant)
);

CREATE TABLE SensorType (
    id_sensortype               NUMBER generated always as identity PRIMARY KEY,
    specifictype                VARCHAR2(50) NOT NULL,
    id_sensor                   NUMBER NOT NULL,
    FOREIGN KEY( id_sensor ) REFERENCES Sensor ( ID_Sensor )
);

CREATE TABLE Analysis (
    ID_Analysis                 NUMBER generated always as identity PRIMARY KEY,
    AnalysisValue               NUMBER NOT NULL,
    AnalysisTimestamp           TIMESTAMP DEFAULT SYSDATE NOT NULL,
    id_sensor                   NUMBER NOT NULL,
    FOREIGN KEY (id_sensor) REFERENCES Sensor(ID_Sensor)
);

CREATE TABLE LogAlert (
    ID_Alert                    NUMBER generated always as identity PRIMARY KEY,
    AlertDescription            VARCHAR2(100) NOT NULL,
    TriggeredAt                 TIMESTAMP DEFAULT SYSDATE NOT NULL,
    ResolvedAt                  TIMESTAMP,
    IsResolved                  CHAR(1) DEFAULT '0' NOT NULL,
    id_analysis                 NUMBER NOT NULL,
    FOREIGN KEY (id_analysis) REFERENCES Analysis(ID_Analysis)
);