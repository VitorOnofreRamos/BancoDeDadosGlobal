set SERVEROUTPUT on;

Create or replace PROCEDURE Insert_NuclearPlant(
    p_plantName         IN  NuclearPlant.plantName%TYPE,
    p_fullCapacity      IN  NuclearPlant.fullCapacity%TYPE,
    p_numberOfReactors  IN  NuclearPlant.numberOfReactors%TYPE,
    p_id                OUT NuclearPlant.id_nuclearplant%TYPE
) AS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_NuclearPlant(p_plantName, p_fullCapacity, p_numberOfReactors) THEN
        INSERT INTO NuclearPlant (PlantName, FullCapacity, NumberOfReactors)
        VALUES (p_plantName, p_fullCapacity, p_numberOfReactors)
        RETURNING ID_NuclearPlant INTO p_id;

        DBMS_OUTPUT.PUT_LINE('Usina inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o da Usina Nuclear.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe uma usina com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Usina Nuclear: ' || SQLERRM);
        ROLLBACK;
END insert_nuclearplant;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Metric(
    p_MetricDate                IN  Metric.MetricDate%TYPE,
    p_ElectricityProvided       IN  Metric.ElectricityProvided%TYPE,
    p_NuclearParticipation      IN  Metric.NuclearParticipation%TYPE,
    p_OperationalEfficiency     IN  Metric.OperationalEfficiency%TYPE,
    p_id_nuclearplant           IN  Metric.id_nuclearplant%TYPE,
    p_id                        OUT Metric.id_metric%TYPE
) AS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_Metric(p_MetricDate, p_ElectricityProvided, p_NuclearParticipation, p_OperationalEfficiency, p_id_nuclearplant) THEN
        INSERT INTO Metric (MetricDate, ElectricityProvided, NuclearParticipation, OperationalEfficiency, id_nuclearplant)
        VALUES (p_MetricDate, p_ElectricityProvided, p_NuclearParticipation, p_OperationalEfficiency, p_id_nuclearplant)
        RETURNING ID_Metric INTO p_id;

        DBMS_OUTPUT.PUT_LINE('M�trica inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o da M�trica.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe uma m�trica com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir M�trica: ' || SQLERRM);
        ROLLBACK;
END Insert_Metric;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Sensor(
    p_SensorName             IN Sensor.SensorName%TYPE,
    p_MachinaryLocation      IN Sensor.MachinaryLocation%TYPE,
    p_Status                 IN Sensor.Status%TYPE,
    p_id_nuclearplant        IN Sensor.id_nuclearplant%TYPE,
    p_id                     OUT Sensor.id_sensor%TYPE
) AS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_Sensor(p_SensorName, p_MachinaryLocation, p_Status, p_id_nuclearplant) THEN
        INSERT INTO Sensor (SensorName, MachinaryLocation, Status, id_nuclearplant)
        VALUES (p_SensorName, p_MachinaryLocation, p_Status, p_id_nuclearplant)
        RETURNING ID_Sensor INTO p_id;

        DBMS_OUTPUT.PUT_LINE('Sensor inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o do Sensor.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe um sensor com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Sensor: ' || SQLERRM);
        ROLLBACK;
END Insert_Sensor;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_SensorType(
    p_SpecificType           IN SensorType.SpecificType%TYPE,
    p_id_sensor              IN SensorType.id_sensor%TYPE,
    p_id                     OUT SensorType.id_sensortype%TYPE
) AS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_SensorType(p_SpecificType, p_id_sensor) THEN
        INSERT INTO SensorType (SpecificType, id_sensor)
        VALUES (p_SpecificType, p_id_sensor)
        RETURNING ID_SensorType INTO p_id;

        DBMS_OUTPUT.PUT_LINE('Tipo de sensor inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o do Tipo de sensor.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe um tipo de sensor com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Tipo de sensor: ' || SQLERRM);
        ROLLBACK;
END Insert_SensorType;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Analysis(
    p_AnalysisValue         IN Analysis.AnalysisValue%TYPE,
    p_AnalysisTimestamp     IN Analysis.AnalysisTimestamp%TYPE,
    p_id_sensor             IN Analysis.id_sensor%TYPE,
    p_id                    OUT Analysis.id_analysis%TYPE
) AS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_Analysis(p_AnalysisValue, p_AnalysisTimestamp, p_id_sensor) THEN
        INSERT INTO Analysis (AnalysisValue, AnalysisTimestamp, id_sensor)
        VALUES (p_AnalysisValue, p_AnalysisTimestamp, p_id_sensor)
        RETURNING ID_Analysis INTO p_id;

        DBMS_OUTPUT.PUT_LINE('Analise inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o do Analise.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe uma analise com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Analise: ' || SQLERRM);
        ROLLBACK;
END Insert_Analysis;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_LogAlert(
    p_AlertDescription            IN LogAlert.AlertDescription%TYPE,
    p_TriggeredAt                 IN LogAlert.TriggeredAt%TYPE,
    p_ResolvedAt                  IN LogAlert.ResolvedAT%TYPE,
    p_IsResolved                  IN LogAlert.IsResolved%TYPE,
    p_id_analysis                 IN LogAlert.id_analysis%TYPE,
    p_id                          OUT LogAlert.id_alert%TYPE
) IS
BEGIN
    -- Validar dados da inser��o
    IF Valida_Insert_LogAlert (p_AlertDescription, p_TriggeredAt, p_ResolvedAt, p_IsResolved, p_id_analysis) THEN
        INSERT INTO LogAlert (AlertDescription, TriggeredAt, ResolvedAt, IsResolved, id_analysis)
        VALUES (p_AlertDescription, p_TriggeredAt, p_ResolvedAt, p_IsResolved, p_id_analysis)
        RETURNING ID_Alert INTO p_id;

        DBMS_OUTPUT.PUT_LINE('Alert inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na valida��o dos dados de entrada para inser��o do Alerta.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: J� existe um Alerta com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Alerta: ' || SQLERRM);
        ROLLBACK;
END Insert_LogAlert;
/

DECLARE
    v_id_nuclearplant NUMBER;
    v_id_metric NUMBER;
    v_id_sensor NUMBER;
    v_id_sensortype NUMBER;
    v_id_analysis NUMBER;
    v_id_logalert NUMBER;
BEGIN
    insert_nuclearplant('Usina Power Max', 123, 2, v_id_nuclearplant);
    DBMS_OUTPUT.PUT_LINE('Usina com Id: ' || v_id_nuclearplant || ', inserida.');
    insert_metric(TIMESTAMP '2024-11-10 07:20:00', 700, 50, 80, v_id_nuclearplant, v_id_metric);
    DBMS_OUTPUT.PUT_LINE('Metrica com Id: ' || v_id_metric || ', inserida.');
    insert_sensor('Sensor de Temperatura do Reator', 'No maquin�rio do reator', '1', v_id_nuclearplant, v_id_sensor);
    DBMS_OUTPUT.PUT_LINE('Sensor com Id: ' || v_id_sensor || ', inserido.');
    insert_sensortype('Sensor de Temperatura', v_id_sensor, v_id_sensortype);
    DBMS_OUTPUT.PUT_LINE('Tipo de Sensor com Id: ' || v_id_sensortype || ', inserido.');
    insert_analysis(300, TIMESTAMP '2024-11-11 12:52:07', v_id_sensor, v_id_analysis);
    DBMS_OUTPUT.PUT_LINE('Analise com Id: ' || v_id_analysis || ', inserida.');
    insert_logalert('Sobreaquecimento no Reator', TIMESTAMP '2024-11-11 12:52:07', null, '0', v_id_analysis, v_id_logalert);
    DBMS_OUTPUT.PUT_LINE('Log de alerta com Id: ' || v_id_logalert || ', inserido.');
END;
/


SELECT * FROM NUCLEARPLANT;
SELECT * FROM METRIC;
SELECT * FROM SENSOR;
SELECT * FROM SENSORTYPE;
SELECT * FROM ANALYSIS;
SELECT * FROM LOGALERT;