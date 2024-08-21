CREATE OR REPLACE PROCEDURE generate_random_screenings(
    p_num_screenings IN NUMBER -- number of screening to generate
) IS
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

END;
/

BEGIN
    generate_random_screenings(4);
END;