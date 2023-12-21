CREATE DATABASE VirtualArtGallery;
USE [VirtualArtGallery];

CREATE TABLE Artists (
 ArtistID INT PRIMARY KEY,
 Name VARCHAR(255) NOT NULL,
 Biography TEXT,
 Nationality VARCHAR(100));

INSERT INTO Artists (ArtistID, Name, Biography, Nationality) VALUES
 (1, 'Pablo Picasso', 'Renowned Spanish painter and sculptor.', 'Spanish'),
 (2, 'Vincent van Gogh', 'Dutch post-impressionist painter.', 'Dutch'),
 (3, 'Leonardo da Vinci', 'Italian polymath of the Renaissance.', 'Italian'),
 (4, 'Georgia O''Keeffe', 'American modernist artist.', 'American'),
 (5, 'Mary Cassatt', 'American printmaker and painter.', 'American');

CREATE TABLE Categories (
 CategoryID INT PRIMARY KEY,
 Name VARCHAR(100) NOT NULL);

INSERT INTO Categories (CategoryID, Name) VALUES
 (1, 'Painting'),
 (2, 'Sculpture'),
 (3, 'Photography');

CREATE TABLE Artworks (
 ArtworkID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 ArtistID INT,
 CategoryID INT,
 Year INT,
 Description TEXT,
 ImageURL VARCHAR(255),
 FOREIGN KEY (ArtistID) REFERENCES Artists (ArtistID),
 FOREIGN KEY (CategoryID) REFERENCES Categories (CategoryID));

INSERT INTO Artworks (ArtworkID, Title, ArtistID, CategoryID, Year, Description, ImageURL) VALUES
 (1, 'Starry Night', 2, 1, 1889, 'A famous painting by Vincent van Gogh.', 'starry_night.jpg'),
 (2, 'Mona Lisa', 3, 1, 1503, 'The iconic portrait by Leonardo da Vinci.', 'mona_lisa.jpg'),
 (3, 'Guernica', 1, 1, 1937, 'Powerful anti-war mural by Pablo Picasso.', 'guernica.jpg'),
 (4, 'The Last Supper', 3, 1, 1498, 'Famous mural depicting the last supper of Jesus by Leonardo da Vinci.', 'last_supper.jpg'),
 (5, 'The Bedroom', 2, 1, 1889, 'Depiction of his bedroom in Arles by Van Gogh.', 'bedroom.jpg'),
 (6, 'Vitruvian Man', 3, 1, 1490, 'Iconic study of the proportions of the human body by Leonardo da Vinci.', 'vitruvian_man.jpg'),
 (7, 'The Weeping Woman', 1, 1, 1937, 'A powerful depiction of the horrors of war by Picasso.', 'weeping_woman.jpg');

CREATE TABLE Exhibitions (
 ExhibitionID INT PRIMARY KEY,
 Title VARCHAR(255) NOT NULL,
 StartDate DATE,
 EndDate DATE,
 Description TEXT);

INSERT INTO Exhibitions (ExhibitionID, Title, StartDate, EndDate, Description) VALUES
 (1, 'Modern Art Masterpieces', '2023-01-01', '2023-03-01', 'A collection of modern art masterpieces.'),
 (2, 'Renaissance Art', '2023-04-01', '2023-06-01', 'A showcase of Renaissance art treasures.'),
 (3, 'Art Across Ages', '2023-11-05', '2024-01-05', 'A retrospective journey through centuries of art, exploring its evolution and influence.'),
 (4, 'Impressionist Masterpieces', '2023-03-15', '2023-05-15', 'A celebration of the beauty and innovation of impressionist art.'),
 (5, 'Classical Canvases: Timeless Beauty', '2024-09-10', '2024-11-10', 'A journey through classical paintings that have stood the test of time.');

CREATE TABLE ExhibitionArtworks (
 ExhibitionID INT,
 ArtworkID INT,
 PRIMARY KEY (ExhibitionID, ArtworkID),
 FOREIGN KEY (ExhibitionID) REFERENCES Exhibitions (ExhibitionID),
 FOREIGN KEY (ArtworkID) REFERENCES Artworks (ArtworkID));

INSERT INTO ExhibitionArtworks (ExhibitionID, ArtworkID) VALUES
 (1, 1),
 (1, 2),
 (1, 3),
 (2, 2),
 (2, 4),
 (2, 6),
 (3, 2),
 (3, 6),
 (4, 1),
 (4, 3),
 (4, 5),
 (4, 7),
 (5, 2);

--1. Retrieve the names of all artists along with the number of artworks they have in the gallery, and list them in descending order of the number of artworks.
SELECT a.ArtistID, a.Name, ISNULL(COUNT(aw.ArtistID), 0) as NumberOfArtworks
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
ORDER BY NumberOfArtworks DESC;

--2. List the titles of artworks created by artists from 'Spanish' and 'Dutch'  nationalities, and order them by the year in ascending
SELECT aw.Title, a.Name, a.Nationality, aw.Year
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
AND (a.Nationality = 'Spanish' OR a.Nationality = 'Dutch')
ORDER BY aw.Year ASC;

--3. Find the names of all artists who have artworks in the 'Painting' category, and the number of artworks they have in this category
SELECT a.ArtistID, a.Name, COUNT(aw.ArtistID) as NumberOfPaintingArtworks
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
AND aw.CategoryID = 1
GROUP BY a.ArtistID, a.Name;

--4. List the names of artworks from the 'Modern Art Masterpieces' exhibition, along with their artists and categories
SELECT aw.Title, a.ArtistID, a.Name, aw.CategoryID
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
AND aw.ArtworkID IN (SELECT ArtworkID FROM ExhibitionArtworks WHERE ExhibitionID = (
SELECT ExhibitionID FROM Exhibitions WHERE Title = 'Modern Art Masterpieces'));

--5. Find the artists who have more than two artworks in the gallery
SELECT a.ArtistID, a.Name, COUNT(aw.ArtworkID) as NumberOfArtworksInGallery
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 2;

--6. Find the titles of artworks that were exhibited in both 'Modern Art Masterpieces' and 'Renaissance Art' exhibitions
SELECT ArtworkID, Title
FROM Artworks
WHERE ArtworkID IN (SELECT ea.ArtworkID 
					FROM Exhibitions e, ExhibitionArtworks ea
					WHERE e.ExhibitionID = ea.ExhibitionID
					AND e.Title = 'Modern Art Masterpieces'
					INTERSECT
					SELECT ea.ArtworkID 
					FROM Exhibitions e, ExhibitionArtworks ea
					WHERE e.ExhibitionID = ea.ExhibitionID
					AND e.Title = 'Renaissance Art');

--7. Find the total number of artworks in each category
SELECT c.Name, ISNULL(COUNT(a.ArtworkID), 0) TotalArtworksInEachCategory
FROM Categories c LEFT JOIN Artworks a
ON c.CategoryID = a.CategoryID
GROUP BY c.Name;

--8. List artists who have more than 3 artworks in the gallery.
SELECT a.ArtistID, a.Name, COUNT(aw.ArtworkID) as NumberOfArtworksInGallery
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 3;

--9. Find the artworks created by artists from a specific nationality (e.g., Spanish).
SELECT aw.ArtworkID, aw.ArtistID, aw.Title
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
AND a.Nationality = 'Spanish';

--10. List exhibitions that feature artwork by both Vincent van Gogh and Leonardo da Vinci.
SELECT ExhibitionID, Title
FROM Exhibitions
WHERE ExhibitionID IN (SELECT ea.ExhibitionID
					   FROM ExhibitionArtworks ea, Artists a, Artworks aw
					   WHERE a.ArtistID = aw.ArtistID
					   AND aw.ArtworkID = ea.ArtworkID
					   AND a.Name = 'Vincent van Gogh'
					   INTERSECT
					   SELECT ea.ExhibitionID
					   FROM ExhibitionArtworks ea, Artists a, Artworks aw
					   WHERE a.ArtistID = aw.ArtistID
					   AND aw.ArtworkID = ea.ArtworkID
					   AND a.Name = 'Leonardo da Vinci');

--11. Find all the artworks that have not been included in any exhibition.
SELECT ArtworkID, Title
FROM Artworks
WHERE ArtworkID NOT IN (SELECT DISTINCT ArtworkID
					FROM ExhibitionArtworks);

--12. List artists who have created artworks in all available categories.


--13. List the total number of artworks in each category.
SELECT c.Name, ISNULL(COUNT(a.ArtworkID), 0) TotalArtworksInEachCategory
FROM Categories c LEFT JOIN Artworks a
ON c.CategoryID = a.CategoryID
GROUP BY c.Name;

--14. Find the artists who have more than 2 artworks in the gallery.
SELECT a.ArtistID, a.Name, COUNT(aw.ArtworkID) as TotalArtworksInGallery
FROM Artists a, Artworks aw
WHERE a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name
HAVING COUNT(aw.ArtworkID) > 2;

--15. List the categories with the average year of artworks they contain, only for categories with more than 1 artwork.


--16. Find the artworks that were exhibited in the 'Modern Art Masterpieces' exhibition.
SELECT aw.ArtworkID, aw.Title
FROM Artworks aw
WHERE aw.ArtworkID IN (SELECT ArtworkID
					   FROM ExhibitionArtworks
					   WHERE ExhibitionID = (SELECT ExhibitionID
											 FROM Exhibitions
											 WHERE Title = 'Modern Art Masterpieces'));

--17. Find the categories where the average year of artworks is greater than the average year of all artworks.


--18. List the artworks that were not exhibited in any exhibition.
SELECT ArtworkID, Title
FROM Artworks
WHERE ArtworkID NOT IN (SELECT DISTINCT ArtworkID
						FROM ExhibitionArtworks);

--19. Show artists who have artworks in the same category as "Mona Lisa."


--20. List the names of artists and the number of artworks they have in the gallery.
SELECT a.ArtistID, a.Name, COUNT(aw.ArtworkID) as NumberOFArtworks
FROM Artists a LEFT JOIN Artworks aw
ON a.ArtistID = aw.ArtistID
GROUP BY a.ArtistID, a.Name;




SELECT * FROM Artists;
SELECT * FROM Categories;
SELECT * FROM Artworks;
SELECT * FROM Exhibitions;
SELECT * FROM ExhibitionArtworks;