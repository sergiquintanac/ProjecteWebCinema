CREATE DATABASE IF NOT EXISTS `CineReserva`;
USE CineReserva;
-- Entitats --
/* [Usuari]: 
{id (PK), nom, email, esAdmin, hashPassword, dataActivacio (N), token (N), expiracioToken (N)}*/
CREATE TABLE IF NOT EXISTS Usuari (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(64) NOT NULL,
    email VARCHAR(255) NOT NULL,
	esAdmin BOOL NOT NULL,
    hashPassword VARCHAR(255) NOT NULL,
    dataActivacio TIME,
    token VARCHAR(255),
    expiracioToken TIME,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

    UNIQUE KEY uq_email_active (email, active_key)
);

/* [Genere]:
{nom (PK), edatClassificacio}*/
CREATE TABLE IF NOT EXISTS Genere (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(32) NOT NULL,
    edatClassificacio ENUM ("","7", "12", "16", "18"),
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

    UNIQUE KEY uq_nom_active (nom, active_key)
);

/* [Pelicula]:
{imdbID (PK), nom, duracioMin, anyCreacio, sinopsi, urlTrailer, valoracio (C), classificacio (C)}*/
CREATE TABLE IF NOT EXISTS Pelicula (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	imdbID VARCHAR(255) NOT NULL,
    nom VARCHAR(255) NOT NULL,
    duracioMin SMALLINT NOT NULL,
    anyEstrena YEAR NOT NULL,
    sinopsi TEXT NOT NULL,
    urlTrailer VARCHAR(255) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_nom_active (nom, active_key)
);

/* [TipusCadira]:
{nom (PK)}*/
CREATE TABLE IF NOT EXISTS TipusCadira (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(16) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_nom_active (nom, active_key)
);

/* [Rol]:
{nom (PK)}*/
CREATE TABLE IF NOT EXISTS Rol (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(16) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_nom_active (nom, active_key)
);

/* [Persona]:
{nom (PK)}*/
CREATE TABLE IF NOT EXISTS Persona (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nomComplet VARCHAR(64) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_nomComplet_active (nomComplet, active_key)
);

/* [Cinema]:
{nom (PK)}*/
CREATE TABLE IF NOT EXISTS Cinema (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	nom VARCHAR(32) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_nom_active (nom, active_key)
);

-- 1:N
/* [TipusCadira] <Conté> [<TipusCadiraSala>]:
{nomTipusCadira(FK), preu}*/
CREATE TABLE IF NOT EXISTS TipusCadiraSala (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idTipusCadira BIGINT UNSIGNED NOT NULL,
    preu DECIMAL(8,2) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_tipuscadira_active (idTipusCadira, active_key),
    
    CONSTRAINT fk_tcs_tipuscadira FOREIGN KEY (idTipusCadira) REFERENCES TipusCadira(id)
);

/* [Sala]:
{id(PK), idCinema(FK), num, qttCadires}*/
CREATE TABLE IF NOT EXISTS Sala (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	idCinema BIGINT UNSIGNED NOT NULL,
    num TINYINT UNSIGNED NOT NULL,
    qttCadires SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_cinema_sala_active (idCinema, id, active_key),
    
    CONSTRAINT fk_sala_cinema FOREIGN KEY (idCinema) REFERENCES Cinema(id)
);

/* [Cadira]:
{fila(PK), columna(PK), idSala(PK,FK)}*/
CREATE TABLE IF NOT EXISTS Cadira (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    fila TINYINT UNSIGNED NOT NULL,
    columna TINYINT UNSIGNED NOT NULL,
    idSala BIGINT UNSIGNED NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,

	UNIQUE KEY uq_sala_cadira_active (idSala, fila, columna, active_key),
    
    CONSTRAINT fk_cadira_sala FOREIGN KEY (idSala) REFERENCES Sala(id)
);

/* [Reserva]:
{id (PK), idUsuari(FK), dataHora, preu}*/
CREATE TABLE IF NOT EXISTS Reserva (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuari BIGINT UNSIGNED NOT NULL,
    dataHora DATETIME NOT NULL,
    preu DECIMAL(8,2) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
    
    CONSTRAINT fk_reserva_usuari FOREIGN KEY (idUsuari) REFERENCES Usuari(id)
);

-- N:M
/* [Genere] <Té> [Pelicula]:
{}*/
CREATE TABLE IF NOT EXISTS GenerePelicula (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idGenere BIGINT UNSIGNED NOT NULL,
    idPelicula BIGINT UNSIGNED NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_genere_pelicula_active (idGenere, idPelicula, active_key),
    
    CONSTRAINT fk_genere FOREIGN KEY (idGenere) REFERENCES Genere(id),
    CONSTRAINT fk_pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(id)
);

/* [Usuari] <Valora> [Pelicula]:
{data, nota}*/
CREATE TABLE IF NOT EXISTS ValoracioPelicula (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuari BIGINT UNSIGNED NOT NULL,
    idPelicula BIGINT UNSIGNED NOT NULL,
    nota DECIMAL(2,1) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_vp_pelicula_active (idUsuari, idPelicula, active_key),
    
    CONSTRAINT fk_vp_usuari FOREIGN KEY (idUsuari) REFERENCES Usuari(id),
    CONSTRAINT fk_vp_pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(id)
);

/* [Usuari] <Valora> [Cinema]:
{data, nota}*/
CREATE TABLE IF NOT EXISTS ValoracioCinema (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idUsuari BIGINT UNSIGNED NOT NULL,
    idCinema BIGINT UNSIGNED NOT NULL,
    nota DECIMAL(2,1) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_vc_cinema_active (idUsuari, idCinema, active_key),
    
    CONSTRAINT fk_vc_usuari FOREIGN KEY (idUsuari) REFERENCES Usuari(id),
    CONSTRAINT fk_vc_cinema FOREIGN KEY (idCinema) REFERENCES Cinema(id)
);

/* [Pelicula] <Fa> [<Projeccio>] <Utilitza> [Sala]:
{dataInici(PK), idPelicula(PK,FK), idSala(PK,FK), dataFi, placesLliures}*/
CREATE TABLE IF NOT EXISTS Projeccio (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dataInici DATETIME NOT NULL,
    idPelicula BIGINT UNSIGNED NOT NULL,
    idSala BIGINT UNSIGNED NOT NULL,
    dataFi DATETIME NOT NULL,
    placesLliures SMALLINT NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_pelicula_sala_active (idPelicula, idSala, dataInici, active_key),
    
    CONSTRAINT fk_projeccio_pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(id),
    CONSTRAINT fk_projeccio_sala FOREIGN KEY (idSala) REFERENCES Sala(id)
);

/* [<Projeccio>] <Té> [<ReservaCadira>] <Esta> [[Cadira]]:
{id(PK), idProjeccio(PK,FK)}*/
CREATE TABLE IF NOT EXISTS ReservaCadira (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idProjeccio BIGINT UNSIGNED NOT NULL,
    idCadira BIGINT UNSIGNED NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_rc_projeccio_active (idProjeccio, idCadira, active_key),
    
    CONSTRAINT fk_rc_projeccio FOREIGN KEY (idProjeccio) REFERENCES Projeccio(id),
    CONSTRAINT fk_rc_cadira FOREIGN KEY (idCadira) REFERENCES Cadira(id)
);

/* [Sala] <Té> [<TipusCadiraSala>]:
{dataInici(PK), idSala(PK,FK), idTipusCadiraSala(PK,FK), dataFinal, preu}*/
CREATE TABLE IF NOT EXISTS PreuTipusCadiraSala (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dataInici DATETIME NOT NULL,
    idSala BIGINT UNSIGNED NOT NULL,
    idTipusCadiraSala BIGINT UNSIGNED NOT NULL,
    dataFinal DATETIME NOT NULL,
    preu DECIMAL(8,2) NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_preu_tcs_active (idSala, idTipusCadiraSala, dataInici, active_key),
    
    CONSTRAINT fk_ptcs_sala FOREIGN KEY (idSala) REFERENCES Sala(id),
    CONSTRAINT fk_ptcs_tcs FOREIGN KEY (idTipusCadiraSala) REFERENCES TipusCadiraSala(id)
);

-- N:M:P
/* [Rol] <Té> [<RolPersona>] <Fa> [Persona]
[<RolPersona>] <Participa> [Pelicula]:
{idPersona(PK,FK), idRol(PK,FK), idPelicula(PK,FK)}*/
CREATE TABLE IF NOT EXISTS Repartiment (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    idPersona BIGINT UNSIGNED NOT NULL,
    idRol BIGINT UNSIGNED NOT NULL,
    idPelicula BIGINT UNSIGNED NOT NULL,
    
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,
	active_key BOOL
		GENERATED ALWAYS AS (IF(deleted_at IS NULL, TRUE, NULL)) VIRTUAL,
    
    UNIQUE KEY uq_repartiment_active (idPelicula, idPersona, idRol, active_key),
    
    CONSTRAINT fk_repartiment_persona FOREIGN KEY (idPersona) REFERENCES Persona(id),
    CONSTRAINT fk_repartiment_rol FOREIGN KEY (idRol) REFERENCES Rol(id),
    CONSTRAINT fk_repartiment_pelicula FOREIGN KEY (idPelicula) REFERENCES Pelicula(id)
);

