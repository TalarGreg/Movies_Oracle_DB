CREATE TABLE Movies (
    movie_id NUMBER PRIMARY KEY,
    title VARCHAR2(255),
    release_date DATE,
    genre VARCHAR2(100),
    director VARCHAR2(100)
	
);

CREATE TABLE Cinema (
    cinema_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    capacity INT
);

CREATE SEQUENCE screening_seq
START WITH 1
INCREMENT BY 1
NOCACHE;

CREATE TABLE Screenings (
    screening_id NUMBER PRIMARY KEY,
    movie_id NUMBER REFERENCES Movies(movie_id),
    screening_date DATE,
    cinema_id INT REFERENCES Cinema(cinema_id),
	note NUMBER
);