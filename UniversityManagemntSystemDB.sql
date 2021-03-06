USE [UniversityCourseAndResultManagementDB]
GO
/****** Object:  StoredProcedure [dbo].[spAddCourse]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddCourse]
@Code nvarchar(50),
@Name nvarchar(50),
@Credit float,
@Description nvarchar(max),
@DepartmentId int,
@SemesterId int
AS
BEGIN
INSERT INTO t_Course VALUES(@Code,@Name,@Credit,@Description,@DepartmentId,@SemesterId);
END
GO
/****** Object:  StoredProcedure [dbo].[spAddStudent]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddStudent]
@Name nvarchar(50),
@RegNo nvarchar(20),
@Email nvarchar(50),
@ContactNo nvarchar(20),
@RegisterationDate datetime,
@Address nvarchar(50),
@DepartmentId int
AS
BEGIN
INSERT INTO t_Student VALUES(@Name,@RegNo,@Email,@ContactNo,@RegisterationDate,@Address,@DepartmentId);
END
GO
/****** Object:  StoredProcedure [dbo].[spAddTeacher]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spAddTeacher]
@Name nvarchar(50),
@Address nvarchar(Max),
@Email nvarchar(50),
@Contact nvarchar(50),
@DesignationId int,
@DepartmentId int,
@CreditTobeTaken float,
@RemainingCredit float
AS
BEGIN

INSERT INTO t_Teacher VALUES(@Name,@Address,@Email,@Contact, @DesignationId,@DepartmentId,@CreditTobeTaken,@RemainingCredit)
END
GO
/****** Object:  StoredProcedure [dbo].[spClassScheduleAndClassRoomAllocation]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spClassScheduleAndClassRoomAllocation]
AS
BEGIN
SELECT d.Id as DepartmentId,c.Code,c.Name,COALESCE(t_Room.Name,'Not sheduled yet') AS Room_Name,t_Day.Name as Day_Name,r.StartTime,r.EnTime as EndTime
FROM t_Course c  LEFT OUTER JOIN t_AllocateClassRoom r
ON r.CourseId=c.Id LEFT OUTER JOIN t_Room  
ON r.RoomId=t_Room.Id LEFT OUTER JOIN t_Day 
ON r.DayId=t_Day.Id LEFT OUTER JOIN t_Departments d ON c.DepartmentId=d.Id 
END

GO
/****** Object:  StoredProcedure [dbo].[spDepartmentInformationWithTeacher]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spDepartmentInformationWithTeacher]
As
BEGIN
SELECT d.Id,d.Code,d.Name, COALESCE(t.Name,'Not Assign yet') as Teacher,t.Email,t.Contact FROM t_Departments d LEFT OUTER JOIN t_Teacher t ON d.Id=t.DepartmentId
END
GO
/****** Object:  StoredProcedure [dbo].[spGetCourseByStudentId]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCourseByStudentId]
@Id  int
AS
 BEGIN
Select C.Id,c.Code,c.Name,c.Credit,c.Descirption,c.DepartmentId,c.SemesterId FROM t_Departments d INNER JOIN t_Course c ON d.Id=c.DepartmentId AND d.Id=(SELECT s.DepartmentId FROM t_Student s WHERE s.Id=@Id)
END
GO
/****** Object:  StoredProcedure [dbo].[spGetCourseInformation]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCourseInformation]
AS
BEGIN
SELECT d.Id as DepartmentId,COALESCE(c.Code,'Not Assigned yet') AS Code,COALESCE(c.Name,'Not Assigned yet') AS Name,COALESCE(s.Name,'Not Assigned yet') as Semester,COALESCE(t.Name,'Not Assigned yet')  as Teacher FROM  t_Departments d  LEFT OUTER JOIN t_Course  c  ON d.Id=c.DepartmentId LEFT OUTER JOIN  t_Semester s ON c.SemesterId=s.Id  LEFT OUTER JOIN t_CourseAssignToTeacher Ct  ON (c.Id=Ct.CourseId AND Ct.IsActive=1) LEFT OUTER JOIN t_Teacher t ON t.Id=Ct.TeacherId ORDER BY c.Code
END
GO
/****** Object:  StoredProcedure [dbo].[spGetCoursesTakenByaStudent]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetCoursesTakenByaStudent]
  @StudentId int
  AS
  BEGIN
  SELECT c.Id,c.Code,c.Name,c.Credit,c.Descirption,c.DepartmentId,c.SemesterId FROM t_Course c INNER JOIN t_StudentEnrollInCourse r ON (c.Id=r.CourseId AND r.StudentId=@StudentId AND r.IsStudentActive=1)
  END


GO
/****** Object:  StoredProcedure [dbo].[spGetStudentInformationById]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE PROCEDURE [dbo].[spGetStudentInformationById]
  @Id int
  AS
  BEGIN

  SELECT s.Id,s.RegNo,s.Name,s.Email,s.ContactNo,s.RegisterationDate,s.Address,d.Name as Department FROM t_Student s INNER JOIN t_Departments d ON s.DepartmentId=d.Id AND s.Id=@Id
  END
GO
/****** Object:  StoredProcedure [dbo].[spGetStudentResult]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spGetStudentResult]
@studentId int
AS
BEGIN
SELECT en.StudentId, c.Code,c.Name,COALESCE(r.Grade,'Not Graded yet') as Grade FROM t_StudentResult r RIGHT OUTER JOIN ( SELECT e.Id,e.StudentId,e.CourseId FROM t_StudentEnrollInCourse e WHERE e.StudentId=@studentId AND e.IsStudentActive=1) en ON r.CourseId=en.CourseId AND r.StudentId=en.StudentId AND r.IsStudentActive=1 INNER JOIN t_Course c ON en.CourseId=c.Id
END



GO
/****** Object:  Table [dbo].[t_AllocateClassRoom]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[t_AllocateClassRoom](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[RoomId] [int] NOT NULL,
	[DayId] [int] NOT NULL,
	[StartTime] [varchar](50) NOT NULL,
	[EndTime] [varchar](50) NOT NULL,
	[AllocationStatus] [bit] NULL,
 CONSTRAINT [PK_t_AllocateClassRoom] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[t_Course]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Course](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](50) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Credit] [float] NOT NULL,
	[Descirption] [nvarchar](max) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[SemesterId] [int] NOT NULL,
 CONSTRAINT [PK_t_Course] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_CourseAssignToTeacher]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_CourseAssignToTeacher](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[TeacherId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_t_CourseAssignToTeacher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Day]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Day](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_t_Day] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Departments]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Departments](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](7) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
 CONSTRAINT [PK_t_Departments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Designation]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Designation](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](max) NULL,
 CONSTRAINT [PK_t_Designation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Room]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Room](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_t_Room] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Semester]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Semester](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_t_Semester] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Student]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Student](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[RegNo] [nvarchar](20) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[ContactNo] [nvarchar](20) NOT NULL,
	[RegisterationDate] [date] NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[DepartmentId] [int] NOT NULL,
 CONSTRAINT [PK_t_Student] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_StudentEnrollInCourse]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_StudentEnrollInCourse](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[EnrollDate] [date] NOT NULL,
	[IsStudentActive] [bit] NULL,
 CONSTRAINT [PK_t_StudentEnrollInCourse] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_StudentResult]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_StudentResult](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StudentId] [int] NOT NULL,
	[CourseId] [int] NOT NULL,
	[Grade] [nvarchar](5) NOT NULL,
	[IsStudentActive] [bit] NULL,
 CONSTRAINT [PK_t_StudentResult] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[t_Teacher]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_Teacher](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[Contact] [nvarchar](50) NOT NULL,
	[DesignationId] [int] NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[CreditToBeTaken] [float] NOT NULL,
	[CreditTaken] [float] NOT NULL,
 CONSTRAINT [PK_t_Teacher] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  View [dbo].[classSchedule]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[classSchedule]
AS
SELECT c.Id as CourseId,c.DepartmentId,c.Code,c.Name,concat(r.Name,',', t_Day.Name,',',cr.StartTime,'-',cr.EnTime,';')
 AS 'Schedule_Inforamtion' FROM t_Course c LEFT OUTER JOIN t_AllocateClassRoom  cr
ON c.Id=cr.CourseId  LEFT OUTER JOIN t_Room r
ON cr.RoomId=r.Id
LEFT OUTER JOIN t_Day 
ON cr.DayId=t_Day.Id
GO
/****** Object:  View [dbo].[GetStudentResult]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[GetStudentResult]
AS
SELECT en.StudentId, c.Code,c.Name,COALESCE(r.Grade,'Not Graded yet') as Grade,r.IsStudentActive FROM t_StudentResult r RIGHT OUTER JOIN ( SELECT e.Id,e.StudentId,e.CourseId FROM t_StudentEnrollInCourse e WHERE  e.IsStudentActive=1) en ON r.CourseId=en.CourseId AND r.StudentId=en.StudentId INNER JOIN t_Course c ON en.CourseId=c.Id
GO
/****** Object:  View [dbo].[ScheduleOfClass]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ScheduleOfClass]
AS
SELECT d.Id as DepartmentId,c.Id AS CourseId,c.Code,c.Name,COALESCE(t_Room.Name,'Not sheduled yet') AS Room_Name,COALESCE(t_Day.Name,'Not sheduled yet') as Day_Name,

case when r.StartTime IS NULL THEN '00:00:00.0000000'
else CONVERT(varchar, r.StartTime) end as StartTime,
case when r.EndTime IS NULL THEN '00:00:00.0000000'
else CONVERT(varchar, r.EndTime) end as EndTime,
COALESCE(AllocationStatus,0) AS AllocationStatus
FROM t_Course c  LEFT OUTER JOIN t_AllocateClassRoom r
ON r.CourseId=c.Id LEFT OUTER JOIN t_Room  
ON r.RoomId=t_Room.Id LEFT OUTER JOIN t_Day 
ON r.DayId=t_Day.Id LEFT OUTER JOIN t_Departments d ON c.DepartmentId=d.Id 
GO
/****** Object:  View [dbo].[StudentResult]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create VIEW [dbo].[StudentResult]
AS
SELECT c.Id,c.Code,c.Name,r.Grade FROM t_Course c INNER JOIN ( SELECT r.Id,r.StudentId,r.CourseId,r.Grade FROM t_StudentResult r WHERE StudentId=2 ) r  ON  c.Id=r.CourseId 
GO
/****** Object:  View [dbo].[TestView]    Script Date: 2/15/2016 12:14:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[TestView]
AS
SELECT d.Id as DepartmentId,c.Code,c.Name,COALESCE(t_Room.Name,'Not sheduled yet') AS Room_Name,COALESCE(t_Day.Name,'Not sheduled yet') as Day_Name,
r.StartTime,r.EnTime
FROM t_Course c  LEFT OUTER JOIN t_AllocateClassRoom r
ON r.CourseId=c.Id LEFT OUTER JOIN t_Room  
ON r.RoomId=t_Room.Id LEFT OUTER JOIN t_Day 
ON r.DayId=t_Day.Id LEFT OUTER JOIN t_Departments d ON c.DepartmentId=d.Id
GO
SET IDENTITY_INSERT [dbo].[t_AllocateClassRoom] ON 

INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1, 1, 1, 1, 1, N'1:45 PM', N'2:45 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (2, 2, 6, 1, 2, N'1:45 PM', N'2:45 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1001, 1, 1, 1, 1, N'2:45 PM', N'3:45 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1002, 1, 2, 1, 1, N'3:45 PM', N'4:30 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1003, 1, 1, 1, 1, N'1:45 PM', N'2:45 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1004, 1, 2, 1, 1, N'12:00 PM', N'1:00 PM', 0)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1005, 1, 1, 1, 2, N'9:45 AM', N'10:45 AM', 1)
INSERT [dbo].[t_AllocateClassRoom] ([Id], [DepartmentId], [CourseId], [RoomId], [DayId], [StartTime], [EndTime], [AllocationStatus]) VALUES (1006, 2, 4, 1, 1, N'9:45 AM', N'10:45 AM', 1)
SET IDENTITY_INSERT [dbo].[t_AllocateClassRoom] OFF
SET IDENTITY_INSERT [dbo].[t_Course] ON 

INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (1, N'CSE-101', N'Computer Fundamental', 4.5, N'This Computer Fundamentals  covers a foundational understanding of computer hardware, software, operating systems, peripherals etc. along with how to get the most value and impact from computer technology.', 1, 1)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (2, N'CSE-102', N'Programming With C', 4, N'C is a general-purpose, procedural, imperative computer programming language developed in 1972 by Dennis M. Ritchie at the Bell Telephone Laboratories to develop the UNIX operating system. C is the most widely used computer language. It keeps fluctuating at number one scale of popularity along with Java programming language, which is also equally popular and most widely used among modern software programmers.', 1, 1)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (3, N'CSE-401', N'Compiler Design', 4.5, N'Compiler design principles provide an in-depth view of translation and optimization process. Compiler design covers basic translation mechanism and error detection & recovery. It includes lexical, syntax, and semantic analysis as front end, and code generation and optimization as back-end.', 1, 7)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (4, N'ICE-101', N'Basic Eloctronics', 3.5, N'There are many different kinds of capacitors available from very small capacitor beads used in resonance circuits to large power factor correction capacitors, but they all do the same thing, they store charge.', 2, 1)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (5, N'EEE-101', N'Fundamental of Electrical Engineering', 5, N'Electrical engineering is a field of engineering that generally deals with the study and application of electricity, electronics, and electromagnetism. This field first became an identifiable occupation in the latter half of the 19th century after commercialization of the electric telegraph, the telephone, and electric power distribution and use. Subsequently, broadcasting and recording media made electronics part of daily life. The invention of the transistor, and later the integrated circuit, brought down the cost of electronics to the point they can be used in almost any household object.', 3, 3)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (6, N'ICE-201', N'Network Theory', 4, N'Description of Network Theory', 2, 4)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (7, N'EEE-201', N'Programming With JAVA', 4, N'Descrip tion Programming With JAVA', 3, 2)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (8, N'BAN-101', N'Bangla-1', 4, N'Description of Bangla-1', 5, 1)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (9, N'BAN-102', N'Bangla-2', 5, N'Description of Bangla-2', 5, 2)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (1001, N'ENG-201', N'English Litature', 4.5, N'Description of English Litature', 4, 3)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (1002, N'ENG-202', N'English Gramar', 4, N'Description of English Gramar ', 4, 3)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (1003, N'AECE-101', N'Discrite Mathmathics', 4, N'Description of Discrite Mathmathics', 6, 4)
INSERT [dbo].[t_Course] ([Id], [Code], [Name], [Credit], [Descirption], [DepartmentId], [SemesterId]) VALUES (1004, N'AECE-120', N'Telecommunication Engineering', 4, N'Description of Telecommunication Engineering', 6, 4)
SET IDENTITY_INSERT [dbo].[t_Course] OFF
SET IDENTITY_INSERT [dbo].[t_CourseAssignToTeacher] ON 

INSERT [dbo].[t_CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [IsActive]) VALUES (1, 1, 1, 3, 0)
INSERT [dbo].[t_CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [IsActive]) VALUES (2, 2, 2, 6, 0)
INSERT [dbo].[t_CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [IsActive]) VALUES (3, 3, 3, 5, 0)
INSERT [dbo].[t_CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [IsActive]) VALUES (1001, 1, 1, 1, 1)
INSERT [dbo].[t_CourseAssignToTeacher] ([Id], [DepartmentId], [TeacherId], [CourseId], [IsActive]) VALUES (1002, 1, 1, 2, 1)
SET IDENTITY_INSERT [dbo].[t_CourseAssignToTeacher] OFF
SET IDENTITY_INSERT [dbo].[t_Day] ON 

INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (1, N'Saturday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (2, N'Sunday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (3, N'Monday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (4, N'Tuesday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (5, N'Wednesday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (6, N'Thursday')
INSERT [dbo].[t_Day] ([Id], [Name]) VALUES (7, N'Friday')
SET IDENTITY_INSERT [dbo].[t_Day] OFF
SET IDENTITY_INSERT [dbo].[t_Departments] ON 

INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (1, N'CSE', N'Computer Science And Engineering')
INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (2, N'ICE', N'Information And Communication Engineering')
INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (3, N'EEE', N'Electrical Engineering')
INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (4, N'ENG', N'English')
INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (5, N'BAN', N'Bangla')
INSERT [dbo].[t_Departments] ([Id], [Code], [Name]) VALUES (6, N'AECE', N'Applied Physics Electronics And Communication Engineering')
SET IDENTITY_INSERT [dbo].[t_Departments] OFF
SET IDENTITY_INSERT [dbo].[t_Designation] ON 

INSERT [dbo].[t_Designation] ([Id], [Title]) VALUES (1, N'Programmer')
INSERT [dbo].[t_Designation] ([Id], [Title]) VALUES (2, N'Lecturer')
INSERT [dbo].[t_Designation] ([Id], [Title]) VALUES (3, N'Associtate Professor')
INSERT [dbo].[t_Designation] ([Id], [Title]) VALUES (4, N'Proffesore')
SET IDENTITY_INSERT [dbo].[t_Designation] OFF
SET IDENTITY_INSERT [dbo].[t_Room] ON 

INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (1, N'Room No:101')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (2, N'Room No:102')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (3, N'Room No:201')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (4, N'Room No:301')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (5, N'Room No:302')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (6, N'Room No:303')
INSERT [dbo].[t_Room] ([Id], [Name]) VALUES (7, N'Room No:304')
SET IDENTITY_INSERT [dbo].[t_Room] OFF
SET IDENTITY_INSERT [dbo].[t_Semester] ON 

INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (1, N'1st')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (2, N'2nd')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (3, N'3rd')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (4, N'4th')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (5, N'5th')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (6, N'6th')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (7, N'7th')
INSERT [dbo].[t_Semester] ([Id], [Name]) VALUES (8, N'8th')
SET IDENTITY_INSERT [dbo].[t_Semester] OFF
SET IDENTITY_INSERT [dbo].[t_Student] ON 

INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (1, N'CSE-2016-001', N'Md.Abdus Salam', N'salamcseiu21@gmail.com', N'01520102680', CAST(0x043B0B00 AS Date), N'Nilphamari', 1)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (2, N'CSE-2016-002', N'Jabir Hossain', N'jabirhasan@gmail.com', N'01962344627', CAST(0x143B0B00 AS Date), N'Chuyadanga', 1)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (3, N'CSE-2016-003', N'Shohana Khatun', N'shohana@gmail.com', N'01722852200', CAST(0x073B0B00 AS Date), N'Dhaka', 1)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (4, N'ICE-2016-001', N'Sharmin Naher', N'putulice@yahoo.com', N'01750142541', CAST(0x073B0B00 AS Date), N'Kushtia', 2)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (5, N'ENG-2016-001', N'Mehedi Hasan', N'mehedihsan@gmail.com', N'0172541695', CAST(0x073B0B00 AS Date), N'Kushtia', 4)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (6, N'CSE-2016-004', N'Kajol Mollick', N'kajolmollick@gmail.com', N'01722852200', CAST(0x073B0B00 AS Date), N'Meherpur', 1)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (7, N'CSE-2016-005', N'Rumana Khatun', N'rumancseiu@gmail.com', N'01722852200', CAST(0x073B0B00 AS Date), N'Rangpur', 1)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (8, N'ENG-2016-002', N'Lipi Akter', N'lipiakater@gmail.com', N'01722852200', CAST(0x143B0B00 AS Date), N'Khulna', 4)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (9, N'ENG-2016-003', N'Kalam Miah', N'kalammiah@gmail.com', N'0172541695', CAST(0x0D3B0B00 AS Date), N'Kurigram', 4)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (10, N'BAN-2016-001', N'Sumon Khondokar', N'sumon@gmail.com', N'01962344627', CAST(0x063B0B00 AS Date), N'Dhaka', 5)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (11, N'BAN-2016-002', N'Sadiya Jahan', N'sadiya@gmail.com', N'01750142541', CAST(0x123B0B00 AS Date), N'Kushtia', 5)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (12, N'ENG-2016-004', N'Md.Noyon Miah', N'noyon@gmail.com', N'01740147407', CAST(0x083B0B00 AS Date), N'Nilphamari', 4)
INSERT [dbo].[t_Student] ([Id], [RegNo], [Name], [Email], [ContactNo], [RegisterationDate], [Address], [DepartmentId]) VALUES (13, N'AECE-2016-001', N'Nahid Sulatan', N'nahidsultan@gmail.com', N'01962344627', CAST(0x133B0B00 AS Date), N'Dinajpur', 6)
SET IDENTITY_INSERT [dbo].[t_Student] OFF
SET IDENTITY_INSERT [dbo].[t_StudentEnrollInCourse] ON 

INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (1, 6, 1, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (2, 6, 2, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (3, 6, 3, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (4, 1, 1, CAST(0x123B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (5, 1, 2, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (6, 1, 3, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (7, 3, 1, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (8, 3, 3, CAST(0x073B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (9, 13, 1003, CAST(0x083B0B00 AS Date), 1)
INSERT [dbo].[t_StudentEnrollInCourse] ([Id], [StudentId], [CourseId], [EnrollDate], [IsStudentActive]) VALUES (10, 13, 1004, CAST(0x083B0B00 AS Date), 1)
SET IDENTITY_INSERT [dbo].[t_StudentEnrollInCourse] OFF
SET IDENTITY_INSERT [dbo].[t_StudentResult] ON 

INSERT [dbo].[t_StudentResult] ([Id], [StudentId], [CourseId], [Grade], [IsStudentActive]) VALUES (1, 1, 1, N'A+', 1)
INSERT [dbo].[t_StudentResult] ([Id], [StudentId], [CourseId], [Grade], [IsStudentActive]) VALUES (2, 1, 2, N'A+', 1)
INSERT [dbo].[t_StudentResult] ([Id], [StudentId], [CourseId], [Grade], [IsStudentActive]) VALUES (3, 1, 3, N'A', 1)
INSERT [dbo].[t_StudentResult] ([Id], [StudentId], [CourseId], [Grade], [IsStudentActive]) VALUES (4, 13, 1003, N'B+', 1)
INSERT [dbo].[t_StudentResult] ([Id], [StudentId], [CourseId], [Grade], [IsStudentActive]) VALUES (5, 13, 1004, N'B-', 1)
SET IDENTITY_INSERT [dbo].[t_StudentResult] OFF
SET IDENTITY_INSERT [dbo].[t_Teacher] ON 

INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (1, N'Md.Ibrahim Abdullah', N'Kushtia,Bangladesh', N'ibrahim@gmail.com', N'01962344627', 4, 1, 20, 8.5)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (2, N'Md.Athikur Rahman', N'Rangpur,Bangladesh', N'athikhasan@gmail.com', N'01750142541', 2, 2, 40, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (3, N'Shohana Islam', N'Dhaka,Bangladesh', N'shohanaislam@gmail.com', N'0158745874', 2, 3, 50, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (4, N'Md.Alamgir Hossain', N'Khulna,Bangladesh', N'alamgirhossain@yahoo.com', N'01722852200', 2, 1, 40, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (5, N'Sharmin Naher', N'Kushtia,Bangladesh', N'putulcse@yahoo.com', N'0158745874', 2, 2, 40, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (6, N'Md.Muntasir Rahman', N'Nilphamari,Bangladesh', N'muntasir@gmail.com', N'01750142541', 3, 3, 30, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (7, N'Kholilur Rahaman', N'Dhaka', N'kholilurrahaman@gmail.com', N'0154212121', 2, 4, 20, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (8, N'Md.Abu Sayed', N'Mymenshing', N'mdabusaydkpi@gmail.com', N'015522222', 2, 5, 20, 0)
INSERT [dbo].[t_Teacher] ([Id], [Name], [Address], [Email], [Contact], [DesignationId], [DepartmentId], [CreditToBeTaken], [CreditTaken]) VALUES (9, N'Towfique Alihe', N'Nilphamari', N'babu@gmail.com', N'01525220', 2, 5, 20, 0)
SET IDENTITY_INSERT [dbo].[t_Teacher] OFF
ALTER TABLE [dbo].[t_AllocateClassRoom] ADD  CONSTRAINT [DF_t_AllocateClassRoom_AllocationStatus]  DEFAULT ((1)) FOR [AllocationStatus]
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher] ADD  CONSTRAINT [DF_t_CourseAssignToTeacher_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[t_StudentEnrollInCourse] ADD  CONSTRAINT [DF_t_StudentEnrollInCourse_IsStudentActive]  DEFAULT ((1)) FOR [IsStudentActive]
GO
ALTER TABLE [dbo].[t_StudentResult] ADD  CONSTRAINT [DF_t_StudentResult_IsStudentActive]  DEFAULT ((1)) FOR [IsStudentActive]
GO
ALTER TABLE [dbo].[t_AllocateClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_t_AllocateClassRoom_t_Course] FOREIGN KEY([CourseId])
REFERENCES [dbo].[t_Course] ([Id])
GO
ALTER TABLE [dbo].[t_AllocateClassRoom] CHECK CONSTRAINT [FK_t_AllocateClassRoom_t_Course]
GO
ALTER TABLE [dbo].[t_AllocateClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_t_AllocateClassRoom_t_Day] FOREIGN KEY([DayId])
REFERENCES [dbo].[t_Day] ([Id])
GO
ALTER TABLE [dbo].[t_AllocateClassRoom] CHECK CONSTRAINT [FK_t_AllocateClassRoom_t_Day]
GO
ALTER TABLE [dbo].[t_AllocateClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_t_AllocateClassRoom_t_Departments] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[t_Departments] ([Id])
GO
ALTER TABLE [dbo].[t_AllocateClassRoom] CHECK CONSTRAINT [FK_t_AllocateClassRoom_t_Departments]
GO
ALTER TABLE [dbo].[t_AllocateClassRoom]  WITH CHECK ADD  CONSTRAINT [FK_t_AllocateClassRoom_t_Room] FOREIGN KEY([RoomId])
REFERENCES [dbo].[t_Room] ([Id])
GO
ALTER TABLE [dbo].[t_AllocateClassRoom] CHECK CONSTRAINT [FK_t_AllocateClassRoom_t_Room]
GO
ALTER TABLE [dbo].[t_Course]  WITH CHECK ADD  CONSTRAINT [FK_t_Course_t_Semester] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[t_Departments] ([Id])
GO
ALTER TABLE [dbo].[t_Course] CHECK CONSTRAINT [FK_t_Course_t_Semester]
GO
ALTER TABLE [dbo].[t_Course]  WITH CHECK ADD  CONSTRAINT [FK_t_Course_t_Semester1] FOREIGN KEY([SemesterId])
REFERENCES [dbo].[t_Semester] ([Id])
GO
ALTER TABLE [dbo].[t_Course] CHECK CONSTRAINT [FK_t_Course_t_Semester1]
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher]  WITH CHECK ADD  CONSTRAINT [FK_t_CourseAssignToTeacher_t_Course] FOREIGN KEY([CourseId])
REFERENCES [dbo].[t_Course] ([Id])
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher] CHECK CONSTRAINT [FK_t_CourseAssignToTeacher_t_Course]
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher]  WITH CHECK ADD  CONSTRAINT [FK_t_CourseAssignToTeacher_t_Departments] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[t_Departments] ([Id])
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher] CHECK CONSTRAINT [FK_t_CourseAssignToTeacher_t_Departments]
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher]  WITH CHECK ADD  CONSTRAINT [FK_t_CourseAssignToTeacher_t_Teacher] FOREIGN KEY([TeacherId])
REFERENCES [dbo].[t_Teacher] ([Id])
GO
ALTER TABLE [dbo].[t_CourseAssignToTeacher] CHECK CONSTRAINT [FK_t_CourseAssignToTeacher_t_Teacher]
GO
ALTER TABLE [dbo].[t_StudentEnrollInCourse]  WITH CHECK ADD  CONSTRAINT [FK_t_StudentEnrollInCourse_t_Course] FOREIGN KEY([CourseId])
REFERENCES [dbo].[t_Course] ([Id])
GO
ALTER TABLE [dbo].[t_StudentEnrollInCourse] CHECK CONSTRAINT [FK_t_StudentEnrollInCourse_t_Course]
GO
ALTER TABLE [dbo].[t_StudentEnrollInCourse]  WITH CHECK ADD  CONSTRAINT [FK_t_StudentEnrollInCourse_t_Student] FOREIGN KEY([StudentId])
REFERENCES [dbo].[t_Student] ([Id])
GO
ALTER TABLE [dbo].[t_StudentEnrollInCourse] CHECK CONSTRAINT [FK_t_StudentEnrollInCourse_t_Student]
GO
ALTER TABLE [dbo].[t_StudentResult]  WITH CHECK ADD  CONSTRAINT [FK_t_StudentResult_t_Course] FOREIGN KEY([CourseId])
REFERENCES [dbo].[t_Course] ([Id])
GO
ALTER TABLE [dbo].[t_StudentResult] CHECK CONSTRAINT [FK_t_StudentResult_t_Course]
GO
ALTER TABLE [dbo].[t_StudentResult]  WITH CHECK ADD  CONSTRAINT [FK_t_StudentResult_t_Student] FOREIGN KEY([StudentId])
REFERENCES [dbo].[t_Student] ([Id])
GO
ALTER TABLE [dbo].[t_StudentResult] CHECK CONSTRAINT [FK_t_StudentResult_t_Student]
GO
ALTER TABLE [dbo].[t_Teacher]  WITH CHECK ADD  CONSTRAINT [FK_t_Teacher_t_Designation] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[t_Designation] ([Id])
GO
ALTER TABLE [dbo].[t_Teacher] CHECK CONSTRAINT [FK_t_Teacher_t_Designation]
GO
ALTER TABLE [dbo].[t_Teacher]  WITH CHECK ADD  CONSTRAINT [FK_t_Teacher_t_Teacher] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[t_Departments] ([Id])
GO
ALTER TABLE [dbo].[t_Teacher] CHECK CONSTRAINT [FK_t_Teacher_t_Teacher]
GO
