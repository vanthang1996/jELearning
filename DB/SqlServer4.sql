USE [master]
GO
/****** Object:  Database [HTTTQL]    Script Date: 6/2/2018 18:53:27 ******/
CREATE DATABASE [HTTTQL]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HTTTQL', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\HTTTQL.mdf' , SIZE = 4288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'HTTTQL_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\HTTTQL_log.ldf' , SIZE = 1088KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [HTTTQL] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HTTTQL].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HTTTQL] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HTTTQL] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HTTTQL] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HTTTQL] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HTTTQL] SET ARITHABORT OFF 
GO
ALTER DATABASE [HTTTQL] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [HTTTQL] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HTTTQL] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HTTTQL] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HTTTQL] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HTTTQL] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HTTTQL] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HTTTQL] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HTTTQL] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HTTTQL] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HTTTQL] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HTTTQL] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HTTTQL] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HTTTQL] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [HTTTQL] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HTTTQL] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [HTTTQL] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HTTTQL] SET RECOVERY FULL 
GO
ALTER DATABASE [HTTTQL] SET  MULTI_USER 
GO
ALTER DATABASE [HTTTQL] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HTTTQL] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HTTTQL] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HTTTQL] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [HTTTQL] SET DELAYED_DURABILITY = DISABLED 
GO
USE [HTTTQL]
GO
/****** Object:  UserDefinedFunction [dbo].[F_GETLISTROLE]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- thang
CREATE FUNCTION  [dbo].[F_GETLISTROLE]  ( @MAGV INT)  RETURNS  @RES  TABLE
(
	ROLE_NAME INT NOT NULL,
	DESCRIBE NVARCHAR(100) NOT NULL
)
AS 
BEGIN
	 IF EXISTS(  SELECT * FROM QUAN_LY_MH WHERE MAGV=@MAGV)
		INSERT INTO @RES(ROLE_NAME,DESCRIBE) VALUES(3,N'Giáo Viên')
	 IF EXISTS( SELECT * FROM  BO_MON WHERE  MAGV =@MAGV)
		INSERT INTO  @RES(ROLE_NAME,DESCRIBE)  VALUES(2,N'Trưởng Bộ Môn');
	 IF EXISTS(SELECT * FROM KHOA WHERE MAGV=@MAGV)
		INSERT INTO @RES(ROLE_NAME,DESCRIBE) VALUES(1,N'Trưởng Khoa');
	 RETURN;
END






GO
/****** Object:  UserDefinedFunction [dbo].[FUNC_CHECK_TIENDOCONGVIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE FUNCTION  [dbo].[FUNC_CHECK_TIENDOCONGVIEC] (@macv int)  RETURNS bit
as
begin
	declare @maloaivc int, @mamon  int,@mactdt  int ;
	set @maloaivc = (select MALOAICV from CONG_VIEC where MACV= @macv);
	set @mamon =(select MAMON from CONG_VIEC where macv=@macv);/*má sao chuối quá v bây*/
	set @mactdt =(select MACTDT from CAU_TRUC_DE_THI where MAMON=@mamon);
	if @maloaivc=1/*tạo đề cương*/
	begin
		RETURN (SELECT TRANGTHAI FROM MON_HOC WHERE MAMON=@mamon);
	end
	else if @maloaivc=3 /*tạo cấu trúc đề thi*/
	begin
		RETURN (select TRANGTHAI FROM CAU_TRUC_DE_THI where MACTDT=@mactdt);
	end
	return 0;
end




GO
/****** Object:  UserDefinedFunction [dbo].[RoleOfUser]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE FUNCTION  [dbo].[RoleOfUser]  ( @email nvarchar(50))  RETURNS  @RES  TABLE
(
	ROLE_NAME varchar(5) NOT NULL
)
AS 
BEGIN
  declare @magv int  ;
  select @magv = (select magv from GIANG_VIEN where EMAIL=@email);
	 IF EXISTS(  SELECT * FROM QUAN_LY_MH WHERE MAGV=@MAGV)
		INSERT INTO @RES(ROLE_NAME) VALUES('GV')
	 IF EXISTS( SELECT * FROM  BO_MON WHERE  MAGV =@MAGV)
		INSERT INTO  @RES(ROLE_NAME)  VALUES('TBM');
	 IF EXISTS(SELECT * FROM KHOA WHERE MAGV=@MAGV)
		INSERT INTO @RES(ROLE_NAME) VALUES('TK');
	 RETURN;
END
GO
/****** Object:  Table [dbo].[BO_MON]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BO_MON](
	[MABOMON] [int] IDENTITY(1,1) NOT NULL,
	[TENBOMON] [nvarchar](50) NULL,
	[MAKHOA] [int] NULL,
	[MAGV] [int] NULL,
 CONSTRAINT [PK_BO_MON] PRIMARY KEY CLUSTERED 
(
	[MABOMON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAU_HOI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAU_HOI](
	[MACH] [int] IDENTITY(1,1) NOT NULL,
	[NOIDUNG] [ntext] NULL,
	[MACHUONG] [int] NULL,
	[MAMON] [int] NULL,
	[MADOKHO] [int] NULL,
	[MAGV] [int] NULL,
	[TRANGTHAI] [bit] NULL,
 CONSTRAINT [PK_CAU_HOI] PRIMARY KEY CLUSTERED 
(
	[MACH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CAU_TRUC_DE_THI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CAU_TRUC_DE_THI](
	[MACTDT] [int] IDENTITY(1,1) NOT NULL,
	[MAMON] [int] NULL,
	[NGAYCAPNHAT] [datetime] NULL,
	[MAGV] [int] NULL,
	[TRANGTHAI] [bit] NULL,
	[SLDETOIDA] [smallint] NULL,
 CONSTRAINT [PK_CAU_TRUC_DE_THI] PRIMARY KEY CLUSTERED 
(
	[MACTDT] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[chat]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[chat](
	[chat_id] [int] IDENTITY(1,1) NOT NULL,
	[code] [nvarchar](max) NOT NULL,
	[room_id] [nvarchar](max) NOT NULL,
	[COUNT_MSG] [int] NULL CONSTRAINT [DF_chat_COUNT_MSG]  DEFAULT ((0)),
	[LAST_USER] [varchar](max) NULL,
 CONSTRAINT [PK_chat] PRIMARY KEY CLUSTERED 
(
	[chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[chatdetails]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[chatdetails](
	[details_chat_id] [int] IDENTITY(1,1) NOT NULL,
	[body] [ntext] NULL,
	[time_on] [datetime] NULL,
	[chat_id] [int] NULL,
	[url] [nvarchar](255) NULL,
	[client_id] [nvarchar](255) NULL,
 CONSTRAINT [PK_chatdetails] PRIMARY KEY CLUSTERED 
(
	[details_chat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHI_TIET_CTDT]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_CTDT](
	[MACTDT] [int] NOT NULL,
	[MACHUONG] [int] NOT NULL,
	[MADOKHO] [int] NOT NULL,
	[SLCAUHOI] [smallint] NULL,
	[TONGDIEM] [float] NULL,
 CONSTRAINT [PK_CHI_TIET_CTDT] PRIMARY KEY CLUSTERED 
(
	[MACTDT] ASC,
	[MACHUONG] ASC,
	[MADOKHO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHI_TIET_DE_THI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHI_TIET_DE_THI](
	[MADETHI] [int] NOT NULL,
	[MACH] [int] NOT NULL,
	[VITRIDAPANDUNG] [smallint] NULL,
	[DIEM] [float] NULL,
 CONSTRAINT [PK_CHI_TIET_DE_THI] PRIMARY KEY CLUSTERED 
(
	[MADETHI] ASC,
	[MACH] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CHUONG_MUC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHUONG_MUC](
	[MACHUONG] [int] IDENTITY(1,1) NOT NULL,
	[TIEUDE] [nvarchar](50) NULL,
	[MOTA] [nvarchar](100) NULL,
	[MAMON] [int] NULL,
 CONSTRAINT [PK_CHUONG_MUC] PRIMARY KEY CLUSTERED 
(
	[MACHUONG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CONG_VIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CONG_VIEC](
	[MACV] [int] IDENTITY(1,1) NOT NULL,
	[MAMON] [int] NULL,
	[MAGV] [int] NULL,
	[MALOAICV] [int] NULL,
	[TGBATDAU] [datetime] NULL,
	[TGKETTHUC] [datetime] NULL,
	[NOIDUNGCV] [ntext] NULL,
	[TRANGTHAI] [bit] NULL,
 CONSTRAINT [PK_CONG_VIEC] PRIMARY KEY CLUSTERED 
(
	[MACV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CT_TAO_CAU_HOI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CT_TAO_CAU_HOI](
	[MACV] [int] NOT NULL,
	[MACHUONG] [int] NOT NULL,
	[SL] [int] NULL,
 CONSTRAINT [PK_CT_TAO_CAU_HOI] PRIMARY KEY CLUSTERED 
(
	[MACV] ASC,
	[MACHUONG] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DAP_AN]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DAP_AN](
	[MACH] [int] NOT NULL,
	[MADAPAN] [int] IDENTITY(1,1) NOT NULL,
	[NOIDUNG] [ntext] NULL,
	[DAPANDUNG] [bit] NULL,
 CONSTRAINT [PK_DAP_AN] PRIMARY KEY CLUSTERED 
(
	[MADAPAN] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DE_THI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DE_THI](
	[MADETHI] [int] IDENTITY(1,1) NOT NULL,
	[MAMON] [int] NULL,
	[NGAYTHEM] [datetime] NULL,
	[NGAYTHI] [date] NULL,
	[THOIGIANLAMBAI] [nvarchar](20) NULL,
	[TRANGTHAI] [bit] NULL,
 CONSTRAINT [PK_DE_THI] PRIMARY KEY CLUSTERED 
(
	[MADETHI] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DO_KHO]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DO_KHO](
	[MADOKHO] [int] IDENTITY(1,1) NOT NULL,
	[TENDOKHO] [nvarchar](50) NULL,
 CONSTRAINT [PK_DO_KHO] PRIMARY KEY CLUSTERED 
(
	[MADOKHO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[GIANG_VIEN]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[GIANG_VIEN](
	[MAGV] [int] IDENTITY(1,1) NOT NULL,
	[HOGV] [nvarchar](50) NULL,
	[TENGV] [nvarchar](50) NULL,
	[NGAYSINH] [date] NULL,
	[EMAIL] [nvarchar](50) NULL,
	[MATKHAU] [varchar](100) NULL,
	[ANHGV] [varchar](300) NULL,
	[DIACHI] [nvarchar](100) NULL,
	[DIENTHOAI] [varchar](12) NULL,
	[GIOITINH] [bit] NULL,
	[MABOMON] [int] NULL,
	[TRANGTHAI] [bit] NULL CONSTRAINT [DF_GIANG_VIEN_TRANGTHAI]  DEFAULT ((1)),
 CONSTRAINT [PK_GIANG_VIEN] PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[KHOA]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[KHOA](
	[MAKHOA] [int] IDENTITY(1,1) NOT NULL,
	[TENKHOA] [nvarchar](50) NULL,
	[MAGV] [int] NULL,
 CONSTRAINT [PK_KHOA] PRIMARY KEY CLUSTERED 
(
	[MAKHOA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LOAI_CONG_VIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LOAI_CONG_VIEC](
	[MALOAICV] [int] IDENTITY(1,1) NOT NULL,
	[TENLOAICV] [nvarchar](100) NULL,
 CONSTRAINT [PK_LOAI_CONG_VIEC] PRIMARY KEY CLUSTERED 
(
	[MALOAICV] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MON_HOC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MON_HOC](
	[MAMON] [int] IDENTITY(1,1) NOT NULL,
	[TENMON] [nvarchar](50) NULL,
	[MABOMON] [int] NULL,
	[MAGV] [int] NULL,
	[TRANGTHAI] [bit] NOT NULL CONSTRAINT [DF_MON_HOC_TRANGTHAI]  DEFAULT ((0)),
 CONSTRAINT [PK_MON_HOC] PRIMARY KEY CLUSTERED 
(
	[MAMON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[QUAN_LY_MH]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QUAN_LY_MH](
	[MAGV] [int] NOT NULL,
	[MAMON] [int] NOT NULL,
 CONSTRAINT [PK_QUAN_LY_MH] PRIMARY KEY CLUSTERED 
(
	[MAGV] ASC,
	[MAMON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[BO_MON] ON 

GO
INSERT [dbo].[BO_MON] ([MABOMON], [TENBOMON], [MAKHOA], [MAGV]) VALUES (1, N'Hệ thống thông tin', 1, 2)
GO
INSERT [dbo].[BO_MON] ([MABOMON], [TENBOMON], [MAKHOA], [MAGV]) VALUES (2, N'Mạng máy tính', 1, 3)
GO
INSERT [dbo].[BO_MON] ([MABOMON], [TENBOMON], [MAKHOA], [MAGV]) VALUES (3, N'Khoa học máy tính', 1, 3)
GO
INSERT [dbo].[BO_MON] ([MABOMON], [TENBOMON], [MAKHOA], [MAGV]) VALUES (4, N' Bộ Môn 6883FDA0Khoa Công Ngh? Thông Tin', 1, 2)
GO
SET IDENTITY_INSERT [dbo].[BO_MON] OFF
GO
SET IDENTITY_INSERT [dbo].[CAU_HOI] ON 

GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (1, N'Quyền và nghĩa vụ của ', 1, 2, 1, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (2, N'Khi công dân vi phạm pháp luật với tính chất và mức độ vi phạm như nhau, trong một hoàn cảnh như nhau thì đều phải chịu trách nhiệm pháp lí', 1, 2, 2, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (3, N'Quyền và nghĩa vụ của công dân không bị phân biệt bởi', 2, 2, 2, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (4, N'Học tập là một trong những', 2, 2, 2, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (5, N'Công dân bình đẳng về trách nhiệm pháp lí là', 4, 2, 2, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (6, N'Công dân bình đẳng trước ', 4, 2, 2, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (7, N'Trách nhiệm của nhà nước trong việc bảo đảm quyền bình đẳng của công dân trước pháp luật thể hiện qua việc', 12, 2, 1, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (8, N'Việc đảm bảo quyền bình đẳng của công dân trước pháp luật là trách nhiệm của ', 12, 2, 1, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (9, N'Ai đẹp trai nhất team', 1, 1, 1, 2, 1)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (10, N'Theo Hiến pháp Việt Nam 1992, Thủ tướng Chính phủ Nước CHXHCN Việt Nam:', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (11, N'Văn bản nào có hiệu lực cao nhất trong HTPL Việt Nam:', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (12, N' Trong Tuyên ngôn ĐCS của C.Mác và Ph.Ăngghen viết: “Pháp luật của các ông chỉ là ý
chí của giai cấp các ông được đề lên thành luật, cái ý chí mà nội dung là do các điều kiện sinh
hoạt vật chất của giai cấp các ông quyết định”. Đại từ nhân xưng “các ông” trong câu nói trên muốn chỉ ai?:
', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (13, N' Lịch sử xã hội loài người đã và đang trải qua mấy kiểu pháp luật:
', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (14, N' Đạo luật nào dưới đây quy định một cách cơ bản về chế độ chính trị, chế độ kinh tế, văn
hóa, xã hội và tổ chức bộ máy nhà nước. ', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (15, N'QPPL là cách xử sự do nhà nước quy định để:', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (16, N'Đặc điểm của các quy phạm xã hội (tập quán, tín điều tôn giáo) thời kỳ CXNT: ', 1, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (17, N'Mỗi một điều luật:', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (18, N'Khẳng định nào là đúng:
', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (19, N'Cơ quan nào có thẩm quyền hạn chế NLHV của công dân:', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (20, N'Trong một nhà nước:
', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (21, N' Chức năng nào không phải là chức năng của pháp luật:', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (22, N'Các thuộc tính của pháp luật là:', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (23, N'Các thuộc tính c ủa pháp luật là:', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (24, N'Việc tòa án thường đưa các vụ án đi xét xử lưu động thể hiện chủ yếu chức năng nào
của pháp luật: ', 1, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (25, N' Xét về độ tuổi, người có NLHV dân sự chưa đầy đủ, khi:', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (26, N'Khẳng định nào là đúng:
', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (27, N' Cơ quan thực hiện chức năng thực hành quyền công tố và kiểm sát các hoạt động tư
pháp:', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (28, N' Nguyên tắc chung của pháp luật trong nhà nước pháp quyền là:', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (29, N'Cơ quan nào có quyền xét xử tội phạm và tuyên bản án hình sự:', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (30, N'Hình thức ADPL nào cần phải có sự tham gia của nhà nước:', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (31, N'Hoạt động áp dụng tương tự quy phạm là: ', 2, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (32, N' Nguyên tắc pháp chế trong tổ chức và hoạt động của bộ máy nhà nước xuất hiện từ khi
nào:
', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (33, N'Theo quy định tại Khoản 1, Điều 271, Bộ luật hình sự Việt Nam 1999, nếu tội phạm có
khung hình phạt từ 15 năm trở xuống thì thuộc thẩm quyền xét xử của:
', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (34, N'Theo quy định tại Khoản 1, Điều 271, Bộ luật hình sự Việt Nam 1999, nếu tội phạm có
khung hình phạt từ 15 năm trở xuống thì thuộc thẩm quyền xét xử của:
', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (35, N' Điều kiện để làm phát sinh, thay đổi hay chấm dứt một QHPL:', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (36, N'Ủy ban Thường vụ Quốc hội có quyền ban hành những loại VBPL nào:', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (37, N'Trong HTPL Việt Nam, để được coi là một ngành luật độc lập khi:', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (38, N'UBND và chủ tịch UBND các cấp có quyền ban hành những loại VBPL nào:', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (39, N'Mục đích khai thác thuộc địa lần thứ hai của Pháp ở Việt Nam là gì?', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (40, N'Theo quy định của Hiến pháp 1992, người có quyền công bố Hiến pháp và luật là:', 2, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (41, N'Mục đích khai thác thuộc địa lần thứ hai của Pháp ở Việt Nam là gì?', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (42, N'Mục đích khai thác thuộc địa lần thứ hai của Pháp ở Việt Nam là gì?', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (43, N'Có thể thay đổi HTPL bằng cách:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (44, N' Hội đồng nhân dân các cấp có quyền ban hành loại VBPL nào:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (45, N'Trong cuộc khai thác thuộc địa lần thứ hai, thực dân Pháp đầu t vốn 
nhiều nhất vào các ngành nào?
', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (46, N'Đối với các hình thức (biện pháp) trách nhiệm dân sự: ', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (47, N' Khẳng định nào là đúng:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (48, N'Tuân thủ pháp luật là:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (49, N'Vì sao tư bản Pháp chú trọng đến việc khai thác mỏ than ở Việt Nam?', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (50, N'Hình thức trách nhiệm nghiêm khắc nhất theo quy định của pháp luật Việt Nam:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (51, N'Thi hành pháp luật là:', 3, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (52, N'Vì sao trong quá trình khai thác thuộc địa lần thứ hai, t bản Pháp hạn 
chế phát triển công nghiệp nặng ở Việt Nam?
', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (53, N'Bản án đã có hiệu lực pháp luật được viện kiểm sát, tòa án có thẩm quyền kháng nghị
theo thủ tục tái thẩm khi:
', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (54, N'Nguyên tắc “không áp dụng hiệu lực hồi tố” của VBPL được hiểu là:
', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (55, N'Thành tựu nào quan trọng nhất mà Liên Xô đạt đợc sau Chiến tranh 
thế giới thứ hai?
', 7, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (56, N'Trong các loại VBPL, văn bản chủ đạo:
', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (57, N'Trong các loại VBPL, văn bản chủ đạo:
', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (58, N'Đâu không phải là ngành luật trong HTPL Việt Nam:
', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (59, N' Đâu không phải là ngành luật trong HTPL Việt Nam:', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (60, N'Đâu không phải là ngành luật trong HTPL Việt Nam:', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (61, N'Chế định “Văn hóa, giáo dục, khoa học, công nghệ” thuộc ngành luật nào:', 3, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (62, N'Các giai cấp nào mới ra đời do hậu quả của cuộc khai thác thuộc địa 
lần thứ hai của Pháp ở Việt Nam?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (63, N'Chế định “Giao dịch dân sự” thuộc ngành luật nào:', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (64, N'Chế định “Khởi tố bị can và hỏi cung bị can” thuộc ngành luật nào: ', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (65, N'Chế định “Điều tra” thuộc ngành luật nào:', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (66, N' Chế định “Cơ quan tiến hành tố tụng, người tiến hành tố tụng và việc thay đổi người
tiến hành tố tụng” thuộc ngành luật nào: ', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (67, N'Chế định “Xét xử phúc thẩm” thuộc ngành luật nào: ', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (68, N'Các đặc điểm, thuộc tính của chế định pháp luật: ', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (69, N'Sau chiến tranh thế giới lần thứ nhất, ở Việt Nam ngoài thực dân 
Pháp, còn có giai cấp nào trở thành đối tượng của cách mạng Việt 
Nam?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (70, N' Sự thay đổi hệ thống QPPL có thể được thực hiện bằng cách:', 4, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (71, N'Quyết định ADPL:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (72, N'Dưới ách thống trị của thực dân Pháp, thái độ chính trị của giai cấp t 
sản dân tộc Việt Nam như thế nào?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (73, N' Nhà nước và pháp luật là hai hiện tượng xã hội thuộc:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (74, N'Văn bản nào có hiệu lực cao nhất trong trong số các loại văn bản sau của HTPL Việt
Nam:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (75, N'Lực lượng nào hăng hái và đông đảo nhất của cách mạng Việt Nam sau 
chiến tranh thế giới thứ nhất?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (76, N'Bộ máy quản lý hành chính của Nhà nước CHXHCN Việt Nam hiện nay có bao nhiêu
bộ:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (77, N'Bộ máy quản lý hành chính của Nhà nước CHXHCN Việt Nam hiện nay có bao nhiêu
bộ:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (78, N'Khẳng định nào là đúng:
', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (79, N'Quá trình xây dựng chủ nghĩa xã hội ở Liên Xô (từ 1950 đến nửa đầu 
những năm 70 của thế kỉ XX), số liệu nào sau đây có ý nghĩa nhất?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (80, N'Điều 57 Hiến pháp Việt Nam 1992 quy định: “Công dân Việt Nam có quyền kinh
doanh theo quy định của pháp luật”, nghĩa là:', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (81, N'Nhận định nào đúng: ', 4, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (82, N'Những tổ chức chính trị như: Việt Nam Nghĩa đoàn, Hội Phục Việt, 
Hội Hưng Nam, Đảng Thanh Niên là tiền thân của tổ chức nào?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (83, N'Các thuộc tính của pháp luật là:
', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (84, N'Khẳng định nào sau đây là đúng: ', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (85, N'Những tờ báo tiến bộ của tầng lớp tiểu tư sản trí thức xuất bản trong 
phong trào yêu nước dân chủ công khai (1919-1926) là:
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (86, N'Hiệu lực về không gian của VBQPPL Việt Nam được hiểu là:
', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (87, N'QPPL là cách xử sự do nhà nước quy định để: ', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (88, N'Tính xác định chặt chẽ về mặt hình thức là thuộc tính (đặc trưng) của:
', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (89, N'Trần Dân Tiên viết: “việc đó tuy nhỏ nhng nó báo hiệu bắt đầu thời 
đại đấu tranh dân tộc nh chim én nhỏ báo hiệu mùa xuân”. Sự kiện 
nào sau đây phản ánh điều đó?
', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (90, N'Đặc điểm của QPPL khác so với quy phạm xã hội thời kỳ CXNT.', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (91, N'Trong những nguyên nhân sau đây, nguyên nhân nào là nguyên nhân 
chủ quan làm cho phong trào yêu nớc dân chủ công khai (1919-1926) 
cuối cùng bị thất bại?
', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (92, N'Tòa án nào có quyền xét xử tội phạm và tuyên bản án hình sự:', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (93, N'Chính sách đối ngoại của Liên Xô từ 1945 đến nửa đầu những năm 70', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (94, N'Thỏa ước lao động tập thể là văn bản được ký kết giữa', 5, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (95, N'Chức năng của pháp luật: ', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (96, N'Chủ thể của QHPL là:
', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (97, N'Nhà thơ Chế Lan Viên viết: “Phút khóc đầu tiên là phút Bác Hồ cười”. ', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (98, N'Khẳng định nào đúng: ', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (99, N'TCXH nào sau đây không được Nhà nước trao quyền ban hành một số VBPL:
', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (100, N'Sự kiện nào đánh dấu giai cấp công nhân Việt Nam đi vào đấu tranh tự giác', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (101, N'NLHV là: ', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (102, N'Xét về độ tuổi, người có NLHV dân sự đầy đủ:
', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (103, N'Sự kiện nào thể hiện: “T tởng cách mạng tháng Mời Nga đã thấm sâu 
hơn vào giai cấp công nhân và bắt đầu biến thành hành động của giai 
cấp công nhân Việt Nam”.
', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (104, N'Chế tài của QPPL là:', 5, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (105, N' Loại nguồn được công nhận trong HTPL Việt Nam:', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (106, N'Sự kiện nào đánh dấu Nguyễn ái Quốc bớc đầu tìm thấy con đờng cứu 
nước đúng đắn
', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (107, N'Người bị mất NLHV dân sự là người do bị bệnh tâm thần hoặc mắc bệnh khác:
', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (108, N'Khẳng định nào là đúng:', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (109, N'Cách mạng dân chủ nhân dân ở các nước đông Âu đã làm gì để xóa bỏ sự bóc lột của địa chủ phong kiến đối với nông dân', 8, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (110, N'Hoạt động áp dụng tương tự pháp luật (hay tương tự luật) là:', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (111, N'Khẳng định nào là đúng:', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (112, N'Thủ tướng chính phủ có quyền ban hành những loại VBPL nào:
', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (113, N'Đứng truớc chủ nghĩa tư bản và chủ nghĩa đế quốc quyền lợi của chúng ta là thống nhất, các bạn hãy nhớ lời kêu gọi của Các Mác: “Vô sản tất cả các nước đoàn kết lại!”. Hãy cho biết đoạn văn trên của ai, viết trong tác phẩm nào?', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (114, N' Đâu là VBPL:', 6, 2, 1, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (115, N'Bộ trưởng có quyền ban hành những loại VBPL nào:', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (116, N'Vào thời gian nào, Nguyễn ái Quốc rời Pari đi Liên Xô, đất nước mà từ 
lâu Người mơ ước đặt chân tới
', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (117, N'Tuân thủ pháp luật là', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (118, N' Văn bản nào có hiệu lực cao nhất trong các văn bản sau của hệ thống VBQPPL Việt
Nam: ', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (119, N' Chủ thể có hành vi trái pháp luật, thì: ', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (120, N'Sự kiện ngày 17/6/1924 gắn với hoạt động nào của Nguyễn ái Quốc ở 
Liên Xô, đó là
', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (121, N'Để phân biệt ngành luật với các đạo luật, nhận định nào sau đây là đúng:', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (122, N'Đâu không phải là ngành luật trong HTPL Việt Nam', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (123, N'Tác dụng trong quá trình hoạt động của Nguyễn ái Quốc từ năm 1919 
đến 1925 là gì?
', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (124, N'Đâu không phải là ngành luật trong HTPL Việt Nam: ', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (125, N'Chế định “Hình phạt” thuộc ngành luật nào:
', 6, 2, 2, 11, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (126, N'Lý do chủ yếu nào chứng minh sự thắng lợi của cách mạng dân chủ 
nhân dân của các nước Đông Âu có ý nghĩa quốc tế:
', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (127, N'Hội Việt Nam cách mạng thanh niên đợc thành lập vào thời gian nào? ở đâu?', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (128, N'Ba tư tưởng sau đây được trình bày trong tác phẩm nào của Nguyễn ái  Quốc Cách mạng là sự nghiệp của quần chúng; cách mạng phải do Đảng theo chủ nghĩa Mác – Lênin lãnh đạo; cách mạng Việt Nam phải gắn bó và đoàn kết với cách mạng thế 
giới
', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (129, N'Hãy nêu rõ thành phần và địa bàn hoạt động của Tân Việt cách mạng đảng?', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (130, N'Tân Việt cách mạng đảng đã phân hóa nh thế nào dới tác động của Hội Việt Nam cách mạng thanh niên?', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (131, N'Lãnh thổ nước ta trải dài:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (132, N'Nội thuỷ là:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (133, N'Đây là cửa khẩu nằm trên biên giới Lào - Việt.', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (134, N'Đường cơ sở của nước ta được xác định là đường:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (135, N'Đi từ bắc vào nam theo biên giới Việt - Lào, ta đi qua lần lượt các cửa khẩu:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (136, N'Sau khi đã hoàn thành cách mạng dân chủ nhân dân, các nước Đông Âu đã:', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (137, N'Nước ta có nguồn tài nguyên sinh vật phong phú nhờ:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (138, N'Đây là cảng biển mở lối ra biển thuận lợi cho vùng Đông Bắc Cam - pu - chia.', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (139, N'Thiên nhiên nước ta bốn mùa xanh tươi khác hẳn với các nước có cùng độ vĩ ở Tây Á, châu Phi là nhờ:', 12, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (140, N'Mục tiêu của Việt Nam quốc dân đảng là gì?', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (141, N'Quần đảo Trường Sa thuộc:', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (142, N'Loại gió có tác động thường xuyên đến toàn bộ lãnh thổ nước ta là:', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (143, N'Vị trí địa lí nước ta tạo điều kiện thuận lợi cho việc:', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (144, N'Đối với vùng đặc quyền kinh tế, Việt Nam có nghĩa vụ và quyền lợi nào dưới đây?', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (145, N'Đối với vùng đặc quyền kinh tế, Việt Nam cho phép các nước:', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (146, N'Xét về góc độ kinh tế, vị trí địa lí của nước ta', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (147, N'Đặc điểm của thiên nhiên nhiệt đới - ẩm - gió mùa của nước ta là do:', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (148, N'Cuộc khởi nghĩa của Việt Nam quốc dân đảng nổ ra đêm 9/2/1930 ở ', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (149, N'Cuộc khởi nghĩa của Việt Nam quốc dân đảng nổ ra đêm 9/2/1930 ở ', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (150, N'Cuộc khởi nghĩa của Việt Nam quốc dân đảng nổ ra đêm 9/2/1930 ở ', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (151, N'Cuộc khởi nghĩa của Việt Nam quốc dân đảng nổ ra đêm 9/2/1930 ở ', 9, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (152, N'Ở nước ta, loại tài nguyên có triển vọng khai thác lớn nhưng chưa được chú ý đúng mức:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (153, N'Quá trình phân hóa của Hội Việt Nam cách mạng thanh niên đã dẫn 
đến sự thành lập các tổ chức cộng sản nào trong năm 1929?
', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (154, N'Ở nước ta, khai thác tổng hợp giá trị kinh tế của mạng lưới sông ngòi dày đặc cùng với lượng nước phong phú là thế mạnh của:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (155, N'Biển Đông là vùng biển lớn nằm ở phía:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (156, N'Vấn đề chủ quyền biên giới quốc gia trên đất liền, Việt Nam cần tiếp tục đàm phán với:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (157, N'Báo “Búa liềm” là cơ quan ngôn luận của tổ chức cộng sản nào đợc 
thành lập năm 1929 ở Việt Nam?
', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (158, N'Thế mạnh của vị trí địa lí nước ta trong khu vực Đông Nam Á sẽ được phát huy cao độ nếu biết kết hợp xây dựng các loại hình giao thông vận tải:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (159, N'Nước nào ở Đông Âu được mệnh danh là “Đất nước của triệu ngời khất 
thực” trong những năm đầu sau Chiến tranh thế giới thứ 2
', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (160, N'Đây là đặc điểm của giai đoạn Tân kiến tạo:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (161, N'Tổ chức Việt Nam quốc dân đảng chịu ảnh hưởng sâu sắc của hệ tư tưởng nào?', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (162, N'Các mỏ than ở Quảng Ninh, Quảng Nam được hình thành trong:', 11, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (163, N'Đây là điểm giống nhau về lịch sử hình thành của khối thượng nguồn sông Chảy và khối núi cao Nam Trung Bộ.', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (164, N'Những người đúng ra thành lập Việt Nam quốc dân đảng là ai', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (165, N' Đây là chứng cứ cho thấy lãnh thổ nước ta được hình thành trong giai đoạn tiền Cambri:', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (166, N'Đồng bằng sông Hồng và Đồng bằng sông Cửu Long được hình thành trong giai đoạn:', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (167, N'Đảng Cộng sản Việt Nam ra đời là sự kết hợp các yếu tố nào?', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (168, N' "Địa hình được nâng cao, sông ngòi trẻ lại", đó là đặc điểm của:', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (169, N'Tại Hội nghị hợp nhất ba tổ chức cộng sản, không có sự tham gia của 
các tổ chức cộng sản nào?
', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (170, N'Đây là biểu hiện cho thấy giai đoạn Tân kiến tạo vẫn còn đang tiếp diễn.', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (171, N'Chỗ dựa chủ yếu của công cuộc xây dựng chủ nghĩa xã hội ở các nước 
Đông âu
', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (172, N'Con đờng cách mạng Việt Nam đợc xác định trong Cơng lĩnh chính 
trị đầu tiên do đồng chí Nguyễn ái Quốc khởi thảo, đó là: 
', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (173, N'Đây là các khối núi được hình thành trong đại Cổ sinh của giai đoạn Cổ kiến tạo.', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (174, N'Phần lớn lãnh thổ nước ta được hình thành trong:', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (175, N'Lực lượng cách mạng để đánh đổ đế quốc và phong kiến được nêu trong 
Cương lĩnh chính trị đầu tiên của Đảng do đồng chí Nguyễn ái Quốc khởi thảo là lực lượng nào?
', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (176, N'Đây là các kì tạo núi thuộc đại Cổ sinh:', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (177, N'Điểm giống nhau giữa Cơng lĩnh chính trị đầu tiên của Đảng do đồng 
chí Nguyễn ái Quốc khởi thảo và Luận cơng chính trị do đồng chí Trần Phú soạn thảo.
', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (178, N'Sách giáo khoa lịch sử lớp 12, trang 25, có viết: “Nhiệm vụ của cách 
mạng tư sản dân quyền ở nước ta là đánh đổ bọn đế quốc Pháp; bọn 
phong kiến và giai cấp tư sản phản cách mạng, làm cho nước Việt Nam 
được độc lập ...”. Đây là một trong những nội dung của văn kiện nào?
', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (179, N'Nguyên nhân chính của sự ra đời liên minh phong thủ Vác-sa-va (14-
5-1955)
', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (180, N'Trong các nội dung sau đây, nội dung nào không thuộc luận cương chính trị tháng 10/1930', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (181, N'Trong các nguyên nhân sau nguyên nhân nào là cơ bản nhất, quyết định sự bùng nổ phong trào cách mạng 1930- 1931', 10, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (182, N'Hai khẩu hiệu mà Đảng ta đã vận dụng trong phong trào cách mạng 
1930-1931 là khẩu hiệu nào?
', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (183, N'Các số liệu sau đây, số liệu nào đúng nhất', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (184, N'Tổ chức Hiệp ước phòng thủ Vác-sa-va mang tính chất', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (185, N'Các sự kiện sau đây, sự kiện nào đúng?', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (186, N'Chính quyền Xô viết - Nghệ Tĩnh đã tỏ rõ bản chất cách mạng của mình. Đó là chính quyền của dân, do dân và vì dân. Tính chất đó được Biểu hiện ở những điểm cơ bản nào?', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (187, N'Qua thực tế lãnh đạo phong trào cách mạng 1930-1931, Đảng ta đã trưởng thành nhanh chóng. Do đó, tháng 4/1931 Đảng ta được quốc tế cộng sản công nhận:', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (188, N'Hệ thống Đảng trong nước nói chung đã được khôi phục vào thời gian nào?', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (189, N'Đâu là mặt hạn chế trong hoạt động của Hội đồng tương trợ kinh tế (SEV)', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (190, N'Khái niệm và ý nghĩa quyền tự do ngôn luận:', 1, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (191, N'Quy trình tố cáo và giải quyết tố cáo của công dân:', 1, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (192, N'Chỉ ra và phân tích ngắn gọn ý nghĩa của trường hợp không tuân thủ phương châm hội thoại trong đoạn văn bản sau:
Vẫn vững lòng, bà dặn cháu đinh ninh: 
“Bố ở chiến khu, bố còn việc bố
Mày có viết thư chớ kể này kể nọ, 
Cứ bảo nhà vẫn được bình yên!”
(Bằng Việt, Bếp lửa, SGK Ngữ văn 9, tập 1,
NXB Giáo dục, 2011, tr 144)', 1, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (193, N'Nội dung pháp luật về dân số thể hiện như thế nào?', 1, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (194, N'Em hiểu như thế nào là nguyên tắc hoạt động của quốc phòng, an ninh ở nước ta?', 2, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (195, N'Tìm và phân tích tác dụng của phép tu từ được sử dụng trong câu thơ sau:

Gác kinh viện sách đôi nơi
Trong gang tấc bỗng cách mười quan san.

(Nguyễn Du, Truyện Kiều, SGK Ngữ văn 9, tập 1,
NXB Giáo dục, 2011, tr 147)', 1, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (196, N'“Một trong những sứ mệnh của người nghệ sĩ là phát hiện cho được cái âm thanh kì diệu của cuộc sống vốn rất đỗi bình thường”.
Ý kiến trên giúp gì cho anh/chị khi lắng nghe những vang âm từ “Lặng lẽ Sa Pa” của Nguyễn Thành Long (SGK Ngữ văn 9, tập 1, NXB Giáo dục, 2011), từ đó rút ra thiên chức của người nghệ sĩ trong sáng tác văn chương.', 1, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (197, N'Nêu ưu điểm và nhược điểm của sinh sản vô tính', 2, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (198, N'Khi ghép cành tại sao phải cắt bỏ hết lá ở cành ghép và phải buộc chặt cành ghép (hoặc mắt ghép) vào gốc ghép', 2, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (199, N'Nêu những ưu điểm điểm của cành chiết và cành giâm so với cây trồng mọc từ hạt. ', 2, 2, 1, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (200, N'Nêu vai trò của sinh sản vô tính đối với chu trình sống của thực vật và vai trò của hình thức sinh sản sinh dưỡng đối với ngành nông nghiệp', 3, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (201, N'Sinh sản hữu tính là gì?', 3, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (202, N'thực vật có hoa sinh sản hữu tính diễn ra như thế nào? ', 3, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (203, N'Nêu những đặc trưng của sinh sản hữu tính?', 4, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (204, N'Tại sao nói sinh sản hữu tính làm tăng khả năng thích nghi và giúp cho quần thể tồn tại được trong môi trường biến động?', 4, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (205, N'Trình bày quá trình hình thành hạt', 4, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (206, N'Trình bày quá trình hình thành quả?', 5, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (207, N'Trình bày vai trò của ngành giun đốt ?', 5, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (208, N'Hãy cho biết đặc điểm chung của ngành giun tròn ?', 5, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (209, N'Trình bày tập tính của một số đại diện ngành thân mềm', 6, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (210, N'Trình bày đặc điểm cấu tạo của trùng giày phức tạp hơn trùng biến hình ?', 6, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (211, N'Hãy cho biết đặc điểm cấu tạo sán lá gan thích nghi với đời sống kí sinh ?', 6, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (212, N'Hãy nêu 1 số vai trò của sâu bọ và biện pháp chống sâu bọ có hại nhưng an toàn cho môi trường ?', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (213, N'Em hãy cho biết vai trò của lớp giáp xác ?', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (214, N'Sự khác nhau giữa san hô và thủy tức trong sinh sản vô tính mọc chồi ?', 7, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (215, N'Nêu dặc điểm chung của ngành giun dẹp ?', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (216, N'Nêu vai trò thực tiễn của lớp giác xác ?', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (217, N'Trình bày dặc điểm chung của ngành động vật nguyên sinh', 8, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (218, N'Tác hại của giun đũa đối với sức khỏe con người', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (219, N'Các biện pháp phòng chống bệnh giun sán', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (220, N'Ý nghĩa của vỏ kitin giàu canxi và sắc tố của tôm', 9, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (221, N'Hãy kể tên một số động vật nguyên sinh có lợi trong ao nuôi cá.', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (222, N'Thủy tức thải chất bã ra ngoài cơ thể bằng con đường nào ?', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (223, N'Vai trò thực tiễn của giun đốt gặp ở địa phương em ?', 10, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (224, N'Cách dinh dưỡng của trai có ý nghĩa như thế nào đối với môi trường nước ?', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (225, N'Nêu cấu tạo lớp ngoài thành cơ thể thủy tức ?', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (226, N'Hãy nêu đặc điểm chung của ngành giun đốt?', 11, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (227, N'Nêu tập tính của ốc sên và mực ?', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (228, N'Cho lăng trụ tam giác ABC.A''B''C'' cạnh đáy a=4, biết diện tích tam giác A''BC bằng 8. Thể tích khối lăng trụ ABC.A''B''C'' bằng bao nhiêu', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (229, N'Tại sao một số vi sinh vật sống được ở trong suối nước nóng có nhiệt độ xấp xỉ 1000 độ C mà prôtêin của chúng lại không bị hỏng?', 2, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (230, N'Tại sao khi ta đun nóng nước lọc cua thì prôtêin của cua lại đóng thành từng mảng?', 2, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (231, N'Cho hình chóp đều S.ABCD có cạnh đáy bằng a, góc giữa mặt bên và mặt đáy bằng 45 độ. Gọi M, N, P lần lượt là trung điểm của SA, SB, SC. Tính thể tích của khối  tứ diện AMNP.', 12, 2, 2, 12, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (232, N'Tại sao chúng ta lại cần ăn prôtêin từ các nguồn thực phẩm khác nhau?', 3, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (233, N' Nêu chức năng của prôtêin?', 3, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (234, N' Nêu điểm khác nhau chính trong các bậc cấu trúc của prôtêin?', 3, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (235, N'Kể tên các loại liên kết hóa học tham gia duy trì cấu trúc prôtêin?', 4, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (236, N'Nêu một vài loại prôtêin trong tế bào người và cho biết các chức năng của chúng?', 4, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (237, N'Tơ nhện, tơ tằm, sừng trâu, tóc, thịt gà và thịt lợn đều được cấu tạo từ prôtêin nhưng chúng khác nhau về nhiều đặc tính, em hãy cho biết sự khác nhau đó là do đâu?', 4, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (238, N'Tơ nhện, tơ tằm, sừng trâu, tóc, thịt gà và thịt lợn đều được cấu tạo từ prôtêin nhưng chúng khác nhau về nhiều đặc tính, em hãy cho biết sự khác nhau đó là do đâu?', 4, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (239, N'Hãy nêu đặc điểm 4 pha sinh trưởng của quần thể vi khuẩn trong nuôi cấy không liên tục. Tại sao nói: “Dạ dày, ruột ở người là hệ thống nuôi cấy liên tục đối với VSV”?', 5, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (240, N'Dựa vào hình thái virut có thể phân thành những dạng nào và cho ví dụ? Có thể nuôi cấy virut trong môi trường nhân tạo như vi khuẩn được không?', 5, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (241, N'Chu trình nhân lên của virut trong tế bào chủ', 5, 2, 1, 14, 0)
GO
INSERT [dbo].[CAU_HOI] ([MACH], [NOIDUNG], [MACHUONG], [MAMON], [MADOKHO], [MAGV], [TRANGTHAI]) VALUES (242, N'Nhận thức và thái độ để phòng tránh lây nhiễm HIV ', 6, 2, 1, 14, 0)
GO
SET IDENTITY_INSERT [dbo].[CAU_HOI] OFF
GO
SET IDENTITY_INSERT [dbo].[CAU_TRUC_DE_THI] ON 

GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (1, 1, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (2, 2, CAST(N'2017-06-18 18:28:43.120' AS DateTime), 11, 1, 1)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (3, 3, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (4, 4, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (5, 6, CAST(N'2017-06-18 18:28:43.120' AS DateTime), 2, 0, 0)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (6, 7, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (7, 8, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (8, 9, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (9, 10, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (10, 11, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (11, 12, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (12, 13, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (13, 14, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (14, 15, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (15, 16, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (16, 17, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (17, 18, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (18, 19, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (19, 20, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (20, 21, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (21, 22, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (22, 23, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (23, 24, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (24, 25, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (25, 26, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (26, 27, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (27, 28, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (28, 29, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (29, 30, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (30, 31, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (31, 32, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (32, 33, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (33, 34, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (34, 35, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (35, 36, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (36, 37, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (37, 38, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (38, 39, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (39, 40, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (40, 41, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (41, 42, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (42, 43, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (43, 44, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (44, 45, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (45, 46, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (46, 47, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (47, 48, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (48, 49, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (49, 50, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (50, 51, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (51, 52, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (52, 53, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (53, 54, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (54, 55, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (55, 56, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (56, 57, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (57, 58, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (58, 59, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (59, 60, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (60, 61, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (61, 62, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (62, 63, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (63, 64, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (64, 65, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (65, 66, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (66, 67, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (67, 68, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (68, 69, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (69, 70, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (70, 71, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (71, 72, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (72, 73, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (73, 74, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (74, 75, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (75, 76, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (76, 77, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (77, 78, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (78, 79, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (79, 80, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (80, 81, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (81, 82, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (82, 83, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (83, 84, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (84, 85, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
INSERT [dbo].[CAU_TRUC_DE_THI] ([MACTDT], [MAMON], [NGAYCAPNHAT], [MAGV], [TRANGTHAI], [SLDETOIDA]) VALUES (85, 1270, CAST(N'2017-06-18 18:28:43.120' AS DateTime), NULL, 1, 20)
GO
SET IDENTITY_INSERT [dbo].[CAU_TRUC_DE_THI] OFF
GO
SET IDENTITY_INSERT [dbo].[chat] ON 

GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (5, N'2', N'7', 0, N'7')
GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (6, N'2', N'2', 0, N'2')
GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (7, N'2', N'11', 0, N'2')
GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (8, N'2', N'1', 0, N'2')
GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (9, N'2', N'12', 6, N'2')
GO
INSERT [dbo].[chat] ([chat_id], [code], [room_id], [COUNT_MSG], [LAST_USER]) VALUES (10, N'2', N'14', 1, N'14')
GO
SET IDENTITY_INSERT [dbo].[chat] OFF
GO
SET IDENTITY_INSERT [dbo].[chatdetails] ON 

GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (23, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 18:58:34.020' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (24, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 18:59:51.283' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (25, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:00:54.197' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (26, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:01:32.390' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (27, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:02:28.870' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (28, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:02:49.360' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (29, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:03:12.097' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (30, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:03:19.483' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (31, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:03:29.530' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (32, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:03:48.487' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (33, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:04:04.047' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (34, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:04:21.447' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (35, N'Công việc được duyệt  <a href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 19:04:34.043' AS DateTime), 5, N'', N'7')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (36, N'Công việc mới, tạo đề cương<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-08 19:17:12.283' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (37, N'Công việc mới, tạo đề cương<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-08 19:49:20.200' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (38, N'Tôi đã tạo đề cương hoàn thành!<a href=''/chuongmuc/xem-de-cuong/2''>Xem chi tiết</a> ', CAST(N'2017-06-08 19:52:49.710' AS DateTime), 7, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (39, N'tạo cấu trúc đề thi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-08 19:57:14.667' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (40, N'Tôi đã tạo cấu trúc đề thi hoàn thành!<a href=''/xem-cau-truc-de-thi/2''>Xem chi tiết</a> ', CAST(N'2017-06-08 20:01:28.850' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (41, N'Công việc đã duyệt và chưa hoàn thành <a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-08 20:01:58.137' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (42, N'Tôi đã tạo cấu trúc đề thi hoàn thành!<a href=''/xem-cau-truc-de-thi/2''>Xem chi tiết</a> ', CAST(N'2017-06-08 20:02:14.273' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (43, N'Công việc mới, tạo câu hỏi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-08 20:04:36.790' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (44, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-08 20:14:16.283' AS DateTime), 7, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (45, N'Công việc chưa đươc duyệt  <a style=''color :red ;''  href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 20:16:13.257' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (46, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-08 20:16:58.257' AS DateTime), 7, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (47, N'Công việc được duyệt  <a href=''/congviec/congviecduocphancong''> Xem lại </a>', CAST(N'2017-06-08 20:17:48.420' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (48, N'Công việc mới, tạo đề cương<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-15 08:51:03.880' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (49, N'Công việc đã duyệt và chưa hoàn thành <a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-15 08:53:11.760' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (50, N'Tôi đã tạo cấu trúc đề thi hoàn thành!<a href=''/xem-cau-truc-de-thi/2''>Xem chi tiết</a> ', CAST(N'2017-06-15 08:54:02.557' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (51, N'Công việc đã duyệt và chưa hoàn thành <a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-15 09:02:08.070' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (52, N'Tôi đã tạo cấu trúc đề thi hoàn thành!<a href=''/xem-cau-truc-de-thi/2''>Xem chi tiết</a> ', CAST(N'2017-06-15 09:25:57.967' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (53, N'tạo cấu trúc đề thi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-15 09:38:30.877' AS DateTime), 6, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (54, N'Công việc mới, tạo đề cương<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-15 09:39:20.600' AS DateTime), 8, N'', N'1')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (55, N'Tôi đã tạo đề cương hoàn thành!<a href=''/chuongmuc/xem-de-cuong/8''>Xem chi tiết</a> ', CAST(N'2017-06-15 09:40:05.960' AS DateTime), 8, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (56, N'Công việc mới, tạo câu hỏi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 12:53:46.907' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (57, N'Công việc mới, tạo câu hỏi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 12:54:21.077' AS DateTime), 9, N'', N'12')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (58, N':((', CAST(N'2017-06-18 13:13:35.773' AS DateTime), 9, N'http://localhost:8080/taocauhoi#', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (59, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 13:50:46.630' AS DateTime), 7, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (60, N'Công việc mới, tạo câu hỏi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 14:20:55.033' AS DateTime), 10, N'', N'14')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (61, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 14:28:40.083' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (62, N'Công việc mới, tạo câu hỏi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 14:36:50.070' AS DateTime), 9, N'', N'12')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (63, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 15:20:30.213' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (64, N'xong rồi', CAST(N'2017-06-18 15:23:33.403' AS DateTime), 9, N'http://localhost:8080/taocauhoi#', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (65, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:27.527' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (66, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:29.603' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (67, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:29.760' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (68, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:30.040' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (69, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:30.213' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (70, N'Hoàn Thành Tạo câu hỏi ', CAST(N'2017-06-18 18:30:30.383' AS DateTime), 9, N'', N'2')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (71, N'tạo cấu trúc đề thi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 18:31:32.917' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (72, N'tạo cấu trúc đề thi<a href=''/congviec/congviecduocphancong''>Thực hiện ngay</a>', CAST(N'2017-06-18 18:49:58.720' AS DateTime), 7, N'', N'11')
GO
INSERT [dbo].[chatdetails] ([details_chat_id], [body], [time_on], [chat_id], [url], [client_id]) VALUES (73, N'Tôi đã tạo cấu trúc đề thi hoàn thành!<a href=''/xem-cau-truc-de-thi/2''>Xem chi tiết</a> ', CAST(N'2017-06-18 18:55:53.257' AS DateTime), 7, N'', N'2')
GO
SET IDENTITY_INSERT [dbo].[chatdetails] OFF
GO
INSERT [dbo].[CHI_TIET_CTDT] ([MACTDT], [MACHUONG], [MADOKHO], [SLCAUHOI], [TONGDIEM]) VALUES (2, 1, 2, 5, 2.5)
GO
INSERT [dbo].[CHI_TIET_CTDT] ([MACTDT], [MACHUONG], [MADOKHO], [SLCAUHOI], [TONGDIEM]) VALUES (2, 2, 1, 10, 5)
GO
INSERT [dbo].[CHI_TIET_CTDT] ([MACTDT], [MACHUONG], [MADOKHO], [SLCAUHOI], [TONGDIEM]) VALUES (2, 10, 2, 10, 3)
GO
INSERT [dbo].[CHI_TIET_CTDT] ([MACTDT], [MACHUONG], [MADOKHO], [SLCAUHOI], [TONGDIEM]) VALUES (2, 12, 2, 7, 2.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 18, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 19, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 21, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 23, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 25, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 26, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 27, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 28, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 29, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 30, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 31, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 143, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 144, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 145, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 146, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 147, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 182, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 183, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 184, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 185, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 186, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 188, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 189, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 196, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 199, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 221, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 222, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 223, NULL, 0.3)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 228, NULL, 0.36)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 229, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 230, NULL, 0.5)
GO
INSERT [dbo].[CHI_TIET_DE_THI] ([MADETHI], [MACH], [VITRIDAPANDUNG], [DIEM]) VALUES (4, 231, NULL, 0.36)
GO
SET IDENTITY_INSERT [dbo].[CHUONG_MUC] ON 

GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (1, N'Chapter 1', N'INFORMATION SYSTEMS IN BUSINESS TODAY', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (2, N'Chapter 2', N'GLOBAL E-BUSINESS AND COLLABORATION', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (3, N'Chapter 3', N'INFORMATION SYSTEMS, ORGANIZATIONS, AND STRATEGY ', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (4, N'Chapter 4', N'ETHICAL AND SOCIAL ISSUES IN INFORMATION SYSTEMS', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (5, N'Chapter 5', N'IT INFRASTRUCTURE AND EMERGING TECHNOLOGIES', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (6, N'Chapter 6', N'FOUNDATIONS OF BUSINESS INTELLIGENCE DATABASES AND INFORMATION MANAGEMENT', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (7, N'Chapter 7', N'TELECOMMUNICATIONS, THE INTERNET, AND WIRELESS TECHNOLOGY', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (8, N'Chapter 8', N'SECURING INFORMATION SYSTEMS', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (9, N'Chapter 9', N'ACHIEVING OPERATIONAL EXCELLENCE AND CUSTOMER INTIMACY: ENTERPRISE APPLICATIONS ', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (10, N'Chapter 10', N'E-COMMERCE: DIGITAL MARKETS, DIGITAL GOODS', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (11, N'Chapter 11', N'MANAGING KNOWLEDGE', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (12, N'Chapter 12', N'ENHANCING DECISION MAKING', 2)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (33, N' Chương 0 04A75E1E', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (34, N' Chương 1 82AE5467', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (35, N' Chương 2 B2F0C2C2', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (36, N' Chương 3 8CACDCBC', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (37, N' Chương 4 9A372AD9', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (38, N' Chương 5 E6E4CD8E', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (39, N' Chương 6 EA259CB6', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (40, N' Chương 7 AB8B8747', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (41, N' Chương 8 1D291292', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (42, N' Chương 9 1B1DD4BA', N'Mô tả M?ng máy tính nâng cao', 3)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (43, N' Chương 0 9771BA3B', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (44, N' Chương 1 8782DE95', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (45, N' Chương 2 EB319C1D', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (46, N' Chương 3 FC8AEA39', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (47, N' Chương 4 4EFEA699', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (48, N' Chương 5 7472890A', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (49, N' Chương 6 D40AEAEE', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (50, N' Chương 7 5BBF5D4E', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (51, N' Chương 8 EB0A2AC3', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (52, N' Chương 9 FB99C0BA', N'Mô tả C?u trúc máy tính', 4)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (53, N' Chương 0 D037CC9A', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (54, N' Chương 1 F52267A5', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (55, N' Chương 2 187B7CB1', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (56, N' Chương 3 2B729237', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (57, N' Chương 4 189FE62C', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (58, N' Chương 5 4CE32A11', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (59, N' Chương 6 1296D769', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (60, N' Chương 7 D851D0C2', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (61, N' Chương 8 D4C15312', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (62, N' Chương 9 C1BC899A', N'Mô tả  Môn h?c 974536F2H? th?ng thông tin', 6)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (63, N' Chương 0 7B179F44', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (64, N' Chương 1 B5A173D9', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (65, N' Chương 2 008D44BF', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (66, N' Chương 3 51631903', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (67, N' Chương 4 6C593EAD', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (68, N' Chương 5 EE3CF68E', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (69, N' Chương 6 E56561C4', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (70, N' Chương 7 8D189126', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (71, N' Chương 8 474261A7', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (72, N' Chương 9 C7BFAFEC', N'Mô tả  Môn h?c B4244C2EH? th?ng thông tin', 7)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (73, N' Chương 0 2596F4FC', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (74, N' Chương 1 D53A83E2', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (75, N' Chương 2 0FA612E9', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (76, N' Chương 3 CD665841', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (77, N' Chương 4 E9DAA089', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (78, N' Chương 5 6DEDF9D7', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (79, N' Chương 6 4D7A4E9C', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (80, N' Chương 7 CB04CC41', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (81, N' Chương 8 C6022FDE', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (82, N' Chương 9 EF1D7343', N'Mô tả  Môn h?c C18CD169H? th?ng thông tin', 8)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (83, N' Chương 0 AD29E609', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (84, N' Chương 1 D9CB1F6B', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (85, N' Chương 2 1879B4FE', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (86, N' Chương 3 B304DD18', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (87, N' Chương 4 8DB384A1', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (88, N' Chương 5 7527CC9A', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (89, N' Chương 6 6BA77E7D', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (90, N' Chương 7 21FEA628', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (91, N' Chương 8 E50BDB08', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (92, N' Chương 9 844506AD', N'Mô tả  Môn h?c 37247BB2H? th?ng thông tin', 9)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (93, N' Chương 0 A662EB51', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (94, N' Chương 1 9E8B7250', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (95, N' Chương 2 B86737C9', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (96, N' Chương 3 D2FE92E2', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (97, N' Chương 4 A6D25DAD', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (98, N' Chương 5 A6C40D49', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (99, N' Chương 6 4B77E7CB', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (100, N' Chương 7 D2941BE2', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (101, N' Chương 8 3890326D', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (102, N' Chương 9 6055E638', N'Mô tả  Môn h?c A5730BBEH? th?ng thông tin', 10)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (103, N' Chương 0 8BFBAE14', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (104, N' Chương 1 A217F2E6', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (105, N' Chương 2 19E9AD15', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (106, N' Chương 3 B9AAC987', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (107, N' Chương 4 E3B464EC', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (108, N' Chương 5 3936D86E', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (109, N' Chương 6 57E83999', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (110, N' Chương 7 866605EF', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (111, N' Chương 8 227BE19D', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (112, N' Chương 9 A49D76B2', N'Mô tả  Môn h?c C1D0AC04H? th?ng thông tin', 11)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (113, N' Chương 0 772EE694', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (114, N' Chương 1 62383AC9', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (115, N' Chương 2 CEFBFE7F', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (116, N' Chương 3 DB10588D', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (117, N' Chương 4 91736E2C', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (118, N' Chương 5 40E480E2', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (119, N' Chương 6 2E29C744', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (120, N' Chương 7 7FED045C', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (121, N' Chương 8 8710B581', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (122, N' Chương 9 469A381B', N'Mô tả  Môn h?c 92325FF9H? th?ng thông tin', 12)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (123, N' Chương 0 D4BBD19B', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (124, N' Chương 1 F3B90C53', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (125, N' Chương 2 D835E3FC', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (126, N' Chương 3 ED514704', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (127, N' Chương 4 83E7D1AF', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (128, N' Chương 5 4B0BCE30', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (129, N' Chương 6 0CCB0872', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (130, N' Chương 7 C2CBE240', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (131, N' Chương 8 F948E647', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (132, N' Chương 9 3E6BDF73', N'Mô tả  Môn h?c F56FA9A9H? th?ng thông tin', 13)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (133, N' Chương 0 5D809D78', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (134, N' Chương 1 3932AD22', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (135, N' Chương 2 EE338C61', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (136, N' Chương 3 3670A868', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (137, N' Chương 4 02F75E46', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (138, N' Chương 5 8C8B7598', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (139, N' Chương 6 81D530A1', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (140, N' Chương 7 48020883', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (141, N' Chương 8 4954B469', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (142, N' Chương 9 3ADFD971', N'Mô tả  Môn h?c F1865846H? th?ng thông tin', 14)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (143, N' Chương 0 0CB3BED7', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (144, N' Chương 1 857C5739', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (145, N' Chương 2 FC1D7C1B', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (146, N' Chương 3 C35336B8', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (147, N' Chương 4 372966B6', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (148, N' Chương 5 F6B217C6', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (149, N' Chương 6 05129785', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (150, N' Chương 7 AA8D4022', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (151, N' Chương 8 EFB42267', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (152, N' Chương 9 8E464D83', N'Mô tả  Môn h?c 200CB7B9H? th?ng thông tin', 15)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (153, N' Chương 0 352DA04D', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (154, N' Chương 1 E4B216C1', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (155, N' Chương 2 037F47E8', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (156, N' Chương 3 C7ED3983', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (157, N' Chương 4 1C5B12BC', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (158, N' Chương 5 19273C1C', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (159, N' Chương 6 11294BFD', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (160, N' Chương 7 140B9404', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (161, N' Chương 8 A7B24D8C', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (162, N' Chương 9 E5D9EF9B', N'Mô tả  Môn h?c 36E0B5B1H? th?ng thông tin', 16)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (163, N' Chương 0 B5C4124E', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (164, N' Chương 1 DCACC9D4', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (165, N' Chương 2 A1DD29FF', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (166, N' Chương 3 27152085', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (167, N' Chương 4 9D4E064F', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (168, N' Chương 5 E9FC4020', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (169, N' Chương 6 550339AE', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (170, N' Chương 7 850D67DA', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (171, N' Chương 8 43823A26', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (172, N' Chương 9 5B1F9AEC', N'Mô tả  Môn h?c 736943E1H? th?ng thông tin', 17)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (173, N' Chương 0 1058A17E', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (174, N' Chương 1 C9E45392', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (175, N' Chương 2 488E3345', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (176, N' Chương 3 FD520720', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (177, N' Chương 4 063CAFE7', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (178, N' Chương 5 6C6BE7CC', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (179, N' Chương 6 1741AB40', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (180, N' Chương 7 DEDAF6FC', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (181, N' Chương 8 23B021CA', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (182, N' Chương 9 D1151167', N'Mô tả  Môn h?c FE4B5B3BH? th?ng thông tin', 18)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (183, N' Chương 0 C811BA2D', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (184, N' Chương 1 30554947', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (185, N' Chương 2 ED4332F2', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (186, N' Chương 3 133654E2', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (187, N' Chương 4 5E50E2F9', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (188, N' Chương 5 31C872D6', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (189, N' Chương 6 9504CC26', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (190, N' Chương 7 B59CA6A9', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (191, N' Chương 8 790B1BEC', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (192, N' Chương 9 74FB1604', N'Mô tả  Môn h?c 0D7880CEH? th?ng thông tin', 19)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (193, N' Chương 0 88AC30F4', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (194, N' Chương 1 C1042623', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (195, N' Chương 2 39F5ADDC', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (196, N' Chương 3 3F97C332', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (197, N' Chương 4 E180B143', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (198, N' Chương 5 EE68D061', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (199, N' Chương 6 58957B53', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (200, N' Chương 7 238BB43C', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (201, N' Chương 8 9E1AAAA3', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (202, N' Chương 9 1B12235A', N'Mô tả  Môn h?c 9EA5F595H? th?ng thông tin', 20)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (203, N' Chương 0 927CE5AA', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (204, N' Chương 1 7E379A10', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (205, N' Chương 2 AC09E309', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (206, N' Chương 3 B20E4307', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (207, N' Chương 4 8EC1F865', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (208, N' Chương 5 93BC6E5E', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (209, N' Chương 6 A1881750', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (210, N' Chương 7 0505E2D4', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (211, N' Chương 8 49CF4764', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (212, N' Chương 9 7F0EE96A', N'Mô tả  Môn h?c 920FCA72H? th?ng thông tin', 21)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (213, N' Chương 0 1C22FBC3', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (214, N' Chương 1 99E761A9', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (215, N' Chương 2 0005D319', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (216, N' Chương 3 D490C1D8', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (217, N' Chương 4 E0F6DA2D', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (218, N' Chương 5 859B83CD', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (219, N' Chương 6 5A2CD7E1', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (220, N' Chương 7 B7CB7D51', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (221, N' Chương 8 7731D556', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (222, N' Chương 9 AC58FED6', N'Mô tả  Môn h?c 662CB402H? th?ng thông tin', 22)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (223, N' Chương 0 C45B1DA9', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (224, N' Chương 1 4EF4FBDE', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (225, N' Chương 2 23E8F542', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (226, N' Chương 3 F6D245C2', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (227, N' Chương 4 78E28CBA', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (228, N' Chương 5 28E38A6A', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (229, N' Chương 6 6277C3F7', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (230, N' Chương 7 E2823420', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (231, N' Chương 8 14814F67', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (232, N' Chương 9 9FF6BF16', N'Mô tả  Môn h?c 4C0C43B6H? th?ng thông tin', 23)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (233, N' Chương 0 DEA2C698', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (234, N' Chương 1 9B41819B', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (235, N' Chương 2 ED59E7FA', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (236, N' Chương 3 A75B247B', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (237, N' Chương 4 5230A427', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (238, N' Chương 5 7226F815', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (239, N' Chương 6 26B16523', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (240, N' Chương 7 4C457DAC', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (241, N' Chương 8 775EBCAC', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (242, N' Chương 9 4A84BAC7', N'Mô tả  Môn h?c 4D373A24H? th?ng thông tin', 24)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (243, N' Chương 0 271FA58B', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (244, N' Chương 1 179560A5', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (245, N' Chương 2 465C5C5B', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (246, N' Chương 3 F77EE25A', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (247, N' Chương 4 9E63FA60', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (248, N' Chương 5 8D595C3D', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (249, N' Chương 6 B0B06E02', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (250, N' Chương 7 CA48EEC4', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (251, N' Chương 8 C95A60E2', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (252, N' Chương 9 8E46EE33', N'Mô tả  Môn h?c 3A4BC717H? th?ng thông tin', 25)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (253, N' Chương 0 EFA7C5D2', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (254, N' Chương 1 52F17811', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (255, N' Chương 2 97DB5178', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (256, N' Chương 3 C21144C9', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (257, N' Chương 4 77C6F763', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (258, N' Chương 5 8FD726D8', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (259, N' Chương 6 D818ED3E', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (260, N' Chương 7 A75A5D7A', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (261, N' Chương 8 FD125724', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (262, N' Chương 9 F0B9327C', N'Mô tả  Môn h?c 20265AF7M?ng máy tính', 26)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (263, N' Chương 0 9EEBBAEF', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (264, N' Chương 1 6D59991F', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (265, N' Chương 2 B675A657', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (266, N' Chương 3 DF2FA864', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (267, N' Chương 4 0D63FE04', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (268, N' Chương 5 6CEABE07', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (269, N' Chương 6 03860E3C', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (270, N' Chương 7 E025EEEA', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (271, N' Chương 8 3870F0E5', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (272, N' Chương 9 9B2AACD0', N'Mô tả  Môn h?c 04B4E1D3M?ng máy tính', 27)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (273, N' Chương 0 DE735749', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (274, N' Chương 1 3E50E172', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (275, N' Chương 2 8057AB99', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (276, N' Chương 3 F64C9C5C', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (277, N' Chương 4 8AA3FCDF', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (278, N' Chương 5 5CEE3B50', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (279, N' Chương 6 99AB410A', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (280, N' Chương 7 F00487AE', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (281, N' Chương 8 02DC592C', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (282, N' Chương 9 9AC41999', N'Mô tả  Môn h?c 3E806208M?ng máy tính', 28)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (283, N' Chương 0 6A46B84B', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (284, N' Chương 1 D734C6C9', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (285, N' Chương 2 2C97E676', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (286, N' Chương 3 3DEDFCDC', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (287, N' Chương 4 076AC76F', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (288, N' Chương 5 2593CFEF', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (289, N' Chương 6 B1D5FDAE', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (290, N' Chương 7 C5CAD6CD', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (291, N' Chương 8 350064CE', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (292, N' Chương 9 63DF0B1F', N'Mô tả  Môn h?c 023600C4M?ng máy tính', 29)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (293, N' Chương 0 280A1DBF', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (294, N' Chương 1 E6B81288', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (295, N' Chương 2 995395D2', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (296, N' Chương 3 145553E3', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (297, N' Chương 4 3D97A9A0', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (298, N' Chương 5 F79669D3', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (299, N' Chương 6 BB048D64', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (300, N' Chương 7 88F3379A', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (301, N' Chương 8 12CC4A1B', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (302, N' Chương 9 28314167', N'Mô tả  Môn h?c 275865A7M?ng máy tính', 30)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (303, N' Chương 0 43EFBD4D', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (304, N' Chương 1 4FC9392D', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (305, N' Chương 2 1F4ECD1E', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (306, N' Chương 3 348431F7', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (307, N' Chương 4 9B7BC7A4', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (308, N' Chương 5 B4910C01', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (309, N' Chương 6 D9FE48D7', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (310, N' Chương 7 8D0A3F8A', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (311, N' Chương 8 60C6E613', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (312, N' Chương 9 758FC965', N'Mô tả  Môn h?c 50A7D469M?ng máy tính', 31)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (313, N' Chương 0 6B1F8EFE', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (314, N' Chương 1 2980FAFB', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (315, N' Chương 2 54BD8986', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (316, N' Chương 3 BBD01BDE', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (317, N' Chương 4 AE0C4105', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (318, N' Chương 5 50532880', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (319, N' Chương 6 9D146A50', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (320, N' Chương 7 B1D276FA', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (321, N' Chương 8 7520A705', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (322, N' Chương 9 E6462410', N'Mô tả  Môn h?c B57CD171M?ng máy tính', 32)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (323, N' Chương 0 CF4FCA2B', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (324, N' Chương 1 392F9248', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (325, N' Chương 2 829BF813', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (326, N' Chương 3 378B28A2', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (327, N' Chương 4 9A646F32', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (328, N' Chương 5 78920D40', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (329, N' Chương 6 1163C891', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (330, N' Chương 7 8E62F77C', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (331, N' Chương 8 EC82EBED', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (332, N' Chương 9 BE264B55', N'Mô tả  Môn h?c 9862AE45M?ng máy tính', 33)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (333, N' Chương 0 93569D24', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (334, N' Chương 1 753A3193', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (335, N' Chương 2 81CEC18F', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (336, N' Chương 3 8141EE73', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (337, N' Chương 4 AD872C63', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (338, N' Chương 5 CD950D41', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (339, N' Chương 6 A6C050E6', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (340, N' Chương 7 CA5BF89B', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (341, N' Chương 8 FFFB4AE8', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (342, N' Chương 9 4E472309', N'Mô tả  Môn h?c A2D264C3M?ng máy tính', 34)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (343, N' Chương 0 6AD05978', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (344, N' Chương 1 BDF49564', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (345, N' Chương 2 77E20C5B', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (346, N' Chương 3 4E8E9A3B', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (347, N' Chương 4 A1348D07', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (348, N' Chương 5 E649D4EA', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (349, N' Chương 6 9ECB89D9', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (350, N' Chương 7 404D65C4', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (351, N' Chương 8 FFC3E241', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (352, N' Chương 9 FB6D3127', N'Mô tả  Môn h?c AC4F528CM?ng máy tính', 35)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (353, N' Chương 0 1B91BB78', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (354, N' Chương 1 FCEC30B2', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (355, N' Chương 2 EF7F73AE', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (356, N' Chương 3 24CEBD80', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (357, N' Chương 4 34A22E08', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (358, N' Chương 5 5470C95E', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (359, N' Chương 6 AC59186B', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (360, N' Chương 7 08A3E55A', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (361, N' Chương 8 685222B9', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (362, N' Chương 9 8DD3B4C5', N'Mô tả  Môn h?c B23321E6M?ng máy tính', 36)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (363, N' Chương 0 5FF15259', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (364, N' Chương 1 D43B9D12', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (365, N' Chương 2 B6611CDE', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (366, N' Chương 3 B39F443D', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (367, N' Chương 4 DC2DF97B', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (368, N' Chương 5 B474B8C3', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (369, N' Chương 6 7DE7C359', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (370, N' Chương 7 785F6833', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (371, N' Chương 8 F770464D', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (372, N' Chương 9 D7568234', N'Mô tả  Môn h?c 3462E839M?ng máy tính', 37)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (373, N' Chương 0 F9D7D8F6', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (374, N' Chương 1 7463399A', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (375, N' Chương 2 F62170F4', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (376, N' Chương 3 1D996FA3', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (377, N' Chương 4 A8E367F4', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (378, N' Chương 5 118D4F55', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (379, N' Chương 6 1919E19B', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (380, N' Chương 7 309CBD2B', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (381, N' Chương 8 A6715114', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (382, N' Chương 9 4E047F8D', N'Mô tả  Môn h?c FAADBB61M?ng máy tính', 38)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (383, N' Chương 0 1E8537DD', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (384, N' Chương 1 32FD71A9', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (385, N' Chương 2 3C6CAFA0', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (386, N' Chương 3 F2909E82', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (387, N' Chương 4 13420CA1', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (388, N' Chương 5 9DABCAFA', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (389, N' Chương 6 9B5990D9', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (390, N' Chương 7 46FE4477', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (391, N' Chương 8 04E4B0CB', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (392, N' Chương 9 4816ED54', N'Mô tả  Môn h?c 20F0FE79M?ng máy tính', 39)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (393, N' Chương 0 AC3B3AFC', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (394, N' Chương 1 E3AA8243', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (395, N' Chương 2 935B78E6', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (396, N' Chương 3 1CEED7EC', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (397, N' Chương 4 65B0F605', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (398, N' Chương 5 B0B3A9A0', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (399, N' Chương 6 F9950525', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (400, N' Chương 7 0971C3FA', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (401, N' Chương 8 A32FE032', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (402, N' Chương 9 3D935000', N'Mô tả  Môn h?c D43347ABM?ng máy tính', 40)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (403, N' Chương 0 FC80897C', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (404, N' Chương 1 5DE6C205', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (405, N' Chương 2 6D9C5776', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (406, N' Chương 3 02F8A9C3', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (407, N' Chương 4 252FB5CC', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (408, N' Chương 5 0E612C68', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (409, N' Chương 6 0130C667', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (410, N' Chương 7 7645D9B8', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (411, N' Chương 8 3A07B44A', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (412, N' Chương 9 4C9E244C', N'Mô tả  Môn h?c D9C6A2D1M?ng máy tính', 41)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (413, N' Chương 0 43A0AFD6', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (414, N' Chương 1 EBCD1E39', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (415, N' Chương 2 321AB1D9', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (416, N' Chương 3 592D9B87', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (417, N' Chương 4 01E7838F', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (418, N' Chương 5 1BBE3C8C', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (419, N' Chương 6 1907ED21', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (420, N' Chương 7 74B86F30', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (421, N' Chương 8 3703E237', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (422, N' Chương 9 046CB67F', N'Mô tả  Môn h?c 7766E85AM?ng máy tính', 42)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (423, N' Chương 0 537DE76F', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (424, N' Chương 1 E818212E', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (425, N' Chương 2 A1B751E2', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (426, N' Chương 3 4E44A8E3', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (427, N' Chương 4 CC12C982', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (428, N' Chương 5 B9BDBC50', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (429, N' Chương 6 81CA57CC', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (430, N' Chương 7 AD3E69BE', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (431, N' Chương 8 A722361D', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (432, N' Chương 9 314855EB', N'Mô tả  Môn h?c FA7D3A90M?ng máy tính', 43)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (433, N' Chương 0 F27D0F26', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (434, N' Chương 1 E24CB927', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (435, N' Chương 2 762FD1EC', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (436, N' Chương 3 E00E593A', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (437, N' Chương 4 7FE9D727', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (438, N' Chương 5 53EF3BC2', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (439, N' Chương 6 BCD0115C', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (440, N' Chương 7 8085752D', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (441, N' Chương 8 129C2585', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (442, N' Chương 9 38B484DD', N'Mô tả  Môn h?c FB50DEBDM?ng máy tính', 44)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (443, N' Chương 0 F4EB5375', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (444, N' Chương 1 926C51D6', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (445, N' Chương 2 167D8FC4', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (446, N' Chương 3 223274A7', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (447, N' Chương 4 631A1351', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (448, N' Chương 5 DE39E122', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (449, N' Chương 6 FC1E190B', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (450, N' Chương 7 05FCED0C', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (451, N' Chương 8 ADE6FDBB', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (452, N' Chương 9 AC7F28BE', N'Mô tả  Môn h?c 54672F0FM?ng máy tính', 45)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (453, N' Chương 0 EADF0246', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (454, N' Chương 1 0E679018', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (455, N' Chương 2 5B209EBA', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (456, N' Chương 3 00D87DB8', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (457, N' Chương 4 69E2F64B', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (458, N' Chương 5 AF6D384B', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (459, N' Chương 6 3FD9F4E7', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (460, N' Chương 7 0F2CEFFE', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (461, N' Chương 8 AA61EB89', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (462, N' Chương 9 B289ECFD', N'Mô tả  Môn h?c B59A0C82Khoa h?c máy tính', 46)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (463, N' Chương 0 64F32870', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (464, N' Chương 1 DC6C9789', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (465, N' Chương 2 6552BA13', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (466, N' Chương 3 02504AD6', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (467, N' Chương 4 CE4DE7F2', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (468, N' Chương 5 7528EE88', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (469, N' Chương 6 26A5190D', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (470, N' Chương 7 7D50984C', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (471, N' Chương 8 3796A60A', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (472, N' Chương 9 56F12FEA', N'Mô tả  Môn h?c A7B0481BKhoa h?c máy tính', 47)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (473, N' Chương 0 83ABF5B0', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (474, N' Chương 1 C497C192', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (475, N' Chương 2 A9A702B3', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (476, N' Chương 3 BE6372E6', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (477, N' Chương 4 01E487F8', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (478, N' Chương 5 C774F4AB', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (479, N' Chương 6 BDEC59AF', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (480, N' Chương 7 D6997EA5', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (481, N' Chương 8 5A7949A7', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (482, N' Chương 9 9F1467FA', N'Mô tả  Môn h?c 4B21659AKhoa h?c máy tính', 48)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (483, N' Chương 0 0F574875', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (484, N' Chương 1 9E5FDF15', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (485, N' Chương 2 84556AC7', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (486, N' Chương 3 E18ED4E6', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (487, N' Chương 4 C9FB1BE2', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (488, N' Chương 5 D782DC92', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (489, N' Chương 6 E6A84CDF', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (490, N' Chương 7 9685B4A2', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (491, N' Chương 8 2C66F219', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (492, N' Chương 9 5DB9CD92', N'Mô tả  Môn h?c DEF70A06Khoa h?c máy tính', 49)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (493, N' Chương 0 32DB63D2', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (494, N' Chương 1 8C8F9D46', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (495, N' Chương 2 3D07EBAB', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (496, N' Chương 3 C4A296CA', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (497, N' Chương 4 BF59B03E', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (498, N' Chương 5 77B8DF69', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (499, N' Chương 6 F05AAEA4', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (500, N' Chương 7 A2DA8AAF', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (501, N' Chương 8 AE872056', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (502, N' Chương 9 1AC98FFC', N'Mô tả  Môn h?c CEF0E439Khoa h?c máy tính', 50)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (503, N' Chương 0 2FEB684B', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (504, N' Chương 1 E7B177E9', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (505, N' Chương 2 427FC837', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (506, N' Chương 3 2DA56F39', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (507, N' Chương 4 BA295EEA', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (508, N' Chương 5 0AEB5282', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (509, N' Chương 6 1432C880', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (510, N' Chương 7 E79187B3', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (511, N' Chương 8 AF46FA3B', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (512, N' Chương 9 5EF69ECC', N'Mô tả  Môn h?c B08693C7Khoa h?c máy tính', 51)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (513, N' Chương 0 7896817B', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (514, N' Chương 1 A45E4F27', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (515, N' Chương 2 98BFA36F', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (516, N' Chương 3 DA12B2A9', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (517, N' Chương 4 58E6D5BA', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (518, N' Chương 5 FCE3C996', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (519, N' Chương 6 5D6FB0AA', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (520, N' Chương 7 B48AEC03', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (521, N' Chương 8 585AD092', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (522, N' Chương 9 C6C2716E', N'Mô tả  Môn h?c A64BEA7AKhoa h?c máy tính', 52)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (523, N' Chương 0 52E6C7E7', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (524, N' Chương 1 C3193ED8', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (525, N' Chương 2 4A46AE34', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (526, N' Chương 3 8969863A', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (527, N' Chương 4 D9713840', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (528, N' Chương 5 FAC073C2', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (529, N' Chương 6 462A5ED2', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (530, N' Chương 7 0F7CE117', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (531, N' Chương 8 452602EF', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (532, N' Chương 9 D7983E53', N'Mô tả  Môn h?c 2730765BKhoa h?c máy tính', 53)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (533, N' Chương 0 12FD782D', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (534, N' Chương 1 12CED181', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (535, N' Chương 2 13802FD2', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (536, N' Chương 3 C90DD5B2', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (537, N' Chương 4 C2AC7CDE', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (538, N' Chương 5 12AA9402', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (539, N' Chương 6 8DBEEB45', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (540, N' Chương 7 CBC8560E', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (541, N' Chương 8 B2390CA7', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (542, N' Chương 9 0CCBD489', N'Mô tả  Môn h?c B99CDF11Khoa h?c máy tính', 54)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (543, N' Chương 0 8789ECB6', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (544, N' Chương 1 DD0BAA31', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (545, N' Chương 2 AFDEEB1B', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (546, N' Chương 3 13A5F62D', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (547, N' Chương 4 8A2340E8', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (548, N' Chương 5 BA719546', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (549, N' Chương 6 8AF5B49A', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (550, N' Chương 7 9CD45B8F', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (551, N' Chương 8 A79B22DE', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (552, N' Chương 9 AA8D085F', N'Mô tả  Môn h?c 2FD880ACKhoa h?c máy tính', 55)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (553, N' Chương 0 84A43549', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (554, N' Chương 1 5FE84FBB', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (555, N' Chương 2 A5EA575C', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (556, N' Chương 3 CF9CDF09', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (557, N' Chương 4 4AAF3C3A', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (558, N' Chương 5 9EE09CCA', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (559, N' Chương 6 E8453AD2', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (560, N' Chương 7 F8255E4A', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (561, N' Chương 8 E09967AD', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (562, N' Chương 9 4D29A401', N'Mô tả  Môn h?c 89EF62ACKhoa h?c máy tính', 56)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (563, N' Chương 0 72860937', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (564, N' Chương 1 ADCBE4DA', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (565, N' Chương 2 80265DA0', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (566, N' Chương 3 0E521D65', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (567, N' Chương 4 55B8FED5', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (568, N' Chương 5 5E048B64', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (569, N' Chương 6 36ABD00B', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (570, N' Chương 7 E700FFB9', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (571, N' Chương 8 CB514303', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (572, N' Chương 9 C3C89456', N'Mô tả  Môn h?c C4D4ED15Khoa h?c máy tính', 57)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (573, N' Chương 0 88DFBAD8', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (574, N' Chương 1 9D203E6D', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (575, N' Chương 2 56CDAE29', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (576, N' Chương 3 4C13158F', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (577, N' Chương 4 11AA285F', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (578, N' Chương 5 00A06E72', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (579, N' Chương 6 82255998', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (580, N' Chương 7 B2002C13', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (581, N' Chương 8 5FD22CF4', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (582, N' Chương 9 B55E0938', N'Mô tả  Môn h?c 283665B6Khoa h?c máy tính', 58)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (583, N' Chương 0 7E69EADA', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (584, N' Chương 1 9934C86D', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (585, N' Chương 2 83CEC687', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (586, N' Chương 3 52C2B769', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (587, N' Chương 4 AA5B7BC6', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (588, N' Chương 5 5E2E2341', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (589, N' Chương 6 6ED8D96A', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (590, N' Chương 7 C24BB6E0', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (591, N' Chương 8 D690563C', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (592, N' Chương 9 DF0F7D3A', N'Mô tả  Môn h?c 0CC20303Khoa h?c máy tính', 59)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (593, N' Chương 0 E4962724', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (594, N' Chương 1 77FD9433', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (595, N' Chương 2 51452887', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (596, N' Chương 3 F0CE2434', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (597, N' Chương 4 43C4852B', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (598, N' Chương 5 1C289D0F', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (599, N' Chương 6 0B6F8A43', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (600, N' Chương 7 6F3B07E7', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (601, N' Chương 8 E1130547', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (602, N' Chương 9 D6BD4D9F', N'Mô tả  Môn h?c FF1F0004Khoa h?c máy tính', 60)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (603, N' Chương 0 BEDF1415', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (604, N' Chương 1 3A1BDFDF', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (605, N' Chương 2 C244C29C', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (606, N' Chương 3 9948845E', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (607, N' Chương 4 87CF807A', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (608, N' Chương 5 2D39FE1D', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (609, N' Chương 6 BF189896', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (610, N' Chương 7 01B7BE5F', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (611, N' Chương 8 35D614BB', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (612, N' Chương 9 1890E833', N'Mô tả  Môn h?c 06C26FFCKhoa h?c máy tính', 61)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (613, N' Chương 0 87FF4E28', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (614, N' Chương 1 16845273', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (615, N' Chương 2 8B0EC58F', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (616, N' Chương 3 BEBC788C', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (617, N' Chương 4 1AACCE23', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (618, N' Chương 5 4420F3C9', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (619, N' Chương 6 4B960B3B', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (620, N' Chương 7 010A66FB', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (621, N' Chương 8 0149EE19', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (622, N' Chương 9 40DBB958', N'Mô tả  Môn h?c 96DDA455Khoa h?c máy tính', 62)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (623, N' Chương 0 3CAB18FF', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (624, N' Chương 1 99AE2A06', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (625, N' Chương 2 6B4BC0E8', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (626, N' Chương 3 CF4F8993', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (627, N' Chương 4 CB856C8E', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (628, N' Chương 5 2F17D3DD', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (629, N' Chương 6 5DFE4C37', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (630, N' Chương 7 AEF483C0', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (631, N' Chương 8 82EC1654', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (632, N' Chương 9 CC4D1C6A', N'Mô tả  Môn h?c 8C405B14Khoa h?c máy tính', 63)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (633, N' Chương 0 94C35F5E', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (634, N' Chương 1 481687F8', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (635, N' Chương 2 2CE06CF1', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (636, N' Chương 3 CA0F247C', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (637, N' Chương 4 B024E8EE', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (638, N' Chương 5 88CF1A53', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (639, N' Chương 6 A14685BC', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (640, N' Chương 7 6F3BA3FB', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (641, N' Chương 8 8F4E6C6E', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (642, N' Chương 9 D2D7C6E9', N'Mô tả  Môn h?c D452D1C0Khoa h?c máy tính', 64)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (643, N' Chương 0 EC15A0B9', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (644, N' Chương 1 57D620EF', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (645, N' Chương 2 6DE44692', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (646, N' Chương 3 9709C636', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (647, N' Chương 4 D55E6EFD', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (648, N' Chương 5 BD8544E8', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (649, N' Chương 6 B17B8E93', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (650, N' Chương 7 F67719A6', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (651, N' Chương 8 CAB4EFD4', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (652, N' Chương 9 04862F0A', N'Mô tả  Môn h?c 7A0F3D88Khoa h?c máy tính', 65)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (653, N' Chương 0 58EFBB81', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (654, N' Chương 1 E507520D', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (655, N' Chương 2 C8207E77', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (656, N' Chương 3 44241973', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (657, N' Chương 4 BE552698', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (658, N' Chương 5 6FE56AB9', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (659, N' Chương 6 EAD42CB4', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (660, N' Chương 7 9B3496DF', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (661, N' Chương 8 EDFAA881', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (662, N' Chương 9 1182E63A', N'Mô tả  Môn h?c 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 66)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (663, N' Chương 0 0ECB04FA', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (664, N' Chương 1 8BEE5876', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (665, N' Chương 2 C42EC47A', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (666, N' Chương 3 95EE592C', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (667, N' Chương 4 AF91FA58', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (668, N' Chương 5 7FC6381D', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (669, N' Chương 6 3FE164B1', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (670, N' Chương 7 58ADD6FE', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (671, N' Chương 8 1CF1652A', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (672, N' Chương 9 ED4E7834', N'Mô tả  Môn h?c A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 67)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (673, N' Chương 0 9BE760B3', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (674, N' Chương 1 E58D5F49', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (675, N' Chương 2 441F0CAC', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (676, N' Chương 3 CA72B475', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (677, N' Chương 4 067FFEF6', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (678, N' Chương 5 4156E580', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (679, N' Chương 6 0C21B8E8', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (680, N' Chương 7 B10D5B28', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (681, N' Chương 8 8E10E752', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (682, N' Chương 9 86615E0B', N'Mô tả  Môn h?c 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 68)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (683, N' Chương 0 1FA1BBD3', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (684, N' Chương 1 59F9FE07', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (685, N' Chương 2 8FEA4B09', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (686, N' Chương 3 3CA36BD2', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (687, N' Chương 4 20D0DECD', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (688, N' Chương 5 6593EA4B', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (689, N' Chương 6 3A324451', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (690, N' Chương 7 E19C92BC', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (691, N' Chương 8 E0C47149', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (692, N' Chương 9 6676B54A', N'Mô tả  Môn h?c 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 69)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (693, N' Chương 0 9507B576', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (694, N' Chương 1 3351C100', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (695, N' Chương 2 24511367', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (696, N' Chương 3 3192F830', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (697, N' Chương 4 CA402111', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (698, N' Chương 5 667AD54C', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (699, N' Chương 6 78F6296B', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (700, N' Chương 7 39E995D6', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (701, N' Chương 8 1B629C48', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (702, N' Chương 9 BD4CF056', N'Mô tả  Môn h?c 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 70)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (703, N' Chương 0 B1BEA808', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (704, N' Chương 1 27C05FFD', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (705, N' Chương 2 C6C845CD', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (706, N' Chương 3 D66FC626', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (707, N' Chương 4 C5B6A352', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (708, N' Chương 5 E8B69054', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (709, N' Chương 6 1C1809C4', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (710, N' Chương 7 77E8EEA5', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (711, N' Chương 8 D0DD8778', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (712, N' Chương 9 3F4DF70D', N'Mô tả  Môn h?c 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 71)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (713, N' Chương 0 47823CE0', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (714, N' Chương 1 242F0E70', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (715, N' Chương 2 3BE0D007', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (716, N' Chương 3 16C54E36', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (717, N' Chương 4 38EAAA2C', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (718, N' Chương 5 F688437F', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (719, N' Chương 6 9780AF19', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (720, N' Chương 7 600627A0', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (721, N' Chương 8 1965E2AC', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (722, N' Chương 9 E93FD88A', N'Mô tả  Môn h?c 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 72)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (723, N' Chương 0 96962D93', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (724, N' Chương 1 44C9EA2B', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (725, N' Chương 2 A31C4BD2', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (726, N' Chương 3 7054CED2', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (727, N' Chương 4 3A0A9FFB', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (728, N' Chương 5 3E392D80', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (729, N' Chương 6 EBE0162C', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (730, N' Chương 7 6451C316', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (731, N' Chương 8 CFD025D3', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (732, N' Chương 9 75005813', N'Mô tả  Môn h?c 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 73)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (733, N' Chương 0 6FF24BF7', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (734, N' Chương 1 3F9EE49D', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (735, N' Chương 2 45FF35F6', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (736, N' Chương 3 C9735C72', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (737, N' Chương 4 0F4C67FC', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (738, N' Chương 5 EF6F0224', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (739, N' Chương 6 65973994', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (740, N' Chương 7 19A7BBC9', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (741, N' Chương 8 D59D2206', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (742, N' Chương 9 3002F6FD', N'Mô tả  Môn h?c 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 74)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (743, N' Chương 0 A3A24F17', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (744, N' Chương 1 CB6E0655', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (745, N' Chương 2 1094361F', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (746, N' Chương 3 D5EEDBB1', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (747, N' Chương 4 CB337F17', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (748, N' Chương 5 066ADCBB', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (749, N' Chương 6 6338BD3F', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (750, N' Chương 7 562C2B5F', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (751, N' Chương 8 CD9DE5C7', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (752, N' Chương 9 0A4DCC3C', N'Mô tả  Môn h?c FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 75)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (753, N' Chương 0 0FD6EB39', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (754, N' Chương 1 CAD751D6', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (755, N' Chương 2 21FDE4F0', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (756, N' Chương 3 C106AFD9', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (757, N' Chương 4 097FCE1E', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (758, N' Chương 5 5133ECEF', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (759, N' Chương 6 2C4DFCAB', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (760, N' Chương 7 ED954081', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (761, N' Chương 8 6B00E818', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (762, N' Chương 9 35E3CFE6', N'Mô tả  Môn h?c 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 76)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (763, N' Chương 0 88DAECE9', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (764, N' Chương 1 2D57230F', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (765, N' Chương 2 8380761D', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (766, N' Chương 3 EC2FBAB5', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (767, N' Chương 4 FE07AFE5', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (768, N' Chương 5 AE185634', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (769, N' Chương 6 8B7BA8C0', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (770, N' Chương 7 AA5F72FB', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (771, N' Chương 8 77E4593B', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (772, N' Chương 9 4C4CBEB9', N'Mô tả  Môn h?c ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 77)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (773, N' Chương 0 3889A175', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (774, N' Chương 1 E7894069', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (775, N' Chương 2 2585C552', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (776, N' Chương 3 D36623DE', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (777, N' Chương 4 7601C6A4', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (778, N' Chương 5 69D61F3D', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (779, N' Chương 6 845734FE', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (780, N' Chương 7 6C2D6A53', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (781, N' Chương 8 AA1036B7', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (782, N' Chương 9 5F906E2E', N'Mô tả  Môn h?c 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 78)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (783, N' Chương 0 5855C30F', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (784, N' Chương 1 30A3664D', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (785, N' Chương 2 ACA2068C', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (786, N' Chương 3 DB9FC433', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (787, N' Chương 4 BBCEE379', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (788, N' Chương 5 D3905571', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (789, N' Chương 6 61F7AB21', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (790, N' Chương 7 0512F2F7', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (791, N' Chương 8 464E9413', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (792, N' Chương 9 982A3C8A', N'Mô tả  Môn h?c FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 79)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (793, N' Chương 0 FC621A9D', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (794, N' Chương 1 F764CE88', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (795, N' Chương 2 EF4D6AD8', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (796, N' Chương 3 3DBEDEA0', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (797, N' Chương 4 C461CF44', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (798, N' Chương 5 4693D2F4', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (799, N' Chương 6 C8016D70', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (800, N' Chương 7 50CAC8B9', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (801, N' Chương 8 B5888E89', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (802, N' Chương 9 33FD87A8', N'Mô tả  Môn h?c FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 80)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (803, N' Chương 0 493D0F22', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (804, N' Chương 1 918D1F0F', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (805, N' Chương 2 86E6F59E', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (806, N' Chương 3 EDA6B417', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (807, N' Chương 4 670093A9', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (808, N' Chương 5 7A41EF1A', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (809, N' Chương 6 BEE835E8', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (810, N' Chương 7 EB667CBE', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (811, N' Chương 8 6D183D76', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (812, N' Chương 9 469C7085', N'Mô tả  Môn h?c 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 81)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (813, N' Chương 0 B31D9A90', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (814, N' Chương 1 88EB3042', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (815, N' Chương 2 76955F7C', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (816, N' Chương 3 6BDB09E9', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (817, N' Chương 4 CF35A9E7', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (818, N' Chương 5 9DAE0AA4', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (819, N' Chương 6 9856D0B2', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (820, N' Chương 7 D187A33B', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (821, N' Chương 8 B5F19D74', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (822, N' Chương 9 F1A246D1', N'Mô tả  Môn h?c A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 82)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (823, N' Chương 0 0185B7DF', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (824, N' Chương 1 3D80666F', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (825, N' Chương 2 719BF0BD', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (826, N' Chương 3 6A30CD2F', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (827, N' Chương 4 924E3858', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (828, N' Chương 5 6E615B9E', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (829, N' Chương 6 1D519DE1', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (830, N' Chương 7 C93351F5', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (831, N' Chương 8 A10CFB49', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (832, N' Chương 9 CEA36005', N'Mô tả  Môn h?c 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 83)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (833, N' Chương 0 91855F5D', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (834, N' Chương 1 7B1DEAC4', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (835, N' Chương 2 5837D038', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (836, N' Chương 3 3AEBCE19', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (837, N' Chương 4 254A539E', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (838, N' Chương 5 A5F80A1A', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (839, N' Chương 6 A8C44189', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (840, N' Chương 7 57D5B123', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (841, N' Chương 8 84ACC183', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (842, N' Chương 9 AA8592D3', N'Mô tả  Môn h?c 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 84)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (843, N' Chương 0 4EA25690', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (844, N' Chương 1 0D6F3ACE', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (845, N' Chương 2 2A265000', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (846, N' Chương 3 229D4729', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (847, N' Chương 4 CFE912E3', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (848, N' Chương 5 4771F4D0', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (849, N' Chương 6 7D0D80B6', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (850, N' Chương 7 DA5A87A8', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (851, N' Chương 8 23BDD1DA', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (852, N' Chương 9 B92257DC', N'Mô tả  Môn h?c 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 85)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (853, N'Tiêu đề chương 1: Giới thiệu', N'Phần này không học gì hết chỉ chơi thôi', 1)
GO
INSERT [dbo].[CHUONG_MUC] ([MACHUONG], [TIEUDE], [MOTA], [MAMON]) VALUES (854, N'Chương 2: Tiêu đề chương 2', N' Học nhiều thứ, đi học sẽ biết', 1)
GO
SET IDENTITY_INSERT [dbo].[CHUONG_MUC] OFF
GO
SET IDENTITY_INSERT [dbo].[CONG_VIEC] ON 

GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (1, 2, 2, 2, CAST(N'2016-01-01 00:00:00.000' AS DateTime), CAST(N'2016-02-02 00:00:00.000' AS DateTime), N'Thêm các chương vào môn học này nhé! =))', 1)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (2, 2, 11, 2, CAST(N'2017-06-18 00:00:00.000' AS DateTime), CAST(N'2017-06-22 00:00:00.000' AS DateTime), N'Lam nhanh em nhe', 0)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (3, 2, 12, 2, CAST(N'2017-06-18 00:00:00.000' AS DateTime), CAST(N'2017-06-22 00:00:00.000' AS DateTime), N'Lam nhanh em nhe', 0)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (4, 2, 14, 2, CAST(N'2017-06-18 00:00:00.000' AS DateTime), CAST(N'2017-06-20 00:00:00.000' AS DateTime), N' Làm nhanh em nhé! ANh yêu em', 0)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (5, 2, 12, 2, CAST(N'2017-06-18 00:00:00.000' AS DateTime), CAST(N'2017-06-20 00:00:00.000' AS DateTime), N'Làm nhanh nhé thằng mặt lồn!', 0)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (7, 2, 11, 3, CAST(N'2017-06-19 00:00:00.000' AS DateTime), CAST(N'2017-06-21 00:00:00.000' AS DateTime), N'Làm Nhanh Em nhé!', 1)
GO
INSERT [dbo].[CONG_VIEC] ([MACV], [MAMON], [MAGV], [MALOAICV], [TGBATDAU], [TGKETTHUC], [NOIDUNGCV], [TRANGTHAI]) VALUES (32, 6, 2, 3, CAST(N'2018-05-31 00:00:00.000' AS DateTime), CAST(N'2018-06-09 00:00:00.000' AS DateTime), N'', 0)
GO
SET IDENTITY_INSERT [dbo].[CONG_VIEC] OFF
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (1, 1, 2)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (1, 2, 4)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (1, 4, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (1, 12, 2)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 1, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 2, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 3, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 4, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 5, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (2, 6, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 7, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 8, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 9, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 10, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 11, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (3, 12, 15)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 1, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 2, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 3, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 4, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 5, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 6, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 7, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 8, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 9, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 10, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 11, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (4, 12, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 1, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 2, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 3, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 4, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 5, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 6, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 7, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 8, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 9, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 10, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 11, 3)
GO
INSERT [dbo].[CT_TAO_CAU_HOI] ([MACV], [MACHUONG], [SL]) VALUES (5, 12, 3)
GO
SET IDENTITY_INSERT [dbo].[DAP_AN] ON 

GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (1, 1, N'Hiến pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (1, 2, N'Hiến pháp và luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (1, 3, N'Luật hiến pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (1, 4, N'Luật và chính sách', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (2, 5, N'Như nhau', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (2, 6, N'Ngang nhau', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (2, 8, N'Bằng nhau', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (2, 9, N'Có thể khác nhau', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (3, 10, N'Dân tộc, giới tính, tôn giáo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (3, 11, N'Thu nhập, tuổi tác, địa vị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (3, 12, N'Dân tộc, địa vị, giới tính, tôn giáo', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (3, 13, N'Dân tộc, độ tuổi, giới tính', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (4, 14, N'Nghĩa vụ của công dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (4, 15, N'Quyền của công dân', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (4, 16, N'Trách nhiệm của công dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (4, 17, N'Quyền và nghĩa vụ của công dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (5, 18, N'Công dân ở bất kỳ độ tuổi nào vi phạm pháp luật đều bị xử lý như nhau', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (5, 19, N'Công dân nào vi phạm quy định của cơ quan, đơn vị, đều phải chịu trách nhiệm kỷ luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (5, 20, N'Công dân nào vi phạm pháp luật cũng bị xử lý theo quy định của pháp luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (5, 21, N'Công dân nào do thiếu hiểu biết về pháp luật mà vi phạm pháp luật thì không phải chịu trách nhiệm pháp lý', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (6, 22, N'Công dân có quyền và nghĩa vụ như nhau nếu cùng giới tính, dân tộc, tôn giáo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (6, 23, N'Công dân có quyền và nghĩa vụ giống nhau tùy theo địa bàn sinh sống', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (6, 24, N'Công dân nào vi phạm pháp luật cũng bị xử lý theo quy định của đơn vị, tổ chức, đoàn thể mà họ tham gia', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (6, 25, N'Công dân không bị phân biệt đối xử trong việc hưởng quyền, thực hiện, nghĩa vụ, và chịu trách nhiệm pháp lý theo quy định của pháp luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (7, 26, N'Quy định quyền và nghĩa vụ công dân trong Hiến pháp và Luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (7, 27, N'Tạo ra các điều kiện bảo đảm cho công dân thực hiện quyền bình đẳng trước pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (7, 28, N'Không ngừng đổi mới và hoàn thiện hệ thống pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (7, 29, N'Tất cả các phương án trên', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (8, 30, N'Nhà nước', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (8, 31, N'Nhà nước và xã hội', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (8, 32, N'Nhà nước và pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (8, 33, N'Nhà nước và công dân', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (10, 34, N'Do nhân dân bầu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (10, 35, N'Do Quốc hội bầu theo sự giới thiệu của Chủ tịch nước ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (10, 36, N'Do Chủ tịch nước giới thiệu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (10, 37, N'Do Chính phủ bầu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (11, 38, N'Pháp lệnh ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (11, 39, N'Luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (11, 40, N'Hiến pháp ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (11, 41, N' Nghị quyết', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (12, 42, N'Các nhà làm luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (12, 43, N'Quốc hội, nghị viện', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (12, 44, N'Nhà nước, giai cấp thống trị', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (12, 45, N'Chính phủ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (13, 46, N' 2 kiểu pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (13, 47, N' 3 kiểu pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (13, 48, N' 4 kiểu pháp luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (13, 49, N'5 kiểu pháp luật ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (14, 50, N' Luật tổ chức Quốc hội', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (14, 51, N' Luật tổ chức Chính phủ ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (14, 52, N'Luật tổ chức Hội đồng nhân dân và UBND', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (14, 53, N' Hiến pháp', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (15, 54, N'Áp dụng trong một hoàn cảnh cụ thể. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (15, 55, N' Áp dụng trong nhiều hoàn cảnh', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (15, 56, N'Cả A và B đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (15, 57, N' Cả A và B đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (16, 58, N'Thể hiện ý chí chung, phù hợp với lợi ích chung của cộng đồng, thị tộc, bộ lạc; Mang tính manh mún, tản mạn và chỉ có hiệu lực trong phạm vi thị tộc - bộ lạc.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (16, 59, N'Mang nội dung, tinh thần hợp tác, giúp đỡ lẫn nhau, tính cộng đồng, bình đẳng, nhưng nhiều quy phạm xã hội có nội dung lạc hậu, thể hiện lối sống hoang dã.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (16, 60, N'Được thực hiện tự nguyện trên cơ sở thói quen, niềm tin tự nhiên, nhiều khi cũng cần sự cưỡng chế, nhưng không do một bộ máy chuyên nghiệp thực hiện mà do toàn thị tộc tự tổ chức thực hiện.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (16, 61, N'Cả A, B và C đều đúng. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (17, 62, N'Có thể có đầy đủ cả ba yếu tố cấu thành QPPL.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (17, 63, N' Có thể chỉ có hai yếu tố cấu thành QPPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (17, 64, N'Có thể chỉ có một yếu tố cấu thành QPPL -> Quy phạm định nghĩa', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (17, 65, N'Cả A, B và C đều đúng ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (18, 66, N' Trong các loại nguồn của pháp luật, chỉ có VBPL là nguồn của pháp luật Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (18, 67, N'Trong các loại nguồn của pháp luật, chỉ có VBPL và tập quán pháp là nguồn của pháp luật Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (18, 68, N'Trong các loại nguồn của pháp luật, chỉ có VBPL và tiền lệ pháp là nguồn của pháp luật Việt Nam', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (18, 69, N'Cả A, B và C đều sai ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (19, 70, N'Viện kiểm sát nhân dân ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (19, 71, N' Tòa án nhân dân ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (19, 72, N'Hội đồng nhân dân; UBND ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (19, 73, N' Quốc hội ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (20, 74, N' NLPL của các chủ thể là giống nhau.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (20, 75, N'NLPL của các chủ thể là khác nhau.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (20, 76, N' NLPL của các chủ thể có thể giống nhau, có thể khác nhau, tùy theo từng trường hợp cụ thể. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (20, 77, N'Cả A, B và C đều sai', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (21, 78, N'Chức năng điều chỉnh các QHXH ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (21, 79, N'Chức năng xây dựng và bảo vệ tổ quốc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (21, 80, N' Chức năng bảo vệ các QHXH ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (21, 81, N'Chức năng giáo dục ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (22, 82, N'Tính bắt buộc chung (hay tính quy phạm phổ biến)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (22, 83, N'Tính xác định chặt chẽ về mặt hình thức ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (22, 84, N' Cả A và B đều đúng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (22, 85, N' Cả A và B đều sai', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (23, 86, N'Tính xác định chặt chẽ về mặt hình thức', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (23, 87, N'Tính được đảm bảo thực hiện bằng nhà nước', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (23, 88, N'Cả A và B đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (23, 89, N'Cả A và B đều sai', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (24, 90, N' Chức năng điều chỉnh các QHXH', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (24, 91, N'Chức năng bảo vệ các QHXH ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (24, 92, N'Chức năng giao dục pháp luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (24, 93, N' Cả A, B và C đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (25, 94, N' Dưới 18 tuổi', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (25, 95, N'Từ đủ 6 tuổi đến dưới 18 tuổi', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (25, 96, N'Từ đủ 15 tuổi đến dưới 18 tuổi', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (25, 97, N'Dưới 21 tuổi', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (26, 98, N' Muốn trở thành chủ thể QHPL thì trước hết phải là chủ thể pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (26, 99, N'Đã là chủ thể QHPL thì là chủ thể pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (26, 100, N' Đã là chủ thể QHPL thì có thể là chủ thể pháp luật, có thể không phải là chủ thể pháp luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (26, 101, N'Cả A và B', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (27, 102, N' Quốc hội', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (27, 103, N'Chính phủ ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (27, 104, N'Tòa án nhân dân ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (27, 105, N'Viện kiểm sát nhân dân ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (28, 106, N'Cơ quan, công chức nhà nước được làm mọi điều mà pháp luật không cấm; Công dân và các tổ chức khác được làm mọi điều mà pháp luật không cấm', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (28, 107, N' Cơ quan, công chức nhà nước được làm những gì mà pháp luật cho phép; Công dân và các tổ chức khác được làm mọi điều mà pháp luật không cấm', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (28, 108, N'Cơ quan, công chức nhà nước được làm mọi điều mà pháp luật không cấm; Công dân và các tổ chức khác được làm những gì mà pháp luật cho phép.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (28, 109, N'Cơ quan, công chức nhà nước được làm những gì mà pháp luật cho phép; Công dân và các tổ chức khác được làm những gì mà pháp luật cho phép.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (29, 110, N'Tòa kinh tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (29, 111, N'Tòa hành chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (29, 112, N'Tòa dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (29, 113, N'Tòa hình sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (30, 114, N'Tuân thủ pháp luật ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (30, 115, N' Thi hành pháp luật ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (30, 116, N'Sử dụng pháp luật ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (30, 117, N'ADPL ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (31, 118, N'Khi không có QPPL áp dụng cho trường hợp đó.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (31, 119, N'Khi có cả QPPL áp dụng cho trường hợp đó và cả QPPL áp dụng cho trường hợp tương tự.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (31, 120, N' Khi không có QPPL áp dụng cho trường hợp đó và không có QPPL áp dụng cho trường hợp tương tự', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (31, 121, N'Khi không có QPPL áp dụng cho trường hợp đó nhưng có QPPL áp dụng cho trường hợp tương tự.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (32, 122, N'Từ khi xuất hiện nhà nước chủ nô ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (32, 123, N' Từ khi xuất hiện nhà nước phong kiến ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (32, 124, N'Từ khi xuất hiện nhà nước tư sản ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (32, 125, N'Từ khi xuất hiện nhà nước XHCN ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (33, 126, N'Tòa án nhân dân huyện ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (34, 127, N'Tòa án nhân dân huyện ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (33, 128, N'Tòa án nhân dân tỉnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (34, 129, N'Tòa án nhân dân tỉnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (33, 130, N'Tòa án nhân dân tối cao ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (34, 131, N'Tòa án nhân dân tối cao ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (33, 132, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (34, 133, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (35, 134, N' Khi có QPPL điều chỉnh QHXH tương ứng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (35, 135, N'Khi xuất hiện chủ thể pháp luật trong trường hợp cụ thể', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (35, 136, N'Khi xảy ra SKPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (35, 137, N' Cả A, B và C ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (36, 138, N'Luật, nghị quyết', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (36, 139, N' Luật, pháp lệnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (36, 140, N' Pháp lệnh, nghị quyết', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (36, 141, N'Pháp lệnh, nghị quyết, nghị định', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (37, 142, N'Ngành luật đó phải có đối tượng điều chỉnh ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (37, 143, N' Ngành luật đó phải có phương pháp điều chỉnh ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (37, 144, N'Ngành luật đó phải có đầy đủ các VBQPPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (37, 145, N'Cả A và B', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (38, 146, N'Nghị định, quyết định ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (38, 147, N'Quyết định, chỉ thị', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (38, 148, N'Quyết định, chỉ thị, thông tư ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (38, 149, N' Nghị định, nghị quyết, quyết định, chỉ thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (39, 150, N'Bù vào những thiệt hại trong cuộc khai thác lần thứ nhất.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (39, 151, N'Để bù đắp những thiệt hại do Chiến tranh thế giới lần thứ nhất gây ra.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (39, 152, N'Để thúc đẩy sự phát triển kinh tế – xã hội ở Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (39, 153, N'Để tăng cường sức mạnh về kinh tế của Pháp đối với các nước tư bản chủ  nghĩa.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (40, 154, N'Chủ tịch Quốc hội ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (40, 155, N'Chủ tịch nước ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (40, 156, N'Tổng bí thư ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (41, 157, N'Bù vào những thiệt hại trong cuộc khai thác lần thứ nhất.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (40, 158, N'Thủ tướng chính phủ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (41, 159, N'Để bù đắp những thiệt hại do Chiến tranh thế giới lần thứ nhất gây ra.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (41, 160, N'Để thúc đẩy sự phát triển kinh tế – xã hội ở Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (42, 161, N'Bù vào những thiệt hại trong cuộc khai thác lần thứ nhất.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (41, 162, N'Để tăng cường sức mạnh về kinh tế của Pháp đối với các nước tư bản chủ  nghĩa.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (42, 163, N'Để bù đắp những thiệt hại do Chiến tranh thế giới lần thứ nhất gây ra.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (42, 164, N'Để thúc đẩy sự phát triển kinh tế – xã hội ở Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (42, 165, N'Để tăng cường sức mạnh về kinh tế của Pháp đối với các nước tư bản chủ  nghĩa.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (43, 166, N'Ban hành mới VBPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (43, 167, N'Sửa đổi, bổ sung các VBPL hiện hành', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (43, 168, N'Đình chỉ, bãi bỏ các VBPL hiện hành', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (43, 169, N' Cả A, B và C.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (44, 170, N'Nghị quyết', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (44, 171, N'Nghị định', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (44, 172, N'Nghị quyết, nghị định ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (44, 173, N'Nghị quyết, nghị định, quyết định ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (45, 174, N'Công nghiệp chế biến', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (45, 175, N'Nông nghiệp và khai thác mỏ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (45, 176, N'Nông nghiệp và thương nghiệp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (45, 177, N'Giao thông vận tải', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (46, 178, N'Cá nhân chịu trách nhiệm dân sự có thể chuyển trách nhiệm này cho cá nhân hoặc cho tổ chức.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (46, 179, N' Cá nhân chịu trách nhiệm dân sự không thể chuyển trách nhiệm này cho cá nhân hoặc tổ chức ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (46, 180, N'Cá nhân chịu trách nhiệm dân sự có thể chuyển hoặc không thể chuyển trách nhiệm này cho cá nhân hoặc tổ chức, tùy từng trường hợp ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (46, 181, N'Cả A, B và C đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (47, 182, N' Mọi hành vi trái pháp luật hình sự được coi là tội phạm ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (47, 183, N'Mọi tội phạm đều đã có thực hiện hành vi trái pháp luật h', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (47, 184, N'Trái pháp luật hình sự có thể bị coi là tội phạm, có thể không bị coi là tội phạm', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (47, 185, N'Cả B và C', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (48, 186, N'Hình thức thực hiện những QPPL mang tính chất ngăn cấm bằng hành vi thụ động, trong đó các chủ thể pháp luật kiềm chế không làm những việc mà pháp luật cấm.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (48, 187, N'Hình thức thực hiện những quy định trao nghĩa vụ bắt buộc của pháp luật một cách tích cực trong đó các chủ thể thực hiện nghĩa vụ của mình bằng những hành động tích cực. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (48, 188, N'Hình thức thực hiện những quy định về quyền chủ thể của pháp luật, trong đó các chủ thể pháp luật chủ động, tự mình quyết định việc thực hiện hay không thực hiện điều mà pháp luật cho phép.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (48, 189, N'Cả A và B', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (49, 190, N'Ở Việt Nam có trữ lượng than lớn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (49, 191, N'Than là nguyên liệu chủ yếu phục vụ cho công nghiệp chính quốc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (49, 192, N'Để phục vụ cho nhu cầu công nghiệp chính quốc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (49, 193, N'Tất cả', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (50, 194, N'Trách nhiệm hành chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (50, 195, N'Trách nhiệm hình sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (50, 196, N'Trách nhiệm dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (50, 197, N'Trách nhiệm kỹ luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (51, 198, N'Hình thức thực hiện những QPPL mang tính chất ngăn cấm bằng hành vi thụ động, trong đó các chủ thể pháp luật kiềm chế không làm những việc mà pháp luật cấm.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (51, 199, N'Hình thức thực hiện những quy định trao nghĩa vụ bắt buộc của pháp luật một cách tích cực trong đó các chủ thể thực hiện nghĩa vụ của mình bằng những hành động tích cực. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (51, 200, N'Hình thức thực hiện những quy định về quyền chủ thể của pháp luật, trong đó các chủ thể pháp luật chủ động, tự mình quyết định việc thực hiện hay không thực hiện điều mà pháp luật cho phép.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (51, 201, N'A và B đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (52, 202, N'Cột chặt nền kinh tế Việt Nam lệ thuộc vào kinh tế Pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (52, 203, N'Biến Việt Nam thành thị trường tiêu thụ hàng hóa do nền công nghiệp Pháp sản xuất', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (52, 204, N'Biến Việt Nam thành căn cứ quân sự và chính trị của Pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (52, 205, N'Câu A và B', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (53, 206, N' Người bị kết án, người bị hại, các đương sự, người có quyền và nghĩa vụ liên quan không đồng ý với phán quyết của tòa án. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (53, 207, N'Phát hiện ra tình tiết mới, quan trọng của vụ án.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (53, 208, N'Có sự vi phạm nghiêm trọng thủ tục tố tụng, vi phạm nghiêm trọng pháp luật trong quá trình giải quyết vụ án. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (53, 209, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (54, 210, N'VBPL chỉ áp dụng trong phạm vi lãnh thổ Việt Nam. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (54, 211, N'VBPL chỉ áp dụng trong một khoảng thời gian nhất định. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (54, 212, N'VBPL không áp dụng đối với những hành vi xảy ra trước thời điểm văn bản đó có hiệu lực pháp luật.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (54, 213, N' Cả A, B và C.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (55, 214, N'Năm 1949, Liên Xô chế tạo thành công bom nguyên tử', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (55, 215, N'Năm 1957, Liên Xô là nước đầu tiên phóng thành công vệ tinh nhân  tạo của trái đất.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (55, 216, N'Năm 1961, Liên Xô đa nhà du hành vũ trụ Ga-ga-rin bay vòng quanh  trái đất', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (55, 217, N'Đến thập kỉ 60 của thế kỷ XX, Liên Xô trở thành cường quốc công  nghiệp đứng thứ hai trên thế giới (sau Mĩ)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (56, 218, N'Luôn luôn chứa đựng các QPPL ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (57, 219, N'Luôn luôn chứa đựng các QPPL ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (56, 220, N'Mang tính cá biệt – cụ thể', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (57, 221, N'Mang tính cá biệt – cụ thể', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (56, 222, N' Nêu lên các chủ trương, đường lối, chính sách ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (57, 223, N' Nêu lên các chủ trương, đường lối, chính sách ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (56, 224, N'Cả A, B và C đều đúng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (57, 225, N'Cả A, B và C đều đúng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (58, 226, N'Ngành luật đất đai ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (58, 227, N'Ngành luật lao động ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (58, 228, N' Ngành luật quốc tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (58, 229, N'Ngành luật đầu tư ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (59, 230, N'Ngành luật đất đai ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (59, 231, N'Ngành luật lao động ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (59, 232, N'Ngành luật quốc tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (59, 233, N'Ngành luật đầu tư ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (60, 234, N'Ngành luật kinh tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (60, 235, N' Ngành luật hành chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (60, 236, N'Ngành luật quốc tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (60, 237, N'Ngành luật cạnh tranh', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (61, 238, N'Ngành luật hành chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (61, 239, N' Ngành luật dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (61, 240, N' Ngành luật quốc tế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (61, 241, N' Ngành luật nhà nước (ngành luật hiến pháp)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (62, 242, N'Công nhân, nông dân, tư sản dân tộc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (62, 243, N'Công nhân, tiểu tư sản, tư sản dân tộc', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (62, 244, N'Công nhân, tư sản dân tộc, địa chủ phong kiến', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (62, 245, N'Công nhân, nông dân, tư sản dân tộc, tiểu tư sản, địa chủ phong kiến', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (63, 246, N'Ngành luật kinh tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (63, 247, N' Ngành luật tài chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (63, 248, N'Ngành luật đất đai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (63, 249, N' Ngành luật dân sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (64, 250, N'Ngành luật dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (64, 251, N'Ngành luật tố tụng dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (64, 252, N'Ngành luật tố tụng hình sự', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (64, 253, N' Ngành luật hành chính', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (65, 254, N'Ngành luật tố tụng hình sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (65, 255, N'Ngành luật tố tụng dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (65, 256, N'Ngành luật hình sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (65, 257, N'Ngành luật dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (66, 258, N' Ngành luật hình sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (66, 259, N' Ngành luật tố tụng hình sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (66, 260, N'Ngành luật dân sự', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (66, 261, N' Ngành luật kinh tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (67, 262, N'Ngành luật hôn nhân và gia đinh ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (67, 263, N'Ngành luật tài chính', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (67, 264, N'Ngành luật nhà nước ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (67, 265, N'Ngành luật tố tụng dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (68, 266, N'Là hệ thống nhỏ trong ngành luật hoặc phân ngành luật', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (68, 267, N'Là một nhóm những các QPPL có quan hệ chặt chẽ với nhau điều chỉnh một nhóm các QHXH cùng loại – những QHXH có cùng nội dung, tính chất có quan hệ mật thiết với nhau. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (68, 268, N'Cả A và B đều đúng ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (68, 269, N'Cả A và B đều sai ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (69, 270, N'Giai cấp nông dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (69, 271, N'Giai cấp công nhân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (69, 272, N'Giai cấp đại địa chủ phong kiến', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (69, 273, N'Giai cấp t sản, dân tộc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (70, 274, N'Ban hành mới; Sửa đổi, bổ sung', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (70, 275, N'Đình chỉ; Bãi bỏ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (70, 276, N'Thay đổi phạm vi hiệulực ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (70, 277, N'Cả A, B và C', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (71, 278, N'Nội dung phải đúng thẩm quyền cơ quan và người ký (ban hành) phải là người có thẩm quyền ký. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (71, 279, N'Phải phù hợp với văn bản của cấp trên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (71, 280, N'Phải phù hợp với lợi ích của nhà nước và lợi ích hợp pháp của công dân. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (71, 281, N'Cả A, B và C ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (72, 282, N'Có thái độ kiên định với Pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (72, 283, N'Có thái độ không kiên định, dễ thoải hiệp, cải lương khi đế quốc mạnh', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (72, 284, N'Có tinh thần đấu tranh cách mạng triệt để trong sự nghiệp giải phóng  dân tộc.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (72, 285, N'Tất cả đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (73, 286, N'Lực lượng sản xuất', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (73, 287, N'Cơ sở hạ tầng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (73, 288, N' Kiến trúc thượng tầng ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (73, 289, N'Quan hệ sản xuất ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (74, 290, N'Quyết định ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (74, 291, N'Nghị định ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (74, 292, N'Thông tư ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (74, 293, N'Chỉ thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (75, 294, N'Công nhân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (75, 295, N'Nông dân', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (75, 296, N'Tiểu tư sản', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (75, 297, N'Tư sản dân tộc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (76, 298, N'16 Bộ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (76, 299, N'17 Bộ ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (77, 300, N'16 Bộ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (76, 301, N'18 Bộ ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (77, 302, N'17 Bộ ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (76, 303, N' 19 Bộ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (77, 304, N'18 Bộ ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (77, 305, N' 19 Bộ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (78, 306, N'Nguồn của pháp luật nói chung là: VBPL. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (78, 307, N' Nguồn của pháp luật nói chung là: VBPL; tập quán pháp.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (78, 308, N'Nguồn của pháp luật nói chung là: VBPL; tập quán pháp; và tiền lệ pháp.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (78, 309, N'Cả A, B và C đều sai', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (79, 310, N'Nếu năm 1950, Liên Xô sản xuất đợc 27,3 triệu tấn thép thì đến năm  1970 sản xuất đợc 115,9 triệu tấn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (79, 311, N'Năm 1950, tổng sản lượng công nghiệp của Liên Xô sản xuất tăng  73% so với trước chiến tranh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (79, 312, N'Từ 1951 đến 1975, mức tăng trưởng của Liên Xô hàng năm đạt 9,6%', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (79, 313, N'Từ giữa thập kỉ 70 của thế kỉ XX, sản xuất công nghiệp của Liên Xô đạt khoảng 20% sản lượng công nghiệp của thế giới.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (80, 314, N'Mọi công dân Việt Nam đều có quyền tự do kinh doanh theo quy định của pháp luật.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (80, 315, N'Mọi công dân Việt Nam được quyền tự do kinh doanh theo quy định của pháp luật, trừ cán bộ, công chức. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (80, 316, N' Mọi công dân Việt Nam được quyền tự do kinh doanh theo quy định của pháp luật, trừ đảng viên. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (80, 317, N'Cả A và B đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (81, 318, N'Kiểu pháp luật sau bao giờ cũng kế thừa kiểu pháp luật trước ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (81, 319, N' Kiểu pháp luật sau bao giờ cũng tiến bộ hơn kiểu pháp luật trước', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (81, 320, N' Kiểu pháp luật sau chỉ tiến bộ hơn kiểu pháp luật trước nhưng không kế thừa kiểu pháp luật trước', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (81, 321, N'Cả A và B đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (82, 322, N'Hội Việt Nam cách mạng thanh niên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (82, 323, N'Việt Nam quốc dân đảng.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (82, 324, N'Tân Việt cách mạng đảng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (82, 325, N'Đông Dương Cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (83, 326, N'Tính bắt buộc chung (hay tính quy phạm phổ biến) ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (83, 327, N'Tính xác định chặt chẽ về mặt hình thức', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (83, 328, N'Tính được đảm bảo thực hiện bằng nhà nước ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (83, 329, N'Cả A, B và C đều đúng ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (84, 330, N'Chỉ có Nhà nước mới có quyền ban hành pháp luật để quản lý xã hội.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (84, 331, N'Không chỉ nhà nước mà cả TCXH cũng có quyền ban hành pháp luật.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (84, 332, N'TCXH chỉ có quyền ban hành pháp luật khi được nhà nước trao quyền. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (84, 333, N' Cả A và C', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (85, 334, N'“Chuông rè”, “An Nam trẻ”, “Nhành lúa”...', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (85, 335, N'“Tin tức”, “Thời mới”, “Tiếng dân” ...', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (85, 336, N'“Chuông rè”, “Tin tức”, “Nhành lúa”, ...', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (85, 337, N'“Chuông rè”, “An Nam trẻ”, “Người nhà quê” ...', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (86, 338, N' Khoảng không gian trong phạm vi lãnh thổ Việt Nam trừ đi phần lãnh thổ của đại sứ quán nước ngoài và phần không gian trên tàu bè nước ngoài hoạt động trên lãnh thổ Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (86, 339, N'Khoảng không gian trong phạm vi lãnh thổ Việt Nam và phần lãnh thổ trong sứ quán Việt Nam tại nước ngoài, phần không gian trên tàu bè mang quốc tịch Việt Nam đang hoạt động ở nước ngoài.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (86, 340, N'Khoảng không gian trong phạm vi lãnh thổ Việt Nam và phần lãnh thổ trong sứ quán Việt Nam tại nước ngoài, phần không gian trên tàu bè mang quốc tịch Việt Nam đang hoạt động ở nước ngoài, nhưng trừ đi phần lãnh thổ của đại sứ quán nước ngoài, phần không gian trên tàu bè nước ngoài hoạt động trên lãnh thổ Việt Nam. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (86, 341, N'Cả A, B và C đều sai ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (87, 342, N'Áp dụng cho một lần duy nhất và hết hiệu lực sau lần áp dụng đó.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (87, 343, N'Áp dụng cho một lần duy nhất và vẫn còn hiệu lực sau lần áp dụng đó. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (87, 344, N'Áp dụng cho nhiều lần và vẫn còn hiệu lực sau những lần áp dụng đó', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (87, 345, N' Áp dụng cho nhiều lần và hết hiệu lực sau những lần áp dụng đó. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (88, 346, N'Quy phạm đạo đức ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (88, 347, N'Quy phạm tập quán ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (88, 348, N' QPPL ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (88, 349, N'Quy phạm tôn giáo ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (89, 350, N'Cuộc bãi công của công nhân Ba Son.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (89, 351, N'Cuộc đấu tranh đòi nhà cầm quyền Pháp thả Phan Bội Châu (1925).', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (89, 352, N'Phong trào để tang Phan Châu Trinh (1926)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (89, 353, N'Tiếng bom Phạm Hồng Thái tại Sa Diện- Quảng Châu (6/1924)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (90, 354, N'Thể hiện ý chí của giai cấp thống trị; Nội dung thể hiện quan hệ bất bình đẳng trong xã hội', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (90, 355, N'Có tính bắt buộc chung, tính hệ thống và thống nhất cao.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (90, 356, N'Được bảo đảm thực hiện bằng nhà nước, chủ yếu bởi sự cưỡng chế. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (90, 357, N'Cả A, B và C đều đúng ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (91, 358, N'Hệ tư tưởng dân chủ tư sản đã trở nên lỗi thời, lạc hậu.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (91, 359, N'Thực dân Pháp còn mạnh, đủ khả năng đàn áp phong trào.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (91, 360, N'Giai cấp tư sản dân tộc do yếu kém về kinh tế nên ơn hèn về chính trị;  tầng lớp tiểu tư sản do điều kiện kinh tế bấp bênh nên không thể lãnh  đạo phong trào cách mạng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (91, 361, N'Do chủ nghĩa Mác – Lê nin được truyền bá sâu rộng vào Việt Nam', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (92, 362, N'Tòa hình sự', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (92, 363, N'Tòa hình sự, tòa kinh tế ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (92, 364, N'Tòa hành chính, tòa hình sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (92, 365, N'Tòa dân sự, tòa hành chính ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (93, 366, N'Muốn làm bạn với tất cả các nước', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (93, 367, N'Chỉ quan hệ với các nước lớn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (93, 368, N'Hòa bình và tích cực ủng hộ cách mạng thế giới', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (93, 369, N'Chỉ làm bạn với các nước xã hội chủ nghĩa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (94, 370, N'Người lao động và người sử dụng lao động ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (94, 371, N'Người sử dụng lao động và đại diện người lao động', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (94, 372, N'Người lao động và đại diện người lao động', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (94, 373, N'Cả A, B và C ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (95, 374, N'Chức năng lập hiến và lập pháp ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (95, 375, N'Chức năng giám sát tối cao', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (95, 376, N'Chức năng điều chỉnh các QHXH ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (95, 377, N'Cả A, B và C đều đúng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (96, 378, N' Bất kỳ cá nhân, tổ chức nào trong một nhà nước.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (96, 379, N'Cá nhân, tổ chức được nhà nước công nhận có khả năng tham gia vào các QHPL', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (96, 380, N'Cá nhân, tổ chức cụ thể có được những quyền và mang những nghĩa vụ pháp lý nhất định được chỉ ra trong các QHPL cụ thể. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (96, 381, N'Cả A, B và C ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (97, 382, N'Bác Hồ ra đi tìm đường cứu nước.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (97, 383, N'Bác Hồ đọc tuyên ngôn độc lập.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (97, 384, N'Bác Hồ đọc sơ thảo luận cương của Lênin', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (97, 385, N'Bác Hồ đa yêu sách đến Hội nghị Vecxai.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (98, 386, N'QPPL mang tính bắt buộc chung.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (98, 387, N' Các quy phạm xã hội không phải là QPPL cũng mang tính bắt buộc chung.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (98, 388, N' Các quy phạm xã hội không phải là QPPL cũng mang tính bắt buộc chung.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (98, 389, N'Cả A và C', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (99, 390, N'ĐCS Việt Nam ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (99, 391, N'Tổng liên đoàn lao động Việt Nam ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (99, 392, N' Hội liên hiệp phụ nữ Việt Nam ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (99, 393, N'Đoàn thanh niên cộng sản Hồ Chí Minh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (100, 394, N'Cuộc bãi công của công nhân thợ nhuộm Chợ Lớn (1922)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (100, 395, N'Cuộc tổng bãi công của công nhân Bắc Kỳ (1922)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (100, 396, N'Bãi công của thợ máy xởng Ba Son cảng Sài Gòn ngăn cản tàu chiến  Pháp đi đàn áp cách mạng ở Trung Quốc (8/1925)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (100, 397, N'Cuộc bãi công của 1000 công nhân nhà máy sợi Nam Định', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (101, 398, N'Khả năng của chủ thể có được các quyền chủ thể và mang các nghĩa vụ pháp lý mà nhà nước thừa nhận', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (101, 399, N'Khả năng của chủ thể được nhà nước thừa nhận, bằng các hành vi của mình thực hiện các quyền chủ thể và nghĩa vụ pháp lý, tham gia vào các QHPL. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (101, 400, N'Cả A và B đều đúng. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (101, 401, N'Cả A và B đều sai ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (102, 402, N'Từ đủ 16 tuổi ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (102, 403, N'Từ đủ 18 tuổi', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (102, 404, N'Từ đủ 21 tuổi ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (102, 405, N'Từ đủ 25 tuổi', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (103, 406, N'Bãi công của thợ máy xưởng Ba Son cảng Sài Gòn (8/1925)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (103, 407, N'Nguyễn Ái Quốc đọc sơ thảo Luận cương của Lênin về vấn đề dân tộc và thuộc địa (7/1920)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (103, 408, N'Tiếng bom của Phạm Hồng Thái vang dội ở Sa Diện-Quảng Châu (6/1924)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (103, 409, N'Nguyễn ái Quốc gửi yêu sách đến Hội nghị Vecxai (1919)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (104, 410, N'Hình phạt nghiêm khắc của nhà nước đối với người có hành vi vi phạm pháp luật.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (104, 411, N'Những hậu quả pháp lý bất lợi có thể áp dụng đối với người không thực hiện hoặc thực hiện không đúng quy định của QPPL. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (104, 412, N'Biện pháp cưỡng chế nhà nước áp dụng đối với người vi phạm pháp luật. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (104, 413, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (105, 414, N'VBPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (105, 415, N'VBPL và tập quán pháp', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (105, 416, N'VBPL, tập quán pháp và tiền lệ pháp', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (105, 417, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (106, 418, N'Nguyễn ái Quốc đa yêu sách đến Hội nghị Vecxai (18/6/1919)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (106, 419, N'Nguyễn Ái Quốc tham gia sáng lập Đảng Cộng sản Pháp (12/1920)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (106, 420, N'Nguyễn ái Quốc đọc sơ thảo luận cương của Lênin về vấn đề dân tộc và thuộc địa (7/1920)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (107, 421, N'Mà không thể nhận thức, làm chủ được hành vi của mình. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (106, 422, N'Nguyễn ái Quốc thành lập tổ chức Hội Việt Nam cách mạng thanh niên(6/1925)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (107, 423, N'Mà không thể nhận thức, làm chủ được hành vi của mình thì theo yêu cầu của người có quyền, lợi ích liên quan, Tòa án ra quyết định tuyên bố mất NLHV dân sự kể cả khi chưa có kết luận của tổ chức giám định.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (107, 424, N'Mà không thể nhận thức, làm chủ được hành vi của mình thì theo yêu cầu của người có quyền, lợi ích liên quan, Tòa án ra quyết định tuyên bố mất NLHV dân sự trên cơ sở kết luận của tổ chức giám định.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (107, 425, N'Cả A, B và C đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (108, 426, N'Hành vi vi phạm pháp luật là hành vi thực hiện pháp luật.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (108, 427, N'Hành vi vi phạm pháp luật không phải là hành vi thực hiện pháp luật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (108, 428, N'Hành vi vi phạm pháp luật cũng có thể là hành vi thực hiện pháp luật cũng có thể không phải là hành vi thực hiện pháp luật. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (108, 429, N'Cả A, B và C đều đúng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (109, 430, N'Triệt phá âm mu lật đổ chính quyền cách mạng của bọn phản động', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (109, 431, N'Cải cách ruộng đất', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (109, 432, N'Quốc hữu hóa xí nghiệp của tư bản', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (109, 433, N'Thực hiện các quyền tự do dân chủ cho nhân dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (110, 434, N'Khi không có QPPL áp dụng cho trường hợp đó. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (110, 435, N'Khi không có QPPL áp dụng cho trường hợp đó nhưng có QPPL áp dụng cho trường hợp tương tự.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (110, 436, N' Khi có cả QPPL áp dụng cho trường hợp đó và có cả QPPL áp dụng cho trường hợp tương tự.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (110, 437, N'Khi không có QPPL áp dụng cho trường hợp đó và không có cả QPPL áp dụng cho trường hợp tương tự.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (111, 438, N'Cơ quan của TCXH có quyền thực hiện hình thức ADPL', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (111, 439, N'Cơ quan của TCXH không có quyền thực hiện hình thức ADPL.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (111, 440, N'Cơ quan của TCXH chỉ có quyền thực hiện hình thức ADPL khi được nhà nước trao quyền. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (111, 441, N'Cả A, B và C đều sai ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (112, 442, N'Nghị định, quyết định ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (112, 443, N'Nghị định, quyết định, chỉ thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (112, 444, N'Quyết định, chỉ thị, thông tư ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (112, 445, N'Quyết định, chỉ thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (113, 446, N'Của Lênin – trong sơ thảo luận cương về vấn đề dân tộc và thuộc địa', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (113, 447, N'Của Mác- Ănghen trong tuyên ngôn Đảng Cộng sản ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (113, 448, N'Của Nguyễn ái Quốc trong tuyên ngôn của Hội liên hiệp thuộc địa', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (113, 449, N'Tất cả đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (114, 450, N' Văn bản chủ đạo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (114, 451, N' VBQPPL ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (114, 452, N' Văn bản ADPL hay văn bản cá biệt – cụ thể ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (114, 453, N'Cả A, B và C', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (115, 454, N'Nghị định, quyết định ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (115, 455, N'Nghị định, quyết định, thông tư', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (115, 456, N'Nghị định, quyết định, thông tư, chỉ thị ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (115, 457, N'Quyết định, thông tư, chỉ thị ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (116, 458, N'6/1924', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (116, 459, N'6/1922', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (116, 460, N'12/1923', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (116, 461, N'6/1923', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (117, 462, N'Thực hiện các QPPL cho phé', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (117, 463, N'Thực hiện các QPPL bắt buộc.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (117, 464, N'Thực hiện các QPPL cấm đoán. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (117, 465, N'Cả B và C', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (118, 466, N'Bộ Luật ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (118, 467, N'Pháp lệnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (118, 468, N'Thông tư ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (118, 469, N'Chỉ thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (119, 470, N'Phải chịu trách nhiệm pháp lý ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (119, 471, N'Không phải chịu trách nhiệm pháp lý ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (119, 472, N'Có thể phải chịu trách nhiệm pháp lý hoặc không, tùy theo từng trường hợp cụ thể', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (119, 473, N'Cả A, B và C đều sai', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (120, 474, N'gười dự đại hội Nông dân quốc tế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (120, 475, N'Người dự đại hội lần thứ V của quốc tế cộng sản', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (120, 476, N'Người dự đại hội quốc tế phụ nữ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (120, 477, N'Người dự đại hội quốc tế VII của quốc tế cộng sản', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (121, 478, N'Đạo luật là văn bản chứa các QPPL, là nguồn của ngành luật ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (121, 479, N'Ngành luật là văn bản chứa các QPPL, là nguồn của đạo luật ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (121, 480, N'Cả A và B đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (121, 481, N'Cả A và B đều sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (122, 482, N'Ngành luật hiến pháp (ngành luật nhà nước) ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (122, 483, N'Ngành luật dân sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (122, 484, N'Ngành luật hôn nhân và gia đình ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (122, 485, N'Ngành luật hàng hải', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (123, 486, N'Quá trình chuẩn bị về tư tưởng chính trị và tổ chức cho sự thành lập Đảng Cộng sản Việt Nam 3/2/1930', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (123, 487, N'Quá trình truyền bá chủ nghĩa Mác – Lênin vào Việt Nam ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (123, 488, N'Quá trình thành lập ba tổ chức Cộng sản ở Việt Nam', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (123, 489, N'Quá trình thực hiện chủ trương “Vô sản hóa” để truyền bá chủ nghĩa Mác – Lênin vào Việt Nam ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (124, 490, N'Ngành luật lao động ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (124, 491, N'Ngành luật hôn nhân và gia đình', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (124, 492, N'Ngành luật tố tụng dân sự ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (124, 493, N'Ngành luật nhà ở', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (125, 494, N'Ngành luật lao động ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (125, 495, N'Ngành luật hành chính', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (125, 496, N'Ngành luật hình sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (125, 497, N'Ngành luật tố tụng hình sự ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (126, 498, N'Cải thiện một bước đời sống cho nhân dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (126, 499, N'Thực hiện một số quyền tự do dân chủ cho nhân dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (126, 500, N'Tạo điều kiện để Đông Âu bước vào giai đoạn xây dựng chủ nghĩa xã hội ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (126, 501, N'Tăng cường sức mạnh bảo vệ hòa bình thế giới và góp phần hình thành hệ thông xã hội chủ nghĩa từ năm 1949', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (127, 502, N'Tháng 5/1925 ở Quảng Châu (Trung Quốc).', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (127, 503, N'Tháng 6/1925 ở Hương Cảng (Trung Quốc)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (127, 504, N'Tháng 7/1925 ở Quảng Châu (Trung Quốc)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (127, 505, N'Tháng 6/1925 ở Quảng Châu (Trung Quốc)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (128, 506, N'Tạp chí Thế tín Quốc tế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (128, 507, N'“Bản án chế độ thực dân Pháp”', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (128, 508, N'“Đường cách mệnh”', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (128, 509, N'Tất cả cùng đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (129, 510, N'Công nhân và nông dân, hoạt động ở Trung Kì', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (129, 511, N'Tư sản dân tộc, công nhân, hoạt động ở Bắc Kì', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (129, 512, N'Trí thức trẻ và thanh niên tiểu tư sản, hoạt động ở Trung Kì', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (129, 513, N'Tất cả các giai cấp và tầng lớp, hoạt động ở Nam Kì', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (130, 514, N'Một số đảng viên tiên tiến chuyển sang Hội Việt Nam cách mạng thanh niên', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (130, 515, N'Một số tiên tiến còn lại tích cực chuẩn bị tiến tới thành lập một chính đảng kiểu mới theo chủ nghĩa Mác – Lênin.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (130, 516, N'Một số gia nhập vào Việt Nam quốc dân đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (130, 517, N'Câu A và B đều đúng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (131, 518, N'Trên 12º vĩ. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (131, 519, N'Gần 15º vĩ.    ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (131, 520, N'Gần 17º vĩ.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (131, 521, N'Gần 18º vĩ.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (132, 522, N'Vùng nước tiếp giáp với đất liền nằm ven biển.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (132, 523, N'Vùng nước tiếp giáp với đất liền phía bên trong đường cơ sở.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (132, 524, N'Vùng nước cách đường cơ sở 12 hải lí.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (132, 525, N'Vùng nước cách bờ 12 hải lí.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (133, 526, N'Cầu Treo. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (133, 527, N'Xà Xía. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (133, 528, N'Mộc Bài. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (133, 529, N'Lào Cai.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (134, 530, N'Nằm cách bờ biển 12 hải lí.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (134, 531, N'Nối các điểm có độ sâu 200 m.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (134, 532, N'Nối các mũi đất xa nhất với các đảo ven bờ.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (134, 533, N'Tính từ mức nước thủy triều cao nhất đến các đảo ven bờ.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (135, 534, N'Tây Trang, Cầu Treo, Lao Bảo, Bờ Y.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (135, 535, N'Cầu Treo, Tân Thanh, Lao Bảo, Bờ Y.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (135, 536, N'Bờ Y, Lao Bảo, Cầu Treo, Tây Trang.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (135, 537, N'Lao Bảo, Cầu Treo, Tây Trang, Bờ Y.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (136, 538, N'Tiến lên chế độ xã hội chủ nghĩa', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (136, 539, N'Tiến lên chế độ t bản chủ nghĩa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (136, 540, N'Một số nước tiến lên xã hội chủ nghĩa, một số nước tiến lên tư bản chủ nghĩa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (136, 541, N'Một số nước thực hiện chế độ trung lập', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (137, 542, N'Lãnh thổ kéo dài từ 8º34''B đến 23º23''B nên thiên nhiên có sự phân hoá đa dạng.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (137, 543, N'Nằm hoàn toàn trong miền nhiệt đới Bắc bán cầu thuộc khu vực châu Á gió mùa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (137, 544, N'Nằm ở vị trí tiếp giáp giữa lục địa và hải dương trên vành đai sinh khoáng của thế giới.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (137, 545, N'Nằm ở vị trí tiếp giáp giữa lục địa và hải dương trên đường di lưu của các loài sinh vật.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (138, 546, N'Hải Phòng.   ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (138, 547, N'Cửa Lò.    ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (138, 548, N'Đà Nẵng.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (138, 549, N'Nha Trang', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (139, 550, N'Nước ta nằm hoàn toàn trong vùng nội chí tuyến.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (139, 551, N'Nước ta nằm ở trung tâm vùng Đông Nam Á.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (139, 552, N'Nước ta nằm ở vị trí tiếp giáp của nhiều hệ thống tự nhiên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (139, 553, N'Nước ta nằm tiếp giáp Biển Đông với chiều dài bờ biển trên 3260 km.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (140, 554, N'Đánh đuổi thực dân Pháp. xóa bỏ ngôi vua.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (140, 555, N'Đánh đuổi thực dân Pháp, thiết lập dân quyền', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (140, 556, N'Đánh đuổi giặc Pháp, đánh đổ ngôi vua, thiết lập dân quyền', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (140, 557, N'Đánh đổ ngôi vua, đánh đuổi giặc Pháp, lập nên nước Việt Nam độc lập', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (141, 558, N'Tỉnh Khánh Hoà.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (141, 559, N'Thành phố Đà Nẵng.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (141, 560, N'Tỉnh Quảng Ngãi. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (141, 561, N'Tỉnh Bà Rịa - Vũng Tàu.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (142, 562, N'Gió mậu dịch. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (142, 563, N'Gió mùa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (142, 564, N'Gió phơn.          ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (142, 565, N'Gió địa phương.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (143, 566, N'Phát triển nền nông nghiệp nhiệt đới.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (143, 567, N'Mở rộng quan hệ hợp tác với các nước trong khu vực Đông Nam Á và thế giới.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (143, 568, N'Phát triển các ngành kinh tế biển.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (143, 569, N'Tất cả các thuận lợi trên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (144, 570, N'Có chủ quyền hoàn toàn về thăm dò, khai thác, bảo vệ, quản lí các tất cả các nguồn tài nguyên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (144, 571, N'Cho phép các nước tự do hàng hải, hàng không, đặt ống dẫn dầu, cáp quang ngầm.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (144, 572, N'Cho phép các nước được phép thiết lập các công trình nhân tạo phục vụ cho thăm dò, khảo sát biển.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (144, 573, N'Tất cả các ý trên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (145, 574, N'Được thiết lập các công trình và các đảo nhân tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (145, 575, N'Được tổ chức khảo sát, thăm dò các nguồn tài nguyên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (145, 576, N'Được tự do hàng hải, hàng không, đặt ống dẫn dầu và cáp quang biển.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (145, 577, N'Tất cả các ý trên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (146, 578, N' Thuận lợi cho việc trao đổi, hợp tác, giao lưu với các nước trong khu vực và thế giới.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (146, 579, N'Thuận lợi cho phát triển các ngành kinh tế, các vùng lãnh thổ; tạo điều kiện thực hiện chính sách mở cửa, hội nhập với các nước và thu hút đầu tư của nước ngoài.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (146, 580, N'Thuận lợi trong việc hợp tác sử dụng tổng hợp các nguồn lợi của Biển Đông, thềm lục địa và sông Mê Công với các nước có liên quan.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (146, 581, N'Thuận lợi cho việc hợp tác kinh tế, văn hóa, khoa học - kĩ thuật với các nước trong khu vực châu Á - Thái Bình Dương.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (147, 582, N'Vị trí địa lí và hình dáng lãnh thổ quy định.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (147, 583, N'Ảnh hưởng của các luồng gió thổi theo mùa từ phương bắc xuống và từ phía nam lên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (147, 584, N'Sự phân hóa phức tạp của địa hình vùng núi, trung du và đồng bằng ven biển.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (147, 585, N'Ảnh hưởng của Biển Đông cùng với các bức chắn địa hình.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (148, 586, N'Phú Thọ, Hải Dương, Hà Tĩnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (148, 587, N'Hòa Bình, Lai Châu, Sơn La', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (148, 588, N'Vĩnh Yên, Phúc Yên, Yên Thế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (148, 589, N'Phú Thọ, Hải Dương, Thái Bình', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (149, 590, N'Phú Thọ, Hải Dương, Hà Tĩnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (149, 591, N'Hòa Bình, Lai Châu, Sơn La', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (149, 592, N'Vĩnh Yên, Phúc Yên, Yên Thế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (149, 593, N'Phú Thọ, Hải Dương, Thái Bình', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (150, 594, N'Phú Thọ, Hải Dương, Hà Tĩnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (150, 595, N'Hòa Bình, Lai Châu, Sơn La', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (150, 596, N'Vĩnh Yên, Phúc Yên, Yên Thế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (150, 597, N'Phú Thọ, Hải Dương, Thái Bình', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (151, 598, N'Phú Thọ, Hải Dương, Hà Tĩnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (151, 599, N'Hòa Bình, Lai Châu, Sơn La', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (151, 600, N'Vĩnh Yên, Phúc Yên, Yên Thế', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (151, 601, N'Phú Thọ, Hải Dương, Thái Bình', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (152, 602, N'Tài nguyên đất.    ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (152, 603, N'Tài nguyên biển.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (152, 604, N'Tài nguyên rừng.    ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (152, 605, N'Tài nguyên khoáng sản.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (153, 606, N'Đông Dương cộng sản đảng, An Nam cộng sản đảng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (153, 607, N'Đông Dương cộng sản đảng, An Nam cộng sản đảng và Đông Dương  cộng sản liên đoàn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (153, 608, N'Đông Dương cộng sản đảng, Đông Duơng cộng sản liên đoàn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (153, 609, N'Tất cả sai', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (154, 610, N'Ngành công nghiệp năng lượng; ngành nông nghiệp và giao thông vận tải, du lịch.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (154, 611, N'Ngành khai thác, nuôi trồng và chế biển thủy sản nước ngọt.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (154, 612, N'Ngành giao thông vận tải và du lịch.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (154, 613, N'Ngành trồng cây lương thực - thực phẩm.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (155, 614, N'Nam Trung Quốc và Đông Bắc Đài Loan.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (155, 615, N'Phía đông Phi - líp - pin và phía tây của Việt Nam.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (155, 616, N'Phía đông Việt Nam và tây Phi - líp - pin.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (155, 617, N'Phía bắc của Xin - ga - po và phía nam Ma - lai - xi - a.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (156, 618, N'Trung Quốc và Lào.            ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (156, 619, N'Lào và Cam - pu - chia.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (156, 620, N'Cam - pu - chia và Trung Quốc.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (156, 621, N'Trung Quốc, Lào và Cam - pu - chia', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (157, 622, N'Đông Dương cộng sản liên đoàn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (157, 623, N'Đông Dương cộng sản đảng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (157, 624, N'An Nam cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (157, 625, N'Đông Dương cộng sản đảng và An Nam cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (158, 626, N'Đường ô tô và đường sắt.         ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (158, 627, N' Đường biển và đường sắt.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (158, 628, N'Đường hàng không và đường biển.  ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (158, 629, N'Đường ô tô và đường biển.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (159, 630, N'Cộng hòa dân chủ Đức', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (159, 631, N'Tiệp Khắc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (159, 632, N'Rumani', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (159, 633, N'Hunggari', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (160, 634, N' Diễn ra trong khoảng 475 triệu năm.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (160, 635, N'Chịu tác động của các kì vận động tạo núi Calêđôni và Hecxini.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (160, 636, N'Chỉ diễn ra trên một bộ phận nhỏ của lãnh thổ nước ta.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (160, 637, N'Chịu tác động của vận động tạo núi Anpi và biến đổi khí hậu toàn cầu.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (161, 638, N'Tư tưởng của chủ nghĩa Mác – Lênin ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (161, 639, N'Tư tưởng Tam dân của Tôn Trung Sơn', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (161, 640, N'Tư tưởng dân chủ tư sản của đảng Quốc Đại ở ấn Độ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (161, 641, N'Tư tưởng của cách Minh Trị ở Nhật Bản', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (162, 642, N' Đại Trung sinh của giai đoạn Cổ kiến tạo.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (162, 643, N'Đại Cổ sinh của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (162, 644, N'Kỉ Đệ tứ của giai đoạn Tân kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (162, 645, N' Đại Nguyên sinh của giai đoạn tiền Cambri.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (163, 646, N'Cùng được hình thành trong đại Cổ sinh của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (163, 647, N'Cùng được hình thành trong đại Trung sinh của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (163, 648, N' Cùng được hình thành trong giai đoạn Cổ kiến tạo.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (163, 649, N'Cùng được hình thành trong giai đoạn Tân kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (164, 650, N'Nguyễn Thái Học, Phạm Tuấn Tài, Nguyễn Khác Nhu, Tôn Trung  Sơn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (164, 651, N'Nguyễn Thái Học, Phạm Tuấn Tài, Nguyễn Khắc Nhu, Phó Đức Chính', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (164, 652, N'Nguyễn Thái Học, Phạm Tuấn Tài, Nguyễn Khắc Nhu, Nguyễn Phan Long', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (164, 653, N'Nguyễn Thái Học, Nguyễn Phan Long, Bùi Quang Chiêu, Phó Đức Chính', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (165, 654, N'Sự có mặt của các hoá thạch san hô ở nhiều nơi.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (165, 655, N'Sự có mặt của các hoá thạch than ở nhiều nơi.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (165, 656, N'Đá biến chất có tuổi 2,3 tỉ năm được tìm thấy ở Kon Tum.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (165, 657, N'Các đá trầm tích biển phân bố rộng khắp trên cả nước.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (166, 658, N'Kỉ Đệ tứ của giai đoạn Tân kiến tạo.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (166, 659, N'Kỉ Nêôgen của giai đoạn Tân kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (166, 660, N' Đại Trung sinh của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (166, 661, N'Đại Cổ sinh của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (167, 662, N'Chủ nghĩa Mác – Lênin với phong trào công nhân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (167, 663, N'Chủ nghĩa Mác – Lênin với tư tưởng Hồ Chí Minh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (167, 664, N'Chủ nghĩa Mác – Lênin với phong trào công nhân và phong trào yêu nước ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (167, 665, N'Chủ nghĩa Mác – Lênin với phong trào công nhân và phong trào tư sản yêu nước', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (168, 666, N'Giai đoạn tiền Cambri.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (168, 667, N'Thời kì đầu của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (168, 668, N'Thời kì sau của giai đoạn Cổ kiến tạo.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (168, 669, N'Giai đoạn Tân kiến tạo.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (169, 670, N'Đông Dương cộng sản đảng, An Nam cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (169, 671, N'Đông Dương cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (169, 672, N'Đông Dương cộng sản liên đoàn', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (169, 673, N'An Nam cộng sản đảng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (170, 674, N'Các đá trầm tích biển được tìm thấy ở nhiều nơi.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (170, 675, N' Ngày càng phát hiện nhiều mỏ khoáng sản có nguồn gốc ngoại sinh.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (170, 676, N'Quá trình phong hoá vẫn tiếp tục, sinh vật và thổ nhưỡng ngày càng phong phú.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (170, 677, N' Khí hậu toàn cầu đang thay đổi theo hướng ngày càng nóng lên.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (171, 678, N'Thành quả của cách mạng dân chủ nhân dân (1946-1949) và nhiệt tình của nhân dân   ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (171, 679, N'Sự hoạt động và hợp tác của Hội đồng tương trợ kinh tế (SEV)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (171, 680, N'Sự giúp đỡ của Liên Xô', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (171, 681, N'Sự hợp tác giữa các nước Đông Âu', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (172, 682, N'Làm cách mạng tư sản dân quyền và cách mạng ruộng đất để tiến lên chủ nghĩa cộng sản ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (172, 683, N'Thực hiện cách mạng ruộng đất cho triệt để', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (172, 684, N'Tịch thu hết sản nghiệp của bọn đế quốc', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (172, 685, N'Đánh đổ địa chủ phong kiến, làm cách mạng thổ địa sau đó làm cách mạng dân tộc ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (173, 686, N' Các dãy núi ở Tây Bắc và Bắc Trung Bộ.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (173, 687, N' Các khối núi cao ở Cao Bằng, Lạng Sơn.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (173, 688, N'Các khối núi cao ở Nam Trung Bộ.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (173, 689, N'Khối nâng Việt Bắc, địa khối Kon Tum.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (174, 690, N'Giai đoạn tiền Cambri.   ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (174, 691, N'Giai đoạn Cổ kiến tạo.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (174, 692, N'Giai đoạn Tân kiến tạo.   ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (174, 693, N'Đại Nguyên sinh và Cổ sinh.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (175, 694, N'Công nhân và nông dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (175, 695, N'Công nhân, nông dân và các tầng  lớp tiểu t sản, trí thức, trung nông', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (175, 696, N'Công nhân, nông dân, tiểu tư sản, tư sản và địa chủ phong kiến', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (175, 697, N'Tất cả đều đúng', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (176, 698, N' Calêđôni và Kimêri.  ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (176, 699, N'Inđôxini và Kimêri.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (176, 700, N'Inđôxini và Calêđôni. ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (176, 701, N'Calêđôni và Hecxini.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (177, 702, N'Cách mạng Việt Nam trải qua hai giai đoạn: cách mạng tư sản dân quyền và cách mạng xã hội chủ nghĩa ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (177, 703, N'Nhân tố quyết đinh mọi thắng lợi của cách mạng Việt Nam là Đảng của giai cấp vô sản lãnh đạo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (177, 704, N'Nhiệm vụ của cách mạng Việt Nam là đánh đế quốc trớc, đánh phong kiến sau?', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (177, 705, N'Câu A và B đúng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (178, 706, N'Luận cương chính trị tháng 10 năm 1930 do đồng chí Trần Phú soạn thảo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (178, 707, N'Lời kêu gọi Hội nghị hợp nhất thành lập Đảng (2-1930)', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (178, 708, N'Cương lĩnh chính trị của Đảng do đồng chí Nguyễn Ái Quốc khởi thảo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (178, 709, N'Câu A và B đều đúng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (179, 710, N'Để tăng cường tình đoàn kết giữa Liên Xô và các nước Đông Âu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (179, 711, N'Để tăng cường sức mạnh của các nước xã hội chủ nghĩa ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (179, 712, N'Để đối phó với khối quân sự NATO', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (179, 713, N'Để đảm bảo hòa bình và an ninh ở Châu Âu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (180, 714, N'Cách mạng Việt Nam phải trải qua hai giai đoạn: cách mạng tư sản dân quyền và cách mạng xã hội chủ nghĩa.', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (180, 715, N'Cách mạng do Đảng của giai cấp vô sản lãnh đạo', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (180, 716, N'Cách mạng Việt Nam là một bộ phận của cách mạng thế giới', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (180, 717, N'Lực lợng để đánh đuổi đế quốc và phong kiến là công nông. Đồng thời “phải biết liên lạc với tiểu tư sản, tri thức, trung nông ... để kéo họ về phe vô sản giai cấp”', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (181, 718, N'Ảnh hưởng của cuộc khủng hoảng kinh tế 1929-1933', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (181, 719, N'Thực dân Pháp tiến hành khủng bố trắng sau khởi nghĩa Yên Bái', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (181, 720, N'Đảng cộng sản Việt Nam ra đời, kịp thời lãnh đạo công nhân và nông  dân đứng lên chống đế quốc và phong kiến', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (181, 721, N'Địa chủ phong kiến cấu kết với thực dân Pháp đàn áp, bóc lột thậm tệ  đối với nông dân', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (182, 722, N'“Độc lập dân tộc” và “ruộng đất dân cày”', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (182, 723, N'“Tự do dân chủ” và “cơm áo hòa bình”', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (182, 724, N'“Tịch thu ruộng đất của đế quốc việt gian” và “tịch thu ruộng đất của địa chủ phong kiến”', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (182, 725, N'“Chống đế quốc” và “chống phát xít”`', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (183, 726, N'Riêng trong tháng 5/1930, cả nớc có 50 cuộc đấu tranh của nông dân, 20 cuộc đấu tranh của công nhân, 8 cuộc đấu tranh của học sinh và dân nghèo thành thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (183, 727, N'Riêng trong tháng 5/1930 cả nớc có 30 cuộc đấu tranh của nông dân, 40 cuộc đấu tranh của công nhân và 4 cuộc đấu tranh của học sinh và dân nghèo thành thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (183, 728, N'Riêng trong tháng 5/1930 cả nước có 34 cuộc đấu tranh của nông dân, 16 cuộc đấu tranh của công nhân và 4 cuộc đấu tranh của học sinh và dân nghèo thành thị', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (183, 729, N'Riêng trong tháng 5/1930 cả nớc có 16 cuộc đấu tranh của nông dân, 34 cuộc đấu tranh của công nhân và 4 cuộc đấu tranh của học sinh và dân nghèo thành thị', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (184, 730, N'Một tổ chức kinh tế của các nước xã hội chủ nghĩa ở Châu Âu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (184, 731, N'Một tổ chức liên minh phòng thủ về quân sự của các nước xã hội chủ nghĩa ở Châu Âu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (184, 732, N'Một tổ chức liên minh chính trị của các nước xã hội chủ nghĩa ở Châu Âu', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (184, 733, N'Một tổ chức liên minh phòng thủ về chính trị và quân sự của các nước xã hội chủ nghĩa ở Châu Âu', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (185, 734, N'Tháng 2/1930, 3000 công nhân đồn điền Phú Riềng bãi công', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (185, 735, N'Ngày 1/5/1930, 3000 nông dân huyện Thanh Chương nổi dậy phá đồn điền Trí Viễn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (185, 736, N'Ngày 12/9/1930, hơn hai vạn nông dân Hưng Nguyên, Nam Đàn, Nghệ An nổi dậy biểu tình', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (185, 737, N'Tất cả các sự kiện trên đều đúng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (186, 738, N'Thực hiện các quyền tự do dân chủ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (186, 739, N'Chia ruộng đất cho dân nghèo, bãi bỏ các thứ thuế vô lý', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (186, 740, N'Xóa bỏ các tập tục lạc hậu, xây dựng đời sống mới', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (186, 741, N'Tất cả đều đúng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (187, 742, N'Là một chi bộ của quốc tế cộng sản', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (187, 743, N'Là một Đảng trong sạch vững mạnh', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (187, 744, N'Là một Đảng đủ khả năng lãnh đạo cách mạng ', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (187, 745, N'Là một Đảng của giai cấp công nhân Việt Nam', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (188, 746, N'Đầu 1932', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (188, 747, N'Đầu 1933', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (188, 748, N'Cuối 1935', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (188, 749, N'Cuối 1934 đầu 1935', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (189, 750, N'Thực hiện quan hệ hợp tác, giúp đỡ nhau về kinh tế giữa các thành viên', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (189, 751, N'Giúp nhau ứng dụng kinh tế khoa học trong sản xuất', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (189, 752, N'"Khép kín cửa” không hòa nhập với nền kinh tế thế giới', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (189, 753, N'Phối hợp giữa các nước thành viên trong các kế hoạch kinh tế dài hạn', 0)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (190, 754, N'*Khái niệm: 
 - Quyền tự do ngôn luận: CD có quyền tự do phát biểu ý kiến, bày tỏ quan điểm của mình về các vấn đề chính trị, kinh tế, văn hóa, XH của đất nước.
*Ý nghĩa: 
- Đảm bảo quyền tự do, dân chủ, có quyền lực thực sự của công dân.
- Là điều kiện để công dân tham gia quản lí NN và XH', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (191, 755, N'-B1:Người tố cáo gửi đơn tố cáo.
-B2:Người giải quyết tố cáo phải tiến hành xác minh và quyết định về nội dung tố cáo.
-B3:Người tố cáo cho rằng giải quyết tố cáo không đúng thì có quyền tố cáo với cơ quan, tố cáo cấp trên.
-B4:Cơ quan, tổ chức, cá nhân giải quyết lần hai có trách nhiệm giải quyết trong thời hạn quy định.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (192, 756, N'– Lời nói của bà không tuân thủ phương châm về chất trong hội thoại (nói không đúng, không chính xác sự thật tình cảnh gia đình)
– Ý nghĩa: Bà cố tình dặn cháu như vậy vì muốn con yên tâm công tác. Qua đó, ta càng hiểu thêm tấm lòng, đức hi sinh thầm lặng mà lớn lao của những người bà, người mẹ hậu phương đối với tiền tuyến lớn.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (193, 757, N'Nội dung pháp luật về dân số thể hiện:
- Tiếp tục giảm tốc độ gia tăng dân số. 
- Ổn định quy mô, cơ cấu và phân bố dân số hợp lí.
- Nâng cao chất lượng dân số.
- Xây dựng gia đình bền vững hạnh phúc.
- Thực hiện tốt Luật HN&GĐ; Pháp lệnh dân số thực hiện KHHGĐ. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (194, 758, N'Nguyên tắc hoạt động của quốc phòng, an ninh ở nước ta:
- Huy động sức mạnh toàn dân bảo vệ quốc phòng an ninh. 
- Kết hợp giữa phát triển kinh tế xã hội với tăng cường quốc phòng, an ninh. 
- Phối hợp có hiệu quả hoạt động an ninh quốc phòng với đối ngoại. 
- Chủ động phòng ngừa âm mưu xâm phạm an ninh quốc gia. 
- Xây dựng thế trận quốc phòng toàn dân với thế trận an ninh nhân dân. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (195, 759, N'Xác định và nêu tác dụng của biện pháp tu từ.
– Biện pháp nói quá
– Hoạn Thư bắt Kiều chép kinh ở Quan Âm các gần phòng đọc sách của Thúc Sinh. Tuy ở gần nhau trong gang tấc nhưng hai người lại trở nên xa cách gấp mười quan san. Nguyễn Du khắc họa đậm nét sự xa cách cũng như cảnh ngộ, thân phận giữa Kiều và Thúc Sinh.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (196, 760, N'– Câu này kiểm tra năng lực viết bài nghị luận xã hội của thí sinh; đòi hỏi thí sinh phải huy động những hiểu biết về đời sống xã hội, kĩ năng tạo lập văn bản và khả năng bày tỏ thái độ, chủ kiến của mình để làm bài.
– Thí sinh có thể làm bài theo nhiều cách khác nhau nhưng phải có lí lẽ và căn cứ xác đáng, được tự do bày tỏ quan điểm riêng của mình, nhưng phải có thái độ chân thành nghiêm túc, phù hợp với chuẩn mực đạo đức xã hội.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (197, 761, N'*Sinh sản vô tính có ưu điểm: + Cá thể sống độc lập, đơn lẻ vẫn có thể tạo ra con cháu. Vì vậy, có lợi trong trường hợp mật độ quần thể thấp. + Tạo ra các cá thể thích nghi tốt với môi trường sống ổn định, ít biến động, nhờ vậy quần thể phát triển nhanh. + Tạo ra các cá thể mới giống nhau và giống cá thể mẹ về các đặc điểm di truyền. + Tạo ra số lượng lớn con cháu giống nhau trong một thời gian ngắn. + Cho phép tăng hiệu suất sinh sản vì không phải tiêu tốn năng lượng cho việc tạo giao tử và thụ tinh. *Sinh sản vô tính có nhược điểm: Tạo ra thế hệ con cháu giống nhau về mặt di truyền vì vậy khi điều kiện sống thay đổi, có thể dẫn đến hàng loạt cá thể bị chết', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (198, 762, N'- Phải cắt bỏ hết lá ở càng ghép vì để giảm mất nước qua con đường thoát hơi nước nhằm tập trung nước nuôi các tế bào cành ghép, nhất là các tế bào mô phân sinh, được đảm bảo. - Phải buộc chặt cành ghép (hoặc mắt ghéph) vào gốc ghép nhằm để mô dẫn (mạch gỗ và mạch libem) nhanh chóng nối liền nhau bảo đảm thông suốt cho dòng nước và các chất dinh dưỡng từ gốc ghép đến được tế bào của cành ghép hoặc mắt ghép được dễ dàng. ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (199, 763, N'- Giữ nguyên được tính trạng con người mong muốn. 
- Thời gian cho thu hoạch sản phẩm ngắn vì cây từ cành giâm và cành chiết sớm ra hoa, kết quả: chỉ 2-5 năm tuỳ loài cây, tuỳ tuổi sinh lý của cành.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (200, 764, N'Sinh sản vô tính giúp cây duy trì nòi giống, sống qua được mùa bất lợi ở dạng thân củ, thân rễ, căn hành và phát triển nhanh khi gặp điều kiện thuận lợi. Vai trò của hình thức sinh sản sinh dưỡng đối với ngành nông nghiệp: có thể duy trì các tính trạng tốt cho con người, nhân nhanh giống cây cần thiết trong thời gian ngắn, tạo được các giống cây trồng sạch bệnh, như giống khoai tây sạch bệnh, phục chế các giống cây trồng quý đang bị thoái hoá nhờ nuôi cấy mô và tế bào thực vật, giá thành thấp, hiệu quả kinh tế cao.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (201, 765, N'Sinh sản hữu tính là sự hợp nhất của các giao tử đực S (n) và cái (n) thành hợp tử (2n) khởi đầu của cá thể mới.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (202, 766, N'Sự hình thành giao tử ở thực vật: giao tử được hình thành từ thể giao tử, thể giao tử lại được sinh ra từ bào tử đơn bội qua giảm phân.
Thụ tinh kép là hiện tượng cả 2 nhân tham gia thụ tinh, một hoà nhập với trứng, nhân thứ hai hợp nhất với nhân lưỡng bội (2n) tạo nên tế bào nhân tam bội (3n). Thụ tinh kép chỉ có ở thực vật Hạt kín (thực vật có hoa).', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (203, 767, N'Trong sinh sản hữu tính luôn có quá trình hình thành và hợp nhất của các tế bào sinh dục (các giao tử), luôn có sự trao đổi, tái tổ hợp của hai bộ gen.
Sinh sản hữu tính luôn gắn liền với giảm phân để tạo giao tử.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (204, 768, N'Cơ sở của sinh sản hữu tính là sự phân bào giảm nhiễm mà điểm mấu chốt là sự hình thành giao tử đực (tinh trùng) và giao tử cái (noãn) và sự kết hợp giữa chúng. Sinh sản hữu tính làm tăng tính biến dị di truyền ở thế hệ con. Thông qua giảm phân và sự thụ tinh ngẫu nhiên, rất nhiều tổ hợp gen khác nhau sẽ được hình thành từ một số ít bộ gen ban đầu. Mức biến dị di truyền của một quần thể càng lớn thì khả năng thì khả năng thích nghi với môi trường biến động ngày càng cao. Trên nguyên tắc khi môi trường thay đổi hoàn toàn và đột ngột, những cá thể con có mang tổ hợp di truyền biến dị rất khác lạ sẽ có nhiều may, thích nghi hơn những cá thể con có kiểu gen đồng nhất và giống hệt bố mẹ.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (205, 769, N'Noãn đã thụ tinh (chứa hợp tử và tế bào tam bội) phát triển thành hạt. Hợp ử phát triển thành phôi. Tế bào tam bội phân chia tạo thành một khối đa bào giàu chất dinh dưỡng được gọi là nội nhũ. Nội nhũ (phôi nhũ) là mô nuôi dưỡng phôi phát triển. Có hai loại hạt: hạt nội nhũ (hạt cây Một lá mầm) và hạt không nội nhũ (hạt cây Hai lá mầm).', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (206, 770, N'+ Quả là do bầu nhuỵ phát triển thành. Bầu nhuỵ dày lên, chuyên hoá như một cái túi chứa hạt, bảo vệ hạt và giúp phát tán hạt. + Quả không có thụ tinh noãn (quả giả) gọi là quả đơn tính. Quả không có hạt chưa hẳn là quả đơn tính vì hạt có thể bị thoái hoá.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (207, 771, N'Có vai trò lớn đối với hệ sinh thái và đời sống con người.1. Có lợi:- Làm thức ăn cho người va động vật.- Làm đất tơi xốp, thoáng khí, màu mỡ.2. Có hại: Hút máu người và động vật → gây bệnh', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (208, 772, N'- Cơ thể hình trụ, thường thuôn hai đầu.- Có khoang cơ thể chưa chính thức.- Cơ quan tiêu hóa bắt đầu từ miệng và kết thúc ở hậu môn.- Phần lớn sống kí sinh, một số nhỏ sống tự do.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (209, 773, N'Nhờ thần kinh phát triển nên ốc sên, mực và một số thân mềm khác có giác quan phát triển và có nhiều tập tính thích nghi với lối sống đảm bảo sự tồn tại của loài.1. Tập tính ở ốc sên:- Tự vệ bằng cách co rụt cơ thể vào trong vỏ.- Đào lỗ đẻ trứng → bảo vệ trứng.2. Tập tính ở mực:- Tự vệ bằng cách phun hỏa mù.- Săn mồi theo cách rình mồi ở một chỗ', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (210, 774, N'Trùng giày là động vật đơn bào nhưng cấu tạo đã phân hóa thành nhiều bộ phận như: nhân lớn,nhân nhỏ, không bào co bóp, miệng, hầu. Mỗi bộ phận đảm nhiệm chức năng sống nhất định.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (211, 775, N'-Mắt và lông bơi tiêu giảm.- Giác bám, cơ quan tiêu hóa, cơ quan sinh dục phát triển', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (212, 776, N'Vai trò của sâu bọ: làm thực phẩm, thụ phấn cho cây trồng.- Tác hại: truyền bệnh và phá hại mùa màng .-Biện pháp: Dùng thuốc trừ sâu sinh học, hạn chế dùng thuốc trừ sâu hóa học, bảo vệ các sâu bọ có ích, dùng các biện pháp vật lý, cơ giới.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (213, 777, N'- Hầu hết giáp xác đều có lợi. - Chúng là nguồn thức ăn của cá và là thực phẩm quan trọng của con người. - Là loại thủy sản xuất khẩu hàng đầu của nước ta hiện nay.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (214, 778, N'- Thủy tức: khi trưởng thành chồi tách ra để sống độc lập .- San hô : chồi vẫn dính với cơ thể mẹ và tiếp tục phát triển để tạo thành tập đoàn.Câu 6: Nêu đặc điểm chung của ngành giun đốt ?- Cơ thể phân đốt, có thể xoang, ống tiêu hóa phân hóa, bắt đầu có hệ tuần hoàn.- Di chuyển nhờ chi bên, tơ hay hệ cơ của thành cơ thể.- Hô hấp qua da hay qua mang.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (215, 779, N'- Cơ thể dẹp có đối xứng 2 bên.- Phân biệt đầu, đuôi, lưng bụng.- Ruột phân nhánh, chưa có ruột sau và hậu môn.- Một số giun dẹp kí sinh có thêm : giác bám, cơ quan sinh sản phát triển.- Âú trùng phát triển qua vật chủ trung gian', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (216, 780, N'- Là nguồn thức ăn cho cá.- Cung cấp thực phẩm cho con người: thực phẩm khô, đông lạnh, tươi sống.- Nguyên liệu để làm mắm.- Có hại cho giao thông đường thủy.- Kí sinh gây hại cho cá', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (217, 781, N'- Cơ thể có kích thước hiển vi, chỉ là một tế bào nhưng dảm nhiệm mọi chức năng sống. Phần lớn : dị dưỡng, di chuyển bằng chân giả, lông bơi hay roi bơi hoặc tiêu giảm . Sinh sản vô tính theo kiểu phân đôi', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (218, 782, N'- Giun đũa thường kí sinh ở ruột non người, nhất là ở trẻ em, gây đau bụng, đôi khi tắc ruột và tắc ống mật', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (219, 783, N'- Ăn sạch, uống sạch, rửa tay trước khi ăn và sau khi đi vệ sinh.- Không đi chân đất, tiếp xúc da với nước bẩn.- Tẩy giun định kỳ 1 – 2 lần trong 1 năm', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (220, 784, N'Vỏ kitin có ngấm nhiều canxi giúp tôm có bộ xương ngoài chắc chắn làm cơ sở cho các cử động và nhờ các sắc tố nên màu sắc cơ thể tôm phù hợp với môi trường, giúp chúng tránh khỏi sự phát hiện của kẻ thù.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (221, 785, N'Một số động vật nguyên sinh có lợi trong ao nuôi cá như: trùng roi xanh và các loài trùng tương tự, các loài trùng cỏ khác nhau…Chúng là thức ăn tự nhiên của các loài giáp xác nhỏ và các động vật nhỏ khác. Các loài động vật vật này là thức ăn quan trọng của cá và các động vật thủy sinh khác ( ốc, tôm, ấu trùng sâu bọ..)', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (222, 786, N'Vì chỉ có một lỗ thông với môi trường ngoài cho nên thủy tức lấy thức ăn và thải bã đều qua lỗ miệng. Đây cũng là đặc điểm của kiểu cấu tạo ruột túi ở ruột khoang..', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (223, 787, N'Với vùng đất nông nghiệp : Giun đất có vai trò thực tiễn lớn trong việc cải tạo đất trồng. Với vùng biển: Các loài giun đất biển ( như giun nhiều tơ… ) có vai trò quan trọng vì chúng là thức ăn của cá. Chính vì thế ngư dân thường khai thác chúng làm mồi câu', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (224, 788, N'Trai dinh dưỡng theo kiểu hút nước để lọc lấy vụn hữu cơ, động vật nguyên sinh, các động vật nhỏ khác góp phần lọc sạch môi trường nước. Vì cơ thể trai giống như những máy lọc sống. Ở những nơi nước ô nhiễm, người ăn trai, sò hay bị ngộ độc vì khi lọc nước, nhiều chất độc còn tồn đọng trong cơ thể trai, sò.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (225, 789, N'- Tế bào gai: Có gai cảm giác, có túi độc.- Tế bào thần kinh: hình sao, tạo thành mạng lưới thần kinh- Tế bào mô bì- cơ: che chở và giúp cơ thể co duỗi.- Tế bào sinh sản: có trứng và tinh trùng', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (226, 790, N'- Cơ thể phân đốt, có thể xoang.- Ống tiêu hóa phân hóa.- Bắt đầu có hệ tuần hoàn.- Di chuyển nhờ chi bên, tơ hay hệ cơ của thành cơ thể.- Hô hấp qua da hay qua mang', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (227, 791, N'- Nhờ thần kinh phát triển → giác quan phát triển và có nhiều tập tính thích nghi với lối sống đảm bảo sự tồn tại của loài.+ Tập tính của ốc sên : đào hang đẻ trứng.+ tập tính của mực : săn mồi, đuổi bắt, rình mồi, phun mực để tự vệ.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (228, 792, N'8 căn bậc 2 của 3', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (229, 793, N'Khi nhiệt độ môi trường quá cao có thể phá hủy cấu trúc không gian 3 chiều của prôtêin làm cho chúng mất chức năng (hiện tượng biến tính của prôtêin).
Một số vi sinh vật sống được ở trong suối nước nóng có nhiệt độ xấp xỉ 1000 độ C mà prôtêin của chúng lại không bị hỏng do prôtêin của các loại sinh vật này có cấu trúc đặc biệt nên không bị biến tính khi ở nhiệt độ cao.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (230, 794, N'Trong môi trường nước của tế bào, prôtêin thường quay các phần kị nước vào bên trong và bộc lộ phần ưa nước ra bên ngoài. Ở nhiệt độ cao, các phân tử chuyển động hỗn loạn làm cho các phần kị nước ở bên trong bộc lộ ra ngoài, nhưng do bản chất kị nước nên các phần kị nước của phân tử này ngay lập tức lại liên kết với phần kị nước của phân tử khác làm cho các phân tử nọ kết dính với phân tử kia. Do vậy, prôtêin bị vón cục và đóng thành từng mảng nổi trên mặt nước canh.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (231, 795, N'(a mũ 3) chia 48', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (232, 796, N'Các prôtêin khác nhau từ thức ăn sẽ được tiêu hoá nhờ các enzim tiêu hoá và sẽ bị thuỷ phân thành các axit amin không có tính đặc thù và sẽ được hấp thụ qua ruột vào máu và được chuyển đến tế bào để tạo thành prôtêin đặc thù cho cơ thể chúng ta. Nếu prôtêin nào đó không được tiêu hoá xâm nhập vào máu sẽ là tác nhân lạ và gây phản ứng dị ứng (nhiều người bị dị ứng với thức ăn như tôm, cua, ba ba..., trường hợp cấy ghép mô lạ gây phản ứng bong miếng ghép...).', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (233, 797, N'Cấu tạo nên tế bào và cơ thể. Chúng đóng vai trò cốt lõi trong cấu trúc của nhân, của mọi bào quan, đặc biệt là hệ màng sinh học có tính chọn lọc cao. Ví dụ: côlagen tham gia cấu tạo nên các mô liên kết, histon tham gia cấu trúc nhiễm sắc thể....
Vận chuyển các chất. Một số prôtêin có vai trò như những "xe tải" vận chuyển các chất trong cơ thể. Ví dụ: hêmôglôbin...
Bảo vệ cơ thể. Ví dụ: các kháng thể (có bản chất là prôtêin) có chức năng bảo vệ cơ thể chống lại các tác nhân gây bệnh...', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (234, 798, N'Cấu trúc bậc một: Các axit amin nối với nhau bởi liên kết peptit hình thành nên chuỗi pôlipeptit. Cấu trúc bậc một của prôtêin thực chất là trình tự sắp xếp đặc thù của các loại axit amin trên chuỗi pôlipeptit. Cấu trúc bậc một thể hiện tính đa dạng và đặc thù của prôtêin qua số lượng, thành phần và trình tự sắp xếp của các axit amin.
Cấu trúc bậc hai: Chuỗi pôlipeptit co xoắn α hoặc gấp nếp β tạo nên nhờ các liên kết hiđrô giữa các axit amin trong chuỗi với nhau tạo nên cấu trúc bậc 2.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (235, 799, N'Liên kết peptit hình thành giữa 2 axit amin. Các axit amin nối với nhau bởi liên kết peptit hình thành nên chuỗi pôlipeptit tạo nên cấu trúc bậc 1 của prôtêin.
Liên kết hiđrô. Cấu trúc bậc 2 của prôtêin được giữ vững nhờ liên kết hiđrô giữa các axit amin ở gần nhau.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (236, 800, N'Collagen và elastin tạo nên cấu trúc sợi rất bền của mô liên kết, dây chằng, gân. Kêratin tạo nên cấu trúc của da, lông, móng.
Hoocmôn insulin và glucagon do tế bào đảo tụy thuộc tuyến tụy tiết ra có tác dụng điều hòa hàm lượng đường glucô trong máu.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (237, 801, N'Trình tự các axit amin trên chuỗi pôlipeptit sẽ thể hiện tương tác giữa các phần trong chuỗi pôlipeptit, từ đó tạo nên hình dạng không gian 3 chiều của prôtêin và do đó quyết định tính chất cũng như vai trò của prôtêin. Sự sai lệch trong trình tự sắp xếp của các axit amin có thể dẫn đến sự biến đổi cấu trúc và tính chất của prôtêin. Số lượng, thành phần và trình tự sắp xếp của các axit amin trên chuỗi pôlipeptit quyết định tính đa dạng và đặc thù của prôtêin.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (238, 802, N'Trình tự các axit amin trên chuỗi pôlipeptit sẽ thể hiện tương tác giữa các phần trong chuỗi pôlipeptit, từ đó tạo nên hình dạng không gian 3 chiều của prôtêin và do đó quyết định tính chất cũng như vai trò của prôtêin. Sự sai lệch trong trình tự sắp xếp của các axit amin có thể dẫn đến sự biến đổi cấu trúc và tính chất của prôtêin. Số lượng, thành phần và trình tự sắp xếp của các axit amin trên chuỗi pôlipeptit quyết định tính đa dạng và đặc thù của prôtêin.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (239, 803, N'- Pha tiềm phát:
 SLTB chưa tăng
 Enzym cảm ứng được hình thành để phân giải cơ chất
 Vi khuẩn thích ứng với môi trường
- Pha lũy thừa:
 Quá trình trao đổi chất diễn ra mạnh mẽ
 SLTB tăng theo cấp số nhân
 Tốc độ sinh trưởng đạt cực đại', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (240, 804, N'Dựa vào hình thái chia thành 3 loại:
Cấu trúc xoắn: virut khảm thuốc lá.
Cấu trúc khối: virut Adeno
Cấu trúc hỗn hợp: phago T2
* Không thể nuôi cấy virut trên môi trường nhân tạo như ở vi khuẩn vì virut sống kí sinh nội bào bắt buộc.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (241, 805, N'. Giai đoạn hấp phụ;
- Gai glicoprotein của virut phải đặc hiệu với thụ thể bề mặt của tế bào chủ thì VR mới bám vào được.
b. Giai đoạn xâm nhập:
- Đối với phago: enzim lizozim phá hủy thành tế bào để bơm axit nucleic vào tế bào chất,còn vỏ nằm bên ngoài.', 1)
GO
INSERT [dbo].[DAP_AN] ([MACH], [MADAPAN], [NOIDUNG], [DAPANDUNG]) VALUES (242, 806, N'- Có lối sống lành mạnh, quan hệ tình dục an toàn, vệ sinh y tế, loại trừ các tệ nạn xã hội….
- Không phân biệt đối xử với bệnh nhân HIV, cần chăm sóc, động viên để họ vượt qua mặt cảm, không bi quan chán nản…', 1)
GO
SET IDENTITY_INSERT [dbo].[DAP_AN] OFF
GO
SET IDENTITY_INSERT [dbo].[DE_THI] ON 

GO
INSERT [dbo].[DE_THI] ([MADETHI], [MAMON], [NGAYTHEM], [NGAYTHI], [THOIGIANLAMBAI], [TRANGTHAI]) VALUES (4, 2, CAST(N'2017-06-19 02:54:49.303' AS DateTime), NULL, NULL, 1)
GO
SET IDENTITY_INSERT [dbo].[DE_THI] OFF
GO
SET IDENTITY_INSERT [dbo].[DO_KHO] ON 

GO
INSERT [dbo].[DO_KHO] ([MADOKHO], [TENDOKHO]) VALUES (1, N'Khó')
GO
INSERT [dbo].[DO_KHO] ([MADOKHO], [TENDOKHO]) VALUES (2, N'Dễ')
GO
INSERT [dbo].[DO_KHO] ([MADOKHO], [TENDOKHO]) VALUES (3, N'Trung bình')
GO
SET IDENTITY_INSERT [dbo].[DO_KHO] OFF
GO
SET IDENTITY_INSERT [dbo].[GIANG_VIEN] ON 

GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (1, N'Phan', N'đình long', CAST(N'1995-09-04' AS Date), N'dinhlong@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'TP HCM', N'0981773084', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (2, N'Trần Lê Như', N'Quỳnh', CAST(N'2017-05-18' AS Date), N'quynhnhu@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/84128613146052335341496749743784.jpg', N'10.8713204,106.7906752', N'0981773084', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (3, N'Pham Van', N'Tinh', CAST(N'1980-05-05' AS Date), N'phamvantinh@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/78246940447241230301496928694457.jpg', N'10.8713257,106.7904928', N'01203947318', 0, 3, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (4, N'Huỳnh Tính ', N'Thành', CAST(N'1995-03-04' AS Date), N'tinhthanh@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/no_img.jpg', N'Đồng Tháp', N'0981773084', 1, 3, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (7, N'Giang vien', N'A', CAST(N'2017-06-16' AS Date), N'giangvien@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'kkkkk', N'0981773084', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (8, N'Giang vien', N'B', CAST(N'2017-06-09' AS Date), N'giangvienb@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'kkk', N'0981773084', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (11, N'Trần Văn ', N'Thắng', CAST(N'2017-06-15' AS Date), N'vanthang1996@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'Tp.HCM', N'01203947318', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (12, N'Nguyễn Tấn ', N'Phát', CAST(N'2017-06-09' AS Date), N'nguyentanphat@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'', N'01203947318', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (13, N'Trương Tam', N'Lang', CAST(N'2017-06-16' AS Date), N'truongtamlang@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'', N'01203947318', 0, 1, 1)
GO
INSERT [dbo].[GIANG_VIEN] ([MAGV], [HOGV], [TENGV], [NGAYSINH], [EMAIL], [MATKHAU], [ANHGV], [DIACHI], [DIENTHOAI], [GIOITINH], [MABOMON], [TRANGTHAI]) VALUES (14, N'Phạm Thị Mỹ', N'Trinh', CAST(N'2017-06-29' AS Date), N'phamthimytrinh@gmail.com', N'$2a$12$SZ3S0TZAlP0WZMBkVTXwAe1v96azURNSLXNeW0SXfpQLsms5k3Xcm', N'/UploadedFiles/default_avatar.jpg', N'', N'01203747318', 0, 1, 1)
GO
SET IDENTITY_INSERT [dbo].[GIANG_VIEN] OFF
GO
SET IDENTITY_INSERT [dbo].[KHOA] ON 

GO
INSERT [dbo].[KHOA] ([MAKHOA], [TENKHOA], [MAGV]) VALUES (1, N'Khoa Công Nghệ Thông Tin', 3)
GO
SET IDENTITY_INSERT [dbo].[KHOA] OFF
GO
SET IDENTITY_INSERT [dbo].[LOAI_CONG_VIEC] ON 

GO
INSERT [dbo].[LOAI_CONG_VIEC] ([MALOAICV], [TENLOAICV]) VALUES (1, N'Tạo đề cương')
GO
INSERT [dbo].[LOAI_CONG_VIEC] ([MALOAICV], [TENLOAICV]) VALUES (2, N'Tạo câu hỏi')
GO
INSERT [dbo].[LOAI_CONG_VIEC] ([MALOAICV], [TENLOAICV]) VALUES (3, N'Tạo cấu trúc đề thi')
GO
SET IDENTITY_INSERT [dbo].[LOAI_CONG_VIEC] OFF
GO
SET IDENTITY_INSERT [dbo].[MON_HOC] ON 

GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (1, N'Mạng máy tính cơ bản', 2, 3, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (2, N'Hệ thống thông tin quản lý', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (3, N'Mạng máy tính nâng cao', 2, 3, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (4, N'Cấu trúc máy tính', 3, 3, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (6, N' Môn học 974536F2H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (7, N' Môn học B4244C2EH? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (8, N' Môn học C18CD169H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (9, N' Môn học 37247BB2H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (10, N' Môn học A5730BBEH? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (11, N' Môn học C1D0AC04H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (12, N' Môn học 92325FF9H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (13, N' Môn học F56FA9A9H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (14, N' Môn học F1865846H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (15, N' Môn học 200CB7B9H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (16, N' Môn học 36E0B5B1H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (17, N' Môn học 736943E1H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (18, N' Môn học FE4B5B3BH? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (19, N' Môn học 0D7880CEH? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (20, N' Môn học 9EA5F595H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (21, N' Môn học 920FCA72H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (22, N' Môn học 662CB402H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (23, N' Môn học 4C0C43B6H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (24, N' Môn học 4D373A24H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (25, N' Môn học 3A4BC717H? th?ng thông tin', 1, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (26, N' Môn học 20265AF7M?ng máy tính', 2, 2, 1)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (27, N' Môn học 04B4E1D3M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (28, N' Môn học 3E806208M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (29, N' Môn học 023600C4M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (30, N' Môn học 275865A7M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (31, N' Môn học 50A7D469M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (32, N' Môn học B57CD171M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (33, N' Môn học 9862AE45M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (34, N' Môn học A2D264C3M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (35, N' Môn học AC4F528CM?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (36, N' Môn học B23321E6M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (37, N' Môn học 3462E839M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (38, N' Môn học FAADBB61M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (39, N' Môn học 20F0FE79M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (40, N' Môn học D43347ABM?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (41, N' Môn học D9C6A2D1M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (42, N' Môn học 7766E85AM?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (43, N' Môn học FA7D3A90M?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (44, N' Môn học FB50DEBDM?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (45, N' Môn học 54672F0FM?ng máy tính', 2, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (46, N' Môn học B59A0C82Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (47, N' Môn học A7B0481BKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (48, N' Môn học 4B21659AKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (49, N' Môn học DEF70A06Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (50, N' Môn học CEF0E439Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (51, N' Môn học B08693C7Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (52, N' Môn học A64BEA7AKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (53, N' Môn học 2730765BKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (54, N' Môn học B99CDF11Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (55, N' Môn học 2FD880ACKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (56, N' Môn học 89EF62ACKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (57, N' Môn học C4D4ED15Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (58, N' Môn học 283665B6Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (59, N' Môn học 0CC20303Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (60, N' Môn học FF1F0004Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (61, N' Môn học 06C26FFCKhoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (62, N' Môn học 96DDA455Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (63, N' Môn học 8C405B14Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (64, N' Môn học D452D1C0Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (65, N' Môn học 7A0F3D88Khoa h?c máy tính', 3, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (66, N' Môn học 55610DDE B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (67, N' Môn học A9F6CD41 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (68, N' Môn học 71A183E4 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (69, N' Môn học 5DF9E82E B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (70, N' Môn học 79E34A32 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (71, N' Môn học 55AAB73F B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (72, N' Môn học 78F06B2E B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (73, N' Môn học 256B2EBA B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (74, N' Môn học 0E2ED96F B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (75, N' Môn học FB2DE07E B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (76, N' Môn học 7435D7CF B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (77, N' Môn học ADF41A05 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (78, N' Môn học 7D066296 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (79, N' Môn học FA3C5571 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (80, N' Môn học FB7327ED B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (81, N' Môn học 17DB434A B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (82, N' Môn học A67426A1 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (83, N' Môn học 08FF3D62 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (84, N' Môn học 5635F906 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (85, N' Môn học 0E828614 B? Môn 6883FDA0Khoa Công Ngh? Th', 4, 2, 0)
GO
INSERT [dbo].[MON_HOC] ([MAMON], [TENMON], [MABOMON], [MAGV], [TRANGTHAI]) VALUES (1270, N'Môn học test', 1, 2, 0)
GO
SET IDENTITY_INSERT [dbo].[MON_HOC] OFF
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (1, 7)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (1, 8)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 1)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 2)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 3)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 6)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 7)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (2, 27)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (3, 1)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (3, 3)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (3, 8)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (3, 26)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (3, 27)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (7, 8)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (11, 2)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (12, 2)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (13, 2)
GO
INSERT [dbo].[QUAN_LY_MH] ([MAGV], [MAMON]) VALUES (14, 2)
GO
/****** Object:  Index [IX_CAU_TRUC_DE_THI]    Script Date: 6/2/2018 18:53:27 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_CAU_TRUC_DE_THI] ON [dbo].[CAU_TRUC_DE_THI]
(
	[MAMON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_GIANG_VIEN]    Script Date: 6/2/2018 18:53:27 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_GIANG_VIEN] ON [dbo].[GIANG_VIEN]
(
	[EMAIL] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[BO_MON]  WITH CHECK ADD  CONSTRAINT [FK_BO_MON_KHOA] FOREIGN KEY([MAKHOA])
REFERENCES [dbo].[KHOA] ([MAKHOA])
GO
ALTER TABLE [dbo].[BO_MON] CHECK CONSTRAINT [FK_BO_MON_KHOA]
GO
ALTER TABLE [dbo].[CAU_HOI]  WITH CHECK ADD  CONSTRAINT [FK_CAU_HOI_CHUONG_MUC] FOREIGN KEY([MACHUONG])
REFERENCES [dbo].[CHUONG_MUC] ([MACHUONG])
GO
ALTER TABLE [dbo].[CAU_HOI] CHECK CONSTRAINT [FK_CAU_HOI_CHUONG_MUC]
GO
ALTER TABLE [dbo].[CAU_HOI]  WITH CHECK ADD  CONSTRAINT [FK_CAU_HOI_DO_KHO] FOREIGN KEY([MADOKHO])
REFERENCES [dbo].[DO_KHO] ([MADOKHO])
GO
ALTER TABLE [dbo].[CAU_HOI] CHECK CONSTRAINT [FK_CAU_HOI_DO_KHO]
GO
ALTER TABLE [dbo].[CAU_HOI]  WITH CHECK ADD  CONSTRAINT [FK_CAU_HOI_MON_HOC] FOREIGN KEY([MAMON])
REFERENCES [dbo].[MON_HOC] ([MAMON])
GO
ALTER TABLE [dbo].[CAU_HOI] CHECK CONSTRAINT [FK_CAU_HOI_MON_HOC]
GO
ALTER TABLE [dbo].[CAU_TRUC_DE_THI]  WITH CHECK ADD  CONSTRAINT [FK_CAU_TRUC_DE_THI_GIANG_VIEN] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIANG_VIEN] ([MAGV])
GO
ALTER TABLE [dbo].[CAU_TRUC_DE_THI] CHECK CONSTRAINT [FK_CAU_TRUC_DE_THI_GIANG_VIEN]
GO
ALTER TABLE [dbo].[CAU_TRUC_DE_THI]  WITH CHECK ADD  CONSTRAINT [FK_CAU_TRUC_DE_THI_MON_HOC] FOREIGN KEY([MAMON])
REFERENCES [dbo].[MON_HOC] ([MAMON])
GO
ALTER TABLE [dbo].[CAU_TRUC_DE_THI] CHECK CONSTRAINT [FK_CAU_TRUC_DE_THI_MON_HOC]
GO
ALTER TABLE [dbo].[chatdetails]  WITH CHECK ADD  CONSTRAINT [FK_chatdetails_chat] FOREIGN KEY([chat_id])
REFERENCES [dbo].[chat] ([chat_id])
GO
ALTER TABLE [dbo].[chatdetails] CHECK CONSTRAINT [FK_chatdetails_chat]
GO
ALTER TABLE [dbo].[CHI_TIET_CTDT]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_CTDT_CAU_TRUC_DE_THI] FOREIGN KEY([MACTDT])
REFERENCES [dbo].[CAU_TRUC_DE_THI] ([MACTDT])
GO
ALTER TABLE [dbo].[CHI_TIET_CTDT] CHECK CONSTRAINT [FK_CHI_TIET_CTDT_CAU_TRUC_DE_THI]
GO
ALTER TABLE [dbo].[CHI_TIET_CTDT]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_CTDT_CHUONG_MUC] FOREIGN KEY([MACHUONG])
REFERENCES [dbo].[CHUONG_MUC] ([MACHUONG])
GO
ALTER TABLE [dbo].[CHI_TIET_CTDT] CHECK CONSTRAINT [FK_CHI_TIET_CTDT_CHUONG_MUC]
GO
ALTER TABLE [dbo].[CHI_TIET_DE_THI]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_DE_THI_CAU_HOI] FOREIGN KEY([MACH])
REFERENCES [dbo].[CAU_HOI] ([MACH])
GO
ALTER TABLE [dbo].[CHI_TIET_DE_THI] CHECK CONSTRAINT [FK_CHI_TIET_DE_THI_CAU_HOI]
GO
ALTER TABLE [dbo].[CHI_TIET_DE_THI]  WITH CHECK ADD  CONSTRAINT [FK_CHI_TIET_DE_THI_DE_THI] FOREIGN KEY([MADETHI])
REFERENCES [dbo].[DE_THI] ([MADETHI])
GO
ALTER TABLE [dbo].[CHI_TIET_DE_THI] CHECK CONSTRAINT [FK_CHI_TIET_DE_THI_DE_THI]
GO
ALTER TABLE [dbo].[CHUONG_MUC]  WITH CHECK ADD  CONSTRAINT [FK_CHUONG_MUC_MON_HOC] FOREIGN KEY([MAMON])
REFERENCES [dbo].[MON_HOC] ([MAMON])
GO
ALTER TABLE [dbo].[CHUONG_MUC] CHECK CONSTRAINT [FK_CHUONG_MUC_MON_HOC]
GO
ALTER TABLE [dbo].[CONG_VIEC]  WITH CHECK ADD  CONSTRAINT [FK_CONG_VIEC_GIANG_VIEN] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIANG_VIEN] ([MAGV])
GO
ALTER TABLE [dbo].[CONG_VIEC] CHECK CONSTRAINT [FK_CONG_VIEC_GIANG_VIEN]
GO
ALTER TABLE [dbo].[CONG_VIEC]  WITH CHECK ADD  CONSTRAINT [FK_CONG_VIEC_LOAI_CONG_VIEC] FOREIGN KEY([MALOAICV])
REFERENCES [dbo].[LOAI_CONG_VIEC] ([MALOAICV])
GO
ALTER TABLE [dbo].[CONG_VIEC] CHECK CONSTRAINT [FK_CONG_VIEC_LOAI_CONG_VIEC]
GO
ALTER TABLE [dbo].[CT_TAO_CAU_HOI]  WITH CHECK ADD  CONSTRAINT [FK_CT_TAO_CAU_HOI_CHUONG_MUC] FOREIGN KEY([MACHUONG])
REFERENCES [dbo].[CHUONG_MUC] ([MACHUONG])
GO
ALTER TABLE [dbo].[CT_TAO_CAU_HOI] CHECK CONSTRAINT [FK_CT_TAO_CAU_HOI_CHUONG_MUC]
GO
ALTER TABLE [dbo].[CT_TAO_CAU_HOI]  WITH CHECK ADD  CONSTRAINT [FK_CT_TAO_CAU_HOI_CONG_VIEC] FOREIGN KEY([MACV])
REFERENCES [dbo].[CONG_VIEC] ([MACV])
GO
ALTER TABLE [dbo].[CT_TAO_CAU_HOI] CHECK CONSTRAINT [FK_CT_TAO_CAU_HOI_CONG_VIEC]
GO
ALTER TABLE [dbo].[DAP_AN]  WITH CHECK ADD  CONSTRAINT [FK_DAP_AN_CAU_HOI] FOREIGN KEY([MACH])
REFERENCES [dbo].[CAU_HOI] ([MACH])
GO
ALTER TABLE [dbo].[DAP_AN] CHECK CONSTRAINT [FK_DAP_AN_CAU_HOI]
GO
ALTER TABLE [dbo].[DE_THI]  WITH CHECK ADD  CONSTRAINT [FK_DE_THI_MON_HOC] FOREIGN KEY([MAMON])
REFERENCES [dbo].[MON_HOC] ([MAMON])
GO
ALTER TABLE [dbo].[DE_THI] CHECK CONSTRAINT [FK_DE_THI_MON_HOC]
GO
ALTER TABLE [dbo].[GIANG_VIEN]  WITH CHECK ADD  CONSTRAINT [FK_GIANG_VIEN_BO_MON1] FOREIGN KEY([MABOMON])
REFERENCES [dbo].[BO_MON] ([MABOMON])
GO
ALTER TABLE [dbo].[GIANG_VIEN] CHECK CONSTRAINT [FK_GIANG_VIEN_BO_MON1]
GO
ALTER TABLE [dbo].[MON_HOC]  WITH CHECK ADD  CONSTRAINT [FK_MON_HOC_BO_MON] FOREIGN KEY([MABOMON])
REFERENCES [dbo].[BO_MON] ([MABOMON])
GO
ALTER TABLE [dbo].[MON_HOC] CHECK CONSTRAINT [FK_MON_HOC_BO_MON]
GO
ALTER TABLE [dbo].[QUAN_LY_MH]  WITH CHECK ADD  CONSTRAINT [FK_QUAN_LY_MH_GIANG_VIEN] FOREIGN KEY([MAGV])
REFERENCES [dbo].[GIANG_VIEN] ([MAGV])
GO
ALTER TABLE [dbo].[QUAN_LY_MH] CHECK CONSTRAINT [FK_QUAN_LY_MH_GIANG_VIEN]
GO
ALTER TABLE [dbo].[QUAN_LY_MH]  WITH CHECK ADD  CONSTRAINT [FK_QUAN_LY_MH_MON_HOC] FOREIGN KEY([MAMON])
REFERENCES [dbo].[MON_HOC] ([MAMON])
GO
ALTER TABLE [dbo].[QUAN_LY_MH] CHECK CONSTRAINT [FK_QUAN_LY_MH_MON_HOC]
GO
/****** Object:  StoredProcedure [dbo].[addDeThi]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[addDeThi] @MAMON INT, @MACHUONG INT, @SL INT, @MADOKHO INT
 AS
 BEGIN
	declare @sqlcommand nvarchar(95)
	set @sqlcommand = 'select top '+CAST(@SL as nvarchar(2))+' * from cau_hoi where mamon='+cast(@MAMON as varchar(10))+' and machuong='+cast(@MACHUONG as varchar(10))+'and madokho='+cast(@MADOKHO as varchar(10))+' order by NEWID()'
	EXECUTE sp_executesql @sqlcommand
 END






GO
/****** Object:  StoredProcedure [dbo].[box_msg]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[box_msg] 
@code nvarchar(max) ,
@room_id   nvarchar(max) ,
@top int  =null 
AS
SET NOCOUNT ON;
IF @top is null 
 set @top = 5 
 IF EXISTS (SELECT *  FROM chat c WHERE c.LAST_USER LIKE  @code )
 BEGIN
   UPDATE chat set  COUNT_MSG = 0 WHERE (code = @code  AND room_id = @room_id AND LAST_USER = @code )OR (code = @room_id AND room_id = @code AND LAST_USER = @code)
 END
SELECT  top (@top)  d.body , d.time_on  , d.url  , d.client_id FROM chat c  JOIN chatdetails d ON c.chat_id = d.chat_id  
    where c.code = @code and c.room_id = @room_id OR c.code = @room_id AND c.room_id = @code ORDER BY d.time_on DESC





GO
/****** Object:  StoredProcedure [dbo].[danhsachgiangvien]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[danhsachgiangvien] 
@magv int  
AS
DECLARE @makhoa int = ( SELECT k.MAKHOA FROM GIANG_VIEN GV JOIN BO_MON BM ON GV.MABOMON = BM.MABOMON  JOIN KHOA K  ON K.MAKHOA = BM.MAKHOA  WHERE GV.MAGV = @magv )
IF @makhoa is nulL
 RAISERROR('Mã Khoa không tồn tại',16,1)
 ELSE
 SELECT  GV.MAGV , GV.HOGV , GV.TENGV , GV.ANHGV , GV.GIOITINH , GV.EMAIL  FROM KHOA K JOIN BO_MON BM on k.MAKHOA  = BM.MAKHOA JOIN GIANG_VIEN GV on BM.MABOMON = GV.MABOMON  WHERE K.MAKHOA = @makhoa 




GO
/****** Object:  StoredProcedure [dbo].[kiemtratinnhan]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


	CREATE proc  [dbo].[kiemtratinnhan] 
	@code  nvarchar(max) 
	AS 
	SELECT  * from  chat c where c.COUNT_MSG > 0 AND c.LAST_USER  like @code    	






GO
/****** Object:  StoredProcedure [dbo].[p_them_cauhoi_congviec2]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[p_them_cauhoi_congviec2] @maCV int,@chuong int ,@soluong int
as
begin
INSERT INTO CT_TAO_CAU_HOI(MACV,MACHUONG,SL) VALUES (@maCV,@chuong,@soluong)
end







GO
/****** Object:  StoredProcedure [dbo].[p_themCongViec_CAUHOI_CONG_VIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[p_themCongViec_CAUHOI_CONG_VIEC] @MAMON int,@MAGV int ,@MALOAICV int,@TGBATDAU datetime,
@TGKETTHUC datetime,@NOIDUNGCV ntext
AS 

BEGIN

SET NOCOUNT ON
BEGIN TRY
DECLARE @result int;

INSERT INTO CONG_VIEC(MAMON,MAGV,MALOAICV,TGBATDAU,TGKETTHUC,NOIDUNGCV,TRANGTHAI)
	VALUES(@MAMON,@MAGV,@MALOAICV,@TGBATDAU,@TGKETTHUC,@NOIDUNGCV,0);
	--INSERT INTO CT_TAO_CAU_HOI VALUES (IDENT_CURRENT('CONG_VIEC'),@MACHUONG,@SOLUONGCAUHOITOIDA);
		SET @result =IDENT_CURRENT('CONG_VIEC');
		SELECT @result as result;
END TRY

BEGIN CATCH
	RAISERROR('CẬP NHẬT THẤT BẠI',16,1);
END CATCH



END







GO
/****** Object:  StoredProcedure [dbo].[p_themCongViec_CONG_VIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[p_themCongViec_CONG_VIEC] @MAMON int,@MAGV int ,@MALOAICV int,@TGBATDAU datetime,
@TGKETTHUC datetime,@NOIDUNGCV ntext
AS 
BEGIN
if exists (select * from CONG_VIEC where MALOAICV=@MALOAICV and MAMON=@MAMON and TRANGTHAI=0) 	
	 begin
	 RAISERROR (N'Job in progress. Can not change!.',16,1);
	 end
	 else begin
	BEGIN TRY
	INSERT INTO CONG_VIEC(MAMON,MAGV,MALOAICV,TGBATDAU,TGKETTHUC,NOIDUNGCV,TRANGTHAI)
	VALUES(@MAMON,@MAGV,@MALOAICV,@TGBATDAU,@TGKETTHUC,@NOIDUNGCV,0);
	UPDATE MON_HOC SET TRANGTHAI ='FALSE' WHERE MAMON=@MAMON;

	END TRY

	BEGIN CATCH
	RAISERROR (N'Add failed!',16,1);
	END CATCH
	end
END









GO
/****** Object:  StoredProcedure [dbo].[p_themCongViec2_CONG_VIEC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[p_themCongViec2_CONG_VIEC] @MAMON int,@MAGV int ,@MALOAICV int,@TGBATDAU datetime,
@TGKETTHUC datetime,@NOIDUNGCV ntext,@SOlUONGDETOIDA int
AS 
BEGIN
		if exists (select * from CONG_VIEC where MALOAICV=@MALOAICV and MAMON=@MAMON and TRANGTHAI=0) 	
	 begin
	 RAISERROR (N'Job in progress. Can not change!.',16,1);
	 end
	 else begin

	BEGIN TRY
		
	INSERT INTO CONG_VIEC(MAMON,MAGV,MALOAICV,TGBATDAU,TGKETTHUC,NOIDUNGCV,TRANGTHAI)
	VALUES(@MAMON,@MAGV,@MALOAICV,@TGBATDAU,@TGKETTHUC,@NOIDUNGCV,0);

	UPDATE CAU_TRUC_DE_THI SET TRANGTHAI =0,SLDETOIDA=@SOlUONGDETOIDA,MAGV=@MAGV WHERE	MAMON=@MAMON
	
	END TRY

	BEGIN CATCH
	
	RAISERROR (N'Add failed!',16,1);
	END CATCH
	end
END 


GO
/****** Object:  StoredProcedure [dbo].[proc_add_cauhoi]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_add_cauhoi] 
  @noidung ntext ,
  @machuong int ,
  @mamon int ,
  @madokho int ,
  @magv int ,
  @out  int  OUTPUT
  AS
   set @out  = 0 ;
  BEGIN 
  IF EXISTS (SELECT * FROM CHUONG_MUC CM WHERE CM.MACHUONG = @machuong AND CM.MAMON =@mamon )
       AND EXISTS (SELECT * FROM GIANG_VIEN GV  WHERE GV.MAGV = @magv)
	    AND EXISTS (SELECT * FROM DO_KHO DK WHERE DK.MADOKHO = @madokho)
		  BEGIN 
		  BEGIN TRANSACTION;  
		  INSERT INTO CAU_HOI VALUES(@noidung , @machuong , @mamon, @madokho , @magv ,0)
		  set @out =  SCOPE_IDENTITY()
		  COMMIT
		   END
	END   







GO
/****** Object:  StoredProcedure [dbo].[proc_add_dapan]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROC [dbo].[proc_add_dapan] 
	@MACH INT ,
    @NOIDUNG ntext ,
	@DAPANDUNG BIT 
	AS 
	SET NOCOUNT ON
	DECLARE @res bit 
	BEGIN 
	 set @res =   0 
	  IF  EXISTS( SELECT * FROM CAU_HOI  DN WHERE  DN.MACH = @MACH )
	  BEGIN
	   INSERT INTO DAP_AN  VALUES(@MACH ,  @NOIDUNG , @DAPANDUNG )
	   set @res = 1 
	    END
	   ELSE 
	   PRINT N'MÃ CÂU HỎI KHÔNG TỒN TẠI'
	   SELECT @res
	  END








GO
/****** Object:  StoredProcedure [dbo].[proc_danhsachcongviec_cuabonom]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_danhsachcongviec_cuabonom] 
   @magvTruongBmon int  
   AS 
    SELECT CV.MACV  , MH.TENMON , GV.TENGV , GV.ANHGV , l.TENLOAICV  ,CV.TGBABTDAU ,CV.TGKETTHUC ,CV.TRANGTHAI ,CV.NOIDUNGCV ,MH.TRANGTHAI ,l.MALOAICV ,( SELECT CT.TRANGTHAI FROM CAU_TRUC_DE_THI CT where  CT.MAMON = CV.MAMON) AS TRANGTHAICTdt, CV.MAMON  FROM CONG_VIEC  CV JOIN GIANG_VIEN GV ON GV.MAGV = CV.MAGV JOIN MON_HOC MH on CV.MAMON = MH.MAMON  JOIN LOAI_CONG_VIEC L ON L.MALOAICV = CV.MALOAICV WHERE  CV.MAMON IN ( SELECT MH.MAMON  FROM   BO_MON B JOIN MON_HOC MH on B.MABOMON = MH.MABOMON  WHERE B.MABOMON in 
	(SELECT BM.MABOMON FROM BO_MON BM where  BM.MAGV = @magvTruongBmon )
	) 



GO
/****** Object:  StoredProcedure [dbo].[proc_danhsachcongviec_cuakhoa]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_danhsachcongviec_cuakhoa] 
   @magvTruongKhoa int  
   AS 
    SELECT CV.MACV  , MH.TENMON , GV.TENGV , GV.ANHGV , l.TENLOAICV  ,CV.TGBABTDAU ,CV.TGKETTHUC ,CV.TRANGTHAI ,CV.NOIDUNGCV , MH.TRANGTHAI ,l.MALOAICV
	,( SELECT CT.TRANGTHAI FROM CAU_TRUC_DE_THI CT where  CT.MAMON = CV.MAMON) AS TRANGTHAICTdt, CV.MAMON  FROM  CONG_VIEC  CV JOIN GIANG_VIEN GV ON GV.MAGV = CV.MAGV JOIN MON_HOC MH  on CV.MAMON = MH.MAMON JOIN LOAI_CONG_VIEC l ON CV.MALOAICV = l.MALOAICV  WHERE  CV.MAMON IN ( SELECT MH.MAMON  FROM KHOA  K JOIN  BO_MON B on k.MAKHOA = b.MAKHOA JOIN MON_HOC MH on B.MABOMON = MH.MABOMON  WHERE K.MAKHOA IN
	(SELECT k.MAKHOA FROM KHOA k where  k.MAGV = @magvTruongKhoa )
	) 



GO
/****** Object:  StoredProcedure [dbo].[proc_DsChuongByMAMH]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_DsChuongByMAMH] 
@MAMH  int 
AS
SELECT * FROM MON_HOC MH INNER JOIN CHUONG_MUC CH ON MH.MAMON = CH.MAMON  WHERE MH.MAMON = @MAMH







GO
/****** Object:  StoredProcedure [dbo].[proc_DSMonHocByMAGV]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_DSMonHocByMAGV] 
  @MAGV int  
  AS
  BEGIN
 SELECT MH.MAMON  ,MH.TENMON , MH.MABOMON  FROM GIANG_VIEN GV JOIN QUAN_LY_MH QL ON GV.MAGV = QL.MAGV JOIN MON_HOC MH ON MH.MAMON = QL.MAMON   WHERE GV.MAGV = @MAGV 
  END







GO
/****** Object:  StoredProcedure [dbo].[proc_login_GIANGVIEN_ResSmg]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC  [dbo].[proc_login_GIANGVIEN_ResSmg] 
	 @email nvarchar(50) ,
	 @pass nvarchar(40) 
   AS
    BEGIN
	 DECLARE @res nvarchar(255) ; 
	  if EXISTS (SELECT * FROM GIANG_VIEN GV  where GV.EMAIL = @email )
	     BEGIN 
			  if EXISTS ( SELECT * FROM GIANG_VIEN GV where GV.email = @email AND  GV.MATKHAU  = @pass)
			   set @res = ( SELECT G.MAGV FROM GIANG_VIEN G where G.EMAIL = @email AND  G.MATKHAU = @pass) 
			   ELSE
			   set @res = N'Mật khẩu không đúng '
		END
		ELSE
		set @res = N' Tài khoản không tồn tại ' 
     SELECT @res 
	END







GO
/****** Object:  StoredProcedure [dbo].[proc_paging_query]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[proc_paging_query]( @p_page_number integer, @p_size integer, @p_sum_page integer out, @p_sum_records integer out, @sql_query varchar(255)) as 
begin
   set
      nocount 
      on;
declare @v_start integer;
declare @v_end integer ;
declare @v_total_item integer = 0;
DECLARE @qr nvarchar(1000) 
set
   @v_start = 
   (
((@p_page_number - 1) * @p_size)
   )
;
-- set v_end =(v_start+p_size)-1;
-- caculate number of record in table use input
set
   @qr = concat('select @total_item = count(*) from ( ', @sql_query, ' ) q');
exec sp_executesql @qr, N'@total_item integer out', @total_item = @v_total_item out;
-- set value
set
   @p_sum_records = @v_total_item;
-- caculate number of pages
if ((@v_total_item % @p_size) = 0) 
begin
   set
      @p_sum_page = @v_total_item / @p_size;
end
else
   begin
      set
         @p_sum_page = 
         (
            @v_total_item / @p_size
         )
          + 1;
   end
   -- result of paging
   set
      @qr = concat('select * from ( ', @sql_query, ' ) q  order by 1 OFFSET ', @v_start, ' ROWS FETCH NEXT ', @p_size, ' ROWS ONLY ');
   exec sp_executesql  @qr ;
end
;
GO
/****** Object:  StoredProcedure [dbo].[proc_thongkecauhoi_bomon]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[proc_thongkecauhoi_bomon] 
@makhoa INT ,
@mabomon INT = NULL
AS
begin 
select K.TENKHOA , BM.TENBOMON , MH.TENMON , sum(case WHEN DK.MADOKHO = 1 THEN 1 ELSE 0 END )  AS CAUKHO ,
                                           sum(case when DK.MADOKHO =2 then 1 else 0 end) AS CAUDE ,
										    COUNT(CH.MACH) AS  Tong
											 FROM  KHOA K JOIN BO_MON BM ON K.MAKHOA =  BM.MAKHOA 
											              JOIN MON_HOC MH ON BM.MABOMON = mh.MABOMON 
														  JOIN CAU_HOI CH ON MH.MAMON = CH.MAMON 
														  JOIN DO_KHO DK ON CH.MADOKHO = DK.MADOKHO WHERE CH.TRANGTHAI = 1
														  GROUP BY K.MAKHOA , K.TENKHOA ,BM.MABOMON ,BM.TENBOMON ,MH.MAMON , MH.TENMON
							                            HAVING @makhoa = K.MAKHOA AND (@mabomon is null or @mabomon=  BM.MABOMON )
							END





GO
/****** Object:  StoredProcedure [dbo].[PROCEDURE_INSERTORUPDATE_CAUTRUCDETHI]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[PROCEDURE_INSERTORUPDATE_CAUTRUCDETHI](@MACTDT INT, @MACHUONG INT, @MADOKHO INT, @SLCAUHOI SMALLINT, @TONGDIEM FLOAT) 
 AS
 BEGIN
 IF EXISTS (SELECT * FROM CHI_TIET_CTDT WHERE MACTDT= @MACTDT AND MACHUONG=@MACHUONG AND MADOKHO=@MADOKHO)
	BEGIN
		 IF (SELECT COUNT(*) FROM CAU_HOI WHERE MACHUONG=@MACHUONG AND MADOKHO=@MADOKHO )>= @SLCAUHOI
			BEGIN
				UPDATE CHI_TIET_CTDT SET SLCAUHOI=@SLCAUHOI, TONGDIEM=@TONGDIEM WHERE MACTDT=@MACTDT AND MACHUONG=@MACHUONG AND MADOKHO=@MADOKHO;
			END
		 ELSE
			BEGIN
				RAISERROR(N'SỐ LƯỢNG QUÁ MỨC CHO PHÉP!',16,1);
			END
	END
 ELSE
	BEGIN
		IF (SELECT COUNT(*) FROM CAU_HOI WHERE MACHUONG=@MACHUONG AND MADOKHO=@MADOKHO )>= @SLCAUHOI
			BEGIN
				INSERT INTO CHI_TIET_CTDT VALUES(@MACTDT, @MACHUONG, @MADOKHO, @SLCAUHOI, @TONGDIEM);
			END
		 ELSE
			BEGIN
				RAISERROR(N'SỐ LƯỢNG QUÁ MỨC CHO PHÉP!',16,1);
			END
	END
 END	







GO
/****** Object:  StoredProcedure [dbo].[themnoidung]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[themnoidung]
 @code nvarchar(max) ,
 @room_id  nvarchar(max) ,
 @body ntext , 
 @url  nvarchar(255) 
 AS
 DECLARE @chat_id int  , @client nvarchar(255) , @date datetime = getdate() 
 IF NOT EXISTS (SELECT * FROM  chat c where c.code = @code  AND c.room_id = @room_id OR c.code = @room_id AND c.room_id = @code )
   BEGIN 
   begin tran 
     INSERT INTO chat(code , room_id , COUNT_MSG , LAST_USER) values (@code , @room_id , 1 ,@room_id ) 
	   set @chat_id  =  SCOPE_IDENTITY()  
	    commit tran
		end
    ELSE  
	BEGIN 
	DECLARE @count  int = (select c.COUNT_MSG from chat c where  c.code = @code  AND c.room_id = @room_id OR c.code = @room_id AND c.room_id = @code)
	UPDATE chat set COUNT_MSG = @count + 1  ,  LAST_USER = @room_id where  code = @code  AND room_id = @room_id OR code = @room_id AND room_id = @code
	set @chat_id  = ( SELECT c.chat_id FROM  chat c where c.code = @code  AND c.room_id = @room_id OR c.code = @room_id AND c.room_id = @code) 
	END 
	BEGIN 
	INSERT chatdetails values (@body , @date , @chat_id  ,  @url , @room_id)   
	end






GO
/****** Object:  Trigger [dbo].[INSERT_GV_INTO_QLMH]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  create trigger [dbo].[INSERT_GV_INTO_QLMH] on [dbo].[MON_HOC] AFTER UPDATE
  as

BEGIN
 IF(UPDATE(MAGV))
 BEGIN
	 IF EXISTS (SELECT  * FROM inserted WHERE MAGV IS NOT NULL)
		IF NOT EXISTS (SELECT * FROM QUAN_LY_MH  JOIN inserted ON inserted.MAGV = QUAN_LY_MH.MAGV AND inserted.MAMON=QUAN_LY_MH.MAMON)
			INSERT INTO QUAN_LY_MH(MAGV,MAMON) SELECT MAGV,MAMON FROM INSERTED
 END

END





GO
/****** Object:  Trigger [dbo].[TRIGGER_INSERT_CAUTRUCDETHI_WHEN_CREATE_MONHOC]    Script Date: 6/2/2018 18:53:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[TRIGGER_INSERT_CAUTRUCDETHI_WHEN_CREATE_MONHOC] ON [dbo].[MON_HOC] AFTER INSERT
AS
BEGIN
	DECLARE @MAMON INT;
	SET @MAMON = (SELECT MAMON FROM inserted)
	INSERT INTO CAU_TRUC_DE_THI(MAMON,NGAYCAPNHAT,TRANGTHAI,SLDETOIDA) VALUES(@MAMON,GETDATE(),0,0);
END






GO
USE [master]
GO
ALTER DATABASE [HTTTQL] SET  READ_WRITE 
GO


CREATE PROC [dbo].[p_addStructureTestDetail] (@mactdt int, @machuong int, @madokho int, @slcauhoi smallint, @tongdiem float)
AS
BEGIN
begin try

	IF EXISTS (SELECT 1 FROM CHI_TIET_CTDT WHERE MACTDT = @mactdt AND MACHUONG = @machuong   and MADOKHO = @madokho)
		BEGIN
			UPDATE CHI_TIET_CTDT
			SET SLCAUHOI = @slcauhoi, TONGDIEM = @tongdiem
			WHERE MACTDT = @mactdt AND MACHUONG = @machuong and MADOKHO = @madokho
		END
	ELSE
		BEGIN
			INSERT INTO CHI_TIET_CTDT (MACTDT, MACHUONG, MADOKHO, SLCAUHOI, TONGDIEM)
			VALUES (@mactdt, @machuong, @madokho, @slcauhoi, @tongdiem)
		END
		END TRY

	BEGIN CATCH
	
	RAISERROR (N'Add failed',16,1);
	END CATCH
END

	