USE moviz;
SHOW TABLES;
SELECT * FROM film;
SELECT * FROM film_pays_de_sortie;
SELECT * FROM note;
SELECT * FROM pays_de_sortie;

-- Uniquement le film Skyfall
SELECT * FROM film WHERE nom LIKE "Skyfall";

-- Budget >= 100 000 000
SELECT * FROM film WHERE budget >= 100000000;

--SYnopsis avec le mot histoire
SELECT * FROM film WHERE synopsis LIKE "%histoire%";

--Combien films
SELECT COUNT(*) FROM film;

--Note < 4
SELECT COUNT(*) FROM film
JOIN note ON film.note_id = note.id
WHERE note.id < 4;

--Association films avec leurs pays de sortie
SELECT * FROM film
JOIN film_pays_de_sortie ON film.id = film_pays_de_sortie.film_id
JOIN pays_de_sortie ON pays_de_sortie.id = film_pays_de_sortie.pays_de_sortie_id;