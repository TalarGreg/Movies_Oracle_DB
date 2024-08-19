CREATE OR REPLACE PACKAGE loader AS
    PROCEDURE generate_random_screenings(p_num_screenings IN NUMBER); -- it loads data to table screenings, INPUT is amount how much records will add
	PROCEDURE create_current_shown_table(p_perc_of_movies IN NUMBER); -- it choose and change which movies are currently display, in which cinema, INPUT is percent of population which is currenctly shown
    -- Możesz dodać więcej procedur w zależności od potrzeb
end;
    
CREATE OR REPLACE PACKAGE BODY loader AS

    PROCEDURE create_current_shown_table(p_perc_of_movies IN NUMBER) IS

	CURSOR c_update_currently_shown IS
    	SELECT MOVIE_ID, CINEMA_ID, CURRENTLY_SHOWN
    	FROM currently_shown
    	SAMPLE(12)
    	FOR UPDATE;
    
    BEGIN

    	EXECUTE IMMEDIATE 'DROP TABLE currently_shown';
		--DROP TABLE currently_shown;

		EXECUTE IMMEDIATE 'CREATE TABLE currently_shown AS
		SELECT 
		    m.MOVIE_ID, c.CINEMA_ID, cast(NULL as number) as currently_shown 
		FROM movies m
		FULL JOIN cinema c on 1=1';

		EXECUTE IMMEDIATE 'ALTER TABLE currently_shown
		MODIFY currently_shown NUMBER(1) DEFAULT 0 CHECK (currently_shown IN (0, 1))';

		FOR rec IN c_update_currently_shown LOOP
            UPDATE currently_shown
            SET currently_shown = 1
            WHERE CURRENT OF c_update_currently_shown;
		END LOOP;

			
		COMMIT;
    END create_current_shown_table;

    -- Procedura do ładowania danych do tabeli Movies
    PROCEDURE generate_random_screenings(p_num_screenings IN NUMBER) IS
    
		    v_screening_id Screenings.screening_id%TYPE;
		    v_movie_id Movies.movie_id%TYPE;
		    v_screening_date Screenings.screening_date%TYPE;
		    v_cinema_id Cinema.cinema_id%TYPE;
			v_note Screenings.note%TYPE;
		BEGIN
		    --DBMS_OUTPUT.PUT_LINE('Brak danych dla podanego ID pracownika.');
			FOR i IN 1..p_num_screenings LOOP
		
		    	--v_screening_id will add as screening_seq.nextval
		
		    	BEGIN 
					SELECT movie_id 
					INTO v_movie_id
					FROM movies
					SAMPLE(15)
					WHERE ROWNUM = 1;
			
					EXCEPTION
		      		WHEN NO_DATA_FOUND THEN
		        	v_movie_id := NULL;
				END;
				--DBMS_OUTPUT.PUT_LINE(v_movie_id);
		
				BEGIN
					SELECT TO_DATE(TO_DATE(TRUNC(DBMS_RANDOM.VALUE(TO_CHAR(DATE '2020-01-01', 'J'),TO_CHAR(SYSDATE, 'J'))), 'J'), 'DD-MM-YYYY') --this generate random date 
		        	INTO v_screening_date
		        	FROM DUAL;
			
					EXCEPTION
		      		WHEN NO_DATA_FOUND THEN
		        	v_screening_date := NULL;
				END;
				--DBMS_OUTPUT.PUT_LINE(v_screening_date);
		
				BEGIN
					SELECT cinema_id 
					INTO v_cinema_id
					FROM cinema
					SAMPLE(15)
					WHERE ROWNUM = 1;
		
					EXCEPTION
		      		WHEN NO_DATA_FOUND THEN
		        	v_cinema_id := NULL;	
				END;
				--DBMS_OUTPUT.PUT_LINE(v_cinema_id);
		
				BEGIN
					SELECT TRUNC(DBMS_RANDOM.VALUE(1, 11)) 
					INTO v_note
					FROM dual;
		
					EXCEPTION
		      		WHEN NO_DATA_FOUND THEN
		        	v_note := NULL;	
				END;
				--DBMS_OUTPUT.PUT_LINE(v_note);		
		
		
		
				INSERT INTO Screenings (screening_id, movie_id, screening_date, cinema_id, note) VALUES (screening_seq.nextval, v_movie_id, v_screening_date, v_cinema_id, v_note);
		    END LOOP;
		COMMIT;
		
		END generate_random_screenings;

END loader;
/

BEGIN
--loader.generate_random_screenings(15);
loader.create_current_shown_table(12);
END;
