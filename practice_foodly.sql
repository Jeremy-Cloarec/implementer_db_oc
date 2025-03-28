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
SELECT UPPER(utilisateur.nom) as "NOM", langue.nom AS "LANGUE"
FROM utilisateur
    JOIN langue ON utilisateur.langue_id = langue.id
WHERE
    langue.id = 1;

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
FROM
    utilisateur
    JOIN utilisateur_aliment ON (
        utilisateur.id = utilisateur_aliment.utilisateur_id
    )
    JOIN aliment ON (
        aliment.id = utilisateur_aliment.aliment_id
    );

-- Voir tous les aliments sélectionnés par les utilisateurs dont adress email est une adress gmail

SELECT *
FROM
    utilisateur
    JOIN utilisateur_aliment ON (
        utilisateur.id = utilisateur_aliment.utilisateur_id
    )
    JOIN aliment ON (
        aliment.id = utilisateur_aliment.aliment_id
    )
WHERE
    utilisateur.email LIKE "%gmail%";

-- ALTER
-- ADD ajouter une colonne
ALTER TABLE aliment ADD vitamines_c FLOAT;

ALTER TABLE langue ADD iso_langue VARCHAR(100);

UPDATE langue SET iso_langue = "fr-FR" WHERE id = 1;

UPDATE langue SET iso_langue = "en-US" WHERE id = 2;

--DROP
-- Supprimer une colonne
ALTER TABLE aliment DROP bio;

ALTER TABLE utilisateur DROP nom;

--MODIFY modifier un champ existant
ALTER TABLE aliment MODIFY calories FLOAT;

ALTER TABLE utilisateur MODIFY email VARCHAR(500);

--CHANGE renommer un champ
-- Pour renommer une colonne il faut aussi indiquer son type
ALTER TABLE aliment CHANGE sucre sucres FLOAT;

ALTER TABLE langue CHANGE iso_langue code_pays VARCHAR(100);

-- Ajouter une relation un à plusieurs
CREATE TABLE famille (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL
);

TRUNCATE famille;

INSERT INTO
    famille (nom)
VALUES ('légumes'),
    ('fruits'),
    ('viande'),
    ('poisson'),
    ('féuclent'),
    ('produits laitier');

SHOW COLUMNS FROM famille;

SELECT * FROM famille;

-- Dans le cadre d'une relation de 1 à plusieurs c'est l'objet qui se trouve du côté plusieurs de la relation qui va être modifié

-- 1/ Ajout du champ famille_id sur les aliments
ALTER TABLE aliment ADD famille_id INT NULL;

-- 2/ Modification de ce champ pour signaler à MySQL que c'est une référence à la table famille
ALTER TABLE aliment
ADD FOREIGN KEY (famille_id) REFERENCES famille (id) ON DELETE CASCADE;

-- ON DELETE
-- RESTRICT ou NO ACTION : MySQL va empêcher la suppression tant que "légume" est référencé sur sur au moins un objet aliment

-- SET NULL : MySQL va autoriser  la suppression de "légumes"  et remplacer "famille_id" par valuer NULL

-- CASCADE : MySQL va supprimer "poire" et "pomme" en même tant que "légume"

-- 3/ Modification d'un objet pour y stocker une relation
UPDATE aliment SET famille_id = 1 WHERE nom = "haricots verts";

UPDATE aliment
SET
    famille_id = 2
WHERE
    nom = "pomme"
    OR nom = "poire"
    OR nom = "banane"

UPDATE aliment
SET
    famille_id = 3
WHERE
    nom = "jambon"
    OR nom = "steak haché"
    OR nom = "blanc de dinde"
    OR nom = "filet de poulet"
    OR nom = "oeuf"

UPDATE aliment SET famille_id = 4 WHERE nom = "saumon"

UPDATE aliment
SET
    famille_id = 5
WHERE
    nom = "riz"
    OR nom = "pâtes completes"
    OR nom = "baguette";

UPDATE aliment SET famille_id = 6 WHERE nom = "lait d'amande"

SELECT aliment.nom, famille.nom
FROM aliment
    JOIN famille ON aliment.famille_id = famille.id

-- Ajouter les réductions disponibles sur les aliments. Une réduction peut être la même pour plusieurs aliments mais chaque aliment peut n'avoir q'une seule réduction.
-- Champ Valeur qui contient réduction au format texte
CREATE TABLE reduction (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    valeur VARCHAR(100)
)

TRUNCATE reduction;

INSERT INTO reduction (valeur) VALUES ('30'), ('20'), ('15');

ALTER TABLE aliment ADD reduction_id INT NULL;

ALTER TABLE aliment
ADD FOREIGN KEY (reduction_id) REFERENCES reduction (id) ON DELETE CASCADE;

UPDATE aliment
SET
    reduction_id = 1
WHERE
    nom = "muesli"
    OR nom = "oeuf"
    OR nom = "baguette";

UPDATE aliment
SET
    reduction_id = 2
WHERE
    nom = "banane"
    OR nom = "jambon"
    OR nom = "saumon";

SELECT aliment.nom, reduction.valeur
FROM aliment
    JOIN reduction ON aliment.reduction_id = reduction.id;

-- Ajouter une relation plusieurs à plusieurs
-- Lieux de ventes: un lieu peut vendre plusieurs aliments, les aliments peuvent être vedu dans plusieurs lieux
-- 1/ Créer une table lieu
CREATE TABLE lieu (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    type VARCHAR(100) NOT NULL
);

-- 2/ Remplir la table
INSERT INTO
    lieu (nom, type)
VALUES (
        'Carrefour City',
        "Supermarché"
    );

-- 3/ Créer table liaison
CREATE TABLE aliment_lieu (
    aliment_id INT NOT NULL,
    lieu_id INT NOT NULL,
    FOREIGN KEY (aliment_id) REFERENCES aliment (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (lieu_id) REFERENCES lieu (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (aliment_id, lieu_id)
);

-- 4/ Remplir la table liaison
INSERT INTO aliment_lieu (aliment_id, lieu_id) VALUES ('11', '1');

INSERT INTO aliment_lieu (aliment_id, lieu_id) VALUES ('12', '1');
-- 5/ Tester des requêtes
SELECT *
FROM
    aliment
    JOIN aliment_lieu ON aliment.id = aliment_lieu.aliment_id
    JOIN lieu ON lieu.id = aliment_lieu.lieu_id;

-- Un utilisateur peut utiliser Foodly sur plusieurs appareils et un même appareil peut-être commun à plusieurs utilisateurs
CREATE TABLE device (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(100) NOT NULL
);

INSERT INTO
    device (type)
VALUES ("Desktop"),
    ("Mobile"),
    ("Tablette");

CREATE TABLE utilisateur_device (
    utilisateur_id INT NOT NULL,
    device_id INT NOT NULL,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateur (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (device_id) REFERENCES device (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    PRIMARY KEY (utilisateur_id, device_id)
);

INSERT utilisateur_device (utilisateur_id, device_id) VALUE ('1','2'), ('1', '1'), ('2', '3');

SELECT * FROM utilisateur 
JOIN utilisateur_device ON utilisateur.id = utilisateur_device.utilisateur_id
JOIN device ON device.id = utilisateur_device.device_id;