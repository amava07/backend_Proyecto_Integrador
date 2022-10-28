-- Copyright 2004-2022 H2 Group. Multiple-Licensed under the MPL 2.0,
-- and the EPL 1.0 (https://h2database.com/html/license.html).
-- Initial Developer: H2 Group
--

select cast(null as varchar(255)) xn, cast(' 10' as int) x10, cast(' 20 ' as int) x20;
> XN   X10 X20
> ---- --- ---
> null 10  20
> rows: 1

select cast(128 as varbinary);
>> X'00000080'

select cast(65535 as varbinary);
>> X'0000ffff'

select cast(X'ff' as tinyint);
>> -1

select cast(X'7f' as tinyint);
>> 127

select cast(X'00ff' as smallint);
>> 255

select cast(X'000000ff' as int);
>> 255

select cast(X'000000000000ffff' as long);
>> 65535

select cast(cast(65535 as long) as varbinary);
>> X'000000000000ffff'

select cast(cast(-1 as tinyint) as varbinary);
>> X'ff'

select cast(cast(-1 as smallint) as varbinary);
>> X'ffff'

select cast(cast(-1 as int) as varbinary);
>> X'ffffffff'

select cast(cast(-1 as long) as varbinary);
>> X'ffffffffffffffff'

select cast(cast(1 as tinyint) as varbinary);
>> X'01'

select cast(cast(1 as smallint) as varbinary);
>> X'0001'

select cast(cast(1 as int) as varbinary);
>> X'00000001'

select cast(cast(1 as long) as varbinary);
>> X'0000000000000001'

select cast(X'ff' as tinyint);
>> -1

select cast(X'ffff' as smallint);
>> -1

select cast(X'ffffffff' as int);
>> -1

select cast(X'ffffffffffffffff' as long);
>> -1

select cast(' 011 ' as int);
>> 11

select cast(cast(0.1 as real) as decimal(1, 1));
>> 0.1

select cast(cast(95605327.73 as float) as decimal(10, 8));
> exception VALUE_TOO_LONG_2

select cast(cast('01020304-0506-0708-090a-0b0c0d0e0f00' as uuid) as varbinary);
>> X'0102030405060708090a0b0c0d0e0f00'

call cast('null' as uuid);
> exception DATA_CONVERSION_ERROR_1

select cast('12345678123456781234567812345678' as uuid);
>> 12345678-1234-5678-1234-567812345678

select cast('000102030405060708090a0b0c0d0e0f' as uuid);
>> 00010203-0405-0607-0809-0a0b0c0d0e0f

select -cast(0 as double);
>> 0.0

SELECT * FROM (SELECT CAST('11:11:11.123456789' AS TIME));
>> 11:11:11

SELECT * FROM (SELECT CAST('11:11:11.123456789' AS TIME(0)));
>> 11:11:11

SELECT * FROM (SELECT CAST('11:11:11.123456789' AS TIME(9)));
>> 11:11:11.123456789

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789' AS TIMESTAMP));
>> 2000-01-01 11:11:11.123457

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789' AS TIMESTAMP(0)));
>> 2000-01-01 11:11:11

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789' AS TIMESTAMP(9)));
>> 2000-01-01 11:11:11.123456789

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789Z' AS TIMESTAMP WITH TIME ZONE));
>> 2000-01-01 11:11:11.123457+00

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789Z' AS TIMESTAMP(0) WITH TIME ZONE));
>> 2000-01-01 11:11:11+00

SELECT * FROM (SELECT CAST('2000-01-01 11:11:11.123456789Z' AS TIMESTAMP(9) WITH TIME ZONE));
>> 2000-01-01 11:11:11.123456789+00

EXPLAIN SELECT CAST('A' AS VARCHAR(10)), CAST(NULL AS BOOLEAN), CAST(NULL AS VARCHAR), CAST(1 AS INT);
>> SELECT CAST('A' AS CHARACTER VARYING(10)), UNKNOWN, CAST(NULL AS CHARACTER VARYING), 1

SELECT CURRENT_TIMESTAMP(9) = CAST(CURRENT_TIME(9) AS TIMESTAMP(9) WITH TIME ZONE);
>> TRUE

SELECT LOCALTIMESTAMP(9) = CAST(LOCALTIME(9) AS TIMESTAMP(9));
>> TRUE

CREATE TABLE TEST(I INTERVAL DAY TO SECOND(9), T TIME(9) WITH TIME ZONE);
> ok

EXPLAIN SELECT CAST(I AS INTERVAL HOUR(4) TO SECOND), CAST(I AS INTERVAL HOUR(4) TO SECOND(6)),
    CAST(I AS INTERVAL HOUR TO SECOND(9)), CAST(I AS INTERVAL HOUR(2) TO SECOND(9)) FROM TEST;
>> SELECT CAST("I" AS INTERVAL HOUR(4) TO SECOND), CAST("I" AS INTERVAL HOUR(4) TO SECOND(6)), CAST("I" AS INTERVAL HOUR TO SECOND(9)), CAST("I" AS INTERVAL HOUR(2) TO SECOND(9)) FROM "PUBLIC"."TEST" /* PUBLIC.TEST.tableScan */

EXPLAIN SELECT CAST(T AS TIME WITH TIME ZONE), CAST(T AS TIME(0) WITH TIME ZONE), CAST(T AS TIME(3) WITH TIME ZONE) FROM TEST;
>> SELECT CAST("T" AS TIME WITH TIME ZONE), CAST("T" AS TIME(0) WITH TIME ZONE), CAST("T" AS TIME(3) WITH TIME ZONE) FROM "PUBLIC"."TEST" /* PUBLIC.TEST.tableScan */

DROP TABLE TEST;
> ok

EXPLAIN SELECT
    CAST(TIME '10:00:00' AS TIME(9)),
    CAST(TIME '10:00:00' AS TIME(9) WITH TIME ZONE),
    CAST(TIME '10:00:00' AS TIMESTAMP(9)),
    CAST(TIME '10:00:00' AS TIMESTAMP(9) WITH TIME ZONE);
>> SELECT TIME '10:00:00', CAST(TIME '10:00:00' AS TIME(9) WITH TIME ZONE), CAST(TIME '10:00:00' AS TIMESTAMP(9)), CAST(TIME '10:00:00' AS TIMESTAMP(9) WITH TIME ZONE)

EXPLAIN SELECT
    CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIME(9)),
    CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIME(9) WITH TIME ZONE),
    CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIMESTAMP(9)),
    CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIMESTAMP(9) WITH TIME ZONE);
>> SELECT CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIME(9)), TIME WITH TIME ZONE '10:00:00+10', CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIMESTAMP(9)), CAST(TIME WITH TIME ZONE '10:00:00+10' AS TIMESTAMP(9) WITH TIME ZONE)

EXPLAIN SELECT
    CAST(DATE '2000-01-01' AS DATE),
    CAST(DATE '2000-01-01' AS TIMESTAMP(9)),
    CAST(DATE '2000-01-01' AS TIMESTAMP(9) WITH TIME ZONE);
>> SELECT DATE '2000-01-01', TIMESTAMP '2000-01-01 00:00:00', CAST(DATE '2000-01-01' AS TIMESTAMP(9) WITH TIME ZONE)

EXPLAIN SELECT
    CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIME(9)),
    CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIME(9) WITH TIME ZONE),
    CAST(TIMESTAMP '2000-01-01 10:00:00' AS DATE),
    CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIMESTAMP(9)),
    CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIMESTAMP(9) WITH TIME ZONE);
>> SELECT TIME '10:00:00', CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIME(9) WITH TIME ZONE), DATE '2000-01-01', TIMESTAMP '2000-01-01 10:00:00', CAST(TIMESTAMP '2000-01-01 10:00:00' AS TIMESTAMP(9) WITH TIME ZONE)

EXPLAIN SELECT
    CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIME(9)),
    CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIME(9) WITH TIME ZONE),
    CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS DATE),
    CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIMESTAMP(9)),
    CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIMESTAMP(9) WITH TIME ZONE);
>> SELECT CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIME(9)), TIME WITH TIME ZONE '10:00:00+10', CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS DATE), CAST(TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10' AS TIMESTAMP(9)), TIMESTAMP WITH TIME ZONE '2000-01-01 10:00:00+10'

CREATE DOMAIN D INT CHECK (VALUE > 10);
> ok

VALUES CAST(11 AS D);
>> 11

VALUES CAST(10 AS D);
> exception CHECK_CONSTRAINT_VIOLATED_1

EXPLAIN SELECT CAST(X AS D) FROM SYSTEM_RANGE(20, 30);
>> SELECT CAST("X" AS "PUBLIC"."D") FROM SYSTEM_RANGE(20, 30) /* range index */

DROP DOMAIN D;
> ok

EXPLAIN VALUES CAST('a' AS VARCHAR_IGNORECASE(10));
>> VALUES (CAST('a' AS VARCHAR_IGNORECASE(10)))

SELECT CAST('true ' AS BOOLEAN) V, CAST(CAST('true' AS CHAR(10)) AS BOOLEAN) F;
> V    F
> ---- ----
> TRUE TRUE
> rows: 1
