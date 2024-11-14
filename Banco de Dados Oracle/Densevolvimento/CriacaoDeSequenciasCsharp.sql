set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE Create_Sequence_For_Table (
    p_table_name IN VARCHAR2
) AS
    v_sequence_name VARCHAR2(30);
    v_count NUMBER;
BEGIN
    -- Definir o nome da sequ�ncia com base no nome da tabela
    v_sequence_name := 'SEQ_' || UPPER(p_table_name);

    -- Verificar se a sequ�ncia j� existe
    SELECT COUNT(*) INTO v_count
    FROM user_sequences
    WHERE sequence_name = v_sequence_name;

    -- Se a sequ�ncia n�o existir, cria a sequ�ncia
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_sequence_name || ' START WITH 1 INCREMENT BY 1';
        DBMS_OUTPUT.PUT_LINE('Sequ�ncia criada: ' || v_sequence_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('A sequ�ncia j� existe: ' || v_sequence_name);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao criar sequ�ncia para a tabela ' || p_table_name || ': ' || SQLERRM);
END Create_Sequence_For_Table;
/

EXECUTE Create_Sequence_For_Table('Sequenciateste');

SELECT * FROM user_sequences;




















