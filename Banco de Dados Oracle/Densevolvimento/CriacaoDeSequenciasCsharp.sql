set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE Create_Sequence_For_Table (
    p_table_name IN VARCHAR2
) AS
    v_sequence_name VARCHAR2(30);
    v_count NUMBER;
BEGIN
    -- Definir o nome da sequência com base no nome da tabela
    v_sequence_name := 'SEQ_' || UPPER(p_table_name);

    -- Verificar se a sequência já existe
    SELECT COUNT(*) INTO v_count
    FROM user_sequences
    WHERE sequence_name = v_sequence_name;

    -- Se a sequência não existir, cria a sequência
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || v_sequence_name || ' START WITH 1 INCREMENT BY 1';
        DBMS_OUTPUT.PUT_LINE('Sequência criada: ' || v_sequence_name);
    ELSE
        DBMS_OUTPUT.PUT_LINE('A sequência já existe: ' || v_sequence_name);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao criar sequência para a tabela ' || p_table_name || ': ' || SQLERRM);
END Create_Sequence_For_Table;
/

EXECUTE Create_Sequence_For_Table('Sequenciateste');

SELECT * FROM user_sequences;




















