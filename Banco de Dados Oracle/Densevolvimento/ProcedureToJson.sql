set SERVEROUTPUT on;

CREATE OR REPLACE PROCEDURE TO_JSON(
    p_id_nuclearplant IN NUMBER,
    p_json_output OUT CLOB
) AS
BEGIN
    SELECT JSON_OBJECT(
               'ID_NuclearPlant' VALUE ID_NuclearPlant,
               'PlantName' VALUE PlantName,
               'FullCapacity' VALUE FullCapacity,
               'NumberOfReactors' VALUE NumberOfReactors
           )
    INTO p_json_output
    FROM NuclearPlant
    WHERE ID_NuclearPlant = p_id_nuclearplant;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_json_output := '{"error": "No data found for the specified ID"}';
    WHEN OTHERS THEN
        p_json_output := '{"error": "An unexpected error occurred"}';
END TO_JSON;
/

DECLARE
    v_json_output CLOB;
BEGIN
    TO_JSON(2, v_json_output);
    DBMS_OUTPUT.PUT_LINE(v_json_output);
END;
/