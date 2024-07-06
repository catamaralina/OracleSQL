-- Section B2: Linear Referencing and GPS Coordinates

-- Find the measure value of a GPS location along a specific OttawaProvRds_LRS highway
SELECT  SDO_LRS.FIND_MEASURE(
    R.GEOM, SDO_GEOMETRY(2001, 26918, SDO_POINT_TYPE(452455.621, 5029031.188, NULL), NULL, NULL)) CLOSEST_measure
 FROM OTTAWAPROVRDS_LRS R
 WHERE R.RDNUMBER = 417;

-- Transformation from Longitude/Latitude (WGS84) to Easting/Northing (26918)
SELECT SDO_CS.TRANSFORM(SDO_GEOMETRY(3301, 4326, SDO_POINT_TYPE(-75.6076248, 45.4131861, NULL),null, null), 26918) Transform
FROM DUAL;


-- PL/SQL stored function to calculate measure value of an accident along a highway
SET SERVEROUTPUT ON
SET VERIFY OFF

CREATE OR REPLACE FUNCTION AccidentCoord(x IN NUMBER, y IN NUMBER, HwyNum IN NUMBER)
RETURN NUMBER
IS
    measure NUMBER;
    error_msg VARCHAR2(512);
BEGIN
    -- Transform WGS84 GPS coordinates to OttawaProvRds_LRS coordinate system (26918)
    SELECT  SDO_LRS.FIND_MEASURE(R.GEOM, (SELECT 
                SDO_CS.TRANSFORM(
                    SDO_GEOMETRY(3301, 4326, SDO_POINT_TYPE(x, y, NULL),null, null), 26918) transform
        FROM OTTAWAPROVRDS_LRS R 
        WHERE R.RDNUMBER = HwyNum) 
            )CLOSEST_measure
        INTO measure
        FROM OTTAWAPROVRDS_LRS R
        WHERE R.RDNUMBER = HwyNum;
    RETURN measure;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle case where highway number is invalid
        DBMS_OUTPUT.PUT_LINE('There is no such highway.');
        RETURN -1;
END AccidentCoord;
/

-- Driving procedure to test the stored function for accident measure calculation
DECLARE
    x NUMBER := '&x_coordinate';       -- Prompt user input for x coordinate
    y NUMBER := '&y_coorinate';        -- Prompt user input for y coordinate
    hwynum NUMBER:= '&Hwy_Number';     -- Prompt user input for highway number
    measure NUMBER;
BEGIN
    measure := AccidentCoord(x, y, hwynum);
    -- Validate GPS coordinates within WGS84 bounds (-180 to 180 Long, -90 to 90 Lat)
    IF (x >-180 And x < 180) 
        AND (y >-90 AND y <90) AND measure <> -1 THEN
            DBMS_OUTPUT.PUT_LINE('The location of the accident is on Hwy ' || hwynum);
            DBMS_OUTPUT.PUT_LINE('At coordinates: ' || x || ', ' || y);
            DBMS_OUTPUT.PUT_LINE('The measure of the accident along the highways is: ' || measure);
    ELSIF measure = -1 THEN
    -- Return error code if GPS coordinates are out of WGS84 bounds
        DBMS_OUTPUT.PUT_LINE('Coordinates are out of bounds for WGS84.');  
    END IF;
END;
/
