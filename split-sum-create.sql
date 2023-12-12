
DROP FUNCTION splitSum;
CREATE FUNCTION splitSum(nums INT[]) RETURNS TABLE (_leftPart INT[], _rightPart INT[]) AS $$
DECLARE
    _totalleft INT := 0;
    _totalright INT := 0;
    _left INT := 1;
    _right INT := ARRAY_length(nums, 1);
BEGIN
    -- Empty ARRAY or single element array.
    IF _right < 2 THEN
        _leftPart := ARRAY[]::INT[];
        _rightPart := ARRAY[]::INT[];
    ELSE
        -- Sum until the indexes meet in the middle.
        WHILE _right != _left LOOP
            IF _totalleft <= _totalright THEN
                _totalleft := _totalleft + nums[_left];
                _left := _left + 1;
            ELSE
                _totalright := _totalright + nums[_right];
                _right := _right - 1;
            END IF;
        END LOOP;

        -- Check middle in _left group.
        IF _totalleft + nums[_left] = _totalright THEN
            _leftPart := nums[1:_left];
            _rightPart := nums[_right + 1:];
        -- Check middle in _right group.
        ELSIF _totalleft = _totalright + nums[_right] THEN
            _leftPart := nums[1:_left - 1];
            _rightPart := nums[_right:];
        ELSE
            _leftPart := ARRAY[]::INT[];
            _rightPart := ARRAY[]::INT[];
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

SELECT 'sql: ' as program, test, splitSum(test) FROM tests ORDER BY id;
