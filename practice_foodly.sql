SHOW DATABASES;
USE foodly;
SELECT * FROM aliment;
SELECT * FROM utilisateur;
SELECT * FROM langue;
SELECT * FROM utilisateur_aliment;
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
Chaque utilisateur est relié à une langue. Et chaque langue peut être reliée à plusieurs utilisateurs
*/

-- JOIN
SELECT *
FROM utilisateur
    JOIN langue ON utilisateur.langue_id = langue.id;

SELECT *
FROM utilisateur
    JOIN langue ON utilisateur.langue_id = langue_id
WHERE (
        utilisateur.email LIKE "%gmail.com"
    )
    AND (langue_id = 1);

SELECT utilisateur.id, UPPER(utilisateur.nom) AS "NOM", utilisateur.prenom, utilisateur.email, langue.nom AS "LANGUE"
FROM utilisateur
    JOIN langue ON utilisateur.langue_id = langue.id
WHERE (
        utilisateur.email LIKE "%gmail%"
    )
    AND (langue.id = 1)
    ORDER BY utilisateur.id DESC;

-- Nom de famille de tous les utilisateurs ayant sélectionné le français
SELECT UPPER(utilisateur.nom) as "NOM", langue.nom AS "LANGUE"  FROM utilisateur
JOIN langue ON utilisateur.langue_id = langue.id
WHERE langue.id = 1;

/** Relations de plusieurs à plusieurs
Stocker tous les aliments qui ont été scanné par un utilisateur
=> un même utilisateur peut stocker plusieurs aliments scannés
=> un aliment peut être scanné par plusieurs utilisateurs 

Relation many to many. Mais SQL ne sait que stocker une valeur par champs. 
Table utilisateur_aliment = sert à stocker des relations entre un utilisateur et un aliment
Convention : {table1}_{table2}
 */

-- Commande pour relier tous les utilisateurs aux aliments qu'ils ont scannés
SELECT *
FROM utilisateur
JOIN utilisateur_aliment ON (utilisateur.id = utilisateur_aliment.utilisateur_id )
JOIN aliment ON (aliment.id = utilisateur_aliment.aliment_id); 

-- Voir tous les aliments sélectionnés par les utilisateurs dont adress email est une adress gmail

SELECT *
FROM utilisateur
JOIN utilisateur_aliment ON (utilisateur.id = utilisateur_aliment.utilisateur_id)
JOIN aliment ON (aliment.id = utilisateur_aliment.aliment_id)
WHERE utilisateur.email LIKE "%gmail%";