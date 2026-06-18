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
    descripcion VARCHAR(50) --Acá pondríamos 'menores de 25 años',etc
);

CREATE TABLE BI_DimTemporada (
    id_Temporada INT PRIMARY KEY,
    descripcion VARCHAR(50) --Acá pondríamos 'Otoño','Invierno','Primavera','Verano'
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
    id_hecho_venta INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
    id_canal_venta INT REFERENCES BI_DimCanalVenta(id_Canal_Venta),
    id_rango_etario_cliente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    id_tipo_servicio INT REFERENCES BI_DimTipoServicio(id_Tipo_Servicio),
    importe_total_venta DECIMAL(18,2)
);

CREATE TABLE BI_Hecho_Solicitud(
    id_hecho_solicitud INT IDENTITY(1,1) PRIMARY KEY,
    id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
    id_temporada INT REFERENCES BI_DimTemporada(id_Temporada),
    id_rango_etario_cliente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    dias_anticipacion INT
);

CREATE TABLE BI_Hecho_Propuesta(
    id_hecho_propuesta INT IDENTITY(1,1) PRIMARY KEY,
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

INSERT INTO BI_DimTiempo VALUES ();
INSERT INTO BI_DimRangoEtario VALUES ("Menores de 25 años"), ("Entre 25 y 35 anios"), ("Entre 35 y 50 anios"), ("Mayores de 50 anios");
INSERT INTO BI_DimTemporada VALUES ("Verano"), ("Otonio"), ("Invierno"), ("Primavera");
INSERT INTO BI_DimTipoSerivicio VALUES ("Venta Directa"), ("Propuesta a Medida");
INSERT INTO BI_DimCanalVenta VALUES ("Telefono"), ("Whatsapp"), ("Mail"), ("Presencial");
INSERT INTO BI_DimEstado VALUES ("Aceptado"), ("Rechazado");
INSERT INTO BI_DimAspecto VALUES ("Claridad de informacion"), ("Efectividad"), ("Rapidez de respuesta"), ("Atencion del agente"), ("Satisfaccion general");

INSERT INTO BI_Hecho_Evaluacion VALUES ();
INSERT INTO BI_Hecho_Propuesta VALUES ();
INSERT INTO BI_Hecho_Solicitud VALUES ();
INSERT INTO BI_Hecho_Venta VALUES ();

SELECT DISTINCT YEAR(fecha_nacimiento) AS Anio, MONTH(fecha_nacimiento) AS Mes FROM PLATENSE.Cliente
UNION
SELECT DISTINCT YEAR(fecha_nacimiento) AS Anio, MONTH(fecha_nacimiento) AS Mes FROM PLATENSE.Agente


--------------------VIEWS--------------------
CREATE VIEW BI_Ticket_Promedio AS
SELECT T.a
FROM BI_Hecho_Venta V JOIN BI_DimTiempo T ON

CREATE VIEW BI_Distribución_Facturación AS

CREATE VIEW BI_Ranking_Solicitudes_Por_Temporadas AS

CREATE VIEW BI_Anticipación_Promedio_Solicitudes AS

CREATE VIEW BI_Tasa_Aceptación_Propuestas AS

CREATE VIEW BI_Cotización_Promedio_Por_Temporada AS

CREATE VIEW BI_Tiempo_Promedio_Respuesta AS

CREATE VIEW BI_Desvío_Presupuesto AS

CREATE VIEW BI_Ranking_Aspectos_Valorados AS

CREATE VIEW BI_Satisfacción_Promedio_Por_Agente AS