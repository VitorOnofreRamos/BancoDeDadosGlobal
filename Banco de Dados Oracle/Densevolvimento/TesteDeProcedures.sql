set SERVEROUTPUT on;

Create or replace PROCEDURE Insert_NuclearPlant(
    p_plantName         NuclearPlant.plantName%TYPE,
    p_fullCapacity      NuclearPlant.fullCapacity%TYPE,
    p_numberOfReactors  NuclearPlant.numberOfReactors%TYPE
) IS
BEGIN
    -- Validar dados da inserção
    IF Valida_Insert_NuclearPlant(p_plantName, p_fullCapacity, p_numberOfReactors) THEN
        INSERT INTO NuclearPlant (ID_NUCLEARPLANT, PlantName, FullCapacity, NumberOfReactors)
        VALUES (seq_nuclearplant.NEXTVAL, p_plantName, p_fullCapacity, p_numberOfReactors);

        DBMS_OUTPUT.PUT_LINE('Usina inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção da Usina Nuclear.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe uma usina com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Usina Nuclear: ' || SQLERRM);
        ROLLBACK;
END insert_nuclearplant;
/

EXECUTE insert_nuclearplant('Usina Power On' , 300, 2);
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Metric(
    p_MetricDate                 Metric.MetricDate%TYPE,
    p_ElectricityProvided        Metric.ElectricityProvided%TYPE,
    p_NuclearParticipation       Metric.NuclearParticipation%TYPE,
    p_OperationalEfficiency      Metric.OperationalEfficiency%TYPE,
    p_id_nuclearplant            Metric.id_nuclearplant%TYPE
) IS
BEGIN
    -- Validar dados da inserção
    IF Valida_Insert_Metric(p_MetricDate, p_ElectricityProvided, p_NuclearParticipation, p_OperationalEfficiency, p_id_nuclearplant) THEN
        INSERT INTO Metric (ID_METRIC, MetricDate, ElectricityProvided, NuclearParticipation, OperationalEfficiency, id_nuclearplant)
        VALUES (seq_metric.NEXTVAL, p_MetricDate, p_ElectricityProvided, p_NuclearParticipation, p_OperationalEfficiency, p_id_nuclearplant);

        DBMS_OUTPUT.PUT_LINE('Métrica inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção da Métrica.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe uma métrica com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Métrica: ' || SQLERRM);
        ROLLBACK;
END Insert_Metric;
/

EXECUTE insert_Metric(TIMESTAMP '2024-11-10 07:20:00', 700, 50, 80, 1);
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Sensor(
    p_SensorName             Sensor.SensorName%TYPE,
    p_MachinaryLocation      Sensor.MachinaryLocation%TYPE,
    p_Status                 Sensor.Status%TYPE,
    p_id_nuclearplant        Sensor.id_nuclearplant%TYPE
) IS
BEGIN
    -- Validar dados da inserção
    IF Valida_Insert_Sensor(p_SensorName, p_MachinaryLocation, p_Status, p_id_nuclearplant) THEN
        INSERT INTO Sensor (ID_SENSOR, SensorName, MachinaryLocation, Status, id_nuclearplant)
        VALUES (seq_sensor.NEXTVAL, p_SensorName, p_MachinaryLocation, p_Status, p_id_nuclearplant);

        DBMS_OUTPUT.PUT_LINE('Sensor inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção do Sensor.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um senso com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Sensor: ' || SQLERRM);
        ROLLBACK;
END Insert_Sensor;
/

    EXECUTE Insert_Sensor('Sensor de Temperatura do Reator', 'No maquinário do reator', '1', 1);
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Analysis(
    p_AnalysisValue          Analysis.AnalysisValue%TYPE,
    p_AnalysisTimestamp      Analysis.AnalysisTimestamp%TYPE,
    p_id_sensor              Analysis.id_sensor%TYPE
) IS
BEGIN
    -- Validar dados da inserção
    IF Valida_Insert_Analysis(p_AnalysisValue, p_AnalysisTimestamp, p_id_sensor) THEN
        INSERT INTO Analysis (ID_ANALYSIS, AnalysisValue, AnalysisTimestamp, id_sensor)
        VALUES (seq_analysis.NEXTVAL, p_AnalysisValue, p_AnalysisTimestamp, p_id_sensor);

        DBMS_OUTPUT.PUT_LINE('Analise inserida com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção do Analise.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe uma analise com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Analise: ' || SQLERRM);
        ROLLBACK;
END Insert_Analysis;
/

EXECUTE Insert_Analysis(300, TIMESTAMP '2024-11-11 12:52:07', 1);
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

Create or replace PROCEDURE Insert_Alert(
    p_AlertDescription             Alert.AlertDescription%TYPE,
    p_TriggeredAt                  Alert.TriggeredAt%TYPE,
    p_ResolvedAt                   Alert.ResolvedAT%TYPE,
    p_IsResolved                   Alert.IsResolved%TYPE,
    p_id_analysis                  Alert.id_analysis%TYPE
) IS
BEGIN
    -- Validar dados da inserção
    IF Valida_Insert_Alert (p_AlertDescription, p_TriggeredAt, p_ResolvedAt, p_IsResolved, p_id_analysis) THEN
        INSERT INTO Alert (ID_ALERT, AlertDescription, TriggeredAt, ResolvedAt, IsResolved, id_analysis)
        VALUES (seq_alert.NEXTVAL, p_AlertDescription, p_TriggeredAt, p_ResolvedAt, p_IsResolved, p_id_analysis);

        DBMS_OUTPUT.PUT_LINE('Alert inserido com sucesso.');
        COMMIT;
    ELSE
        DBMS_OUTPUT.PUT_LINE('Erro na validação dos dados de entrada para inserção do Alerta.');
    END IF;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Já existe um Alerta com este identificador.');
        ROLLBACK;

    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Tipo de dado incorreto fornecido.');
        ROLLBACK;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir Alerta: ' || SQLERRM);
        ROLLBACK;
END Insert_Alert;
/

EXECUTE Insert_Alert('Sobreaquecimento no Reator', TIMESTAMP '2024-11-11 12:52:07', TIMESTAMP '2024-11-11 13:01:21', '1', 1);
/

SELECT * FROM NUCLEARPLANT;
SELECT * FROM METRIC;
SELECT * FROM SENSOR;
SELECT * FROM ANALYSIS;
SELECT * FROM ALERT;