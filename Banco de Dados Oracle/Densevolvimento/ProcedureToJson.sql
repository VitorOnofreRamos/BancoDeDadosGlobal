set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE TO_JSON(
    p_table_name IN VARCHAR2,
    p_id_column IN VARCHAR2,
    p_id_value IN NUMBER,
    p_json_output OUT CLOB
) AS
    v_sql VARCHAR2(32767);
    v_cursor SYS_REFCURSOR;
    v_column_name VARCHAR2(30);
    v_data_type VARCHAR2(30);
    v_value VARCHAR2(4000);
BEGIN
    -- Constrói a consulta dinamicamente
    v_sql := '
        SELECT column_name, data_type
        FROM user_tab_columns
        WHERE table_name = ''' || UPPER(p_table_name) || '''
        ORDER BY column_id';

    OPEN v_cursor FOR v_sql;

    -- Inicializa o objeto JSON
    p_json_output := '{';

    LOOP
        FETCH v_cursor INTO v_column_name, v_data_type;
        EXIT WHEN v_cursor%NOTFOUND;

        -- Adiciona cada coluna ao objeto JSON
        p_json_output := p_json_output || '"' || v_column_name || '": ';

        -- Executa uma consulta para obter o valor da coluna
        EXECUTE IMMEDIATE '
            SELECT ' || v_column_name || '
            FROM ' || p_table_name || '
            WHERE ' || p_id_column || ' = :1'
            INTO v_value
            USING p_id_value;

        -- Converte o valor para string
        CASE
            WHEN v_data_type LIKE '%CHAR%' THEN
                p_json_output := p_json_output || '"' || v_value || '"';
            WHEN v_data_type LIKE '%DATE%' THEN
                p_json_output := p_json_output || '"' || TO_CHAR(v_value, 'YYYY-MM-DD HH24:MI:SS') || '"';
            ELSE
                p_json_output := p_json_output || v_value;
        END CASE;

        p_json_output := p_json_output || ',';
    END LOOP;

    CLOSE v_cursor;

    -- Remove a última vírgula e fecha o objeto JSON
    p_json_output := SUBSTR(p_json_output, 1, LENGTH(p_json_output) - 1) || '}';

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_json_output := '{"error": "No data found for the specified ID"}';
    WHEN OTHERS THEN
        p_json_output := '{"error": "An unexpected error occurred: ' || SQLERRM || '"}';
END TO_JSON;
/

DECLARE
    v_json_output CLOB;
BEGIN
    TO_JSON('NUCLEARPLANT', 'ID_NUCLEARPLANT', 1, v_json_output);
    DBMS_OUTPUT.PUT_LINE(v_json_output);
END;
/