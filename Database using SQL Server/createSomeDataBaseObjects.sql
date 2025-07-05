use Library
/*
1. Write a query that displays Full name of an employee who has more than 3
	letters in his/her First Name.
*/

select CONCAT(e.Fname,' ',e.Lname) [Full Name Of Employee]
from Employee e
where LEN(e.Fname) > 3

/*
 2. Write a query to display the total number of Programming books available in
 the library with alias name ‘NO OF PROGRAMMING BOOKS’
*/

select COUNT(b.Id) [NO OF PROGRAMMING BOOKS]
from Book b inner join Category c
on b.Cat_id = c.Id
where c.Cat_name = 'Programming'

/*
 3. Write a query to display the number of books published by 
(HarperCollins) with the alias name 'NO_OF_BOOKS'. 
*/

select COUNT(b.Id) [NO_OF_BOOKS]
from Book b inner join Publisher p
on b.Publisher_id = p.Id
where p.Name = 'HarperCollins'

/*
4. Write a query to display the User SSN and name, date of borrowing and due date 
of the User whose due date is before July 2022.
*/

select u.SSN,u.User_Name,b.Borrow_date,b.Due_date
from Users u inner join Borrowing b
on u.SSN = b.User_ssn
where b.Due_date < 'July 2022'


/*
5. Write a query to display book title, author name and display in the following
 format, ' [Book Title] is written by [Author Name].
*/

select concat( b.Title, ' is written by ', u.Name, '.') 
from Book_Author a inner join Book b
on a.Book_id = b.Id inner join Author u
on u.Id = a.Author_id


/*
6. Write a query to display the name of users who have letter 'A' in their 
names.
*/
select* from users u where u.User_Name LIKE '%a%'

/*
7. Write a query that display user SSN who makes the most borrowing
*/
select*
from Users u
where u.SSN = 
(select top 1 b.User_ssn
from Borrowing b
group by b.User_ssn
order by count(*) desc)

/*
8. Write a query that displays the total amount of money that each user paid 
for borrowing books.
*/

select u.User_Name [Full Name Of User], SUM(b.Amount) [Total Amount Of Money]
from Borrowing b inner join Users u
on b.User_ssn = u.SSN
group by u.User_Name

/*
9. write a query that displays the category which has the book that has the 
minimum amount of money for borrowing.
*/
select*
from Category c 
where c.Id = 
(select top(1) b.Cat_id
from Borrowing o
inner join Book b
on o.Book_id = b.Id
order by o.Amount)

/*
10.write a query that displays the email of an employee if it's not found, 
    display address if it's not found, display date of birthday.
*/

select 
    coalesce(email, address, CONVERT(varchar, DOB, 23))  [contact info]
from employee;

/*
10.Write a query to list the category and number of books in each category 
    with the alias name 'Count Of Books'.
*/

select c.Cat_name, count(b.Id)
from Category c
inner join Book b
on c.Id = b.Cat_id
group by c.Cat_name

/*
12. Write a query that display books id which is not found in floor num = 1 
    and shelf-code = A1.
*/

select b.Id [books id]
from Book b
inner join Shelf s
on b.Shelf_code = s.Code
inner join Floor f
on f.Number = s.Floor_num
where f.Number = 1 and s.Code = 'A1'

/*
13.Write a query that displays the floor number , Number of Blocks and 
    number of employees working on that floor.
*/

select f.Number, f.Num_blocks, count(e.Floor_no)
from Floor f inner join Employee e
on e.Floor_no = f.Number
group by f.Number, f.Num_blocks

/*
14.Display Book Title and User Name to designate Borrowing that occurred 
    within the period ‘3/1/2022’ and ‘10/1/2022’.
*/

select o.Title, u.User_Name
from Borrowing b 
join Book o 
on b.Book_id = o.Id 
inner join Users u 
on u.SSN = b.User_ssn 
where b.Borrow_date 
between '3/1/2022' 
and '10/1/2022'

/*
15.Display Employee Full Name and Name Of his/her Supervisor as 
    [Supervisor Name].
*/

select CONCAT(e.Fname,' ' , e.Lname) [Employee Full Name],
CONCAT(super.Fname, ' ' , super.Lname) [Supervisor Name]
from Employee e
inner join Employee super
on e.Id = super.Super_id

/*
16.Select Employee name and his/her salary but if there is no salary display 
    Employee bonus..
*/

select CONCAT(e.Fname,' ' , e.Lname) [Employee Full Name],
coalesce(Salary,Bouns)
from Employee e

/*
17.Display max and min salary for Employees 
*/

select MIN(e.Salary) [Max Salary],
MAX(e.Salary) [Min Salary]
from Employee e

/*
18.Write a function that take Number and display if it is even or odd
*/
go
create or alter function GetEvenOrOdd(@num int)
returns varchar(5)
as
begin
declare @result varchar(5);
if(@num%2!=0)
    set @result = 'OOD'
else
    set @result = 'EVEN'

return @result
end
go
select dbo.GetEvenOrOdd(1) AS Result;  
select dbo.GetEvenOrOdd(2) AS Result;
/*
19.write a function that take category name and display Title of books
in that category 
*/

go
create or alter function GetTitleOfBookByCategoryName(@categoryName varchar(40))
returns table
as
return
(select b.Title from Book b inner join Category c on c.Id = b.Cat_id where c.Cat_name = @categoryName)
go

select * from dbo.GetTitleOfBookByCategoryName('programming');

/*
20. write a function that takes the phone of the user and displays Book Title , 
    user-name,  amount of money and due-date. 
*/
go
create or alter function GetBorrowedBooksByPhone(@phone varchar(20))
returns table 
as
return
(
select o.Title, u.User_Name, b.Amount, b.Due_date
from User_phones ph
join Users u
on ph.User_ssn = u.SSN
join Borrowing b
on b.User_ssn =u.SSN
join Book o
on b.Book_id = o.Id
where ph.Phone_num = @phone
)
go

select * from dbo.GetBorrowedBooksByPhone('0102302155');

/*
21.Write a function that take user name and check if it's duplicated return
    Message in the following format ([User Name] is Repeated [Count] times) if it's 
    not duplicated display msg with this format [user name] is not duplicated,
    if it's not Found Return [User Name] is Not Found */

go
create or alter function CheckUserNameDuplication(@userName varChar(30))
returns varchar(100)
as
begin
    declare @count int;
    declare @message varchar(100);
    select @count = count(*) from Users u where u.User_Name = @userName
    if @count = 0 
        set @message = CONCAT(' [ ', @userName , ' ] ', 'is not found')
    else if @count = 1
        set @message = CONCAT(' [ ', @userName , ' ] ', 'is not duplicated')
    else
        set @message = CONCAT(' [ ', @userName , ' ] is Repeated ', @count ,' times')
return @message
end
go

SELECT dbo.CheckUserNameDuplication('Amr Ahmed');

/*
22.Create a scalar function that takes date and Format to return Date With 
    That Format.
*/
go
create or alter function FormatGivenDate(@date date, @Format varchar(50))
returns varchar(50)
as
begin
declare @formattedDate varchar(50)
set @formattedDate = FORMAT(@date,@Format)
return @formattedDate
end
go

SELECT dbo.FormatGivenDate(GETDATE(), 'dd--yyyy')
SELECT dbo.FormatGivenDate('2024-05-15', 'MM-dd-yyyy')

/*
23.Create a stored procedure to show the number of books per Category.
*/
go
create or alter procedure GetBookCountPerCategory
as
begin
select c.Cat_name, COUNT(b.Id)
from Book b join Category c on b.Cat_id = c.Id
group by c.Cat_name
end
go

GetBookCountPerCategory

/*
24.Create a stored procedure that will be used in case there is an old manager 
    who has left the floor and a new one becomes his replacement. The 
    procedure should take 3 parameters (old Emp.id, new Emp.id and the 
    floor number) and it will be used to update the floor table.
*/

go
create or alter procedure ReplaceFloorManager(@oldEmp int,@newEmp int,@floorNumber int)
as
begin
    update Floor
    set MG_ID = @newEmp
    where Number = @floorNumber and MG_ID = @oldEmp
end
go

/*
25.Create a view AlexAndCairoEmp that displays Employee data for users 
    who live in Alex or Cairo.
*/

go 
create or alter view AlexAndCairoEmp
as
select*
from Employee e 
where e.Address in('Alex','Cairo')
go

select * from AlexAndCairoEmp;

/*
26.create a view "V2" That displays number of books per shelf
*/

go 
create or alter view getNumberOfBooksPerShelf
as
select s.Code, count(b.Id) [NumberOfBooks]
from Book b join Shelf s 
on b.Shelf_code = s.Code
group by s.Code
go

select * from getNumberOfBooksPerShelf;

/*
27.create a view "V3" That display the shelf code that have maximum number of  books
    using the previous view "V2" */

go 
create or alter view getShelfCodeHavrMaxNumberOfBooks
as
select * 
from getNumberOfBooksPerShelf v
where v.NumberOfBooks = 
(select max(NumberOfBooks) from getNumberOfBooksPerShelf)
go

select * from getShelfCodeHavrMaxNumberOfBooks;

/*
28.Create a table named ‘ReturnedBooks’ With the Following Structure : 
___________________________________________________________________________________
|    User SSN    |    Book Id    |    Due Date    |    Return Dat    |    fees    |
|________________|_______________|________________|__________________|____________|
then create A trigger that instead of inserting the data of returned book 
checks if the return date is the due date  or not if not so the user must pay 
a fee and it will be 20% of the amount that was paid before. 
*/
create table ReturnedBooks (
    User_SSN VARCHAR(9),
    Book_Id INT,
    Due_Date DATE,
    Return_Date DATE,
    fees DECIMAL(10, 2),
    PRIMARY KEY (User_SSN, Book_Id)
)
go
create or alter trigger CheckReturnDate
on ReturnedBooks
INSTEAD of insert
as
begin
    insert into  ReturnedBooks (User_ssn, Book_id, Return_date)
    select u.SSN, b.Book_id, b.Borrow_date
    from Users u 
    join Borrowing b
    on u.SSN = b.User_ssn
    join Book o
    on o.Id = b.Book_id
end