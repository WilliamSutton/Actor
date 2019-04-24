SELECT * FROM sakila.actor;

# 1a Display the first and last name of all actors from the table 'actor'

SELECT first_name , last_name 
FROM actor;

# 1b Display the first name and last name of each actor in a single column in upper case letters. Name the column 'Actor N ame'

Select UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name'

# 2a You need to find the ID number, first name, and last name of     
-- 		an actor, of whom you know only the first name, "Joe." What is 
--      one query would you use to obtain this information?

SELECT 


