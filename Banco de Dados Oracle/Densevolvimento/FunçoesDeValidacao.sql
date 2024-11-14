set SERVEROUTPUT on;

Create or replace FUNCTION Is_Null_Or_Empty(value IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    RETURN (value IS NULL OR TRIM(value) = '' OR NOT REGEXP_LIKE(value, '^[A-Za-z0-9À-ÖØ-öø-ÿ][A-Za-z0-9À-ÖØ-öø-ÿ ]*$'));
EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Is_Null_Or_Empty;
/

CREATE OR REPLACE FUNCTION Is_Valid_Timestamp(p_timestamp IN TIMESTAMP) RETURN BOOLEAN IS
BEGIN
    IF p_timestamp > CURRENT_TIMESTAMP THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora não pode ser no futuro.');
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Is_Valid_Timestamp;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

create or replace FUNCTION Valida_Insert_NuclearPlant(
    p_plantName         NuclearPlant.plantName%TYPE,
    p_fullCapacity      NuclearPlant.fullCapacity%TYPE,
    p_numberOfReactors  NuclearPlant.numberOfReactors%TYPE
) RETURN BOOLEAN IS
    invalid_name EXCEPTION;
    invalid_capacity EXCEPTION;
    invalid_reactors EXCEPTION;
BEGIN
    -- Verificar se o nome está vazio ou nulo, ou não corresponde ao padrão
    IF Is_Null_Or_Empty(p_plantName) THEN
        RAISE invalid_name;
    END IF;

    -- Validar se fullCapacity é um número positivo válido
    BEGIN
        IF p_fullCapacity IS NULL OR p_fullCapacity < 1 THEN
            RAISE invalid_capacity;
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erro: A capacidade total deve ser um número válido e positivo.');
            RETURN FALSE;
    END;

    -- Validar se numberOfReactors é um número positivo válido
    BEGIN
        IF p_numberOfReactors IS NULL OR p_numberOfReactors < 1 THEN
            RAISE invalid_reactors;
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erro: O número de reatores deve ser um número válido e positivo.');
            RETURN FALSE;
    END;

    DBMS_OUTPUT.PUT_LINE('Usina válida para a inserção.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_name THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O nome da Usina é inválido.');
        RETURN FALSE;

    WHEN invalid_capacity THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A capacidade total dos reatores não pode ser nula ou negativa.');
        RETURN FALSE;

    WHEN invalid_reactors THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O número de reatores não pode ser nulo ou negativo.');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_NuclearPlant;
/

BEGIN
    IF Valida_Insert_NuclearPlant('Nome da Usina', 123, 123) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Metric(
    p_MetricDate                 Metric.MetricDate%TYPE,
    p_ElectricityProvided        Metric.ElectricityProvided%TYPE,
    p_NuclearParticipation       Metric.NuclearParticipation%TYPE,
    p_OperationalEfficiency      Metric.OperationalEfficiency%TYPE,
    p_id_nuclearplant            Metric.id_nuclearplant%TYPE
) RETURN BOOLEAN IS
    invalid_timestamp EXCEPTION;
    invalid_electricity EXCEPTION;
    invalid_nuclear_participation EXCEPTION;
    invalid_operational_efficiency EXCEPTION;
    invalid_id_nuclearplant EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Verificar se a Usina exsiste
    SELECT COUNT(*) INTO v_count
    FROM nuclearplant
    WHERE id_nuclearplant = p_id_nuclearplant;
    IF v_count = 0 OR p_id_nuclearplant IS NULL THEN
        RAISE invalid_id_nuclearplant;
    END IF;

    -- Verifica se MetricDate não é no futuro
    IF p_MetricDate IS NULL OR p_MetricDate > CURRENT_TIMESTAMP THEN
        RAISE invalid_timestamp;
    END IF;

    -- Verifica se ElectricityProvided é um número positivo
    IF p_ElectricityProvided IS NULL OR p_ElectricityProvided < 0 THEN
        RAISE invalid_electricity;
    END IF;

    -- Verifica se NuclearParticipation está entre 0 e 100
    IF p_NuclearParticipation IS NULL OR p_NuclearParticipation < 0 OR p_NuclearParticipation > 100 THEN
        RAISE invalid_nuclear_participation;
    END IF;

    -- Verifica se OperationalEfficiency está entre 0 e 100
    IF p_OperationalEfficiency IS NULL OR p_OperationalEfficiency < 0 OR p_OperationalEfficiency > 100 THEN
        RAISE invalid_operational_efficiency;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados da métrica válidos para inserção.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_timestamp THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora não pode ser no futuro.');
        RETURN FALSE;

    WHEN invalid_electricity THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor de eletricidade fornecida inválido.');
        RETURN FALSE;

    WHEN invalid_nuclear_participation THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Participação nuclear deve estar entre 0 e 100.');
        RETURN FALSE;

    WHEN invalid_operational_efficiency THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Eficiência operacional deve estar entre 0 e 100.');
        RETURN FALSE;
        
    WHEN invalid_id_nuclearplant THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usina não consta no Banco de Dados');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Metric;
/

BEGIN
    IF Valida_Insert_Metric(TIMESTAMP '2024-11-11 12:30:00', 1234, 100, 0, 1) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Sensor(
    p_SensorName             Sensor.SensorName%TYPE,
    p_MachinaryLocation      Sensor.MachinaryLocation%TYPE,
    p_Status                 Sensor.Status%TYPE,
    p_id_nuclearplant        Sensor.id_nuclearplant%TYPE
) RETURN BOOLEAN IS
    invalid_sensor_name EXCEPTION;
    invalid_location EXCEPTION;
    invalid_status EXCEPTION;
    invalid_id_nuclearplant EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Verificar se a Usina exsiste
    SELECT COUNT(*) INTO v_count
    FROM nuclearplant
    WHERE id_nuclearplant = p_id_nuclearplant;
    IF v_count = 0 OR p_id_nuclearplant IS NULL THEN
        RAISE invalid_id_nuclearplant;
    END IF;

    -- Valida o nome do sensor (somente letras, números e espaços)
    IF Is_Null_Or_Empty(p_SensorName) THEN
        RAISE invalid_sensor_name;
    END IF;

    -- Valida a localização da maquinaria
    IF Is_Null_Or_Empty(p_MachinaryLocation) THEN
        RAISE invalid_location;
    END IF;

    -- Verifica se o status é '0' (inativo) ou '1' (ativo)
    IF p_Status IS NULL OR NOT p_Status IN ('0', '1') THEN
        RAISE invalid_status;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados do sensor válidos para inserção.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_sensor_name THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome do sensor inválido.');
        RETURN FALSE;

    WHEN invalid_location THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Localização do maquinaria inválida.');
        RETURN FALSE;

    WHEN invalid_status THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status do sensor deve ser "0" (inativo) ou "1" (ativo).');
        RETURN FALSE;
        
    WHEN invalid_id_nuclearplant THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usina não consta no Banco de Dados');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Sensor;
/

BEGIN
    IF Valida_Insert_Sensor('Nome do Sensor', 'Localização do Sensor', '1', 1) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Analysis(
    p_AnalysisValue           Analysis.AnalysisValue%TYPE,
    p_AnalysisTimestamp       Analysis.AnalysisTimestamp%TYPE,
    p_id_sensor               Analysis.id_sensor%TYPE
) RETURN BOOLEAN IS
    invalid_analysis_value EXCEPTION;
    invalid_analysis_timestamp EXCEPTION;
    invalid_id_sensor EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Verificar se a Usina exsiste
    SELECT COUNT(*) INTO v_count
    FROM sensor
    WHERE id_sensor = p_id_sensor;
    IF v_count = 0 OR p_id_sensor IS NULL THEN
        RAISE invalid_id_sensor;
    END IF;

    -- Verifica se AnalysisTimestamp não é no futuro
    IF p_AnalysisTimestamp IS NULL OR p_AnalysisTimestamp > CURRENT_TIMESTAMP THEN
        RAISE invalid_analysis_timestamp;
    END IF;

    -- Verifica se o valor da análise é positivo
    IF p_AnalysisValue IS NULL OR p_AnalysisValue < 0 THEN
        RAISE invalid_analysis_value;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados de análise válidos para inserção.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_analysis_value THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor da análise inválido. Deve ser positivo.');
        RETURN FALSE;
        
    WHEN invalid_analysis_timestamp THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora não pode ser no futuro.');
        RETURN FALSE;
        
    WHEN invalid_id_sensor THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Sensor não consta no Banco de Dados');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Analysis;
/

BEGIN
    IF Valida_Insert_Analysis(123, TIMESTAMP '2024-11-11 12:30:00', 2) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Alert(
    p_AlertDescription         Alert.AlertDescription%TYPE,
    p_TriggeredAt              Alert.TriggeredAt%TYPE,
    p_ResolvedAt               Alert.ResolvedAt%TYPE,
    p_IsResolved               Alert.IsResolved%TYPE,
    p_id_analysis              Alert.id_analysis%TYPE
) RETURN BOOLEAN IS
    invalid_description EXCEPTION;
    invalid_trigger EXCEPTION;
    invalid_resolution EXCEPTION;
    invalid_isresolved EXCEPTION;
    invalid_id_analysis EXCEPTION;
    v_count NUMBER;
BEGIN
    -- Verificar se a Analysis exsiste
    SELECT COUNT(*) INTO v_count
    FROM analysis
    WHERE id_analysis = p_id_analysis;
    IF v_count = 0 OR p_id_analysis IS NULL THEN
        RAISE invalid_id_analysis;
    END IF;

    -- Verifica se a descrição do alerta está vazia ou não segue o padrão
    IF Is_Null_Or_Empty(p_AlertDescription) THEN
        RAISE invalid_description;
    END IF;
    
    IF p_TriggeredAt > CURRENT_TIMESTAMP THEN
        RAISE invalid_trigger;
    END IF;
    
    IF p_ResolvedAt < p_TriggeredAt OR p_ResolvedAt > CURRENT_TIMESTAMP THEN
        RAISE invalid_resolution;
    END IF;

    -- Verifica se IsResolved tem valor '0'(Não) ou '1'(Sim)
    IF p_IsResolved IS NULL OR NOT p_IsResolved IN ('0', '1') THEN
        RAISE invalid_isresolved;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados do alerta válidos para inserção.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_description THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Descrição do alerta inválida.');
        RETURN FALSE;
    
    WHEN invalid_trigger THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora não pode ser no futuro.');
        RETURN FALSE;
        
    WHEN invalid_resolution THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora de resolução não pode ser menor que a data/hora de trigger e não pode ser no futuro.');
        RETURN FALSE;

    WHEN invalid_isresolved THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status de resolução deve ser "Y" ou "N".');
        RETURN FALSE;
        
    WHEN invalid_id_analysis THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Analise não consta no Banco de Dados');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Alert;
/

BEGIN
    IF Valida_Insert_Alert('Sobreaquecimento', TIMESTAMP '2024-11-11 12:30:00', TIMESTAMP '2024-11-11 11:30:00', '1', 1) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/
