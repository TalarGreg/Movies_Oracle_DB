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

CREATE TABLE currently_shown AS
SELECT 
    m.MOVIE_ID, c.CINEMA_ID, cast(NULL as number) as currently_shown 
FROM movies m
FULL JOIN cinema c on 1=1;


CREATE TABLE screenings_timeline (
    timeline_id INT PRIMARY KEY,
    start_time_line DATE
);

  CREATE TABLE "CURRENTLY_SHOWN" 
   (	"MOVIE_ID" NUMBER, 
	"CINEMA_ID" NUMBER(*,0), 
	"CURRENTLY_SHOWN" NUMBER(1,0) DEFAULT 0, 
	"TIMELINE_ID" NUMBER, 
	 CHECK (currently_shown IN (0, 1)) ENABLE
   ) ;

  ALTER TABLE "CURRENTLY_SHOWN" ADD FOREIGN KEY ("TIMELINE_ID")
	  REFERENCES "SCREENINGS_TIMELINE" ("TIMELINE_ID") ENABLE;