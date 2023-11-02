/*

Cleaning Data in SQL Queries

*/

Select *
From DataCleaningSql.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select saleDate, CONVERT(Date,SaleDate)
From DataCleaningSql.dbo.NashvilleHousing


ALTER TABLE DataCleaningSql.dbo.NashvilleHousing
Add SaleDateConverted Date;


Update DataCleaningSql.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From DataCleaningSql.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaningSql.dbo.NashvilleHousing a
JOIN DataCleaningSql.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From DataCleaningSql.dbo.NashvilleHousing  a
JOIN DataCleaningSql.dbo.NashvilleHousing  b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From DataCleaningSql.dbo.NashvilleHousing

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From DataCleaningSql.dbo.NashvilleHousing


ALTER TABLE  DataCleaningSql.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update DataCleaningSql.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE  DataCleaningSql.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update DataCleaningSql.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From DataCleaningSql.dbo.NashvilleHousing





Select OwnerAddress
From DataCleaningSql.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From DataCleaningSql.dbo.NashvilleHousing

ALTER TABLE DataCleaningSql.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update DataCleaningSql.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE DataCleaningSql.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update DataCleaningSql.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE DataCleaningSql.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update DataCleaningSql.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From DataCleaningSql.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From DataCleaningSql.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From  DataCleaningSql.dbo.NashvilleHousing


Update DataCleaningSql.dbo.NashvilleHousing
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

From DataCleaningSql.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From DataCleaningSql.dbo.NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From  DataCleaningSql.dbo.NashvilleHousing

ALTER TABLE DataCleaningSql.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Select *
From  DataCleaningSql.dbo.NashvilleHousing
