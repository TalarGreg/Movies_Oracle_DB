create or replace PACKAGE loader AS
    PROCEDURE generate_random_screenings(p_num_screenings IN NUMBER); -- it loads data to table screenings, INPUT is amount how much records will add
	PROCEDURE create_current_shown_table(p_perc_of_movies IN NUMBER); -- it choose and change which movies are currently display, in which cinema, INPUT is percent of population which is currenctly shown
    PROCEDURE generate_random_timeline; --generate and insert data to CURRENTLY_SHOWN.TIMELINE_ID column, based on SCREENINGS_TIMELINE table
end;
/

create or replace PACKAGE BODY loader AS

    -- load random data to table Movies
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
                    WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Wystąpił błąd: ' || SQLERRM);
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

    PROCEDURE generate_random_timeline IS

	CURSOR c_update_currently_shown_timeline IS
    	SELECT MOVIE_ID, CINEMA_ID, CURRENTLY_SHOWN, TIMELINE_ID
    	FROM currently_shown
    	WHERE CURRENTLY_SHOWN = 1 
    	FOR UPDATE;

    v_min_timeline_id screenings_timeline.TIMELINE_ID%TYPE;
    v_max_timeline_id screenings_timeline.TIMELINE_ID%TYPE;

    BEGIN

    SELECT MIN(TIMELINE_ID) INTO v_min_timeline_id FROM screenings_timeline;
    SELECT MAX(TIMELINE_ID) INTO v_max_timeline_id FROM screenings_timeline;

        FOR rec IN c_update_currently_shown_timeline LOOP
            UPDATE currently_shown
            SET TIMELINE_ID = ROUND(DBMS_RANDOM.VALUE(v_min_timeline_id, v_max_timeline_id))
            --SET TIMELINE_ID = ROUND(DBMS_RANDOM.VALUE(1, 14))
            WHERE CURRENT OF c_update_currently_shown_timeline;
		END LOOP;

    END generate_random_timeline;



END loader;
/