#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Rename the weight column to atomic_mass
RENAME_PROPERTIES_WEIGHT=$($PSQL "ALTER TABLE properties RENAME COLUMN weight TO atomic_mass;")
echo "RENAME_PROPERTIES_WEIGHT: $RENAME_PROPERTIES_WEIGHT"

# Rename the melting_point column to melting_point_celsius and the boiling_point column to boiling_point_celsius
RENAME_PROPERTIES_MELTING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN melting_point TO melting_point_celsius;")
RENAME_PROPERTIES_BOILING_POINT=$($PSQL "ALTER TABLE properties RENAME COLUMN boiling_point TO boiling_point_celsius;")
echo "RENAME_PROPERTIES_MELTING_POINT: $RENAME_PROPERTIES_MELTING_POINT"
echo "RENAME_PROPERTIES_BOILING_POINT: $RENAME_PROPERTIES_BOILING_POINT"

# Set NOT NULL constraints on melting_point_celsius and boiling_point_celsius
ALTER_PROPERTIES_MELTING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN melting_point_celsius SET NOT NULL;")
ALTER_PROPERTIES_BOILING_POINT_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN boiling_point_celsius SET NOT NULL;")
echo "ALTER_PROPERTIES_MELTING_POINT_NOT_NULL: $ALTER_PROPERTIES_MELTING_POINT_NOT_NULL"
echo "ALTER_PROPERTIES_BOILING_POINT_NOT_NULL: $ALTER_PROPERTIES_BOILING_POINT_NOT_NULL"

# Add UNIQUE constraint to symbol and name columns in the elements table
ALTER_ELEMENTS_SYMBOL_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(symbol);")
ALTER_ELEMENTS_NAME_UNIQUE=$($PSQL "ALTER TABLE elements ADD UNIQUE(name);")
echo "ALTER_ELEMENTS_SYMBOL_UNIQUE: $ALTER_ELEMENTS_SYMBOL_UNIQUE"
echo "ALTER_ELEMENTS_NAME_UNIQUE: $ALTER_ELEMENTS_NAME_UNIQUE"

# Set NOT NULL constraints on symbol and name columns in the elements table
ALTER_ELEMENTS_SYMBOL_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN symbol SET NOT NULL;")
ALTER_ELEMENTS_NAME_NOT_NULL=$($PSQL "ALTER TABLE elements ALTER COLUMN name SET NOT NULL;")
echo "ALTER_ELEMENTS_SYMBOL_NOT_NULL: $ALTER_ELEMENTS_SYMBOL_NOT_NULL"
echo "ALTER_ELEMENTS_NAME_NOT_NULL: $ALTER_ELEMENTS_NAME_NOT_NULL"

# Set atomic_number column in the properties table as a foreign key
ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY (atomic_number) REFERENCES elements(atomic_number);")
echo "ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY: $ALTER_PROPERTIES_ATOMIC_NUMBER_FOREIGN_KEY"

# Create the types table
CREATE_TBL_TYPES=$($PSQL "CREATE TABLE types();")
echo "CREATE_TBL_TYPES: $CREATE_TBL_TYPES"

# Add columns to the types table
ADD_COLUMN_TYPES_TYPE_ID=$($PSQL "ALTER TABLE types ADD COLUMN type_id SERIAL PRIMARY KEY;")
ADD_COLUMN_TYPES_TYPE=$($PSQL "ALTER TABLE types ADD COLUMN type VARCHAR(20) NOT NULL;")
echo "ADD_COLUMN_TYPES_TYPE_ID: $ADD_COLUMN_TYPES_TYPE_ID"
echo "ADD_COLUMN_TYPES_TYPE: $ADD_COLUMN_TYPES_TYPE"

# Insert distinct types from properties table into types table
INSERT_COLUMN_TYPES_TYPE=$($PSQL "INSERT INTO types(type) SELECT DISTINCT(type) FROM properties;")
echo "INSERT_COLUMN_TYPES_TYPE: $INSERT_COLUMN_TYPES_TYPE"

# Add and update type_id column in the properties table
ADD_COLUMN_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE properties ADD COLUMN type_id INT;")
ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID=$($PSQL "ALTER TABLE properties ADD FOREIGN KEY(type_id) REFERENCES types(type_id);")
UPDATE_PROPERTIES_TYPE_ID=$($PSQL "UPDATE properties SET type_id = (SELECT type_id FROM types WHERE properties.type = types.type);")
ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL=$($PSQL "ALTER TABLE properties ALTER COLUMN type_id SET NOT NULL;")
echo "ADD_COLUMN_PROPERTIES_TYPE_ID: $ADD_COLUMN_PROPERTIES_TYPE_ID"
echo "ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID: $ADD_FOREIGN_KEY_PROPERTIES_TYPE_ID"
echo "UPDATE_PROPERTIES_TYPE_ID: $UPDATE_PROPERTIES_TYPE_ID"
echo "ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL: $ALTER_COLUMN_PROPERTIES_TYPE_ID_NOT_NULL"

# Capitalize the first letter of all symbols in the elements table
UPDATE_ELEMENTS_SYMBOL=$($PSQL "UPDATE elements SET symbol=INITCAP(symbol);")
echo "UPDATE_ELEMENTS_SYMBOL: $UPDATE_ELEMENTS_SYMBOL"

# Remove trailing zeros from atomic_mass column
ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS=$($PSQL "ALTER TABLE properties ALTER COLUMN atomic_mass TYPE VARCHAR(9);")
UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS=$($PSQL "UPDATE properties SET atomic_mass=CAST(atomic_mass AS FLOAT);")
echo "ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS: $ALTER_VARCHAR_PROPERTIES_ATOMIC_MASS"
echo "UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS: $UPDATE_FLOAT_PROPERTIES_ATOMIC_MASS"

# Insert elements Fluorine and Neon
INSERT_ELEMENT_F=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(9, 'F', 'Fluorine');")
INSERT_PROPERTIES_F=$($PSQL "INSERT INTO properties(atomic_number, type_id, melting_point_celsius, boiling_point_celsius, atomic_mass) VALUES(9, (SELECT type_id FROM types WHERE type='nonmetal'), -220, -188.1, 18.998);")
INSERT_ELEMENT_NE=$($PSQL "INSERT INTO elements(atomic_number, symbol, name) VALUES(10, 'Ne', 'Neon');")
INSERT_PROPERTIES_NE=$($PSQL "INSERT INTO properties(atomic_number, type_id, melting_point_celsius, boiling_point_celsius, atomic_mass) VALUES(10, (SELECT type_id FROM types WHERE type='nonmetal'), -248.6, -246.1, 20.18);")
echo "INSERT_ELEMENT_F: $INSERT_ELEMENT_F"
echo "INSERT_PROPERTIES_F: $INSERT_PROPERTIES_F"
echo "INSERT_ELEMENT_NE: $INSERT_ELEMENT_NE"
echo "INSERT_PROPERTIES_NE: $INSERT_PROPERTIES_NE"

# Delete the non-existent element with atomic_number 1000
DELETE_PROPERTIES_1000=$($PSQL "DELETE FROM properties WHERE atomic_number=1000;")
DELETE_ELEMENTS_1000=$($PSQL "DELETE FROM elements WHERE atomic_number=1000;")
echo "DELETE_PROPERTIES_1000: $DELETE_PROPERTIES_1000"
echo "DELETE_ELEMENTS_1000: $DELETE_ELEMENTS_1000"

# Drop the type column from the properties table
DELETE_COLUMN_PROPERTIES_TYPE=$($PSQL "ALTER TABLE properties DROP COLUMN type;")
echo "DELETE_COLUMN_PROPERTIES_TYPE: $DELETE_COLUMN_PROPERTIES_TYPE"
