

-- Volcando estructura para tabla politecnicas.estados
CREATE TABLE  estados (
  cve_estados int(11) NOT NULL,
  nombre varchar(60) default NULL,
  latitud varchar(30) default NULL,
  longitud varchar(30) default NULL,
  es_predeterminado int(11) default NULL,
  abreviatura varchar(20) default NULL,
  cve_regiones int(11) default NULL,
  PRIMARY KEY  (cve_estados)
);

-- Volcando estructura para tabla politecnicas.municipios
CREATE TABLE municipios (
  cve_municipios int(11) NOT NULL,
  cve_estados int(11) NOT NULL,
  nombre varchar(60) default NULL,
  latitud varchar(30) default NULL,
  longitud varchar(30) default NULL,
  es_predeterminado int(11) default NULL,
  abreviatura varchar(20) default NULL,
  PRIMARY KEY  (cve_municipios,cve_estados)
);

CREATE TABLE  planteles (
  cve_planteles int(11) NOT NULL,
  cve_municipios int(11) default NULL,
  cve_estados int(11) default NULL,
  cve_subsistemas int(11) default NULL,
  nombre varchar(120) default NULL,
  direccion varchar(200) default NULL,
  latitud varchar(50) default NULL,
  longitud varchar(50) default NULL,
  nombre_contacto varchar(90) default NULL,
  telefono varchar(120) default NULL,
  email varchar(120) default NULL,
  actualizado int(11) default NULL,
  pagina_web varchar(120) default NULL,
  nombre_corto varchar(200) default NULL,
  logo varchar(100) default NULL,
  nombre_archivo_foto varchar(100) default NULL,
  PRIMARY KEY  (cve_planteles)
);

CREATE TABLE  regiones (
  cve_regiones int(11) default NULL,
  nombre varchar(30) default NULL
);