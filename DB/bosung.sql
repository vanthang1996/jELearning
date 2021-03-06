create proc p_themMonHoc(@tenmon nvarchar(50), @mabomon int, @magv int, @trangthai bit)
as
begin
	if exists (SELECT 1 FROM MON_HOC WHERE MABOMON = @mabomon AND TENMON = @tenmon)
		UPDATE MON_HOC
		SET MAGV = @magv, TRANGTHAI = @trangthai
		WHERE MABOMON = @mabomon AND TENMON = @tenmon
	else
		INSERT INTO MON_HOC (TENMON, MABOMON, MAGV, TRANGTHAI)
		VALUES (@tenmon, @mabomon, @magv, @trangthai)
end

go
create proc p_themBoMon(@tenbomon nvarchar(50), @makhoa int, @magv int)
as
begin
	if exists (SELECT 1 FROM BO_MON WHERE MAKHOA = @makhoa AND TENBOMON = @tenbomon)
		UPDATE BO_MON
		SET MAGV = @magv
		WHERE MAKHOA = @makhoa AND TENBOMON = @tenbomon
	else 
		INSERT INTO BO_MON (TENBOMON, MAKHOA, MAGV)
		VALUES (@tenbomon, @makhoa, @magv)
end

go
create proc p_themGiangVien (
	@hogv nvarchar(50),
	@tengv nvarchar(50),
	@ngaysinh date,
	@email nvarchar(50),
	@matkhau varchar(100),
	@anhgv varchar(300),
	@diachi nvarchar(100),
	@dienthoai nvarchar(100),
	@gioitinh bit,
	@mabomon int,
	@trangthai bit)
as
begin
	if exists (select 1 from GIANG_VIEN where EMAIL = @email)
		raiserror(N'Email đã được sử dụng!', 16, 1)
	else
		insert into GIANG_VIEN(
			HOGV, 
			TENGV,
			NGAYSINH,
			EMAIL,
			MATKHAU,
			ANHGV,
			DIACHI,
			DIENTHOAI,
			GIOITINH,
			MABOMON,
			TRANGTHAI)
		values (@hogv, @tengv, @ngaysinh, @email, @matkhau, @anhgv, @diachi, @dienthoai, @gioitinh, @mabomon, @trangthai)
end