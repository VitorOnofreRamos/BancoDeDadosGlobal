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

EXECUTE insert_nuclearplant('Usina Teste' , 1212, 324-12);
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

EXECUTE insert_Metric(TIMESTAMP '2024-05-02 07:20:00', 654, 70, 93, 1);
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
        VALUES (seq_metric.NEXTVAL, p_SensorName, p_MachinaryLocation, p_Status, p_id_nuclearplant);

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

EXECUTE Insert_Sensor('Nome do Sensor', 'Localização do Sensor', '1', 1);
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
        VALUES (seq_metric.NEXTVAL, p_AnalysisValue, p_AnalysisTimestamp, p_id_sensor);

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

EXECUTE Insert_Analysis(123, TIMESTAMP '2024-11-11 12:30:00', 2);
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------