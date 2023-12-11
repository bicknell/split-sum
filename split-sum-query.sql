DO $$
BEGIN
    FOR i IN 1..1000000
    LOOP
        PERFORM test, splitSum(test) FROM tests;
    END LOOP;
END; $$
