-- Section A1: Import Ottawa Schools and School Boards, Coordinate System Transformation

--Import Ottawa Schools using Oracle Java Shapefile Converter and School boards using SQL Developer. 
--Transform the coordinate system using Oracle functions

SELECT SRID, COORD_REF_SYS_NAME
FROM MDSYS.SDO_COORD_REF_SYSTEM
WHERE COORD_REF_SYS_NAME LIKE '%NAD%83%CSRS%MTM%9%';

-- SRID found: NAD_1983_CSRS_MTM_9

-- Import OttawaSchools shapefile using Oracle Java Shapefile Converter
java -cp H:\GDM\Week1\PractiseLoad\PractiseLoadData\jarfiles\ojdbc7.jar;H:\GDM\Week1\PractiseLoad\PractiseLoadData\jarfiles\sdoutl.jar;H:\GDM\Week1\PractiseLoad\PractiseLoadData\jarfiles\sdoapi.jar oracle.spatial.util.SampleShapefileToJGeomFeature -h 142.237.139.23 -p 1521 -sn orclpdb -u apagrp08gdm -d a1group8 -t OttawaSchools -f H:\GDM\OttawaData2023\Schools\OttawaSchools -r 2951 -g SHAPE -x -180,180 -y -90,90 -o 0.05 -c 50

--Validate geometry

-- Transform OttawaSchools to match OttawaBuildings coordinate system (SRID 4326)

UPDATE OTTAWASCHOOLS4326 A SET A.SHAPE =
SDO_CS.TRANSFORM(A.SHAPE, 4326);

-- Update spatial metadata for transformed OttawaSchools
-- X (-180, 180, .05)
-- Y (-90, 90, .05)

-- Validate geometries using dimension information
-- Create spatial index for efficient querying

-- Create Primary Key (PK) in SCHOOLBOARD table
ALTER TABLE SCHOOLBOARD ADD
CONSTRAINT pkschoolboard PRIMARY KEY (BOARD);

-- Create PK and Foreign Key (FK) constraints for OTTAWASCHOOLS4326
ALTER TABLE OTTAWASCHOOLS4326 ADD
(CONSTRAINT pkschools PRIMARY KEY (OBJECTID),
CONSTRAINT fkschools FOREIGN KEY (BOARD)
REFERENCES SCHOOLBOARD(BOARD));

