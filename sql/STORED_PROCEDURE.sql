USE PROJECT;
DELIMITER //

DROP PROCEDURE IF EXISTS ShowInfo //
CREATE PROCEDURE ShowInfo(IN ID varchar(20))
BEGIN
   IF BINARY ID IN (SELECT Symbol FROM SECURITIES) THEN 
  SELECT DISTINCT S.Symbol, S.CIK, S.Security_Name, E.Exchange_Name, SECTOR.GICS_Sector,
        SECTOR.GICS_Industry, SECTOR.GICS_Sub_Industry, C.City, S.Founded
  FROM SECURITIES AS S, EXCHANGES AS E, SECTOR, CITY AS C
  WHERE ID = S.Symbol AND S.ExchangeID = E.ExchangeID AND S.SectorID = SECTOR.SectorID AND S.CityID = C.CityID;
        SELECT *
        FROM INSTITUTIONOWNERSHIP AS I
  WHERE ID = I.Symbol;
        SELECT *
        FROM COMPONENT_OF AS C, INDICE AS I
        WHERE ID = C.Symbol AND C.IndiceID = I.IndiceID;
        SELECT *
        FROM FUNDAMENTAL AS F
  WHERE ID = F.Symbol;
  SELECT * 
  FROM PRICE AS P
  WHERE ID = P.Symbol;
 ELSE
  SELECT 'Sorry, it is an invalid company symbol' AS 'Error Message';
 END IF;
END;

CALL ShowInfo('AAPL')//

DROP PROCEDURE IF EXISTS INDICEINFORMATION //
CREATE PROCEDURE INDICEINFORMATION (IN indicename VARCHAR(40), IN begindate DATE, IN enddate DATE)
BEGIN
     SELECT *
     FROM INDICE
     WHERE Indice = indicename;
	 SELECT b.Date_Observed
                   ,b.Open_Price
                   ,b.High
                   ,b.Low 
                   ,b.Close_Price
     FROM INDICE AS a INNER JOIN INDICE_VALUE AS b ON b.IndiceID=a.IndiceID
     WHERE a.Indice=indicename AND b.Date_Observed >= begindate AND b.Date_Observed <= enddate
     ORDER BY b.Date_Observed;
END;//
     
DROP PROCEDURE IF EXISTS BestSecurityInSector//
CREATE PROCEDURE BestSecurityInSector(IN Input_Sector varchar(70), IN Input_date Date)
BEGIN
SELECT s.Security_Name, d.dayreturn
FROM DAILY_RETURN AS d LEFT JOIN SECURITIES AS s ON s.symbol = d.symbol
WHERE d.Date_Observed = Input_date
   AND s.SectorID IN (SELECT DISTINCT e.SectorID FROM SECTOR AS e WHERE e.GICS_Sector = Input_Sector)
ORDER BY d.dayreturn DESC
LIMIT 5;
END;
//

DROP PROCEDURE IF EXISTS RecommendFund;//
CREATE PROCEDURE RecommendFund(IN Input_Type VARCHAR(20))
IF Input_Type IN (SELECT DISTINCT Type_Name FROM FUND) THEN
  SELECT *
  FROM FUND
  WHERE Type_Name = Input_Type
  ORDER BY YTD DESC
  LIMIT 1;
END IF;
//

CALL RecommendFund('Equity')//

CALL BestSecurityInSector('Energy','2016-9-19') //
CALL INDICEINFORMATION('Nikkei 225','2016-10-08','2018-12-19');//
SELECT * FROM INDICE;//
SELECT * FROM INDICE_VALUE ;// 
SELECT DISTINCT(IndiceID) FROM INDICE_VALUE ;// 
SELECT DISTINCT(Indice) FROM INDICE;//
