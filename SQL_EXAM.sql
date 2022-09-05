CREATE DATABASE Ekzamen;
USE Ekzamen;

CREATE TABLE Authors(
Id int not null auto_increment primary key,
Name varchar(100) not null check (Name <> N''),
Surname varchar(100) not null check (Surname <> N''),
CountryId int not null);
alter table Authors add foreign key (CountryId) references Countries(Id);
INSERT INTO Authors VALUES(1, "Герберт", "Шилдт", 2), (2, "Alex", "Merfy", 3), (3, "Dmitry", "Gribov", 1), (4, "Artur", "King", 1), (5, "Frank", "Dollars", 2);

CREATE TABLE Books(
Id int not null auto_increment primary key,
Name varchar(100) not null check (Name <> N''),
Pages int not null CHECK(Pages >= 0),
Price int not null CHECK(Price > 0),
PublishDate Date not null CHECK(PublishDate <= sysdate()),
AuthorId int not null,
ThemeId int not null);
alter table Books add foreign key (AuthorId) references Authors(Id);
alter table Books add foreign key (ThemeId) references Themes(Id);
#DROP TABLE Books
SELECT * FROM Books;
INSERT INTO Books VALUES(1, "Qwerty", 500, 2500, '1997-08-30', 1, 2), (2, "Program algoritm", 1500, 50000, '2014-08-30', 1, 2), 
(3, "Sailent Don", 450, 1500, '1999-11-16', 2, 1), (4, "Auto 3D", 800, 2700, '2015-10-06', 2, 4), (5, "Knight", 900, 3000, '1989-03-17', 3, 1),
(6, "One Shot", 350, 1000, '2003-12-20', 3, 1), (7, "SQL V1", 750, 2750, '2021-02-27', 4, 3), (8, "SQL V2", 950, 3700, '2022-05-30', 5, 3);

CREATE TABLE Countries(
Id int not null auto_increment primary key,
Name varchar(50) not null check (Name <> N'') unique);
INSERT INTO Countries VALUES (1, "Rus"), (2, "USA"), (3,"UA");

CREATE TABLE Sales(
Id int not null auto_increment primary key,
Price int not null CHECK(Price > 0),
Quantity int not null CHECK(Quantity >= 0),
SaleDate Date not null CHECK(SaleDate <= sysdate()) default (sysdate()),
BookId int not null,
ShopId int not null);
alter table Sales add foreign key (BookId) references Books(Id);
alter table Sales add foreign key (ShopId) references Shops(Id);
INSERT INTO Sales VALUES(1, 25000, 10, '2018-08-30', 1, 3), (2, 150000, 3, '2019-08-30', 2, 3), 
(3, 150000, 50, '2001-11-16', 3, 1), (4, 27500, 35, '2018-10-06', 4, 1), (5, 35000, 40,'2005-03-17', 5, 2),
(6, 10000, 25,'2013-12-20', 6, 2), (7, 175000, 100,'2021-02-27', 7, 4), (8, 63700, 38,'2022-05-30', 8, 5);
SELECT * FROM Sales;
CREATE TABLE Shops(
Id int not null auto_increment primary key,
Name varchar(100) not null check (Name <> N''),
CountryId int not null);
alter table Shops add foreign key (CountryId) references Countries(Id);
INSERT INTO Shops VALUES(1, "Азбука книг", 1), (2, "Книжный Мир", 1), (3, "Books from World", 2), (4, "Country Shmauntry", 2), (5, "fhjdsghiuw", 3);

CREATE TABLE Themes(
Id int not null auto_increment primary key,
Name varchar(100) not null check (Name <> N'') unique);
INSERT INTO Themes VALUES(1, "Детектив"), (2, "Программирование"), (3, "Администрирование"), (4, "Дизайн");

-- 1. Показать все книги, количество страниц в которых больше 500, но меньше 650.
SELECT name, Pages FROM Books WHERE Pages BETWEEN 500 AND 650; 
-- 2. Показать все книги, в которых первая буква названия либо «А», либо «З».
SELECT name FROM Books WHERE name LIKE 'A%' OR name LIKE 'S%';
-- 3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров.
SELECT * FROM Books
JOIN Sales ON Sales.BookId = Books.id
JOIN Themes ON Themes.Id = Books.ThemeId
WHERE Sales.Quantity > 30 AND Themes.Name LIKE 'Детектив';
-- 4. Показать все книги, в названии которых есть слово «Microsoft», но нет слова «Windows».
SELECT name FROM Books
WHERE name LIKE 'SQL% _%' AND name NOT LIKE '_% V2%';
-- 5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек.
SELECT Books.name as Название_Книги, Themes.name as Тематика, Concat(Authors.name, " ", Authors.Surname) as "Автор", Price/Pages as Цена_страницы FROM Books
INNER JOIN Themes ON Themes.id = Books.ThemeId
INNER JOIN Authors ON Authors.id = Books.AuthorId
WHERE Price/Pages < 30;
-- 6. Показать все книги, название которых состоит из 4 слов.
SELECT name FROM Books WHERE name LIKE '_% _%';
-- 7. Показать информацию о продажах в следующем виде:
-- ▷▷Название книги, но, чтобы оно не содержало букву «А».
-- ▷▷Тематика, но, чтобы не «Программирование».
-- ▷▷Автор, но, чтобы не «Герберт Шилдт».
-- ▷▷Цена, но, чтобы в диапазоне от 10 до 20 гривен.
-- ▷▷Количество продаж, но не менее 8 книг.
-- ▷▷Название магазина, который продал книгу, но он не должен быть в Украине или России.
SELECT Books.name as Название_Книги, themes.name as Тематика, Authors.name as Автор, Books.Price as Цена, Sales.Quantity as Колво_Продаж, 
shops.name as Магазин  FROM Sales
INNER JOIN shops ON shops.id = Sales.shopId
INNER JOIN Countries ON Countries.id = shops.CountryId
INNER JOIN Authors ON Authors.CountryId = Countries.id
INNER JOIN Books ON Books.id = Sales.bookId
INNER JOIN themes ON themes.id = Books.ThemeId
WHERE Books.name not like 'A%' and shops.CountryId = 2 and themes.name not like 'Программирование'
and Authors.name not like 'Герберт' and (Books.Price between 0 and 3000) and (Sales.Quantity between 0 and 100);
-- 8. Показать следующую информацию в два столбца (числа в правом столбце приведены в качестве примера):
-- ▷▷Количество авторов: 14
-- ▷▷Количество книг: 47
-- ▷▷Средняя цена продажи: 85.43 грн.
-- ▷▷Среднее количество страниц: 650.6.
SELECT 'Количество авторов:' as Наименование,COUNT(*) as Количество,' ' FROM Authors--  Distinct
UNION
(SELECT 'Количество книг:',COUNT(*),' ' FROM Books)
UNION 
(SELECT 'Средняя цена продажи:', AVG(Sales.Quantity), ' ' as AVG_продаж FROM Sales)
UNION 
(SELECT 'Среднее количество страниц:', AVG(Books.Pages), ' ' as AVG_продаж FROM Books);
-- 9. Показать тематики книг и сумму страниц всех книг по каждой из них.
SELECT SUM(Books.Pages) as Страниц, Themes.name as Тематика FROM Books
INNER JOIN Themes ON Themes.id = Books.ThemeId
GROUP BY Themes.name;
-- 10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов.
SELECT COUNT(*) as Колво_Книг, SUM(Books.Pages) as Колво_Страниц, Concat(Authors.name, " ", Authors.Surname) as "Автор" FROM Books 
INNER JOIN Authors ON Authors.id = Books.AuthorId
GROUP BY Authors.name;
-- 11. Показать книгу тематики «Программирование» с наибольшим количеством страниц.
SELECT Books.name FROM Books
INNER JOIN Themes ON Themes.id = Books.ThemeId
WHERE Themes.name LIKE 'Программирование' and Books.Pages IN (
SELECT MAX(Pages) FROM Books);
-- 12. Показать среднее количество страниц по каждой тематике, которое не превышает 400.
SELECT AVG(Books.Pages) as 'Среднее кол-во страниц', Themes.name as Тематика FROM Themes
INNER JOIN Books ON Books.ThemeId = Themes.id
GROUP BY Themes.name;
-- 13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400, и чтобы
-- тематики были «Программирование», «Администрирование» и «Дизайн».
SELECT SUM(Books.Pages) as 'Сумма страниц', Themes.name as Тематика FROM Themes
INNER JOIN Books ON Books.ThemeId = Themes.id
WHERE Books.Pages < 1000 and Themes.name like 'Программирование' or Themes.name like 'Администрирование' or Themes.name like 'Дизайн'
GROUP BY Themes.name;
-- 14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано.
select Books.name as Название_Книг, Countries.name as Страна, Shops.name as Магазин, Sales.Saledate as Дата, Sales.Quantity as Количество  from Books
join Sales on Sales.BookId = Books.Id
join Shops on Shops.Id = Sales.ShopId
join Countries on Countries.Id = Shops.CountryId;
-- ORDER BY Sales.ShopId
-- 15. Показать самый прибыльный магазин.
WITH x AS (SELECT SUM( (Sales.Price - Books.Price )*Sales.Quantity) AS MaxPrb, Shops.Name FROM Sales 
	JOIN Shops on Shops.Id =Sales.ShopId 
	JOIN Books on Books.Id = Sales.BookId 
	GROUP by Shops.Id)
SELECT x.Name as 'Название магазина', MAX(x.MaxPrb) as 'Прибль' FROM x
WHERE  x.MaxPrb = ( SELECT MAX(x.MaxPrb) FROM x );