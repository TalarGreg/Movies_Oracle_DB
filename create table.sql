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
   (	
   "CURRENTLY_SHOWN_ID" NUMBER,
   "MOVIE_ID" NUMBER, 
	"CINEMA_ID" NUMBER(*,0), 
	"CURRENTLY_SHOWN" NUMBER(1,0) DEFAULT 0, 
	"TIMELINE_ID" NUMBER, 
	 CHECK (currently_shown IN (0, 1)) ENABLE
   ) ;

ALTER TABLE "CURRENTLY_SHOWN" ADD FOREIGN KEY ("TIMELINE_ID")
	  REFERENCES "SCREENINGS_TIMELINE" ("TIMELINE_ID") ENABLE;
	  
	  
	  
CREATE TABLE "screenings_planned" 
   (	
   "screenings_planned_ID" NUMBER,
   "CURRENTLY_SHOWN_ID" NUMBER REFERENCES CURRENTLY_SHOWN(CURRENTLY_SHOWN_ID),
   "screening_planned_date" DATE
   ) ;	  
   
CREATE OR REPLACE FORCE EDITIONABLE VIEW "VIEW_PLANNED_SCREENINGS" ("SCREENING_PLANNED_ID", "CURRENTLY_SHOWN_ID", "SCREENING_PLANNED_DATE", "START_TIME_LINE", "TITLE", "NAME_AND_LOCATION") AS 
  SELECT 
    SP.SCREENING_PLANNED_ID, 
    SP.CURRENTLY_SHOWN_ID, 
    SP.SCREENING_PLANNED_DATE, 
    TO_CHAR(ST.START_TIME_LINE,'HH24:MI:SS') AS START_TIME_LINE, 
    M.TITLE, 
    C.NAME || ' ' || C.LOCATION AS NAME_AND_LOCATION
FROM 
    SCREENINGS_PLANNED_2 SP
INNER JOIN 
    CURRENTLY_SHOWN CS ON CS.CURRENTLY_SHOWN_ID = SP.CURRENTLY_SHOWN_ID
INNER JOIN 
    SCREENINGS_TIMELINE ST ON ST.TIMELINE_ID = CS.TIMELINE_ID
INNER JOIN 
    MOVIES M ON M.MOVIE_ID = CS.MOVIE_ID
INNER JOIN 
    CINEMA C ON C.CINEMA_ID = CS.CINEMA_ID
ORDER BY 
    SP.SCREENING_PLANNED_DATE, 
    ST.START_TIME_LINE;   
   
CREATE SEQUENCE  "TICKET_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 35034 NOCACHE  NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;
   
   
   
CREATE TABLE "TICKET"
    (
        "TICKET_ID" NUMBER,
        "SCREENING_PLANNED_ID" NUMBER,
        "STATUS_TICKET" VARCHAR2(255 BYTE)
    )
;   
   
   
   
   
   
   
   
   