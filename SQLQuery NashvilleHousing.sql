--DATA CLEANING QUERIES

SELECT *
FROM [Portfolio project]..NashvilleHousing

--Standardize date format

SELECT SaleDateConverted, CONVERT(Date, SaleDate) 
FROM [Portfolio project]..NashvilleHousing
ORDER BY SaleDateConverted 

ALTER TABLE [Portfolio project]..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE [Portfolio project]..NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

--Populate property address data
-- there are some properties which do not have address listed and have NULL value. On this one we will replace the NULL values with the addresses that has same parcel IDs

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio project]..NashvilleHousing a
JOIN [Portfolio project]..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [Portfolio project]..NashvilleHousing a
JOIN [Portfolio project]..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL -- we will run this quesry first and then run the above query to replace all the NULL values with correct address


-- breaking out address into individual columns (address, city, state)

SELECT PropertyAddress
FROM [Portfolio project]..NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [Portfolio project]..NashvilleHousing


ALTER TABLE [Portfolio project]..NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE [Portfolio project]..NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From [Portfolio project]..NashvilleHousing





Select OwnerAddress
From [Portfolio project]..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Portfolio project]..NashvilleHousing



ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Portfolio project]..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Portfolio project]..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [Portfolio project]..NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Portfolio project]..NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Portfolio project]..NashvilleHousing


Update [Portfolio project]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [Portfolio project]..NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio project]..NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio project]..NashvilleHousing


ALTER TABLE [Portfolio project]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
