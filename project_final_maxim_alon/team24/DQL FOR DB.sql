

USE db_team24;


#1 


SELECT  d.w_name,  COUNT(DISTINCT w.day_name) AS number_of_days_in_week , SUM(w.price) AS income_for_2020
FROM dogWalker d JOIN week_day w ON w.w_email LIKE d.w_email  
JOIN trip t ON w.w_email = t.w_email  AND t.t_day = w.day_name
WHERE w_city IN ('haifa' , 'Tel-Aviv')  AND YEAR(t_date) = 2020 
GROUP BY w.w_email;

#2

SELECT d.d_name, d.dogID, dw.w_name  
FROM (SELECT COUNT(*) AS COUNT,t.dogid, t.w_email 
	  FROM trip t 
      WHERE YEAR(t.t_date) = 2020 
      GROUP BY t.dogid, t.w_email) y JOIN dog d ON d.dogid = y.dogid 
									 JOIN dogWalker dw ON dw.w_email = y.w_email 
									 WHERE NOT EXISTS (SELECT z.* FROM 
									(SELECT COUNT(*) AS COUNT,t.dogid, t.w_email  
                                     FROM trip t  
                                     WHERE YEAR(t.t_date) = 2020 
                                     GROUP BY t.dogid, t.w_email) z
                                     WHERE z.dogid = y.dogid AND z.COUNT > y.COUNT) 
                                     GROUP BY y.dogid
									 ORDER BY d.d_name; 



#3

SELECT d.w_name, COUNT(DISTINCT i.w_email) AS total_appearances_in_emailDelivery, COUNT(DISTINCT s.o_email) AS total_recievers 
FROM trip t JOIN inEmail i ON i.w_email = t.w_email AND YEAR(t.t_date) = 2020 
JOIN emailDelivery e ON e.e_id =  i.e_id AND YEAR(e.e_date) = 2020 
JOIN sentTo s ON s.e_id = e.e_id 
JOIN dogWalker d ON d.w_email =  t.w_email 
GROUP BY i.e_id 
HAVING COUNT(DISTINCT i.w_email) > 2
ORDER BY total_recievers DESC;

#4

SELECT b.d_breed, avg(w.price) AS sunday_avg_price, COUNT(t.w_email) AS num_of_active_walkers
FROM breed b JOIN dog d ON d.d_breed = b.d_breed 
JOIN trip t ON t.dogid = d.dogid 
JOIN week_day w ON t.w_email= w.w_email AND t.t_day = w.day_name
WHERE t.t_day = 'sunday' AND YEAR(t.t_date) = 2020 
GROUP BY b.d_breed;

