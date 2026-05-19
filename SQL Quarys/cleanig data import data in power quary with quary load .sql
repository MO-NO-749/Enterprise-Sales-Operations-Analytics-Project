-- Cleaning customers table and adding column using load in power quary in quary 

SELECT *,CASE WHEN AGE >= 60 THEN 'Above-60'
            WHEN AGE BETWEEN 30 AND 59 THEN '30-59'
            WHEN AGE BETWEEN 18 AND 29 THEN '18-29'
            WHEN AGE < 18 then 'Below-18'
            END AS Age_Division 
           FROM  (SELECT c.[CustomerID]
                         ,c.[CustomerGender]
                         ,c.[CustomerName]
                         ,c.[CustomerCity]
                         ,c.[CustomerStateCode]
                         ,c.[CustomerState]
                         ,c.[CustomerZip]
                         ,c.[CustomerCountry]
                         ,c.[CustomerContinent]
                         ,c.[CustomerDOB]
                         ,DATEDIFF(YEAR,c.CustomerDOB,MAX(o.OrderDate)) AS AGE
                            FROM Customers c LEFT JOIN Orders o ON o.CustomerID = c.CustomerID
                             GROUP BY c.[CustomerID]
                                     ,c.[CustomerGender]
                                     ,c.[CustomerName]
                                     ,c.[CustomerCity]
                                     ,c.[CustomerStateCode]
                                     ,c.[CustomerState]
                                     ,c.[CustomerZip]
                                     ,c.[CustomerCountry]
                                     ,c.[CustomerContinent]
                                     ,c.[CustomerDOB]
                 ) g
