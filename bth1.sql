--Câu 1
EXEC sp_addtype 'Mota', 'nvarchar(40)'
EXEC sp_addtype 'IDKH', 'char(10)', 'Not null'
EXEC sp_addtype 'DT', 'char(12)'

--Câu 2
CREATE DATABASE BTH1
USE BTH1
GO
CREATE TABLE SanPham (
	MaSP char(6) PRIMARY KEY,
	TenSP varchar(20) NOT NULL,
	NgayNhap Date,
	DVT char(10),
	SoLuongTon Int,
	DonGiaNhap money
);

CREATE TABLE KhachHang (
	MaKH IDKH PRIMARY KEY,
	TenKH nvarchar(30),
	DiaChi nvarchar(40),
	DienThoai DT
);

CREATE TABLE HoaDon (
	MaHD char(10) PRIMARY KEY,
	NgayLap Date,
	NgayGiao Date,
	MaKH IDKH,
	FOREIGN KEY (MaKH) REFERENCES KhachHang,
	DienGiai Mota
);

CREATE TABLE ChiTietHD (
	MaHD char(10),
	MaSP char(6),
	PRIMARY KEY (MaHD,MaSP),
	FOREIGN KEY (MaHD) REFERENCES HoaDon,
	FOREIGN KEY (MaSP) REFERENCES SanPham,
	SoLuong int
);

--Câu 3
ALTER TABLE HoaDon
ALTER COLUMN DienGiai nvarchar(100)

--Câu 4
ALTER TABLE SanPham
ADD TyLeHoaHong float

--Câu 5
ALTER TABLE SanPham
DROP COLUMN NgayNhap

--Câu 6
--Đã hoàn thành ở câu 2

--Câu 7
ALTER TABLE HoaDon
ADD CONSTRAINT check_ngay_giao CHECK (NgayGiao >= NgayLap)
ALTER TABLE HoaDon
ADD CONSTRAINT check_ma_hd CHECK (MaHD like '[A-Z][A-Z][0-9][0-9][0-9][0-9]')
ALTER TABLE HoaDon
ADD CONSTRAINT check_ngay_lap DEFAULT GETDATE() FOR NgayLap

--Câu 8
ALTER TABLE SanPham
ADD CONSTRAINT check_so_luong_ton CHECK (SoLuongTon BETWEEN 0 AND 500)
ALTER TABLE SanPham
ADD CONSTRAINT check_don_gia_nhap CHECK (DonGiaNhap > 0)
ALTER TABLE SanPham
ADD NgayNhap Date
ALTER TABLE SanPham
ADD CONSTRAINT check_ngay_nhap DEFAULT GETDATE() for NgayNhap
ALTER TABLE SanPham
ADD CONSTRAINT check_dvt CHECK (DVT IN ('KG','Thung','Hop','Cai'))

--Câu 9
INSERT INTO SanPham (MaSP,TenSP,DVT,SoLuongTon,DonGiaNhap,TyLeHoaHong)
VALUES	('BK1','Banh Chocopie','Hop',20,100,0.1),
		('BK2','Banh bong lan','Cai',30,40,0.05),
		('DR1','Sua tuoi TH','Hop',50,20,0.1),
		('DR2','Coca cola','Thung',100,40,0.05),
		('DR3','Tra xanh 0 do','Thung',120,35,0.04)

INSERT INTO KhachHang(MaKH,TenKH,DiaChi,DienThoai)
VALUES  ('KH1','Nguyen Ngoc Thien','5C Nguyen Dinh Chieu','123456'),
		('KH2','Le Truong Tho', '168 Cong Hoa','111222'),
		('KH3','Tran Nhat Huy', '15 Vo Oanh', '123123'),
		('KH4','Tran Minh Tu', '320 CMT8','222222')

INSERT INTO HoaDon(MaHD,MaKH)
VALUES	('HD0001','KH1'),
		('HD0002','KH1'),
		('HD0003','KH2'),
		('HD0004','KH3'),
		('HD0005','KH4'),
		('HD0006','KH4'),
		('HD0007','KH4')

INSERT INTO ChiTietHD(MaHD,MaSP,SoLuong)
VALUES	('HD0001','BK1',5),
		('HD0002','DR1',6),
		('HD0003','BK2',7),
		('HD0004','BK1',8),
		('HD0005','DR1',9),
		('HD0006','DR2',10),
		('HD0007','DR3',10)

SELECT * FROM SanPham
SELECT * FROM KhachHang
SELECT * FROM HoaDon
SELECT * FROM ChiTietHD

--Câu 10
--Xóa một hóa đơn bất kỳ trong bảng HoaDon không được
--Vì trong bảng ChiTietHD có MaHD là khóa ngoại từ HoaDon
--Nếu vẫn muốn xóa thì phải xóa các hóa đơn tương ứng trong bảng ChiTietHD trước, sau đó mới xóa trong bảng HoaDon

--Câu 11
--Không được, vì MaHD trong bảng ChiTietHD refer từ MaHD trong bảng HoaDon
--Mà trong bảng HoaDon có 1 ràng buộc về MaHD là gồm 6 kí tự, 2 kí tự đầu là chữ, 4 kí tự sau là số
--MaHD = 'HD999999999' và MaHD = '1234567890' đã vi phạm ràng buộc

--Câu 12
USE master;  
GO  
ALTER DATABASE BTH1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE BTH1 MODIFY NAME = BanHang;
GO  
ALTER DATABASE BanHang SET MULTI_USER;
GO