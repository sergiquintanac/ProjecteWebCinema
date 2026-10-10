-- CineReserva
-- Contrasenyes de prova: usuaris = Cine2026! 
-- administradors (ids 1 i 2) = Admin2026!

CREATE DATABASE IF NOT EXISTS `CineReserva`;

USE CineReserva;

CREATE TABLE IF NOT EXISTS genere (
  nom            VARCHAR(50)  PRIMARY KEY,
  classificacio  VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS pelicula (
  imdb_id        VARCHAR(15)  PRIMARY KEY,
  nom            VARCHAR(150) NOT NULL,
  duracio        INT          NOT NULL,      
  sinopsi        TEXT,
  classificacio  VARCHAR(10),                
  url_trailer    VARCHAR(255),
  valoracio      DECIMAL(3,1),               
  any_estrena    INT
);
CREATE TABLE IF NOT EXISTS pelicula_genere (         
  imdb_id        VARCHAR(15) REFERENCES pelicula(imdb_id),
  genere_nom     VARCHAR(50) REFERENCES genere(nom),
  PRIMARY KEY (imdb_id, genere_nom)
);
CREATE TABLE IF NOT EXISTS rol     (nom VARCHAR(50)  PRIMARY KEY);
CREATE TABLE IF NOT EXISTS persona (nom VARCHAR(100) PRIMARY KEY);
CREATE TABLE IF NOT EXISTS participa (                
  imdb_id        VARCHAR(15)  REFERENCES pelicula(imdb_id),
  rol_nom        VARCHAR(50)  REFERENCES rol(nom),
  persona_nom    VARCHAR(100) REFERENCES persona(nom),
  PRIMARY KEY (imdb_id, rol_nom, persona_nom)
);
CREATE TABLE IF NOT EXISTS cinema (nom VARCHAR(100) PRIMARY KEY);
CREATE TABLE IF NOT EXISTS sala (
  id             INT PRIMARY KEY,
  num            INT NOT NULL,
  qtt_cadires    INT NOT NULL,
  cinema_nom     VARCHAR(100) NOT NULL REFERENCES cinema(nom),
  UNIQUE (cinema_nom, num)
);
CREATE TABLE IF NOT EXISTS tipus_cadira (nom VARCHAR(50) PRIMARY KEY);
CREATE TABLE IF NOT EXISTS tipus_cadira_sala (
  id                 INT PRIMARY KEY,
  tipus_cadira_nom   VARCHAR(50) NOT NULL REFERENCES tipus_cadira(nom),
  preu               DECIMAL(6,2) NOT NULL    
);
CREATE TABLE IF NOT EXISTS sala_tipus_cadira (       
  sala_id               INT NOT NULL REFERENCES sala(id),
  tipus_cadira_sala_id  INT NOT NULL REFERENCES tipus_cadira_sala(id),
  data_inici            DATE NOT NULL,
  data_final            DATE,                      
  preu                  DECIMAL(6,2) NOT NULL,
  PRIMARY KEY (sala_id, tipus_cadira_sala_id, data_inici)
);
CREATE TABLE IF NOT EXISTS cadira (
  id                    INT PRIMARY KEY,
  sala_id               INT NOT NULL REFERENCES sala(id),
  fila                  INT NOT NULL,
  columna               INT NOT NULL,
  tipus_cadira_sala_id  INT NOT NULL REFERENCES tipus_cadira_sala(id),
  UNIQUE (sala_id, fila, columna)
);
CREATE TABLE IF NOT EXISTS projeccio (
  id             INT PRIMARY KEY,
  imdb_id        VARCHAR(15) NOT NULL REFERENCES pelicula(imdb_id),
  sala_id        INT NOT NULL REFERENCES sala(id),
  data_inici     TIMESTAMP NOT NULL,
  data_fi        TIMESTAMP NOT NULL,
  places_lliures INT NOT NULL,
  UNIQUE (sala_id, data_inici)
);
CREATE TABLE IF NOT EXISTS usuari (
  id               INT PRIMARY KEY,
  nom              VARCHAR(100) NOT NULL,
  correu           VARCHAR(150) NOT NULL UNIQUE,
  es_admin         BOOLEAN NOT NULL,
  hash_passwd      VARCHAR(255) NOT NULL,
  data_activacio   TIMESTAMP,
  token            VARCHAR(64),
  expiracio_token  TIMESTAMP
);
CREATE TABLE IF NOT EXISTS reserva (
  id          INT PRIMARY KEY,
  data_hora   TIMESTAMP NOT NULL,
  preu        DECIMAL(7,2) NOT NULL,
  usuari_id   INT NOT NULL REFERENCES usuari(id)
);
CREATE TABLE IF NOT EXISTS reserva_cadira (
  id            INT PRIMARY KEY,
  reserva_id    INT NOT NULL REFERENCES reserva(id),
  projeccio_id  INT NOT NULL REFERENCES projeccio(id),
  cadira_id     INT NOT NULL REFERENCES cadira(id),
  UNIQUE (projeccio_id, cadira_id)                 
);
CREATE TABLE IF NOT EXISTS valoracio_pelicula (       
  usuari_id  INT NOT NULL REFERENCES usuari(id),
  imdb_id    VARCHAR(15) NOT NULL REFERENCES pelicula(imdb_id),
  data       DATE NOT NULL,
  nota       INT NOT NULL,                         
  PRIMARY KEY (usuari_id, imdb_id, data)
);
CREATE TABLE IF NOT EXISTS valoracio_cinema (         
  usuari_id   INT NOT NULL REFERENCES usuari(id),
  cinema_nom  VARCHAR(100) NOT NULL REFERENCES cinema(nom),
  data        DATE NOT NULL,
  nota        INT NOT NULL,                          
  PRIMARY KEY (usuari_id, cinema_nom, data)
);
