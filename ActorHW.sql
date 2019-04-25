SELECT * FROM sakila.actor;

# 1a Display the first and last name of all actors from the table 'actor'

SELECT first_name , last_name 
FROM actor;

# 1b Display the first name and last name of each actor in a single column in upper case letters. Name the column 'Actor N ame'
 
Select UPPER(CONCAT(first_name,' ', last_name)) AS 'Actor Name'
From actor;

# 2a You need to find the ID number, first name, and last name of     
-- 		an actor, of whom you know only the first name, "Joe." What is 
--      one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
Where first_name = "Joe";

# 2b Find actors name that contain the letters "GEN'

Select last_name, first_name
FROM actor
WHERE last_name LIKE "%GEN%";

# 2c Find actors name nthat contain the letters "LI". Rows in oder last name and first name.alter

Select last_name, first_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name;

# 2d Using IN display the 'country_id' and 'country_columns' of the following countries: Afghanistan, Bangledesh and China.

SELECT country_id, country
FROM country
WHERE country in
('Afghanistin', 'Bangladesh', 'China');

# 3a Add a `middle_name` column to the table `actor`. Position it between `first_name` and `last_name`. Hint: you will need to specify the data type.

ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(25) AFTER first_name;

# 3b You realize that some of these actors have tremendously long middle names. Change the data type of the `middle_name` column to `blobs`.


ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

# 3c Delete the 'middle_name' column

ALTER TABLE actor
DROP COLUMN middle_name;

# 4a List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name;

# 4b List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors.

SELECT last_name, COUNT(*) AS 'Number of Actors' 
FROM actor GROUP BY last_name HAVING count(*) >=2;

# 4c The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, the name of Harpo's second cousin's husband's  yoga teacher. Write a query to fix the record.

UPDATE actor 
SET first_name = 'HARPO'
WHERE First_name = "Groucho" AND last_name = "Williams";

# 4d Change name

UPDATE actor 
SET first_name = 'GROUCHO'
WHERE actor_id = 172;

# 5a You cannot locate the schema of the `address` table.

Describe sakila.address;

# 6a Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT first_name, last_name, address
FROM staff s 
JOIN address a
ON s.address_id = a.address_id;

# 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. 

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff INNER JOIN payment ON
staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%'; 

# 6c List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT f.title AS 'Film Title', COUNT(fa.actor_id) AS `Number of Actors`
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.title;

# 6d How many copies of film

SELECT title, (
SELECT COUNT(*) FROM inventory
WHERE film.film_id = inventory.film_id
) AS 'Number of Copies'
FROM film
WHERE title = "Hunchback Impossible";

# 6e List customers alphabetically by lsat name.

SELECT c.first_name, c.last_name, sum(p.amount) AS `Total Paid`
FROM customer c
JOIN payment p 
ON c.customer_id= p.customer_id
GROUP BY c.last_name;

# 7a Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. 

SELECT title
FROM film WHERE title 
LIKE 'K%' OR title LIKE 'Q%'
AND title IN 
(
SELECT title 
FROM film 
WHERE language_id = 1
);

# 7b Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name
FROM actor
WHERE actor_id in
(
SELECT actor_id
FROM film_actor
WHERE film_id IN
(
SELECT film_id
FROM film
WHERE title = 'Alone Trip'
));

# 7c Use joins to retrieve this information.

SELECT cus.first_name, cus.last_name, cus.email 
FROM customer cus
JOIN address a 
ON (cus.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id)
WHERE country.country= 'Canada';

# 7d Identify all movies categorized as famiy films.

SELECT title, description FROM film 
WHERE film_id IN
(
SELECT film_id FROM film_category
WHERE category_id IN
(
SELECT category_id FROM category
WHERE name = "Family"
));

# 7e Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(rental_id) AS 'Times Rented'
FROM rental r
JOIN inventory i
ON (r.inventory_id = i.inventory_id)
JOIN film f
ON (i.film_id = f.film_id)
GROUP BY f.title
ORDER BY `Times Rented` DESC;

# 7f Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(amount) AS 'Revenue'
FROM payment p
JOIN rental r
ON (p.rental_id = r.rental_id)
JOIN inventory i
ON (i.inventory_id = r.inventory_id)
JOIN store s
ON (s.store_id = i.store_id)
GROUP BY s.store_id; 

# 7g Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, cty.city, country.country 
FROM store s
JOIN address a 
ON (s.address_id = a.address_id)
JOIN city cty
ON (cty.city_id = a.city_id)
JOIN country
ON (country.country_id = cty.country_id);

# 7h List the top five genres in gross revenue in descending order. 

SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

# 8a Top five genres by gross revenue.

CREATE VIEW genre_revenue AS
SELECT c.name AS 'Genre', SUM(p.amount) AS 'Gross' 
FROM category c
JOIN film_category fc 
ON (c.category_id=fc.category_id)
JOIN inventory i 
ON (fc.film_id=i.film_id)
JOIN rental r 
ON (i.inventory_id=r.inventory_id)
JOIN payment p 
ON (r.rental_id=p.rental_id)
GROUP BY c.name ORDER BY Gross  LIMIT 5;

# 8b  How would you display the view that you created in 8a?

SELECT * FROM genre_revenue;

# 8c You find that you no longer need the view `top_five_genres`.  Write a query to delete it.

DROP VIEW genre_revenue;








