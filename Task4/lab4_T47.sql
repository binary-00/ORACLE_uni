SET SERVEROUTPUT ON
SET VERIFY ON

DELETE Incidents;
DELETE Accounts;
DELETE Elites;
DELETE Commons;
DELETE CatsR;

DROP TABLE Incidents;
DROP TABLE Accounts;
DROP TABLE Elites;
DROP TABLE Commons;
DROP TABLE CatsR;
DROP TYPE BODY INCIDENT_TYPE;
DROP TYPE INCIDENT_TYPE;
DROP TYPE BODY ACCOUNT_TYPE;
DROP TYPE ACCOUNT_TYPE;
DROP TYPE ELITE_TYPE;
DROP TYPE COMMON_TYPE;
DROP TYPE BODY CAT_TYPE;
DROP type CAT_TYPE;


--TASK 47
CREATE OR REPLACE TYPE CAT_TYPE AS OBJECT
(
name VARCHAR2(15),
gender VARCHAR2(1),
nickname VARCHAR2(15),
function VARCHAR2(10),
chief REF CAT_TYPE,
in_herd_since DATE,
mice_ration NUMBER(3),
mice_extra NUMBER(3),
band_no NUMBER(3),
MEMBER FUNCTION GetName RETURN VARCHAR2,
MEMBER FUNCTION GetTotalEats RETURN NUMBER,
MEMBER FUNCTION GetInHerdSince RETURN DATE
);

CREATE OR REPLACE TYPE BODY CAT_TYPE AS
    MEMBER FUNCTION GetName RETURN VARCHAR2 IS
    BEGIN
        RETURN name;
    END;
    MEMBER FUNCTION GetTotalEats RETURN NUMBER IS
    BEGIN
        RETURN NVL(mice_ration,0)+NVL(mice_extra,0);
    END;
    MEMBER FUNCTION GetInHerdSince RETURN DATE IS
    BEGIN
        RETURN TO_CHAR(in_herd_since, 'YYYY-MM-DD');
    END;
END;

CREATE OR REPLACE TYPE COMMON_TYPE AS OBJECT
(
    common_id NUMBER,
    cat REF CAT_TYPE
);

CREATE OR REPLACE TYPE ELITE_TYPE AS OBJECT
(
    id_elite NUMBER,
    cat REF CAT_TYPE,
    servant REF COMMON_TYPE
);

CREATE OR REPLACE TYPE ACCOUNT_TYPE AS OBJECT
(
    action_id NUMBER,
    owner REF ELITE_TYPE,
    creation_date DATE,
    deletion_date DATE,
    MEMBER PROCEDURE add_mouse,
    MEMBER PROCEDURE delete_mouse
);

CREATE OR REPLACE TYPE BODY ACCOUNT_TYPE AS
    MEMBER PROCEDURE add_mouse IS
    BEGIN
        creation_date:=current_date;
    END;
    MEMBER PROCEDURE delete_mouse IS
    BEGIN
        deletion_date:=current_date;
    END;
END;

CREATE OR REPLACE TYPE INCIDENT_TYPE AS OBJECT
(
    incident_id NUMBER,
    victim REF CAT_TYPE,
    enemy_name VARCHAR2(15),
    incident_date DATE,
    incident_description VARCHAR2(50),
    MEMBER FUNCTION GetInfo RETURN VARCHAR2
);

CREATE OR REPLACE TYPE BODY INCIDENT_TYPE AS
    MEMBER FUNCTION GetInfo RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Incident of : '||enemy_name||' On : '|| incident_date;
    END;
END;

-----err----
CREATE TABLE CatsR OF CAT_TYPE
(
    CONSTRAINT cats_pk_1 PRIMARY KEY (nickname),
    CONSTRAINT cats_fk_function_1 FOREIGN KEY (function)
                          REFERENCES Functions(function),
    CONSTRAINT cats_fk_band_1 FOREIGN KEY (band_no)
                          REFERENCES Bands(band_no)
);

CREATE TABLE Commons OF COMMON_TYPE
(
    CONSTRAINT commons_pk PRIMARY KEY(common_id),
    cat NOT NULL
);

CREATE TABLE Elites OF ELITE_TYPE
(
    cat NOT NULL,
    servant SCOPE IS Commons,
    CONSTRAINT elites_pk PRIMARY KEY(id_elite)
);

CREATE TABLE Accounts OF ACCOUNT_TYPE
(
    CONSTRAINT accounts_pk PRIMARY KEY(action_id),
    owner SCOPE IS Elites,
    CONSTRAINT account_creation_date_nn CHECK(creation_date IS NOT NULL),
    CONSTRAINT account_date CHECK(creation_date >= deletion_date)
);
---err02---
CREATE TABLE Incidents OF INCIDENT_TYPE
(
    CONSTRAINT incidents_pk PRIMARY KEY (incident_id),
    victim SCOPE IS CatsR,
    enemy_name NOT NULL,
    CONSTRAINT incidents_fk_enemies FOREIGN KEY (enemy_name) REFERENCES Enemies(enemy_name),
    incident_date NOT NULL
);


INSERT INTO CatsR VALUES('MRUCZEK','M','TIGER','BOSS',NULL,'2002-01-01',103,33,1);

INSERT ALL
    INTO CatsR VALUES('BOLEK','M','BALD','THUG',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2006-08-15',72,21,2)
    INTO CatsR VALUES('MICKA','W','LOLA','NICE',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2009-10-14',25,47,1)
    INTO CatsR VALUES('KOREK','M','ZOMBIES','THUG',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2004-03-16',75,13,3)
    INTO CatsR VALUES('RUDA','W','LITTLE','NICE',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2006-09-17',22,42,1)
    INTO CatsR VALUES('PUCEK','M','REEF','CATCHING',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2006-10-15',65,NULL,4)
    INTO CatsR VALUES('CHYTRY','M','BOLEK','DIVISIVE',(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'2002-05-05',50,NULL,1)
SELECT * FROM DUAL;

INSERT ALL
    INTO CatsR VALUES('JACEK','M','CAKE','CATCHING',(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),'2008-12-01',67,NULL,2)
    INTO CatsR VALUES('BARI','M','TUBE','CATCHER',(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),'2009-09-01',56,NULL,2)
    INTO CatsR VALUES('SONIA','W','FLUFFY','NICE',(SELECT REF(K) FROM CatsR K WHERE nickname='ZOMBIES'),'2010-11-18',20,35,3)
    INTO CatsR VALUES('ZUZIA','W','FAST','CATCHING',(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),'2006-07-21',65,NULL,2)
    INTO CatsR VALUES('PUNIA','W','HEN','CATCHING',(SELECT REF(K) FROM CatsR K WHERE nickname='ZOMBIES'),'2008-01-01',61,NULL,3)
    INTO CatsR VALUES('BELA','W','MISS','NICE',(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),'2008-02-01',24,28,2)
    INTO CatsR VALUES('LATKA','W','EAR','CAT',(SELECT REF(K) FROM CatsR K WHERE nickname='REEF'),'2011-01-01',40,NULL,4)
    INTO CatsR VALUES('DUDEK','M','SMALL','CAT',(SELECT REF(K) FROM CatsR K WHERE nickname='REEF'),'2011-05-15',40,NULL,4)
    INTO CatsR VALUES('KSAWERY','M','MAN','CATCHER',(SELECT REF(K) FROM CatsR K WHERE nickname='REEF'),'2008-07-12',51,NULL,4)
    INTO CatsR VALUES('MELA','W','LADY','CATCHER',(SELECT REF(K) FROM CatsR K WHERE nickname='REEF'),'2008-11-01',51,NULL,4)
SELECT * FROM DUAL;

INSERT INTO CatsR VALUES('LUCEK','M','ZERO','CAT',(SELECT REF(K) FROM CatsR K WHERE nickname='HEN'),'2010-03-01',43,NULL,3);

INSERT ALL
    INTO Commons VALUES(1,(SELECT REF(K) FROM CatsR K WHERE nickname='CAKE'))
    INTO Commons VALUES(2,(SELECT REF(K) FROM CatsR K WHERE nickname='TUBE'))
    INTO Commons VALUES(3,(SELECT REF(K) FROM CatsR K WHERE nickname='LOLA'))
    INTO Commons VALUES(4,(SELECT REF(K) FROM CatsR K WHERE nickname='ZERO'))
    INTO Commons VALUES(5,(SELECT REF(K) FROM CatsR K WHERE nickname='FLUFFY'))
    INTO Commons VALUES(6,(SELECT REF(K) FROM CatsR K WHERE nickname='EAR'))
    INTO Commons VALUES(7,(SELECT REF(K) FROM CatsR K WHERE nickname='SMALL'))
    INTO Commons VALUES(8,(SELECT REF(K) FROM CatsR K WHERE nickname='MISS'))
    INTO Commons VALUES(9,(SELECT REF(K) FROM CatsR K WHERE nickname='MAN'))
SELECT * FROM DUAL;

INSERT ALL
    INTO Elites VALUES(1,(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),(SELECT REF(P) FROM Commons P WHERE common_id=1))
    INTO Elites VALUES(2,(SELECT REF(K) FROM CatsR K WHERE nickname='BOLEK'),NULL)
    INTO Elites VALUES(3,(SELECT REF(K) FROM CatsR K WHERE nickname='ZOMBIES'),(SELECT REF(P) FROM Commons P WHERE common_id=3))
    INTO Elites VALUES(4,(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),(SELECT REF(P) FROM Commons P WHERE common_id=4))
    INTO Elites VALUES(5,(SELECT REF(K) FROM CatsR K WHERE nickname='FAST'),(SELECT REF(P) FROM Commons P WHERE common_id=1))
    INTO Elites VALUES(6,(SELECT REF(K) FROM CatsR K WHERE nickname='SMALL'),NULL)
    INTO Elites VALUES(7,(SELECT REF(K) FROM CatsR K WHERE nickname='REEF'),(SELECT REF(P) FROM Commons P WHERE common_id=7))
    INTO Elites VALUES(8,(SELECT REF(K) FROM CatsR K WHERE nickname='HEN'),(SELECT REF(P) FROM Commons P WHERE common_id=5))
    INTO Elites VALUES(9,(SELECT REF(K) FROM CatsR K WHERE nickname='LADY'),NULL)
SELECT * FROM DUAL;

INSERT ALL
    INTO Incidents VALUES(1,(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'KAZIO','2004-10-13','HE HAS TRYING TO STICK ON THE FORK')
    INTO Incidents VALUES(2,(SELECT REF(K) FROM CatsR K WHERE nickname='BOLEK'),'KAZIO','2005-03-29','HE CLEANED DOG')
    INTO Incidents VALUES(3,(SELECT REF(K) FROM CatsR K WHERE nickname='SMALL'),'SLYBOOTS','2007-03-07','HE RECOMMENDED HIMSELF AS A HUSBAND')
    INTO Incidents VALUES(4,(SELECT REF(K) FROM CatsR K WHERE nickname='TIGER'),'WILD BILL','2007-06-12','HE TRIED TO KILL')
    INTO Incidents VALUES(5,(SELECT REF(K) FROM CatsR K WHERE nickname='BOLEK'),'WILD BILL','2007-11-10','HE BITE THE EAR')
    INTO Incidents VALUES(6,(SELECT REF(K) FROM CatsR K WHERE nickname='MISS'),'WILD BILL','2008-12-12','HE BITCHED')
    INTO Incidents VALUES(7,(SELECT REF(K) FROM CatsR K WHERE nickname='MISS'),'KAZIO','2009-01-07','HE CAUGHT THE TAIL AND MADE A WIND')
    INTO Incidents VALUES(8,(SELECT REF(K) FROM CatsR K WHERE nickname='LADY'),'KAZIO','2009-02-07','HE WANTED TO SKIN OFF')
    INTO Incidents VALUES(9,(SELECT REF(K) FROM CatsR K WHERE nickname='MAN'),'REKS','2009-04-14','HE BARKED EXTREMELY RUDELY')
    INTO Incidents VALUES(10,(SELECT REF(K) FROM CatsR K WHERE nickname='BALD'),'BETHOVEN','2009-05-11','HE DID NOT SHARE THE PORRIDGE')
    INTO Incidents VALUES(11,(SELECT REF(K) FROM CatsR K WHERE nickname='TUBE'),'WILD BILL','2009-09-03','HE TOOK THE TAIL')
    INTO Incidents VALUES(12,(SELECT REF(K) FROM CatsR K WHERE nickname='CAKE'),'BASIL','2010-07-12','HE PREVENTED THE CHICKEN FROM BEING HUNTED')
    INTO Incidents VALUES(13,(SELECT REF(K) FROM CatsR K WHERE nickname='FLUFFY'),'SLIM','2010-11-19','SHE THREW CONES')
    INTO Incidents VALUES(14,(SELECT REF(K) FROM CatsR K WHERE nickname='HEN'),'DUN','2010-12-14','HE CHASED')
    INTO Incidents VALUES(15,(SELECT REF(K) FROM CatsR K WHERE nickname='SMALL'),'SLYBOOTS','2011-07-13','HE TOOK THE STOLEN EGGS')
    INTO Incidents VALUES(16,(SELECT REF(K) FROM CatsR K WHERE nickname='EAR'),'UNRULY DYZIO','2011-07-14','HE THREW STONES')
SELECT * FROM DUAL;

INSERT ALL
    INTO Accounts VALUES(1,(SELECT REF(E) FROM Elites E WHERE id_elite=1),SYSDATE,NULL)
    INTO Accounts VALUES(2,(SELECT REF(E) FROM Elites E WHERE id_elite=2),SYSDATE,NULL)
    INTO Accounts VALUES(3,(SELECT REF(E) FROM Elites E WHERE id_elite=3),SYSDATE,NULL)
    INTO Accounts VALUES(4,(SELECT REF(E) FROM Elites E WHERE id_elite=8),SYSDATE,NULL)
    INTO Accounts VALUES(5,(SELECT REF(E) FROM Elites E WHERE id_elite=8),SYSDATE,NULL)
    INTO Accounts VALUES(6,(SELECT REF(E) FROM Elites E WHERE id_elite=1),SYSDATE,NULL)
    INTO Accounts VALUES(7,(SELECT REF(E) FROM Elites E WHERE id_elite=7),SYSDATE,NULL)
    INTO Accounts VALUES(8,(SELECT REF(E) FROM Elites E WHERE id_elite=1),SYSDATE,NULL)
    INTO Accounts VALUES(9,(SELECT REF(E) FROM Elites E WHERE id_elite=1),SYSDATE,NULL)
    INTO Accounts VALUES(10,(SELECT REF(E) FROM Elites E WHERE id_elite=4),SYSDATE,NULL)
SELECT * FROM DUAL;
COMMIT;


------------------
--REFERENCE
------------------
SELECT DEREF(cat).nickname "Elite", DEREF(servant).cat.GetName() "Servant"
FROM Elites
WHERE servant is not null;

--CATS WITH MICE ON ACCOUNT
SELECT E.cat.GetName() "Owner", A.creation_date "Creation Date"
FROM Elites E LEFT JOIN Accounts A ON A.owner=REF(E)
WHERE A.creation_date > A.deletion_date OR A.deletion_date IS NULL;


------------------
--SUBQUERY
------------------
--SERVANT DATA
SELECT C.cat.name "Name", C.cat.function, NVL(C.cat.mice_ration,0)+NVL(C.cat.mice_extra,0) "Eats"
FROM Commons C
WHERE C.cat.nickname IN (SELECT E.servant.cat.nickname
                         FROM Elites E);

------------------
--GROUPING
------------------
SELECT A.owner.cat.nickname "Owner", COUNT(*) "Num Mice"
FROM Accounts A
WHERE A.creation_date > A.deletion_date OR A.deletion_date IS NULL
GROUP BY A.owner.cat.nickname
ORDER BY 2 DESC;

-------------------
--TASK 18
SELECT C.name "Name", C.GetInHerdSince() "Hunts Since"
FROM CatsR C JOIN CatsR C1 ON C1.name='JACEK'
WHERE C.in_herd_since < C1.in_herd_since
ORDER BY 2 DESC;

--TASK  23
SELECT C.name "Name", C.GetTotalEats()*12 "Annual Dose", 'More Than 864'
FROM CatsR C
WHERE C.mice_extra IS NOT NULL AND C.GetTotalEats()*12 > 864
UNION ALL
SELECT C.name "Imie", C.GetTotalEats()*12 "Annual Dose", '864'
FROM CatsR C
WHERE C.mice_Extra IS NOT NULL AND C.GetTotalEats()*12 = 864
UNION ALL
SELECT C.name "Name", C.GetTotalEats()*12 "Annual Dosel", 'Less Than 864'
FROM CatsR C
WHERE C.mice_extra IS NOT NULL AND C.GetTotalEats()*12 < 864
ORDER BY 2 DESC;

--TASK 37
DECLARE
    i NUMBER:=1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('No  Nickname  Eats');
    DBMS_OUTPUT.PUT_LINE(LPAD('-',20,'-'));
    FOR cr IN (SELECT C.nickname nickname,C.GetTotalEats() mice
                FROM CatsR C
                ORDER BY 2 DESC)
    LOOP
        EXIT WHEN i>5;
        DBMS_OUTPUT.PUT_LINE(i||'   '||RPAD(cr.nickname,9)||'   '||cr.mice);
        i:=i+1;
    END LOOP;
END;

--TASK 38
DECLARE
    maxl NUMBER:='&n';
    i NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('NUMBER OF SUPERIORS - '||maxl);
    DBMS_OUTPUT.PUT(RPAD('Name', 15));
    FOR i IN 1..maxl LOOP
        DBMS_OUTPUT.PUT(RPAD('|  Chief '||i, 18));
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;
    DBMS_OUTPUT.PUT(RPAD('-',13,'-'));
    FOR i IN 1..maxl LOOP
        DBMS_OUTPUT.PUT(' --- '||RPAD('-',13,'-'));
    END LOOP;
    DBMS_OUTPUT.NEW_LINE;

    FOR cat IN (SELECT name, nickname, chief FROM CatsR WHERE function IN ('CAT','NICE'))
    LOOP
        DBMS_OUTPUT.PUT(RPAD(cat.name, 15));
        FOR i IN 1..maxl
        LOOP
            IF cat.chief IS NULL THEN DBMS_OUTPUT.PUT(RPAD('|', 18));
            ELSE SELECT name, nickname, chief INTO cat FROM CatsR WHERE DEREF(cat.chief).nickname=nickname;
                DBMS_OUTPUT.PUT(RPAD('|  '||cat.name, 18));
            END IF;
        END LOOP;
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;