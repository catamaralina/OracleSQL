# OracleSQL

## Section A1: Import Ottawa Schools and School Boards, Coordinate System Transformation
- Import feature class using Oracle Java Shapefile Converter
- Import feature class using SQL Developer
- Transform coordinate system
- Create Primary Key (PK) and Foreign Key (FK) constraints
## Section A2: Implementing Linear Referencing Systems for OttawaProvRds
- Import feature class using FME
- Update OttawaProvRds to current geometry standard
- Copy metadata for consistency
- Convert to Linear Referencing Systems (LRS)
- Define and translate measure values for highways
## Section B1: Population Density Queries
- Calculate population density for all city wards
- Calculate population density for user-selected ward
- Develop stored procedure to compare ward population density with city-wide density
- Implement an anonymous block to validate and test the stored procedure
## Section A1: Import Ottawa Schools and School Boards, Coordinate System Transformation
- Determine measure value of a specific GPS location along OttawaProvRds_LRS highway
- Transform WGS84 GPS coordinates to match OttawaProvRds_LRS coordinate system
- Create a stored function to compute measure value of an accident along a specified highway based on user-inputted GPS coordinates
- Execute an anonymous block to test the stored function
