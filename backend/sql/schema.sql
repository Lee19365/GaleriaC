-- ============================
-- Tabla: usuarios
-- ============================
DROP TABLE IF EXISTS usuarios CASCADE;

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    username VARCHAR(20) NOT NULL UNIQUE,
    password_hash VARCHAR(60) NOT NULL,
    name VARCHAR(20),
    birthday DATE,
    description VARCHAR(200),
    photo VARCHAR(300),
    created_at TIMESTAMP DEFAULT NOW()
);
-- ============================
-- Tabla: publicaciones
-- ============================
DROP TABLE IF EXISTS publicaciones CASCADE;
CREATE TABLE publicaciones (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    contents TEXT,
    images VARCHAR(150),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);


-- ============================
-- Tabla: follows
-- ============================
DROP TABLE IF EXISTS follows CASCADE;
CREATE TABLE follows (
    seguidor_id INTEGER REFERENCES usuarios(id),
    seguido_id INTEGER REFERENCES usuarios(id),
    CHECK (seguidor_id != seguido_id),
    created_at TIMESTAMP,
    PRIMARY KEY (seguidor_id, seguido_id)
);

-- ============================
-- Tabla: likes
-- ============================
DROP TABLE IF EXISTS likes CASCADE;

CREATE TABLE likes (
    usuario_id INTEGER REFERENCES usuarios(id),
    publicacion_id INTEGER REFERENCES publicaciones(id),
    created_at TIMESTAMP DEFAULT NOW(),
    PRIMARY KEY (usuario_id, publicacion_id)
);


-- ============================
-- Tabla: favoritos
-- ============================
DROP TABLE IF EXISTS favoritos CASCADE;
CREATE TABLE favoritos (
    usuario_id INTEGER REFERENCES usuarios(id),
    publicacion_id INTEGER REFERENCES publicaciones(id),
    created_at TIMESTAMP,
    PRIMARY KEY (usuario_id, publicacion_id)
);


-- ============================
-- Tabla: comentarios
-- ============================
DROP TABLE IF EXISTS comentarios CASCADE;
CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    usuario_id INTEGER REFERENCES usuarios(id) ON DELETE CASCADE,
    publicacion_id INTEGER REFERENCES publicaciones(id) ON DELETE CASCADE,
    content VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW()
);

