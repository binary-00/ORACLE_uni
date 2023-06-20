--Task 17: 
SELECT c.nickname "Hunts in the field", c.mice_ration "Ration of mice", b.name "Band"
FROM cats c 
JOIN bands b 
ON c.band_no = b.band_no 
WHERE (c.mice_ration > 50) 
AND (b.site = 'FIELD' OR b.site = 'WHOLE AREA');

-- Task 18: 
SELECT c.name, c.in_herd_since
FROM cats c 
JOIN cats c1 
ON c.nickname = c1.nickname 
AND c.in_herd_since < '2008-12-01'
ORDER BY c.in_herd_since DESC; 

--Task 19: 
--a)
SELECT  C1.name ,C1.function ,C2.NAME "Chief 1",C3.NAME "Chief 2",C4.NAME "Chief 3"
from Cats C1 FULL JOIN (Cats C2 FULL JOIN 
            (Cats C3 FULL JOIN Cats C4
            ON C3.CHIEF = C4.NICKNAME)
            ON C2.CHIEF = C3.NICKNAME)
            ON C1.CHIEF = C2.NICKNAME
where C1.function in( 'CAT','NICE') 
ORDER BY C4.function ASC,C2.FUNCTION ASC
;
--b)
SELECT *
FROM
(
  SELECT CONNECT_BY_ROOT name "Name", name, CONNECT_BY_ROOT function "function", LEVEL "L"
  FROM Cats
  CONNECT BY PRIOR chief = nickname
  START WITH function IN ('CAT', 'NICE') ORDER BY NAME 
)
PIVOT (
   MIN(name) FOR L IN (2 "chief 1", 3 "chief 2", 4 "chief 3")
) ;
--c)
SELECT  name, function, RTRIM(REVERSE(RTRIM(SYS_CONNECT_BY_PATH(REVERSE(name), ' | '), name)), '| ') "Name of susbsequent chiefs"
FROM Cats
WHERE function = 'CAT'
      OR function = 'NICE'
CONNECT BY PRIOR nickname = chief
START WITH chief IS NULL
;

--Task 20:
SELECT c.name "Name of female cat "  , b.name "Band name"  , i.enemy_name "Enemy name", e.hostility_degree "Enemy rating", I.incdent_date "Incident date." 
FROM cats c join incidents i on c.nickname = i.nickname 
JOIN bands b on c.chief = b.band_chief
JOIN enemies e on e.enemy_name = i.enemy_name
WHERE  incdent_date> '2007-01-01' and gender = 'W'
ORDER BY c.name ASC ;

--Task21:
SELECT B.name "Band name", COUNT(*) "Cats with enemies" 
FROM Cats C
JOIN bands  B ON c.band_no= b.band_no
WHERE c.nickname IN (Select nickname FROM incidents)
GROUP BY B.name;

-- modded ---------------------------------------------------
SELECT B.name "Band name", 
COUNT(DISTINCT C.nickname) "Cats with enemies", 
SUM(CASE WHEN (SELECT COUNT(*) FROM incidents WHERE nickname = C.nickname) > 2 THEN 1 ELSE 0 END) as "Cats with >2 Enemies"
FROM Cats C
JOIN bands B ON C.band_no = B.band_no
WHERE C.nickname IN (SELECT nickname FROM incidents)
GROUP BY B.name;
-------------------------------------------------------------
--Taks 22: 
SELECT c.function "Function", c.nickname "Nickname of Cat", COUNT(*) as "Number of enemies"
FROM CATS C 
JOIN incidents I ON c.nickname = i.nickname
GROUP BY c.function, c.nickname
HAVING count(*)>1 ;

--Task 23 :
SELECT C.name, (C.mice_ration + C.mice_extra) * 12 "Annual dose",'Above 864' "Dose"
FROM Cats C
WHERE C.mice_extra IS NOT NULL AND  mice_ration IS NOT NULL AND (C.mice_ration+C.mice_extra)*12 > 864
UNION

SELECT C.name, (C.mice_ration + C.mice_extra) * 12 "Annual dose",' ' "Dose"
FROM Cats C
WHERE C.mice_extra IS NOT NULL AND  mice_ration IS NOT NULL AND (C.mice_ration+C.mice_extra)*12 = 864
UNION

SELECT C.name, (C.mice_ration + C.mice_extra) * 12 "Annual dose",'Below 864' "Dose"
FROM Cats C
WHERE C.mice_extra IS NOT NULL AND  mice_ration IS NOT NULL AND (C.mice_ration+C.mice_extra)*12 < 864
ORDER BY "Annual dose" DESC ;

--Task 24.
-- 1.) Using subqueries
SELECT B.BAND_NO ,B.NAME, B.site 
FROM bands B
LEFT JOIN CATS C
ON B.BAND_NO = C.BAND_NO
WHERE C.nickname IS NULL
;

-- 2.) Using set operators
SELECT B.BAND_NO ,B.NAME, B.site FROM bands B
MINUS
SELECT B.BAND_NO ,B.NAME, B.site FROM bands B
WHERE B.BAND_NO IN(SELECT band_no FROM CATS);


-- Task 25. 
SELECT C.name,C.function,C.mice_ration as "Ration of Mice"
FROM CATS C
JOIN(SELECT Cin.mice_RATION FROM CATS Cin JOIN Bands B ON cin.band_no=B.band_no
        WHERE Cin.function ='NICE' AND b.site IN ('WHOLE AREA', 'ORCHARD') AND ROWNUM =1
        ORDER BY cin.mice_ration DESC) C21
ON C.mice_ration >= C21.mice_ration*3
ORDER BY C.mice_ration;

-- Task 26. 
SELECT C2.function, C2.AVG
FROM
  (SELECT MIN(AVG) "MINAVG", MAX(AVG) "MAXAVG"
  FROM (
    SELECT function, CEIL(AVG(mice_ration + NVL(mice_extra, 0))) "AVG"
    FROM Cats
    WHERE function != 'BOSS'
    GROUP BY function
  )) C1
  JOIN
  (SELECT function, CEIL(AVG(mice_ration + NVL(mice_extra, 0))) "AVG"
  FROM Cats
  WHERE function != 'BOSS'
  GROUP BY function)  C2

  ON C1.MINAVG = C2.AVG
     OR C1.MAXAVG = C2.AVG
ORDER BY C2.AVG;

-- Task 27
-- a.)
SELECT nickname, mice_ration + NVL(mice_extra, 0) "EATS"
FROM Cats C
WHERE (SELECT COUNT(DISTINCT mice_ration + NVL(mice_extra, 0)) FROM Cats
      WHERE mice_ration + NVL(mice_extra, 0) > C.mice_ration + NVL(C.mice_extra, 0)) < 6
ORDER BY 2 DESC;

-- b.)
SELECT nickname, mice_ration + NVL(mice_extra, 0) "EATS"
FROM Cats
WHERE mice_ration + NVL(mice_extra, 0) IN (
  SELECT *
  FROM (
    SELECT DISTINCT mice_ration + NVL(mice_extra, 0)
    FROM Cats
    ORDER BY 1 DESC
  ) WHERE ROWNUM <= 6
);

-- c.)
SELECT C1.nickname, AVG(C1.mice_ration + NVL(C1.mice_extra, 0)) "EATS"
FROM Cats C1 LEFT JOIN Cats C2
    ON C1.mice_ration + NVL(C1.mice_extra, 0) < C2.mice_ration + NVL(C2.mice_extra, 0)
GROUP BY C1.nickname
HAVING COUNT(C1.nickname) <=6
ORDER BY 2 DESC;

-- Task 28:
WITH Years AS
(SELECT  EXTRACT( YEAR FROM in_herd_since) AS "YEAR", COUNT(*) "NUMBER OF ENTRIES" 
FROM Cats
GROUP BY EXTRACT( YEAR FROM in_herd_since)
ORDER BY "YEAR")
SELECT to_char("YEAR") "YEAR", "NUMBER OF ENTRIES"
FROM (SELECT  "YEAR", "NUMBER OF ENTRIES",
              DENSE_RANK() OVER(ORDER BY ABS("NUMBER OF ENTRIES" - (SELECT SUM("NUMBER OF ENTRIES")/ COUNT("YEAR")FROM Years))) rn
      FROM Years
      GROUP BY "YEAR", "NUMBER OF ENTRIES"
      ) Ranked_years
WHERE rn = 1 or rn = 2      
UNION ALL
SELECT 'Average' "YEAR",
       ROUND((SELECT SUM("NUMBER OF ENTRIES")/ COUNT("YEAR")FROM Years), 7) "NUMBER OF ENTRIES"
FROM DUAL
GROUP BY 'Average'
ORDER BY "NUMBER OF ENTRIES";

-- Task 29:
-- a.)
SELECT C1.name, MIN(C1.mice_ration + NVL(C1.mice_extra, 0)) "EATS", C1.band_no, TO_CHAR(AVG(C2.mice_ration + NVL(C2.mice_extra, 0)), '99.99') "AVERAGE IN BAND"
FROM Cats C1 JOIN Cats C2 ON c1.band_no= C2.band_no
WHERE C1.gender = 'M'
GROUP BY C1.name, C1.band_no
HAVING MIN(C1.mice_ration + NVL(C1.mice_extra, 0)) < AVG(C2.mice_ration + NVL(C2.mice_extra, 0))
order by band_no desc;

-- b.)
SELECT name, mice_ration + NVL(mice_extra, 0) "EATS", C1.band_no, TO_CHAR(AVG, '99.99') "AVERAGE IN BAND"
FROM Cats C1 JOIN (SELECT band_no, AVG(mice_ration + NVL(mice_extra, 0)) "AVG" FROM Cats GROUP BY band_no) C2
    ON C1.band_no= C2.band_no
       AND mice_ration + NVL(mice_extra, 0) < AVG
WHERE gender = 'M';

-- c.)
SELECT name, mice_ration + NVL(mice_extra, 0) "EATS", band_no,
  TO_CHAR((SELECT AVG(mice_ration + NVL(mice_extra, 0)) "AVG" 
FROM Cats K WHERE Cats.band_no = K.band_no), '99.99') "AVERAGE IN BAND"
FROM Cats
WHERE gender = 'M'
AND mice_ration + NVL(mice_extra, 0) < (SELECT AVG(mice_ration + NVL(mice_extra, 0)) "AVG" 
FROM Cats K WHERE Cats.band_no= K.band_no);

-- Task 30:
SELECT name, TO_CHAR(in_herd_since, 'YYYY-MM-DD')  ' <--- LONGEST TIME IN THE BAND '  Band "JOIN THE HERD"
FROM (
  SELECT Cats.name, in_herd_since, Bands.name Band, MIN(in_herd_since) OVER (PARTITION BY Cats.band_no)  minexperience
  FROM Cats JOIN Bands ON Cats.band_no = Bands.band_no
) 
WHERE in_herd_since = minexperience

UNION ALL

SELECT name, TO_CHAR(in_herd_since, 'YYYY-MM-DD')  ' <--- SHORTEST TIME IN THE BAND '  Band "JOIN THE HERD"
FROM (
  SELECT Cats.name, in_herd_since, Bands.name Band, MAX(in_herd_since) OVER (PARTITION BY Cats.band_no) maxeperience
  FROM Cats JOIN Bands ON Cats.band_no = Bands.band_no
)
WHERE in_herd_since = maxeperience

UNION ALL

SELECT name, TO_CHAR(in_herd_since, 'YYYY-MM-DD')
FROM (
  SELECT Cats.name, in_herd_since, Bands.name Band,
    MIN(in_herd_since) OVER (PARTITION BY Cats.band_no) minexperience,
    MAX(in_herd_since) OVER (PARTITION BY Cats.band_no) maxeperience
  FROM Cats JOIN Bands ON Cats.band_no= Bands.band_no
)
WHERE in_herd_since != minexperience AND
      in_herd_since != maxeperience
ORDER BY name;

-- Task 31:
DROP VIEW Statistics;

CREATE OR REPLACE VIEW Statistics(name_Band, avg_cons, MAX_CONS, MIN_CONS, CAT, CAT_WITH_EXTRA)
AS
SELECT Bands.name, AVG(mice_ration), MAX(mice_ration), MIN(mice_ration), COUNT(nickname), COUNT(mice_extra)
FROM Bands JOIN Cats ON Bands.band_no = Cats.band_no
GROUP BY Bands.name;

SELECT *
FROM Statistics;

SELECT nickname "NICKNAME", Cats.name, function, mice_ration "EATS", 'OD ' || MIN_CONS || ' DO ' || MAX_CONS "CONSUMPTION LIMITS", TO_CHAR(in_herd_since, 'YYYY-MM-DD') "HUNT FROM"
FROM (Bands JOIN Cats ON Bands.band_no = Cats.band_no JOIN Statistics  ON Bands.name = Statistics.name_Band)
WHERE nickname = '&nickname';

-- Task 32:
DROP VIEW member_rations
CREATE VIEW member_rations AS
    SELECT * FROM
    (SELECT C.nickname "Nickname", C.gender "Gender", C.mice_ration "Mice Before Increase", NVL(C.mice_extra,0) "Extra Before Increase"
        FROM Cats C, Bands B
        WHERE C.band_no=B.band_no
        AND B.name='BLACK KNIGHTS'
        ORDER BY C.in_herd_since ASC
        FETCH FIRST 3 ROWS ONLY)T1
    UNION
    SELECT * FROM
    (SELECT C.nickname "Nickname", C.gender "Gender", C.mice_ration "Mice Ration", NVL(C.mice_extra,0) "Extra Before Increase"
        FROM Cats C, Bands B
        WHERE C.band_no=B.band_no
        AND B.name='PINTO HUNTERS'
        ORDER BY C.in_herd_since ASC
        FETCH FIRST 3 ROWS ONLY)T2;

UPDATE Cats
SET mice_ration = CASE gender
    WHEN 'M' THEN mice_ration+10
    WHEN 'W' THEN mice_ration+(.10(SELECT MIN(mice_ration) FROM Cats))
    END
WHERE name IN (SELECT name FROM member_rations);

UPDATE Cats
SET mice_extra = CASE band_no
    WHEN 2 THEN NVL(mice_extra,0)+(.15(SELECT AVG(NVL(mice_extra,0)) FROM Cats WHERE band_no = 2))
    WHEN 4 THEN NVL(mice_extra,0)+(.15(SELECT AVG(NVL(mice_extra,0)) FROM Cats WHERE band_no = 4))
    END
WHERE name IN (SELECT name FROM member_rations);

SELECT
FROM member_rations;

-- Task 33:
WITH Cat_Function_Band AS
(SELECT B.name "NAME", 
      CASE
      WHEN C.gender = 'M' THEN 'Male cat '
      ELSE 'Female cat'
      END "GENDER",
      COUNT(*) "HOW MANY",
      SUM(CASE WHEN C.function = 'BOSS' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "BOSS",
      SUM(CASE WHEN C.function = 'THUG' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "THUG",
      SUM(CASE WHEN C.function = 'CATCHING' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CATCHING",
      SUM(CASE WHEN C.function = 'CATCHER' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CATCHER",
      SUM(CASE WHEN C.function = 'CAT' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CAT",
      SUM(CASE WHEN C.function = 'NICE' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "NICE",
      SUM(CASE WHEN C.function = 'DIVISIVE' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "DIVISIVE",
      SUM( NVL(mice_ration, 0) + NVL(mice_extra, 0)  ) "SUM"
FROM Cats C
    JOIN Bands B ON C.band_no = B.band_no
GROUP BY B.name, C.gender
ORDER BY B.name)

SELECT name, gender, TO_CHAR("HOW MANY") "HOW MANY", "BOSS", "THUG", "CATCHING", "CATCHER", "CAT", "NICE", "DIVISIVE", "SUM"
FROM Cat_Function_Band
UNION
SELECT 'Z Eats in total' "NAME",
       ' ' "GENDER",
       ' ' "HOW MANY",
       SUM(CASE WHEN C.function = 'BOSS' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "BOSS",
       SUM(CASE WHEN C.function = 'THUG' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "THUG",
       SUM(CASE WHEN C.function = 'CATCHING' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CATCHING",
       SUM(CASE WHEN C.function = 'CATCHER' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CATCHER",
       SUM(CASE WHEN C.function = 'CAT' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "CAT",
       SUM(CASE WHEN C.function = 'NICE' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "NICE",
       SUM(CASE WHEN C.function = 'DIVISIVE' THEN NVL(mice_ration, 0) + NVL(mice_extra, 0) ELSE 0 END ) "DIVISIVE",
       SUM( NVL(mice_ration, 0) + NVL(mice_extra, 0)  ) "SUM"
FROM Cats  C ;    