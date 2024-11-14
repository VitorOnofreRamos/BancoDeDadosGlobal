set SERVEROUTPUT on;

Create or replace FUNCTION Is_Null_Or_Empty(value IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
    RETURN (value IS NULL OR TRIM(value) = '' OR NOT REGEXP_LIKE(value, '^[\p{L}\d][\p{L}\d\s]*$'));
END Is_Null_Or_Empty;
/

CREATE OR REPLACE FUNCTION Is_Valid_Timestamp(p_timestamp IN TIMESTAMP) RETURN BOOLEAN IS
BEGIN
    IF p_timestamp > CURRENT_TIMESTAMP THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora n�o pode ser no futuro.');
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
    -- Verificar se o nome est� vazio ou nulo, ou n�o corresponde ao padr�o
    IF Is_Null_Or_Empty(p_plantName) THEN
        RAISE invalid_name;
    END IF;

    -- Validar se fullCapacity � um n�mero positivo v�lido
    BEGIN
        IF p_fullCapacity IS NULL OR p_fullCapacity < 1 THEN
            RAISE invalid_capacity;
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erro: A capacidade total deve ser um n�mero v�lido e positivo.');
            RETURN FALSE;
    END;

    -- Validar se numberOfReactors � um n�mero positivo v�lido
    BEGIN
        IF p_numberOfReactors IS NULL OR p_numberOfReactors < 1 THEN
            RAISE invalid_reactors;
        END IF;
    EXCEPTION
        WHEN VALUE_ERROR THEN
            DBMS_OUTPUT.PUT_LINE('Erro: O n�mero de reatores deve ser um n�mero v�lido e positivo.');
            RETURN FALSE;
    END;

    DBMS_OUTPUT.PUT_LINE('Usina v�lida para a inser��o.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_name THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O nome da Usina � inv�lido.');
        RETURN FALSE;

    WHEN invalid_capacity THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A capacidade total dos reatores n�o pode ser nula ou negativa.');
        RETURN FALSE;

    WHEN invalid_reactors THEN
        DBMS_OUTPUT.PUT_LINE('Erro: O n�mero de reatores n�o pode ser nulo ou negativo.');
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

    -- Verifica se MetricDate n�o � no futuro
    IF p_MetricDate IS NULL OR p_MetricDate > CURRENT_TIMESTAMP THEN
        RAISE invalid_timestamp;
    END IF;

    -- Verifica se ElectricityProvided � um n�mero positivo
    IF p_ElectricityProvided IS NULL OR p_ElectricityProvided < 0 THEN
        RAISE invalid_electricity;
    END IF;

    -- Verifica se NuclearParticipation est� entre 0 e 100
    IF p_NuclearParticipation IS NULL OR p_NuclearParticipation < 0 OR p_NuclearParticipation > 100 THEN
        RAISE invalid_nuclear_participation;
    END IF;

    -- Verifica se OperationalEfficiency est� entre 0 e 100
    IF p_OperationalEfficiency IS NULL OR p_OperationalEfficiency < 0 OR p_OperationalEfficiency > 100 THEN
        RAISE invalid_operational_efficiency;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados da m�trica v�lidos para inser��o.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_timestamp THEN
        DBMS_OUTPUT.PUT_LINE('Erro: A data/hora n�o pode ser no futuro.');
        RETURN FALSE;

    WHEN invalid_electricity THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor de eletricidade fornecida inv�lido.');
        RETURN FALSE;

    WHEN invalid_nuclear_participation THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Participa��o nuclear deve estar entre 0 e 100.');
        RETURN FALSE;

    WHEN invalid_operational_efficiency THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Efici�ncia operacional deve estar entre 0 e 100.');
        RETURN FALSE;
        
    WHEN invalid_id_nuclearplant THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usina n�o consta no Banco de Dados');
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

    -- Valida o nome do sensor (somente letras, n�meros e espa�os)
    IF Is_Null_Or_Empty(p_SensorName) THEN
        RAISE invalid_sensor_name;
    END IF;

    -- Valida a localiza��o da maquinaria
    IF Is_Null_Or_Empty(p_MachinaryLocation) THEN
        RAISE invalid_location;
    END IF;

    -- Verifica se o status � '0' (inativo) ou '1' (ativo)
    IF p_Status IS NULL OR NOT p_Status IN ('0', '1') THEN
        RAISE invalid_status;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados do sensor v�lidos para inser��o.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_sensor_name THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Nome do sensor inv�lido.');
        RETURN FALSE;

    WHEN invalid_location THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Localiza��o do maquinaria inv�lida.');
        RETURN FALSE;

    WHEN invalid_status THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status do sensor deve ser "0" (inativo) ou "1" (ativo).');
        RETURN FALSE;
        
    WHEN invalid_id_nuclearplant THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Usina n�o consta no Banco de Dados');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Sensor;
/

BEGIN
    IF Valida_Insert_Sensor('Nome do Sensor', 'Localizacao do Sensor', '0', 1) THEN
        DBMS_OUTPUT.PUT_LINE('A');
    END IF;
END;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Analysis(
    p_AnalysisValue           Analysis.AnalysisValue%TYPE,
    p_id_sensor               Analysis.id_sensor%TYPE
) RETURN BOOLEAN IS
    invalid_analysis_value EXCEPTION;
BEGIN
    -- Verifica se o valor da an�lise � positivo
    IF p_AnalysisValue IS NULL OR p_AnalysisValue < 0 THEN
        RAISE invalid_analysis_value;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados de an�lise v�lidos para inser��o.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_analysis_value THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Valor da an�lise inv�lido. Deve ser positivo.');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Analysis;
/

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION Valida_Insert_Alert(
    p_AlertDescription         Alert.AlertDescription%TYPE,
    p_IsResolved               Alert.IsResolved%TYPE,
    p_id_analysis              Alert.id_analysis%TYPE
) RETURN BOOLEAN IS
    invalid_description EXCEPTION;
    invalid_isresolved EXCEPTION;
BEGIN
    -- Verifica se a descri��o do alerta est� vazia ou n�o segue o padr�o
    IF Is_Null_Or_Empty(p_AlertDescription) OR NOT REGEXP_LIKE(p_AlertDescription, '^[A-Za-z0-9 ]+$') THEN
        RAISE invalid_description;
    END IF;

    -- Verifica se IsResolved tem valor 'Y' ou 'N'
    IF p_IsResolved IS NULL OR NOT p_IsResolved IN ('Y', 'N') THEN
        RAISE invalid_isresolved;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Dados do alerta v�lidos para inser��o.');
    RETURN TRUE;

EXCEPTION
    WHEN invalid_description THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Descri��o do alerta inv�lida.');
        RETURN FALSE;

    WHEN invalid_isresolved THEN
        DBMS_OUTPUT.PUT_LINE('Erro: Status de resolu��o deve ser "Y" ou "N".');
        RETURN FALSE;

    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro inesperado: ' || SQLERRM);
        RETURN FALSE;
END Valida_Insert_Alert;
/
