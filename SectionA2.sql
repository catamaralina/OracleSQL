-- Section A2: Implementing Linear Referencing Systems for OttawaProvRds

-- Update OttawaProvRds to current geometry standard
EXECUTE SDO_MIGRATE.TO_CURRENT('OTTAWAPROVRDS');

-- Copy metadata to ensure consistency
INSERT INTO user_sdo_geom_metadata SELECT 'OTTAWAPROVRDS_LRS', column_name, diminfo, srid
FROM user_sdo_geom_metadata WHERE table_name = 'OTTAWAPROVRDS';

-- Convert to LRS format
DECLARE
status varchar2(20);
BEGIN
status := SDO_LRS.CONVERT_TO_LRS_LAYER('OTTAWAPROVRDS_LRS', 'GEOM');
END;

-- Define measure values for highways
SELECT SDO_LRS.TRANSLATE_MEASURE(c.GEOM, m.diminfo, 87000)
FROM OTTAWAPROVRDS_LRS c, user_sdo_geom_metadata m
WHERE m.table_name = 'OTTAWAPROVRDS_LRS' AND m.column_name = 'GEOM'
AND c.RDNUMBER = '417';

SELECT SDO_LRS.TRANSLATE_MEASURE(c.GEOM, m.diminfo, 41000)
FROM OTTAWAPROVRDS_LRS c, user_sdo_geom_metadata m
WHERE m.table_name = 'OTTAWAPROVRDS_LRS' AND m.column_name = 'GEOM'
AND c.RDNUMBER = '416';

-- Commit the changes
COMMIT;


