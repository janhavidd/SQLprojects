

select * from ProjectDB.[dbo].[NashvilleHousing]

--Convert date to standard format

select SaleDateConverted
--,CONVERT(date,SaleDate) 
from ProjectDB.[dbo].[NashvilleHousing]

Update ProjectDB.[dbo].[NashvilleHousing]
set SaleDate=CONVERT(date,SaleDate) ;

Alter table  ProjectDB.[dbo].[NashvilleHousing]
add SaleDateConverted date;

Update ProjectDB.[dbo].[NashvilleHousing]
set SaleDateConverted=CONVERT(date,SaleDate) ;


--Populate property address


select a.ParcelID,a.PropertyAddress, b.ParcelID, b.PropertyAddress,
isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectDB.[dbo].[NashvilleHousing] a
join ProjectDB.[dbo].[NashvilleHousing] b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set a.PropertyAddress=isnull(a.PropertyAddress, b.PropertyAddress)
from ProjectDB.[dbo].[NashvilleHousing] a
join ProjectDB.[dbo].[NashvilleHousing] b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address in individual Columns (Address,City,State)


select OwnerAddress ,
SUBSTRING(OwnerAddress,1,CHARINDEX(',',OwnerAddress)-1) as Address
,SUBSTRING(OwnerAddress, CHARINDEX(',',OwnerAddress)+1, LEN(OwnerAddress))
from ProjectDB.[dbo].[NashvilleHousing]


select OwnerAddress,
parsename(replace(OwnerAddress,',','.'),3) as Address,
parsename(replace(OwnerAddress,',','.'),2) as City,
parsename(replace(OwnerAddress,',','.'),1) as State
from ProjectDB.[dbo].[NashvilleHousing]


--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT SoldAsVacant  
FROM ProjectDB.[dbo].[NashvilleHousing]
WHERE SoldAsVacant='N' 



SELECT DISTINCT SoldAsVacant  
FROM ProjectDB.[dbo].[NashvilleHousing]
--WHERE SoldAsVacant='N' 


update  ProjectDB.[dbo].[NashvilleHousing]
set SoldAsVacant=case when SoldAsVacant='Y' then 'Yes' 
					  when SoldAsVacant='N' then 'No'
					  ELSE SoldAsVacant
					  END

set SoldAsVacant='Yes' where SoldAsVacant='Y'

and SoldAsVacant='No' where SoldAsVacant='N'


--Remove duplicates

WITH RowNumCTE as(
select * , 
		ROW_NUMBER() over (
		partition by parcelID,
					PropertyAddress,
					Saleprice,
					SaleDate,
					LegalReference
					Order by 
					UniqueId
					) row_num
from 
ProjectDB.[dbo].[NashvilleHousing]
)
select * from RowNumCTE
where row_num>1
--order by PropertyAddress


