-- Données entièrement fictives pour SRV-DATA
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50),
    ville VARCHAR(50),
    email VARCHAR(100)
);

INSERT INTO clients (nom, ville, email) VALUES
    ('Client Test 1', 'Ville Fictive', 'client1@exemple.test'),
    ('Client Test 2', 'Ville Fictive', 'client2@exemple.test'),
    ('Client Test 3', 'Ville Fictive', 'client3@exemple.test');
