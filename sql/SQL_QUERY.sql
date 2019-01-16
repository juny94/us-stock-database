USE PROJECT;

#1 
SELECT m.institution
FROM MAIN_HOLDER AS m LEFT JOIN COMPONENT_OF AS c ON m.Symbol = c.Symbol
WHERE IndiceID = 'SPX'
GROUP BY m.institution
HAVING COUNT(DISTINCT m.symbol) >5; 

#2
SELECT r.institution
FROM (SELECT 
             i.institution
     , i.Investment_Weight
     , rank() over (ORDER BY investment_weight DESC) AS weight_rank
   FROM INSTITUTION_SECTOR AS i
      WHERE i.GICS_Sector = 'Healthcare') AS r
WHERE r.weight_rank =1;

#3
SELECT COUNT(DISTINCT a.symbol)
FROM SECURITIES AS a LEFT JOIN SECTOR as b ON a.sectorID = b.sectorID
WHERE CAST(a.founded AS SIGNED) < 2000
   AND b.GICS_sector = 'Information Technology';
      
#4
SELECT DISTINCT s.symbol
FROM SECURITIES AS s INNER JOIN REPORT AS r ON s.CIK = r.CIK
WHERE r.filling_date = '2018-11-1';

#5
SELECT s.symbol
FROM SECURITIES AS s INNER JOIN EXCHANGES as e ON s.exchangeid = e.exchangeid
     INNER JOIN CITY AS c ON c.cityid = s.cityid
WHERE e.exchange_name = 'New York Stock EXCHANGES'
      AND c.country = 'US'
      AND c.state = 'New York'
      AND c.city = 'New York';
	
# 6
SELECT s.Security_Name
              ,(p.Close_Price-p.Open_Price)/p.Open_Price AS dayreturn
FROM PRICE AS p
INNER JOIN SECURITIES AS s ON s.Symbol=p.Symbol
WHERE p.Date_Observed='2016-12-29'
ORDER BY (p.Close_Price-p.Open_Price)/p.Open_Price DESC
LIMIT 1;

# 7
SELECT s.Security_Name
FROM (
             SELECT c.Symbol
                            ,COUNT(c.IndiceID) AS countindice
			 FROM COMPONENT_OF AS c
			 GROUP BY c.Symbol
			 ) AS a
INNER JOIN SECURITIES AS s ON s.Symbol=a.Symbol
WHERE a.countindice >= 2;

# 8
SELECT s.Security_Name
FROM FUNDAMENTAL AS f
INNER JOIN SECURITIES AS s ON s.Symbol=f.Symbol
WHERE f.Liabilities >= f.Assets
AND YEAR(f.Date_Observed)=2016;

# 9
SELECT i.Institution
		      ,i.GICS_Sector
              ,i.Investment_Weight
FROM ( 
              SELECT Institution
			                 ,MAX(Investment_Weight) AS maxweight
              FROM INSTITUTION_SECTOR 
              GROUP BY Institution
			) AS a
INNER JOIN INSTITUTION_SECTOR AS i 
ON i.Institution=a.Institution 
AND a.maxweight=i.Investment_Weight;

# 10
SELECT DISTINCT(r.FileNumber)
FROM REPORT AS r
INNER JOIN SECURITIES AS s ON s.CIK=r.CIK
WHERE s.Security_Name='Apple Inc.'
AND r.Filling_Date>'2018-11-01';

# 11
SELECT S.Symbol AS Symbol, COUNT(*) AS Num_Of_8K_Files
FROM SECURITIES AS S, REPORT AS R
WHERE S.CIK = R.CIK AND S.Symbol = 'AAPL' AND R.Filling = '8-K' AND YEAR(R.filling_date) = 2018;

# 12
SELECT E.Exchange_Name AS 
Exchange_Name, COUNT(*) AS Num_Of_8K_Files
FROM SECURITIES AS S, REPORT AS R, EXCHANGES AS E
WHERE S.CIK = R.CIK 
			  AND E.Exchange_Name= 'New York Stock EXCHANGES' 
			  AND E.ExchangeID = S.ExchangeID
              AND R.Filling = '8-K'
              AND YEAR(R.filling_date) = 2018;

# 13
SELECT *
FROM MAIN_HOLDER AS M
WHERE M.Symbol = 'TWTR'
ORDER BY M.Shares DESC
LIMIT 1;

# 14
SELECT *
FROM MAIN_HOLDER AS M
WHERE M.Institution LIKE  (SELECT CONCAT(F.Institution, '%')
											  FROM FUND AS F
											  WHERE F.Date_Observed = '2018-11-15'
                                              ORDER BY F.YTD DESC
                                               LIMIT 1);

# 15
SELECT *
FROM SECURITIES AS S, MAIN_HOLDER AS M
WHERE S.Symbol = M.Symbol AND 
			  S.Security_Name = (SELECT S.Security_Name
												FROM PRICE AS P, SECURITIES AS S
	                                            WHERE P.Date_Observed='2016-12-29' AND S.Symbol=P.Symbol
											    ORDER BY (P.Close_Price-P.Open_Price)/P.Open_Price DESC
												LIMIT 1)
ORDER BY M.Shares DESC
LIMIT 1;

# 16
SELECT S2.Symbol, F.Assets, F.Liabilities, F.Revenue
FROM SECURITIES AS S1, SECURITIES AS S2, FUNDAMENTAL AS F
WHERE S1.Security_Name = 'PayPal' AND S1.CityID = S2.CityID AND S1.Symbol <> S2.Symbol
               AND F.Symbol = S2.Symbol;
