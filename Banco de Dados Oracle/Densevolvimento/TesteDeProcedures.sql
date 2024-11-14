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