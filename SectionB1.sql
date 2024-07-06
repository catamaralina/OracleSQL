-- Section B1: Population Density Queries

-- Calculate population density for all wards combined
SELECT 
SUM(C.TOTAL_POP) /SUM(SDO_GEOM.SDO_AREA ( W.Shape, 0.5, 'UNIT=SQ_KM' )) "Population Density Per Sq Km"
FROM CURRENTWARDS W, CENSUS2016 C;

-- Create a SQL query that returns the population density (based on total population and the area of the geometry) for a specific ward. 
-- (Ward 1 as an example)
SELECT C.Ward, C.TOTAL_POP/SDO_GEOM.SDO_AREA( W.Shape, 0.5, 'UNIT=SQ_KM') "Population Density Per Sq Km" 
FROM CENSUS2016 C, CURRENTWARDS W
WHERE W.WARD_NUM = C.WARD AND C.WARD = '1';

DECLARE
    i_pop NUMBER(7, 0); 
    i_ward NUMBER(2, 0):='&ward_num';
    i_area NUMBER;
BEGIN
    SELECT C.TOTAL_POP, SDO_GEOM.SDO_AREA( W.Shape, 0.5, 'UNIT=SQ_KM')
        INTO i_pop, i_area
    FROM CENSUS2016 C, CURRENTWARDS W
    WHERE W.WARD_NUM = i_ward AND C.WARD = i_WARD;
    DBMS_OUTPUT.PUT_LINE ('Ward: ' || i_ward);
    DBMS_OUTPUT.PUT_LINE ('Pop Density Sq Km: ' || i_pop/i_area);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such ward');
END;

-- PL/SQL stored procedure to compare population density of a specific ward with all wards combined
SET SERVEROUTPUT ON
SET VERIFY OFF

CREATE OR REPLACE PROCEDURE Pop_Density (ward IN NUMBER)
IS
    i_area NUMBER;
    i_pop NUMBER(7, 0);
    i_density NUMBER;
    t_density NUMBER;
    i_ward NUMBER(2, 0);
BEGIN
    i_ward := ward;
    -- Retrieve population and area for the specified ward
    SELECT C.TOTAL_POP, SDO_GEOM.SDO_AREA( W.Shape, 0.5, 'UNIT=SQ_KM'), (
            SELECT SUM(C.TOTAL_POP)/SUM(SDO_GEOM.SDO_AREA ( W.Shape, 0.5, 'UNIT=SQ_KM' )) FROM CENSUS2016 C, CURRENTWARDS W)
    INTO i_pop, i_area, t_density
    FROM CENSUS2016 C, CURRENTWARDS W
    WHERE W.WARD_NUM = i_ward AND C.WARD = i_WARD;

    i_density := i_pop/i_area;

    -- Compare the density of the specified ward with the total density
    IF i_density = t_density THEN
        DBMS_OUTPUT.PUT_LINE('Ward Number: ' || i_ward);
        DBMS_OUTPUT.PUT_LINE('Ward Density is same as total Density' || t_density);
    ELSIF i_density < t_density THEN
        DBMS_OUTPUT.PUT_LINE('Ward Number: ' || i_ward);
        DBMS_OUTPUT.PUT_LINE('Ward Density is lower than total density: ' || i_density);
        DBMS_OUTPUT.PUT_LINE('Total Density: ' || t_density);
    ELSIF i_density > t_density THEN
        DBMS_OUTPUT.PUT_LINE('Ward Number: ' || i_ward);
        DBMS_OUTPUT.PUT_LINE('Ward Density is higher than total density: ' || i_density);
        DBMS_OUTPUT.PUT_LINE('Total Density: ' || t_density);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Something went wrong, sorry.');
    END IF;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE ('There is no such ward');
END Pop_Density;
/


-- Driving procedure to test the stored procedure
BEGIN
    Pop_Density('&ward_num');
END;


