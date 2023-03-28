create database CourseDb

use CourseDb

create table Students(
[Id] int primary key identity(1,1),
[Name] nvarchar(50),
[Surname] nvarchar(50),
[Age] int,
[Email] nvarchar(50) unique,
[Address] nvarchar(100)
)

insert into Students ([Name],[Surname],[Age],[Email],[Address])
VALUES ('Anar','Aliyev',24,'anar@code.edu.az','Raboci'),
       ('Samil','Abbasli',26,'samil@code.edu.az','Bayil'),
       ('Cavid','Bashirov',29,'cavid@code.edu.az','Ehmedli'),
       ('Besir','Huseynzade',23,'besir@code.edu.az','Mastaga'),
       ('Gunel','Semedova',31,'gunel@code.edu.az','Elmler'),
	   ('Sehla','Imanova',28,'sehla@code.edu.az','Elmler')


create table StudentArchives(
 [Id] int primary key identity(1,1),
 [StudentID] int,
 [Operation] nvarchar(10),
 [Date] datetime 
)
 create trigger trg_deleteStudent on Students
 after delete
 as
 BEGIN
   insert into StudentArchives([StudentID],[Operation],[Date])
   select Id,'Delete',GETDATE() from deleted
 END

 delete from Students where Id=1


create procedure usp_deleteStudent
 @id int
 as
 BEGIN
 delete from Students where Id = @id
 END


 exec usp_deleteStudent 2
