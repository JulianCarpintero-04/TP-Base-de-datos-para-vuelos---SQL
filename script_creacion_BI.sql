DROP TABLE IF EXISTS BI_Hecho_Venta;
DROP TABLE IF EXISTS BI_Hecho_Propuesta;
DROP TABLE IF EXISTS BI_Hecho_Solicitud;
DROP TABLE IF EXISTS BI_Hecho_Evaluacion;

DROP TABLE IF EXISTS BI_DimTiempo;
DROP TABLE IF EXISTS BI_DimRangoEtario;
DROP TABLE IF EXISTS BI_DimTemporada;
DROP TABLE IF EXISTS BI_DimTipoServicio;
DROP TABLE IF EXISTS BI_DimCanalVenta;
DROP TABLE IF EXISTS BI_DimEstado;
DROP TABLE IF EXISTS BI_DimAspecto;


CREATE TABLE BI_DimTiempo (
    id_Tiempo INT IDENTITY(1,1) PRIMARY KEY,
    anio INT,
    cuatrimestre INT,
    mes INT
);

CREATE TABLE BI_DimRangoEtario (
    id_Rango_Etario INT IDENTITY(1,1) PRIMARY KEY,
    rango_inicio INT,
    rango_fin INT,
    descripcion VARCHAR(50) --Acá pondríamos 'menores de 25 años',etc
);

CREATE TABLE BI_DimTemporada (
    id_Temporada INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) --Acá pondríamos 'Otoño','Invierno','Primavera','Verano'
);

CREATE TABLE BI_DimTipoServicio (
    id_Tipo_Servicio INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) 
);

CREATE TABLE BI_DimCanalVenta (
    id_Canal_Venta INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_DimEstado (
    id_Estado_Propuesta INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50)
);

CREATE TABLE BI_DimAspecto (
    id_Aspecto INT IDENTITY(1,1) PRIMARY KEY,
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
    id_estado INT REFERENCES BI_DimEstado(id_Estado_Propuesta),
    id_temporada INT REFERENCES BI_DimTemporada(id_Temporada),
    id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
    importe DECIMAL(18,2),
    dias_transcurridos_emision INT,
    desvio_precio DECIMAL(18,2)
);

CREATE TABLE BI_Hecho_Evaluacion(
  id_hecho_evaluacion INT IDENTITY(1,1) PRIMARY KEY,
  id_tiempo INT REFERENCES BI_DimTiempo(id_Tiempo),
  id_aspecto INT REFERENCES BI_DimAspecto(id_Aspecto),
  id_rango_etario_agente INT REFERENCES BI_DimRangoEtario(id_Rango_Etario),
  puntaje INT
);


INSERT INTO BI_DimTiempo (anio, cuatrimestre, mes)
SELECT DISTINCT YEAR(fecha_nacimiento), ((MONTH(fecha_nacimiento) - 1) / 4) + 1, MONTH(fecha_nacimiento) FROM PLATENSE.Cliente
UNION
SELECT DISTINCT YEAR(fecha_nacimiento), ((MONTH(fecha_nacimiento) - 1) / 4) + 1, MONTH(fecha_nacimiento) FROM PLATENSE.Agente
UNION
SELECT DISTINCT YEAR(fecha_salida), ((MONTH(fecha_salida) - 1) / 4) + 1, MONTH(fecha_salida) FROM PLATENSE.Vuelo
UNION
SELECT DISTINCT YEAR(fecha_llegada), ((MONTH(fecha_llegada) - 1) / 4) + 1, MONTH(fecha_llegada) FROM PLATENSE.Vuelo
UNION
SELECT DISTINCT YEAR(fecha), ((MONTH(fecha) - 1) / 4) + 1, MONTH(fecha) FROM PLATENSE.Encuesta_Satisfaccion
UNION
SELECT DISTINCT YEAR(fecha_solicitud), ((MONTH(fecha_solicitud) - 1) / 4) + 1, MONTH(fecha_solicitud) FROM PLATENSE.Solicitud_Cotizacion
UNION
SELECT DISTINCT YEAR(fecha_inicio_tentativa), ((MONTH(fecha_inicio_tentativa) - 1) / 4) + 1, MONTH(fecha_inicio_tentativa) FROM PLATENSE.Solicitud_Cotizacion
UNION
SELECT DISTINCT YEAR(fecha_fin_tentativa), ((MONTH(fecha_fin_tentativa) - 1) / 4) + 1, MONTH(fecha_fin_tentativa) FROM PLATENSE.Solicitud_Cotizacion
UNION
SELECT DISTINCT YEAR(fecha_emision), ((MONTH(fecha_emision) - 1) / 4) + 1, MONTH(fecha_emision) FROM PLATENSE.Propuesta_Personalizada
UNION
SELECT DISTINCT YEAR(vigencia), ((MONTH(vigencia) - 1) / 4) + 1, MONTH(vigencia) FROM PLATENSE.Propuesta_Personalizada
UNION
SELECT DISTINCT YEAR(fecha_desde), ((MONTH(fecha_desde) - 1) / 4) + 1, MONTH(fecha_desde) FROM PLATENSE.Propuesta_Personalizada
UNION
SELECT DISTINCT YEAR(fecha_hasta), ((MONTH(fecha_hasta) - 1) / 4) + 1, MONTH(fecha_hasta) FROM PLATENSE.Propuesta_Personalizada
UNION
SELECT DISTINCT YEAR(fecha_Desde), ((MONTH(fecha_Desde) - 1) / 4) + 1, MONTH(fecha_Desde) FROM PLATENSE.Propuesta_hospedaje
UNION
SELECT DISTINCT YEAR(fecha_Hasta), ((MONTH(fecha_Hasta) - 1) / 4) + 1, MONTH(fecha_Hasta) FROM PLATENSE.Propuesta_hospedaje
UNION
SELECT DISTINCT YEAR(fecha), ((MONTH(fecha) - 1) / 4) + 1, MONTH(fecha) FROM PLATENSE.Venta
UNION
SELECT DISTINCT YEAR(fecha_realizacion), ((MONTH(fecha_realizacion) - 1) / 4) + 1, MONTH(fecha_realizacion) FROM PLATENSE.Reserva_Excursion
UNION
SELECT DISTINCT YEAR(fecha_hora_ingreso), ((MONTH(fecha_hora_ingreso) - 1) / 4) + 1, MONTH(fecha_hora_ingreso) FROM PLATENSE.Reserva_Habitacion
UNION
SELECT DISTINCT YEAR(fecha_hora_egreso), ((MONTH(fecha_hora_egreso) - 1) / 4) + 1, MONTH(fecha_hora_egreso) FROM PLATENSE.Reserva_Habitacion
UNION
SELECT DISTINCT YEAR(horario), ((MONTH(horario) - 1) / 4) + 1, MONTH(horario) FROM PLATENSE.Excursion

INSERT INTO BI_DimRangoEtario (rango_inicio, rango_fin, descripcion) 
    VALUES (0, 25, 'Menores de 25 años'), (26, 35, 'Entre 25 y 35 años'), (36, 50, 'Entre 35 y 50 años'), (51, 999, 'Mayores de 50 años');
INSERT INTO BI_DimTemporada (descripcion) 
    VALUES ('Verano'), ('Otoño'), ('Invierno'), ('Primavera');
INSERT INTO BI_DimTipoServicio (descripcion) 
    VALUES ('Venta Directa'), ('Propuesta a Medida');
INSERT INTO BI_DimCanalVenta (descripcion) 
    VALUES ('Telefono'), ('Whatsapp'), ('Mail'), ('Presencial');
INSERT INTO BI_DimEstado (descripcion) 
    VALUES ('Aceptado'), ('Rechazado');
INSERT INTO BI_DimAspecto (descripcion) 
    VALUES ('Claridad de informacion'), ('Efectividad'), ('Rapidez de respuesta'), ('Atencion del agente'), ('Satisfaccion general');




INSERT INTO BI_Hecho_Solicitud (id_tiempo, id_temporada, id_rango_etario_cliente, dias_anticipacion)
SELECT T.id_Tiempo,Temp.id_Temporada,R.id_Rango_Etario,
    DATEDIFF(DAY, S.fecha_solicitud, S.fecha_inicio_tentativa) 
FROM PLATENSE.Solicitud_Cotizacion S JOIN PLATENSE.Cliente C ON S.nro_cliente = C.nro_cliente
                                     JOIN BI_DimTiempo T ON T.anio = YEAR(S.fecha_solicitud) AND T.mes = MONTH(S.fecha_solicitud)
                                     JOIN BI_DimTemporada Temp ON Temp.descripcion = (
                                            CASE 
                                                WHEN MONTH(S.fecha_solicitud) BETWEEN 1 AND 3 THEN 'Verano'
                                                WHEN MONTH(S.fecha_solicitud) BETWEEN 4 AND 6 THEN 'Otoño'
                                                WHEN MONTH(S.fecha_solicitud) BETWEEN 7 AND 9 THEN 'Invierno'
                                                WHEN MONTH(S.fecha_solicitud) BETWEEN 10 AND 12 THEN 'Primavera'
                                            END
                                        )
                                     JOIN BI_DimRangoEtario R ON DATEDIFF(YEAR, C.fecha_nacimiento, S.fecha_solicitud) BETWEEN R.rango_inicio AND R.rango_fin;


INSERT INTO BI_Hecho_Venta (id_tiempo, id_canal_venta, id_rango_etario_cliente,
                            id_rango_etario_agente, id_tipo_servicio, importe_total_venta)
SELECT T.id_Tiempo, CV2.id_Canal_Venta, RC.id_Rango_Etario, RA.id_Rango_Etario, TS.id_Tipo_Servicio, V.importe_total
FROM PLATENSE.Venta V
                                    JOIN PLATENSE.Cliente C ON V.nro_cliente = C.nro_cliente
                                    JOIN PLATENSE.Agente A ON V.nro_agente = A.nro_legajo
                                    JOIN PLATENSE.Canal_venta CV1 ON V.nro_canal_venta = CV1.nro_canal
                                    JOIN BI_DimCanalVenta CV2 ON CV1.nombre = CV2.descripcion
                                    JOIN BI_DimTiempo T ON T.anio = YEAR(V.fecha) AND T.mes = MONTH(V.fecha)
                                    JOIN BI_DimRangoEtario RC ON DATEDIFF(YEAR, C.fecha_nacimiento, V.fecha) BETWEEN RC.rango_inicio AND RC.rango_fin
                                    JOIN BI_DimRangoEtario RA ON DATEDIFF(YEAR, A.fecha_nacimiento, V.fecha) BETWEEN RA.rango_inicio AND RA.rango_fin
                                    JOIN BI_DimTipoServicio TS ON TS.descripcion = (
                                            CASE 
                                                WHEN V.nro_propuesta IS NOT NULL THEN 'Propuesta a Medida'
                                                WHEN V.nro_propuesta IS NULL THEN 'Venta Directa'
                                            END)


INSERT INTO BI_Hecho_Evaluacion (id_tiempo, id_aspecto, id_rango_etario_agente, puntaje)
SELECT T.id_Tiempo, AXE.tipo_aspecto, R.id_Rango_Etario, AXE.puntaje
FROM PLATENSE.Encuesta_Satisfaccion E JOIN PLATENSE.Agente A ON E.nro_agente = A.nro_legajo
                                      JOIN PLATENSE.AspectoXEncuesta AXE ON E.nro_encuesta = AXE.nro_encuesta
                                      JOIN BI_DimTiempo T ON T.anio = YEAR(E.fecha) AND T.mes = MONTH(E.fecha)
                                      JOIN BI_DimRangoEtario R ON DATEDIFF(YEAR, A.fecha_nacimiento, E.fecha) BETWEEN R.rango_inicio AND R.rango_fin



INSERT INTO BI_Hecho_Propuesta (id_tiempo, id_estado, id_temporada, id_rango_etario_agente,
								importe, dias_transcurridos_emision, desvio_precio)
SELECT T.id_Tiempo, P.nro_estado, TEMP.id_Temporada, R.id_Rango_Etario, P.importe_total,
		DATEDIFF(DAY, S.fecha_solicitud, P.fecha_emision), (P.importe_total - S.presupuesto_estimado)
FROM PLATENSE.Propuesta_Personalizada P JOIN PLATENSE.Solicitud_Cotizacion S ON P.nro_solicitud = S.nro_solicitud
										JOIN PLATENSE.Agente A ON P.nro_agente = A.nro_legajo
										JOIN BI_DimTiempo T ON YEAR(P.fecha_emision) = T.anio AND MONTH(P.fecha_emision) = T.mes
										JOIN BI_DimTemporada TEMP ON TEMP.descripcion = 
											CASE 
												WHEN MONTH(P.fecha_desde) BETWEEN 1 AND 3 THEN 'Verano'
												WHEN MONTH(P.fecha_desde) BETWEEN 4 AND 6 THEN 'Otoño'
												WHEN MONTH(P.fecha_desde) BETWEEN 7 AND 9 THEN 'Invierno'
												WHEN MONTH(P.fecha_desde) BETWEEN 10 AND 12 THEN 'Primavera'
											END
										JOIN BI_DimRangoEtario R ON 
										DATEDIFF(YEAR, A.fecha_nacimiento, P.fecha_emision) BETWEEN R.rango_inicio AND R.rango_fin;



--------------------------VIEWS--------------------------
CREATE VIEW BI_Ticket_Promedio AS
SELECT T.anio, T.mes, R.descripcion rango_etario_cliente, C.descripcion canal_venta,
        CAST(AVG(V.importe_total_venta) AS DECIMAL(18,2)) ticket_promedio 
FROM BI_Hecho_Venta V JOIN BI_DimTiempo T ON (V.id_tiempo = T.id_Tiempo)
                      JOIN BI_DimRangoEtario R ON (V.id_rango_etario_cliente = R.id_Rango_Etario)
                      JOIN BI_DimCanalVenta C ON (V.id_canal_venta = C.id_Canal_Venta)
GROUP BY T.anio, T.mes, R.descripcion, C.descripcion;


CREATE VIEW BI_Distribución_Facturación AS
SELECT t.anio, t.cuatrimestre, s.descripcion, SUM(V.importe_total_venta) * 100.0 /
    (SELECT SUM(V2.importe_total_venta) FROM BI_Hecho_Venta V2
    JOIN BI_DimTiempo T2 ON V2.id_tiempo = T2.id_Tiempo
    WHERE T2.anio = T.anio AND T2.cuatrimestre = T.cuatrimestre
    ) AS porcentaje_facturacion    
    FROM BI_Hecho_Venta v
    JOIN BI_DimTiempo t ON (v.id_tiempo = t.id_Tiempo)
    JOIN BI_DimTipoServicio s ON (v.id_tipo_servicio = s.id_Tipo_Servicio)
GROUP BY t.anio, t.cuatrimestre, s.descripcion


CREATE VIEW BI_Ranking_Solicitudes_Por_Temporadas AS
SELECT ti.anio, r.descripcion, t.descripcion, COUNT(*) AS Cantidad_Solicitudes
FROM BI_Hecho_Solicitud s JOIN BI_DimTemporada t ON (s.id_temporada = t.id_Temporada)
                          JOIN BI_DimRangoEtario r ON s.id_rango_etario_cliente = r.id_Rango_Etario
                          JOIN BI_DimTiempo ti ON (ti.id_Tiempo = s.id_tiempo)
GROUP BY ti.anio, id_rango_etario_cliente, t.descripcion


CREATE VIEW BI_Anticipación_Promedio_Solicitudes AS
SELECT r.descripcion, t.cuatrimestre, AVG(s.dias_anticipacion) AS Promedio_Dias_Anticipacion
FROM BI_Hecho_Solicitud s JOIN BI_DimTiempo t ON (s.id_tiempo = t.id_Tiempo)
                          JOIN BI_DimRangoEtario r ON s.id_rango_etario_cliente = r.id_Rango_Etario
GROUP BY r.descripcion, t.cuatrimestre


CREATE VIEW BI_Tasa_Aceptación_Propuestas AS 
SELECT t.cuatrimestre, COUNT(CASE WHEN e.descripcion = 'Aceptado' THEN 1 END) * 100.0 / COUNT(*) AS tasa_aceptacion
FROM BI_Hecho_Propuesta hp JOIN BI_DimTiempo t ON (hp.id_tiempo = t.id_Tiempo)
                           JOIN BI_DimEstado e ON (hp.id_estado = e.id_Estado_Propuesta)
GROUP BY t.cuatrimestre


CREATE VIEW BI_Cotización_Promedio_Por_Temporada AS
SELECT t.anio, te.descripcion, AVG(hp.importe) AS cotizacion_promedio
FROM BI_Hecho_Propuesta hp JOIN BI_DimTiempo t ON (hp.id_tiempo = t.id_Tiempo)
                           JOIN BI_DimTemporada te ON (hp.id_temporada = te.id_Temporada)
GROUP BY t.anio, te.descripcion


CREATE VIEW BI_Tiempo_Promedio_Respuesta AS
SELECT t.mes, r.descripcion, AVG(hp.dias_transcurridos_emision) AS promedio_dias
FROM BI_Hecho_Propuesta hp JOIN BI_DimTiempo t ON hp.id_tiempo = t.id_Tiempo
                           JOIN BI_DimRangoEtario r ON hp.id_rango_etario_agente = r.id_Rango_Etario
GROUP BY t.mes, r.descripcion


CREATE VIEW BI_Desvío_Presupuesto_Promedio AS
SELECT T.anio, T.cuatrimestre, CAST(AVG(P.desvio_precio) AS DECIMAL(18,2)) desvio_presupuesto_promedio
FROM BI_Hecho_Propuesta P JOIN BI_DimTiempo T ON (P.id_tiempo = T.id_Tiempo)
GROUP BY T.anio, T.cuatrimestre;

----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
CREATE VIEW BI_Ranking_Aspectos_Valorados AS
SELECT T.anio, T.cuatrimestre, A.descripcion aspecto,
        CAST(AVG(CAST(E.puntaje AS DECIMAL(18,2))) AS DECIMAL(18,2)) puntaje_promedio,
        RANK() OVER ( --No se puede usar un ORDER BY suelto al final para views 
            PARTITION BY T.anio, T.cuatrimestre 
            ORDER BY CAST(AVG(CAST(E.puntaje AS DECIMAL(18,2))) AS DECIMAL(18,2)) puntaje_promedio DESC
            ) posicion_ranking
FROM BI_Hecho_Evaluacion E JOIN BI_DimTiempo T ON (E.id_tiempo = T.id_Tiempo)
                           JOIN BI_DimAspecto A ON (E.id_aspecto = A.id_Aspecto)
GROUP BY t.anio, T.cuatrimestre, A.descripcion
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------

CREATE VIEW BI_Satisfacción_Promedio_Por_Agente AS
SELECT T.anio, T.mes, R.descripcion rango_etario_agente,
        CAST(AVG(CAST(E.puntaje AS DECIMAL(18,2))) AS DECIMAL(18,2)) satisfaccion_promedio
FROM BI_Hecho_Evaluacion E JOIN BI_DimTiempo T ON (E.id_tiempo = T.id_Tiempo)
                           JOIN BI_DimRangoEtario R ON (E.id_rango_etario_agente = R.id_Rango_Etario)
GROUP BY T.anio, T.mes, R.descripcion;