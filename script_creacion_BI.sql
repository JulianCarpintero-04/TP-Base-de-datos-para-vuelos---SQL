DROP TABLE IF EXISTS BI_DimTiempo;
DROP TABLE IF EXISTS BI_DimRangoEtario;
DROP TABLE IF EXISTS BI_DimTemporada;
DROP TABLE IF EXISTS BI_DimTipoSerivicio;
DROP TABLE IF EXISTS BI_DimCanalVenta;
DROP TABLE IF EXISTS BI_DimEstado;
DROP TABLE IF EXISTS BI_DimAspecto;
DROP TABLE IF EXISTS BI_Hecho_Venta;
DROP TABLE IF EXISTS BI_Hecho_Propuesta;
DROP TABLE IF EXISTS BI_Hecho_Solicitud;
DROP TABLE IF EXISTS BI_Hecho_Evaluacion;

CREATE TABLE BI_DimTiempo (
    id_Tiempo INT IDENTITY PRIMARY KEY,
    anio INT,
    cuatrimestre INT,
    mes INT
);

CREATE TABLE BI_DimRangoEtario (
    id_Rango_Etario INT PRIMARY KEY,
    anio_inicio INT,
    anio_final INT
);

CREATE TABLE BI_DimTemporada (
    id_Temporada INT PRIMARY KEY,
    mes_inicio INT,
    mes_final INT
);

CREATE TABLE BI_DimTipoServicio (
    id_Tipo_Servicio INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_DimCanalVenta (
    id_Canal_Venta INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_DimEstado (
    id_Estado_Propuesta INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_DimAspecto (
    id_Aspecto INT PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_Hecho_Venta(
    UniqueID INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
    id_canal_venta INT REFERENCES BI_DimCanalVenta(id_Canal_Venta),
    id_rango_etario_cliente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    id_tipo_servicio INT REFERENCES BI_DimTipoServicio(id_Tipo_Servicio),
    precio_venta DECIMAL(18,2)
);

CREATE TABLE BI_Hecho_Solicitud(
    UniqueID INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
    id_temporada INT REFERENCES BI_DimTemporada(id_Temporada),
    id_rango_etario_cliente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    dias_anticipacion INT
);

CREATE TABLE BI_Hecho_Propuesta(
    UniqueID INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
    id_estado INT REFERENCES BI_DimEstadoPropuesta(id_Estado_Propuesta),
    id_temporada INT REFERENCES BI_DimTemporada(id_Temporada),
    id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    importe DECIMAL(18,2),
    dias_transcurridos_emision INT,
    desvio_precio DECIMAL(18,2)
);

CREATE TABLE BI_Hecho_Evaluacion(
  id_hecho_encuesta INT PRIMARY KEY,
  id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
  id_aspecto INT REFERENCES BI_DimAspecto(id_Aspecto),
  id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
  puntaje INT
);


