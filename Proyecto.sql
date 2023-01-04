-- Creación de Table Spaces

CREATE TABLESPACE DATA1
DATAFILE 'C:\data1.dbf' SIZE 10M;

CREATE TABLESPACE DATA2
DATAFILE 'C:\data2.dbf' SIZE 10M;

CREATE TABLESPACE DATA3
DATAFILE 'C:\data3.dbf' SIZE 10M;

-- Creación del Usuario para el proyecto

CREATE USER proyecto_admin 
IDENTIFIED BY proyecto123
DEFAULT TABLESPACE DATA1;

CREATE USER proyecto_user 
IDENTIFIED BY proyecto123
DEFAULT TABLESPACE DATA1;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW TO proyecto_admin;
GRANT CREATE SESSION TO proyecto_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON FUNCION TO PROYECTO_ADMIN



-- Creación Tablas

CREATE TABLE IDIOMA(
    id_idioma number primary key,
    nombre_idioma varchar2(20) not null
);

CREATE TABLE FORMATO_PELICULA(
    id_formato number primary key,
    tipo_formato varchar2(20) not null
);

CREATE TABLE CINE(
    id_cine number primary key,
    nombre_cine varchar2(50) not null,
    direccion_cine varchar2(100) not null
);

CREATE TABLE CLASIFICACION(
    id_clasificacion number primary key,
    tipo_clasificacion varchar2(10) not null
);

CREATE TABLE GENERO(
    id_genero number primary key,
    nombre_genero varchar2(30) not null
);

CREATE TABLE PELICULA(
    id_pelicula number primary key,
    sinopsis varchar2(500) not null,
    portada_pelicula blob not null,
    ruta_pelicula varchar2(100) not null,
    avance_pelicula blob not null,
    ruta_avance_pelicula varchar2(100) not null,
    duracion number not null,
    nombre_pelicula varchar2(100) not null,
    id_genero number foreign key references GENERO(id_genero)
    id_clasificacion number foreign key references CLASIFICACION(id_clasificacion)
)
-- Creación de Particionamiento
PARTITION BY HASH(id_pelicula)
PARTITIONS 5;

CREATE TABLE FUNCION(
    id_funcion number primary key,
    horario datetime not null,
    subtitulado boolean not null,
    id_pelicula number foreign key references PELICULA(id_pelicula),
    id_idioma number foreign key references IDIOMA(id_idioma),
    id_cine number foreign key references CINE(id_cine),
    id_formato number foreign key references FORMATO_PELICULA(id_formato)
);
-- Creación Tabla Dinámica

-- Llenado de tablas

-- Insert...

-- Creación de Cluster

CREATE CLUSTER proyecto_admin.project_clu (id_funcion number)
size 10M
tablespace data1;

CREATE TABLE proyecto_admin.funcion_respaldo
CLUSTER proyecto_admin.project_clu(id_funcion)
as select * from proyecto_admin.FUNCION;