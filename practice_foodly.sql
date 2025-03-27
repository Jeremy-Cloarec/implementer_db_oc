SHOW DATABASES;

USE foodly;

SELECT * FROM aliment;

SELECT * FROM utilisateur;

SELECT nom FROM utilisateur;

SHOW COLUMNS FROM aliment;

SHOW TABLES;

-- SHOW COLUMNS FROM utilisateur;
INSERT INTO
    utilisateur (email, nom, prenom)
VALUES (
        'test@gmail.com',
        'DOE',
        'John'
    );

INSERT INTO
    aliment (
        nom,
        marque,
        calories,
        sucre,
        graisses,
        proteines,
        bio
    )
VALUES (
        "haricots vert",
        "Monoprix",
        25,
        3,
        0,
        1.7,
        FALSE
    );

UPDATE utilisateur SET email = 'bb@gmail.com' WHERE nom = 'DOE';

UPDATE aliment SET marque = "ALDI" WHERE id = 21;

DELETE FROM utilisateur WHERE nom = 'DOE';

-- LIKE
SELECT * FROM aliment WHERE nom LIKE "%re";

-- ORDER
SELECT * FROM aliment ORDER BY calories DESC;

-- COUNT & DISTINCT & AS
SELECT COUNT(*) FROM utilisateur WHERE email LIKE "%gmail.com";

SELECT COUNT(*) FROM aliment WHERE marque LIKE "%sans marque%";

SELECT COUNT(DISTINCT marque)
FROM aliment
WHERE
    marque LIKE "%sans marque%";

SELECT COUNT(DISTINCT nom) AS "Haricot vert"
FROM aliment
WHERE
    nom = "haricots verts";

-- Fonctions en SQL
-- AVG, SUM, MAX, MIN, ROUND
SELECT ROUND(AVG(sucre)) AS "Moyenne du taux de sucre" FROM aliment;

SELECT SUM(sucre) AS "Somme du taux de sucre" FROM aliment;

SELECT MAX(sucre) AS "Maximum du taux de sucre" FROM aliment;

SELECT MIN(sucre) AS "Minimum du taux de sucre" FROM aliment;

-- Créer une vue, permet de créer des tables temporaires
CREATE VIEW utilisateurs_gmail_vw AS (
    SELECT *
    FROM utilisateur
    WHERE
        email LIKE "%gmail.com"
)

DROP VIEW utilisateurs_gmail_vw;

-- Utiliser la vue
SELECT * FROM utilisateurs_gmail_vw;

-- Créer vue avec liste aliments non bio, classée par contenance en protéine (décroissante)
CREATE VIEW non_bio_aliments_vw AS (
    SELECT *
    FROM aliment
    WHERE
        bio = 0
    ORDER BY proteines DESC
)

DROP VIEW non_bio_aliments_vw;

SELECT * FROM non_bio_aliments_vw;

-- Relation de plusieurs à plusieurs doit passer par une table de liaision
-- Un utiisateur peut scanner plusieus aliments et un aliment peut être scanné par plusieurs utilisateurs

/**Relation un à plusieurs
* 
*  
* 
* */