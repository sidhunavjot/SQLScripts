select * from dbo.[Nasville Housing];

--updating sales date

select 
SaleDate, CONVERT(date,SaleDate)
from dbo.[Nasville Housing]



alter table dbo.[Nasville Housing]
add  saledateconverted date

update dbo.[Nasville Housing]
set saledateconverted = CONVERT(date,SaleDate);

select saledateconverted from dbo.[Nasville Housing];

-------------------------------------------------------------------------------------------------------------

-- updating property address

select 
*
from dbo.[Nasville Housing]
where PropertyAddress is null;

select 
a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nasville Housing] as a
join dbo.[Nasville Housing]as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from dbo.[Nasville Housing] as a
join dbo.[Nasville Housing]as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null;

select 
*
from dbo.[Nasville Housing]
where PropertyAddress is null;

-----------------------------------------------------------------------------------------------------------------------

-- breaking address in columns (Address, city, state)

select 
PropertyAddress
from dbo.[Nasville Housing]

select 
PropertyAddress, 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address ,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as city
from dbo.[Nasville Housing]

alter table dbo.[Nasville Housing]
add PropertySplitAddress varchar(255)

update dbo.[Nasville Housing]
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table dbo.[Nasville Housing]
add PropertySplitcity varchar(255)

update dbo.[Nasville Housing]
set PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select 
*
from dbo.[Nasville Housing];

-- Owner address update with parsename

select 
PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
from dbo.[Nasville Housing]

alter table dbo.[Nasville Housing]
add OwnerSplitAddress varchar(255)

update dbo.[Nasville Housing]
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)

alter table dbo.[Nasville Housing]
add OwnerSplitCity varchar(255)

update dbo.[Nasville Housing]
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)

alter table dbo.[Nasville Housing]
add OwnerSplitCountry varchar(255)

update dbo.[Nasville Housing]
set OwnerSplitCountry  = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)

select 
*
from dbo.[Nasville Housing];

-----------------------------------------------------------------------------------------------------------

-- change Y and N to yes and no in 'Sold as vacant' field


select distinct(SoldAsVacant),count(SoldAsVacant)
from dbo.[Nasville Housing]
group by SoldAsVacant
order by SoldAsVacant


select SoldAsVacant,
	case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end
from dbo.[Nasville Housing]

update dbo.[Nasville Housing]
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
		 when SoldAsVacant = 'N' then 'No'
		 else SoldAsVacant
		 end;


--------------------------------------------------------------------------------------------


--remove duplicates-> rows basically

-- tells duplicate

with RowNumCTE as (
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 order by
					uniqueID) row_num
from dbo.[Nasville Housing]
)

select *
from RowNumCTE
where row_num>1
order by PropertyAddress;

-- delete duplicates

with RowNumCTE as (
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 LegalReference
				 order by
					uniqueID) row_num
from dbo.[Nasville Housing]
)

delete
from RowNumCTE
where row_num>1;


--------------------------------------------------------------------------------

-- delete unused columns

alter table dbo.[Nasville Housing]
drop column OwnerAddress, TaxDistrict, PropertyAddress 

select 
*
from dbo.[Nasville Housing];
