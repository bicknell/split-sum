
-- SQL function to calculate splitSum
CREATE OR REPLACE FUNCTION splitSum(nums INT[]) RETURNS TABLE (barSum INT[], bazSum INT[]) AS $$
DECLARE
    totalbar INT := 0;
    totalbaz INT := 0;
    bar INT := 1;
    baz INT := ARRAY_length(nums, 1);
BEGIN
    -- Empty ARRAY or single element array.
    IF baz < 2 THEN
        barSum := ARRAY[]::INT[];
        bazSum := ARRAY[]::INT[];
    ELSE
        -- Sum until the indexes meet in the middle.
        WHILE baz != bar LOOP
            IF totalbar <= totalbaz THEN
                totalbar := totalbar + nums[bar];
                bar := bar + 1;
            ELSE
                totalbaz := totalbaz + nums[baz];
                baz := baz - 1;
            END IF;
        END LOOP;

        -- Check middle in bar group.
        IF totalbar + nums[bar] = totalbaz THEN
            barSum := nums[1:bar];
            bazSum := nums[baz + 1:];
        -- Check middle in baz group.
        ELSIF totalbar = totalbaz + nums[baz] THEN
            barSum := nums[1:bar - 1];
            bazSum := nums[baz:];
        ELSE
            barSum := ARRAY[]::INT[];
            bazSum := ARRAY[]::INT[];
        END IF;
    END IF;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

DROP TABLE tests;
CREATE TABLE tests (
    id INT PRIMARY KEY,
    test INT[]
);
INSERT INTO tests VALUES (1, ARRAY[]::INT[]),
                         (2, '{ 100 }'),
                         (3, '{ 99, 99 }'),
                         (4, '{ 98, 1, 99 }'),
                         (5, '{ 99, 1, 98 }'),
                         (6, '{ 1, 2, 3, 0 }'),
                         (7, '{ 1, 2, 3, 5 }'),
                         (8, '{ 1, 2, 2, 1, 0 }'),
                         (9, '{ 10, 11, 12, 16, 17 }'),
                         (10, '{ 1, 1, 1, 1, 1, 1, 6 }'),
                         (11, '{ 6, 1, 1, 1, 1, 1, 1 }');

SELECT 'sql: ' as out1, test, splitSum(test) FROM tests ORDER BY id;
