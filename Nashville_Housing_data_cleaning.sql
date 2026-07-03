SELECT * FROM nashville;

--standardizing date
ALTER TABLE nashville
ALTER COLUMN saledate type date;
SELECT * FROM nashville;

--populating missing addresses
SELECT parcelid FROM nashville WHERE propertyaddress IS NULL OR propertyaddress = '';

SELECT  
    a.parcelid, a.propertyaddress AS missing_address, 
    b.parcelid, b.propertyaddress AS found_address,
    COALESCE(a.propertyaddress, b.propertyaddress) AS final_address
FROM nashville a
JOIN nashville b
ON a.parcelid = b.parcelid AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL OR a.propertyaddress = '';

UPDATE nashville a
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
FROM nashville b
WHERE a.parcelid = b.parcelid
AND a.uniqueid <> b.uniqueid
AND (a.propertyaddress IS NULL OR a.propertyaddress = '');

SELECT propertyaddress FROM nashville WHERE propertyaddress IS NULL OR propertyaddress = '';

--Breaking address into address, city, state
SELECT propertyaddress FROM nashville;
ALTER TABLE nashville
ADD COLUMN property_split_address VARCHAR(255),
ADD COLUMN property_split_city VARCHAR(100);

UPDATE nashville
SET property_split_address = TRIM(SPLIT_PART(propertyaddress, ',', 1)),
    property_split_city = TRIM(SPLIT_PART(propertyaddress, ',', 2));
SELECT propertyaddress, property_split_address, property_split_city FROM nashville;

SELECT owneraddress FROM nashville;
ALTER TABLE nashville
ADD COLUMN owner_split_address VARCHAR(255),
ADD COLUMN owner_split_city VARCHAR(100),
ADD COLUMN owner_split_state VARCHAR(50);

UPDATE nashville
SET owner_split_address = TRIM(SPLIT_PART(owneraddress, ',', 1)),
    owner_split_city = TRIM(SPLIT_PART(owneraddress, ',', 2)),
    owner_split_state = TRIM(SPLIT_PART(owneraddress, ',', 3));

SELECT 
    owneraddress, 
    owner_split_address, 
    owner_split_city, 
    owner_split_state 
FROM nashville
WHERE ROW(owneraddress, owner_split_address, owner_split_city, owner_split_state) IS NOT NULL;

--removing duplicates
WITH duplicate AS (
    SELECT uniqueid,
    ROW_NUMBER() OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference
    ORDER BY uniqueid) AS row_num
    FROM nashville
)
DELETE FROM nashville
WHERE uniqueid IN (
    SELECT uniqueid FROM duplicate
    WHERE row_num > 1
);

WITH duplicate AS (
    SELECT uniqueid,
    ROW_NUMBER() OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference
    ORDER BY uniqueid) AS row_num
    FROM nashville
)
SELECT * FROM duplicate WHERE row_num > 1;