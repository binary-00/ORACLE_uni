>> DROP TABLE BANDS CASCADE CONSTRAINTS; to remove any previous tables and started new,

CREATE TABLE Cats(
  name VARCHAR2(15) NOT NULL, 
  gender VARCHAR2(1) CONSTRAINT check_gender CHECK(
    gender = 'M' 
    OR gender = 'W'
  ), 
  nickname VARCHAR2(15) CONSTRAINT Cats_PK PRIMARY KEY, 
  function VARCHAR2(10), 
  CONSTRAINT function_fk FOREIGN KEY (function) REFERENCES Functions(function), 
  chief VARCHAR2(15), 
  CONSTRAINT chief_fk FOREIGN KEY(nickname) REFERENCES Cats(nickname), 
  in_herd_since DATE DEFAULT sysdate CONSTRAINT in_herd_since_nn not null, 
  mice_ration NUMBER(3), 
  mice_extra NUMBER(2), 
  band_no NUMBER(2)
) 

ALTER TABLE 
  Cats 
add 
  constraint cat_band_no_fk foreign key(band_no) references bands(band_no);

>> I had to alter the cats table as it had a foreign key referencing the bands table. Since the bands table had a foreign key
referencing the cats table, it was not possible to create the bands table before creating the cats table.

CREATE TABLE Bands(
  Band_no NUMBER(2) CONSTRAINT Bands_PK PRIMARY KEY, 
  name VARCHAR2(20) CONSTRAINT name_nn NOT NULL, 
  site VARCHAR2(15) CONSTRAINT site_unique UNIQUE, 
  band_chief VARCHAR2(15) CONSTRAINT band_chief_uinque UNIQUE, 
  CONSTRAINT band_chief foreign key (band_chief) references Cats(nickname)
);

CREATE TABLE Functions(
  function VARCHAR2(10) CONSTRAINT function_pk PRIMARY KEY, 
  min_mice NUMBER(3) CONSTRAINT check_min_mice CHECK(min_mice > 5), 
  max_mice NUMBER(3) CONSTRAINT check_max_mice CHECK(
    max_mice > 5 
    AND max_mice <= 200
  )
) 

CREATE TABLE Enemies(
  enemy_name VARCHAR2(15) CONSTRAINT Enemies_PK PRIMARY KEY, 
  hostility_degree NUMBER(2) CONSTRAINT check_hostility_degree CHECK(
    hostility_degree >= 1 
    AND hostility_degree <= 10
  ), 
  species VARCHAR2(15), 
  bride VARCHAR(20)
) 

CREATE TABLE Incidents(
  nickname varchar2(15) constraint nickname_fk_1 references Cats(nickname), 
  enemy_name varchar(15) constraint enemy_name_fk references Enemies(enemy_name), 
  incdent_date date not null, 
  incident_desc varchar2(50), 
  constraint incidents_pk primary key (nickname, enemy_name)
)

>>> check constrains;

select 
  constraint_type, 
  constraint_name 
from 
  all_constraints 
where 
  table_name = 'Functions';

-------------------------------------------------------------------------------------------------------------------------

INSERT INTO Functions VALUES ('BOSS',90,110);
INSERT INTO Functions VALUES ('THUG',70,90);
INSERT INTO Functions VALUES ('CATCHING',60,70);
INSERT INTO Functions VALUES ('CATCHER',50,60);
INSERT INTO Functions VALUES ('CAT',40,50);
INSERT INTO Functions VALUES ('NICE',20,30);
INSERT INTO Functions VALUES ('DIVISIVE',45,55);
INSERT INTO Functions VALUES ('HONORARY',6,25);

select * from  Functions ; 

INSERT INTO Enemies VALUES ('KAZIO',10,'MAN','BOTTLE');
INSERT INTO Enemies VALUES ('STUPID SOPHIA',1,'MAN','BEAD');
INSERT INTO Enemies VALUES ('UNRULY DYZIO',7,'MAN','CHEWING GUM');
INSERT INTO Enemies VALUES ('DUN',4,'DOG','BON');
INSERT INTO Enemies VALUES ('WILD BILL',10,'DOG',NULL);
INSERT INTO Enemies VALUES ('REKS',2,'DOG','BONE');
INSERT INTO Enemies VALUES ('BETHOVEN',1,'DOG','PEDIGRIPALL');
INSERT INTO Enemies VALUES ('SLYBOOTS',5,'FOX','CHICKEN');
INSERT INTO Enemies VALUES ('SLIM',1,'PINE',NULL);
INSERT INTO Enemies VALUES ('BASIL',3,'ROOSTER','HEN TO THE HERD');

select * from Enemies ;

INSERT INTO Bands VALUES (1,'SUPERIORS','WHOLE AREA',NULL);
INSERT INTO Bands VALUES (2,'BLACK KNIGHTS','FIELD',NULL);
INSERT INTO Bands VALUES (3,'WHITE HUNTERS','ORCHARD',NULL);
INSERT INTO Bands VALUES (4,'PINTO HUNTERS','HILLOCK',NULL);
INSERT INTO Bands VALUES (5,'ROCKERS','FARM',NULL);

>>> First i changed the date format in sql to YYYY-MM-DD and inserted data into CATS. After that 
this UPDATE was done.

update Bands
set band_chief  = 'TIGER'
where band_no =1 ; 

update Bands
set band_chief  = 'BALD'
where band_no = 2; 

update Bands
set band_chief  = 'ZOMBIES'
where band_no = 3; 

update Bands
set band_chief  = 'REEF'
where band_no = 4; 


select * from Bands ;
 
INSERT INTO Cats VALUES ('MRUCZEK','M','TIGER','BOSS',NULL,'2002-01-01',103,33,1);
INSERT INTO Cats VALUES ('BOLEK','M','BALD','THUG','TIGER','2006-08-15',72,21,2);
INSERT INTO Cats VALUES ('JACEK','M','CAKE','CATCHING','BALD','2008-12-01',67,NULL,2);
INSERT INTO Cats VALUES ('BARI','M','TUBE','CATCHER','BALD','2009-09-01',56,NULL,2);
INSERT INTO Cats VALUES ('MICKA','W','LOLA','NICE','TIGER','2009-10-14',25,47,1);
INSERT INTO Cats VALUES ('KOREK','M','ZOMBIES','THUG','TIGER','2004-03-16',75,13,3);
INSERT INTO Cats VALUES ('PUNIA','W','HEN','CATCHING','ZOMBIES','2008-01-01',61,NULL,3);
INSERT INTO Cats VALUES ('LUCEK','M','ZERO','CAT','HEN','2010-03-01',43,NULL,3);
INSERT INTO Cats VALUES ('SONIA','W','FLUFFY','NICE','ZOMBIES','2010-11-18',20,35,3);
INSERT INTO Cats VALUES ('PUCEK','M','REEF','CATCHING','TIGER','2006-10-15',65,NULL,4);
INSERT INTO Cats VALUES ('LATKA','W','EAR','CAT','REEF','2011-01-01',40,NULL,4);
INSERT INTO Cats VALUES ('DUDEK','M','SMALL','CAT','REEF','2011-05-15',40,NULL,4);
INSERT INTO Cats VALUES ('CHYTRY','M','BOLEK','DIVISIVE','TIGER','2002-05-05',50,NULL,1);
INSERT INTO Cats VALUES ('ZUZIA','W','FAST','CATCHING','BALD','2006-07-21',65,NULL,2);
INSERT INTO Cats VALUES ('RUDA','W','LITTLE','NICE','TIGER','2006-09-17',22,42,1);
INSERT INTO Cats VALUES ('BELA','W','MISS','NICE','BALD','2008-02-01',24,28,2);
INSERT INTO Cats VALUES ('KSAWERY','M','MAN','CATCHER','REEF','2008-07-12',51,NULL,4);
INSERT INTO Cats VALUES ('MELA','W','LADY','CATCHER','REEF','2008-11-01',51,NULL,4);


INSERT INTO Incidents VALUES ('TIGER','KAZIO','2004-10-13','HE HAS TRYING TO STICK ON THE FORK');
INSERT INTO Incidents VALUES ('ZOMBIES', 'UNRULY DYZIO','2005-03-07','HE FOOTED AN EYE FROM PROCAST');
INSERT INTO Incidents VALUES ('BOLEK','KAZIO','2005-03-29','HE CLEANED DOG');
INSERT INTO Incidents VALUES ('FAST', 'STUPID SOPHIA' ,'2006-09-12','SHE USED THE CAT AS A CLOTH');
INSERT INTO Incidents VALUES ('LITTLE','SLYBOOTS','2007-03-07','HE RECOMMENDED HIMSELF AS A HUSBAND');
INSERT INTO Incidents VALUES ('TIGER','WILD BILL','2007-06-12','HE TRIED TO KILL');
INSERT INTO Incidents VALUES ('BOLEK','WILD BILL','2007-11-10','HE BITE THE EAR');
INSERT INTO Incidents VALUES ('MISS','WILD BILL','2008-12-12','HE BITCHED');
INSERT INTO Incidents VALUES ('MISS','KAZIO','2009-01-07','HE CAUGHT THE TAIL AND MADE A WIND');
INSERT INTO Incidents VALUES ('LADY','KAZIO','2009-02-07','HE WANTED TO SKIN OFF');
INSERT INTO Incidents VALUES ('MAN','REKS','2009-04-14','HE BARKED EXTREMELY RUDELY');
INSERT INTO Incidents VALUES ('BALD','BETHOVEN','2009-05-11','HE DID NOT SHARE THE PORRIDGE');
INSERT INTO Incidents VALUES ('TUBE','WILD BILL','2009-09-03','HE TOOK THE TAIL');
INSERT INTO Incidents VALUES ('CAKE','BASIL','2010-07-12','HE PREVENTED THE CHICKEN FROM BEING HUNTED');
INSERT INTO Incidents VALUES ('FLUFFY','SLIM','2010-11-19','SHE THREW CONES');
INSERT INTO Incidents VALUES ('HEN','DUN','2010-12-14','HE CHASED');
INSERT INTO Incidents VALUES ('SMALL','SLYBOOTS','2011-07-13','HE TOOK THE STOLEN EGGS');
INSERT INTO Incidents VALUES ('EAR', 'UNRULY DYZIO','2011-07-14','HE THREW STONES');

------------------------------------------------------------------------------------------------------------
--Task 1
SELECT Enemy_Name, incident_desc AS "Fault Description"
FROM Incidents
WHERE incdent_date BETWEEN '2009-01-01' AND '2009-12-31';

--Task 2
SELECT name, function, in_herd_since as "With as Form"
FROM Cats
WHERE gender = 'W' 
AND in_herd_since BETWEEN '2005-09-01' AND '2007-07-31'

--Task 3
SELECT enemy_name, species, hostility_degree
FROM Enemies
WHERE bride is null
ORDER BY hostility_degree ASC

--Task 4
SELECT name || ' called ' || nickname || ' (fun. ' || function || ') has been catching mice in band ' || band_no || ' since ' || in_herd_since as ALL_ABOUT_MALE_CATS
FROM Cats
WHERE gender = 'M' 
ORDER BY in_herd_since DESC, nickname ASC;

--Task 5
SELECT 
  nickname, 
  REPLACE(
    REPLACE(nickname, 'AL', '#%'), 
    'LA', 
    '%#'
  ) AS "After replacing A and L" 
FROM Cats 
WHERE nickname LIKE '%AL%' OR nickname LIKE '%LA%' 
ORDER BY nickname;

--Task 6
SELECT 
  name, 
  in_herd_since as "In herd", 
  round(
    0.9 *(mice_ration)
  ) as Ate, 
  ADD_MONTHS(in_herd_since, 6) as Increase, 
  mice_ration as Eat 
FROM 
  cats 
WHERE 
  round(
    MONTHS_BETWEEN(SYSDATE, in_herd_since)
  )/ 12 > 11 
  AND (
    TO_CHAR(in_herd_since, 'MM-DD') BETWEEN '03-01' 
    AND '09-30'
  );

--Task 7
SELECT 
  NAME, 
  Mice_Ration* 3 as "MICE QUATERLY", 
  MICE_EXTRA* 3 as "EXTRA QUATERLY" 
FROM 
  CATS 
WHERE 
  mice_ration > 2*NVL(mice_extra, 0)
  AND mice_ration > 55 
ORDER BY 
  mice_ration DESC;

--Task 8
SELECT 
  NAME, 
  CASE WHEN(
    (MICE_RATION)* 12 + NVL(mice_extra, 0)* 12)< 660 THEN 'Below 660' WHEN(
    (MICE_RATION)* 12 + NVL(mice_extra, 0)* 12)= 660 THEN 'LIMIT' 
    ELSE TO_CHAR((MICE_RATION)* 12 + NVL(mice_extra, 0)* 12) 
    END "Eats annually" 
FROM CATS
ORDER BY Name;

--Task 9
SELECT 
  nickname, 
  in_herd_since as "IN HERD", 
  CASE WHEN EXTRACT(
    DAY 
    FROM 
      in_herd_since
  ) <= 15 THEN '2020-10-29' ELSE '2020-11-25' END PAYMENT 
FROM 
  CATS 
ORDER BY 
  in_herd_since ASC;

SELECT 
  NICKNAME, 
  in_herd_since as "IN HERD", 
  CASE WHEN(
    EXTRACT(
      DAY 
      FROM 
        IN_HERD_SINCE
    )<= 15
  ) THEN '2020-10-28' ELSE '2020-11-25' END PAYMENT 
FROM 
  CATS 
ORDER BY 
  in_herd_since ASC;
____

SELECT nickname, in_herd_since "In Herd",
    CASE 
        WHEN EXTRACT(DAY FROM TO_DATE(in_herd_since, 'YYYY-MM-DD')) <= 15 
            THEN LAST_DAY(TO_DATE('2020-10-27', 'YYYY-MM-DD'))-14 
        ELSE 
            LAST_DAY(LAST_DAY(TO_DATE('2020-10-27', 'YYYY-MM-DD'))+1)-14 
    END payment 
FROM cats
ORDER BY in_herd_since ASC;

SELECT nickname, in_herd_since "In Herd",
    CASE 
        WHEN EXTRACT(DAY FROM TO_DATE(in_herd_since, 'YYYY-MM-DD')) <= 15 
            THEN LAST_DAY(TO_DATE('2020-10-29', 'YYYY-MM-DD'))-7 
        ELSE 
            LAST_DAY(LAST_DAY(TO_DATE('2020-10-29', 'YYYY-MM-DD'))+1)-7 
    END payment 
FROM cats;

----
--Task 10
SELECT 
  CASE WHEN COUNT(nickname) = 1 THEN CONCAT(nickname, ' - unique') ELSE CONCAT(nickname, ' - non-unique') END "Uniqueness of the nickname" 
FROM 
  CATS 
GROUP BY 
  nickname 
ORDER BY 
  nickname ASC;

SELECT 
  CASE WHEN COUNT(CHIEF)= 1 THEN CONCAT(chief, ' - unique') ELSE CONCAT(chief, ' - non-unique') END "UNIQUENESS OF THE CHIEF" 
FROM 
  CATS 
WHERE 
  chief is not NULL 
GROUP BY 
  CHIEF 
ORDER BY 
  chief;

--Task 11
SELECT nickname, COUNT(enemy_name) AS "Number of enemies"
FROM INCIDENTS
GROUP BY nickname
HAVING COUNT(enemy_name) > 1
ORDER BY nickname;

--Task 12
SELECT 'Number of Cats= ' || COUNT(Function)|| ' hunts as ' || Function || ' and eats max. ' || MAX(MICE_RATION + NVL(MICE_EXTRA, 0))|| ' mice per month' AS " " 
FROM (SELECT * FROM Cats WHERE Function != 'BOSS' AND Gender != 'M') 
GROUP BY Function 
HAVING AVG(MICE_RATION + NVL(MICE_EXTRA, 0)) > 50 
ORDER BY MAX(MICE_RATION + NVL(MICE_EXTRA, 0)) ASC;

--Task13
SELECT BAND_NO as "Band No", GENDER, 
  MIN(MICE_RATION) as "Minimum Ration" 
FROM CATS 
GROUP BY GENDER, BAND_NO;

--Task 14
SELECT Level, Nickname, Function, Band_NO 
FROM Cats 
WHERE GENDER = 'M'
CONNECT BY PRIOR Nickname = Chief
START WITH Function = 'THUG' 
ORDER BY Band_NO;

--Task 15
SELECT 
  CASE WHEN level -1 = 0 THEN TO_CHAR('0') ELSE RPAD('===>', (level -1)* 4, '===>') || TO_CHAR(level -1) END "Hierarchy", 
  CASE WHEN chief IS NULL THEN 'Master yourself' ELSE chief END "Nickname of the Chief", 
  Function "Function" 
FROM Cats 
WHERE 
  mice_extra IS NOT NULL
CONNECT BY PRIOR Nickname = Chief
START WITH Chief IS NULL;

--Task 16
SELECT 
  CASE WHEN level -1 = 0 THEN CONNECT_BY_ROOT Nickname ELSE RPAD('    ', (level)* 4, '    ') || CONNECT_BY_ROOT Nickname END "Path of Chiefs" 
FROM Cats 
WHERE mice_extra IS NULL 
AND Gender = 'M' 
AND Months_Between(TO_DATE('2020-04-06', 'YYYY--MM-DD'), In_Herd_Since) / 12 >= 11 
CONNECT BY PRIOR Nickname = Chief 
START WITH Nickname IS NOT NULL 
ORDER BY Nickname, Level;