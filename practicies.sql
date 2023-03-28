--view-copy table herdefe table muraciyet etmemek ucun
create view getCustomerById
as
select * from Customers where Id=1

select * from  getCustomerById

--FUCTIONS-mueyen is gorur 

create function SayHelloWorld()

--hansi type return edecek yaziriq
returns nvarchar(50)
as
BEGIN
  return 'Hello World'
END

--function-cagiririq
select dbo.SayHelloWorld()



--parametr gebul eden -function
create function dbo.writeWord(@word nvarchar(20))
returns nvarchar(50)
as
BEGIN
  return @word
END

--vareybl teyin edirik
declare @word nvarchar(20) ='P135'

select dbo.writeWord(@word)




--iki parametr gebul eden-function
create function dbo.writeWordWithTwoParametr(@word nvarchar(20),@source nvarchar(20))
returns nvarchar(50)
as
BEGIN
  return @word + @source
END

select dbo.writeWordWithTwoParametr('Shaiq','P135') as 'Data'


--regemleri toplayan -function
create function dbo.sumOfNumbers(@num1 int,@num2 int)
returns int
as
BEGIN
  return @num1 + @num2
END

select dbo.sumOfNumbers(5,10)


--function-Customer tabldaki datalarin sayi
create function dbo.getCustomerCount()
returns int
as

--BEGIN-END-seliqe ucun scop mentiqinde 
BEGIN
   declare @count int 
   --select count-yazsaq return edecek table,biz ise bildirmisik bize int return edecek deye
   --ona gore vareybl teyin edib ona beraberlesdirib icindeki reqemi elde edib ele return edirik
   select @count=COUNT(*) from Customers
   return @count
END

select dbo.getCustomerCount()


--FUNCTION-icinde select islemleri ucundu yalniz,mutleq nese return edir!


--function-gonderdiyimiz reqemden boyuk olan id-si olanlarin orta yasi verir
create function dbo.getCustomerAvarageAgeById(@id int)
returns int
as
BEGIN
   declare @avgAge int
   select @avgAge=AVG(Age) from Customers where Id > @id
   return @avgAge
END


select dbo.getCustomerAvarageAgeById(4)



--PROCEDURE-bir is gorur function kimi ama return olada-olamayada biler,CRUD-isleri gormey olur

create procedure usp_SayHelloWorld
as
BEGIN
 print 'Hello World'
END

--proceduru isletmek
exec usp_SayHelloWorld

--procedure-parametr kimi iki reqem gebul edib toplayir
create procedure usp_sumOfNums
@num1 int,
@num2 int
as
BEGIN
 print @num1 + @num2 
END

exec usp_sumOfNums 5,8


--procedure-Customer-table data elave eden -herdefe insert yazmamaq ucun
create procedure usp_addCustomer
@name nvarchar(50),
@surname nvarchar(50),
@age int
as
BEGIN
 insert into Customers([Name],[Surname],[Age])
 values(@name,@surname,@age)
END

exec usp_addCustomer 'Eli','Talibov',21


--procedure-delete data in table
create procedure usp_deleteCustomer
 @id int
 as
BEGIN
 delete from Customers where Id=@id
END

exec usp_deleteCustomer 3


--procedure-delete data in table and show datas table
create procedure usp_deleteCustomerAndShow
 @id int
 as
BEGIN
 delete from Customers where Id=@id
 select * from Customers
END

exec usp_deleteCustomerAndShow 9

create table Users(
[Id] int primary key identity(1,1),
[Name] nvarchar(50),
[Age] int,
[IsDelete] bit
)

--1)datani Isdeletede columuna true vererek silin ve silinmeyen datalari gorsedin
create procedure getDeleteDataAndShowdatas
@id int
AS
BEGIN
update  Users set IsDelete = 'true' where Id=@id
select * from Users where IsDelete='false'
END

getDeleteDataAndShowdatas 1



--2)herfin sozun icinde olub olmadiqini yoxlayin
create procedure usp_searchOperations
 @text nvarchar(50),
 @char nvarchar(50)

AS
BEGIN
   declare @num int
  select  @num= CHARINDEX(@char, @text)
  if
  @num>0
 print 'yes'

else

print 'no'

END

exec usp_searchOperations Salam,s


--TRIGERS-tetiklemek, yani bir tablde isleyende basqa tablde mueyyen bir is gorulsun
 --create,update,delete bunlar ucun trigger yazmaq olur


 --table UserLogs yaradiriq-report edecek bize ki men User-tablda nevaxt neynemisem(create,delete,update)
 create table UserLogs(
 [Id] int primary key identity(1,1),
 [UserID] int,
 [Operation] nvarchar(10),
 [Date] datetime
 )


 --trigger hansi tablda olacaq bildiririk (on Users)
--geyd edirik triger nevaxt islesin meselen insert olanda User-tablda(after insert)
 create trigger trg_insertUser on Users
 after insert
 as
 BEGIN
  --Userlogs-doldururuq icini
   insert into UserLogs([UserID],[Operation],[Date])
   --insert elediyimiz dataynan dolduruq values yox-select yazib
   select Id,'Insert',GETDATE() from inserted
 END


 --procedure-table data elave etmek ucun
 create procedure usp_insertUser
 @name nvarchar(20),
 @age int
 as
 BEGIN
  insert into Users([Name],[Age])
  values(@name,@age)
 END


 exec usp_insertUser 'Ceyhun',23

 --geyd edirik triger nevaxt islesin meselen delete olanda User-tablda(after delete)
 create trigger trg_deleteUser on Users
 after delete
 as
 BEGIN
   insert into UserLogs([UserID],[Operation],[Date])
   select Id,'Delete',GETDATE() from deleted
 END

 delete from Users where Id =25

--triger  islesin update olanda User-tablda(after delete)
  create trigger trg_updateUser on Users
 after update
 as
 BEGIN
   insert into UserLogs([UserID],[Operation],[Date])
   select Id,'Update',GETDATE() from deleted
 END

 update Users
 set [Name] = 'Mirze' where Id = 4

 select * from UserLogs where UserId = 25







