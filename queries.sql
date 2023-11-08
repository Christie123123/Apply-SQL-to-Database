connect to COMPANY_DATABASE;

/* 1. Find all employees (their first name, last name, salary per month, years of service)
who have a monthly salary greater than $12,000 and have 10 or more years of service.*/
SELECT FIRSTNAME, lastname, salarypermonth, yearsofservice
from EMPLOYEES
where EMPLOYEES.salarypermonth > 12000 AND
      EMPLOYEES.yearsofservice >= 10;

/*2. Find the employees (last name and first name) whose first names begin with ‘C’ and
have a birth year greater than 1970. Hint: Use the Year() function*/
SELECT lastname, firstname
FROM Employees
WHERE Employees.firstname LIKE 'C%' AND
      YEAR(Employees.birthdate) > 1970;

/*3. Find the average Salary per month of all female employees.*/
SELECT AVG(SALARYPERMONTH)
FROM Employees
WHERE Employees.Gender = 'F';

/*4. List the names of research groups that have a room in the ‘John Hodgins Building’.*/
SELECT DISTINCT rg.GROUPNAME
FROM RESEARCHGROUPS rg, ROOMS r,BUILDINGS b
WHERE rg.ID = r.RESEARCHGROUPID AND
      r.BUILDINGID IN (SELECT b.ID
                       FROM BUILDINGS b
                       WHERE b.NAME = 'John Hodgins Building');

/*5. Find the names of employees (their last name and first name) who have the same
last name as another employee, but have a different first name. For example, ‘Joe Smith’ and
‘Jessica Smith’. Group the results by (last name, first name), and order by last name.*/
SELECT DISTINCT e.LASTNAME, e.FIRSTNAME
FROM EMPLOYEES e, EMPLOYEES e1
WHERE e.LASTNAME = e1.LASTNAME AND
      e.FIRSTNAME != e1.FIRSTNAME
ORDER BY e.LASTNAME;

/*6a. List the number of elevators across all the campus buildings, and call this result ’NumOfElevators’.
Group the results by building name.*/
SELECT COUNT(h.ID) AS "NumOfElevators", b.NAME
FROM BUILDINGAREATYPE ba, HASAREA h, BUILDINGS b
WHERE ba.TYPENAME = 'Elevator' AND
      ba.ID = h.BUILDINGAREATYPEID AND
      h.BUILDINGID = b.ID
GROUP BY b.NAME;

/*6b. extend the query to only list the buildings that have more than
2 elevators. Group your results by building name.*/
SELECT COUNT(h.ID) AS "NumOfElevators", b.NAME
FROM BUILDINGAREATYPE ba, HASAREA h, BUILDINGS b
WHERE ba.TYPENAME = 'Elevator' AND
      ba.ID = h.BUILDINGAREATYPEID AND
      h.BUILDINGID = b.ID
GROUP BY b.NAME
HAVING COUNT(h.ID) > 2;

/*7. Find all buildings that have a building area type of ‘Food Area’ or ‘Lobby’. Display
only the building name, and the building area typename, and no duplicates.*/
SELECT DISTINCT b.NAME, ba.TYPENAME
FROM HASAREA h, BUILDINGS b, BUILDINGAREATYPE ba
WHERE h.BUILDINGAREATYPEID = ba.ID AND
      (ba.TYPENAME = 'Food Area' OR ba.TYPENAME = 'Lobby') AND
      h.BUILDINGID = b.ID;

/*8. Find the employee ID and names (lastname, firstname) of all department chairs who
do not work in any research group.*/
SELECT e.ID,e.LASTNAME, e.FIRSTNAME
FROM EMPLOYEES e
WHERE e.ID NOT IN (
    SELECT REL_EMPWORKINGROUP.EMPLOYEEID
    FROM REL_EMPWORKINGROUP
    ) AND
      e.ID IN (
          SELECT DEPARTMENTS.CHAIREMPID
          FROM DEPARTMENTS
        );


/*9. Report the January 2021 hydro bill for the ‘Pulp and Paper Technology’ research
group. Hint: The hydro bill is calculated based on readings obtained from all meters of typename
‘Hydro’ located in all rooms that belong to the Pulp and Paper research group. Assume
meter readings are automatically taken at 12:00am, and are cumulative. That is, on Jan 2, 2021
a meter reading may have a value v1 = 3000, and the next day (Jan 3, 2021), the same meter
may give a reading v2 = 3500. The hydro bill for Jan 2 (for this meter only) would be calculated
as (v2 - v1) * cost per unit (hydro rate).*/
CREATE VIEW METERSBELONGS AS
    SELECT *
    FROM REL_METERINSTALLEDINROOM m1
    WHERE m1.ROOMID IN (
        SELECT r.ID
        FROM ROOMS r, RESEARCHGROUPS rg
        WHERE r.RESEARCHGROUPID = rg.ID AND
            rg.GROUPNAME = 'Pulp and Paper Technology') AND
        m1.METERID IN (
        SELECT m2.ID
        FROM METERS m2,METERTYPE mp
        WHERE m2.METERTYPEID = mp.ID AND
          mp.TYPENAME = 'Hydro'
        );

SELECT SUM((mb2.READING-mb1.READING)*
           (SELECT r.COSTPERUNIT
            FROM RATES r, METERTYPE mt
            WHERE r.ID = mt.RATEID AND
                  mt.TYPENAME = 'Hydro')) AS HydroBill
FROM METERSBELONGS mb1, METERSBELONGS mb2
WHERE mb2.DATEOFRECORD = '2021-02-01' AND
      mb1.DATEOFRECORD = '2021-01-01' AND
      mb1.METERID = mb2.METERID;

/*10. List all research groups (their group name) and their hydro bill (in descending order
of hydro bill) for Jan 2021.*/
CREATE VIEW HYDROMETERS AS
    SELECT *
    FROM REL_METERINSTALLEDINROOM m1
    WHERE m1.METERID IN (
            SELECT m2.ID
            FROM METERS m2,METERTYPE mp
            WHERE m2.METERTYPEID = mp.ID AND
            mp.TYPENAME = 'Hydro'
          );

CREATE VIEW ROOMMETERS AS
SELECT SUM((mb2.READING-mb1.READING)*
           (SELECT r.COSTPERUNIT
            FROM RATES r, METERTYPE mt
            WHERE r.ID = mt.RATEID AND
                  mt.TYPENAME = 'Hydro')) AS READINGSUM,
       mb1.ROOMID
FROM HYDROMETERS mb1, HYDROMETERS mb2
WHERE mb2.DATEOFRECORD = '2021-02-01' AND
      mb1.DATEOFRECORD = '2021-01-01' AND
      mb1.METERID = mb2.METERID
GROUP BY mb1.ROOMID;



SELECT SUM(READINGSUM) AS "HydroBills", rg.GROUPNAME
FROM ROOMS r, ROOMMETERS rm, RESEARCHGROUPS rg
WHERE rm.ROOMID = r.ID AND
      r.RESEARCHGROUPID = rg.ID
GROUP BY rg.ID, rg.GROUPNAME
ORDER BY SUM(READINGSUM) DESC;

TERMINATE;


