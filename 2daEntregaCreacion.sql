--BEGIN TRANSACTION
-- ==========================================
-- ELIMINACIÓN DE TABLAS EN ORDEN INVERSO
-- ==========================================

-- Nivel 6: Ventas y Reservas
DROP TABLE IF EXISTS PLATENSE.Reserva_Habitacion;
DROP TABLE IF EXISTS PLATENSE.Reserva_Excursion;
DROP TABLE IF EXISTS PLATENSE.Reserva_Vuelo;
DROP TABLE IF EXISTS PLATENSE.Venta;

-- Nivel 5: Solicitudes y Propuestas
DROP TABLE IF EXISTS PLATENSE.Propuesta_Personalizada;
DROP TABLE IF EXISTS PLATENSE.Habitacion;
DROP TABLE IF EXISTS PLATENSE.Ciudades_destino;
DROP TABLE IF EXISTS PLATENSE.Solicitud_Cotizacion;

-- Nivel 4: Comercial, Agentes y Vuelos
DROP TABLE IF EXISTS PLATENSE.AspectoXEncuesta;
DROP TABLE IF EXISTS PLATENSE.Encuesta_Satisfaccion;
DROP TABLE IF EXISTS PLATENSE.Vuelo;
DROP TABLE IF EXISTS PLATENSE.Agente;
DROP TABLE IF EXISTS PLATENSE.Agencia;

-- Nivel 3: Bloque Geográfico y Entidades
DROP TABLE IF EXISTS PLATENSE.Hospedaje;
DROP TABLE IF EXISTS PLATENSE.Aeropuerto;
DROP TABLE IF EXISTS PLATENSE.Cliente;
DROP TABLE IF EXISTS PLATENSE.Localidad;
DROP TABLE IF EXISTS PLATENSE.Ciudad;

-- Nivel 2: Primer Nivel de Dependencia
DROP TABLE IF EXISTS PLATENSE.Excursion;
DROP TABLE IF EXISTS PLATENSE.Aerolinea;
DROP TABLE IF EXISTS PLATENSE.Provincia;

-- Nivel 1: Tablas Base
DROP TABLE IF EXISTS PLATENSE.Proveedor;
DROP TABLE IF EXISTS PLATENSE.Estado;
DROP TABLE IF EXISTS PLATENSE.Medio_pago;
DROP TABLE IF EXISTS PLATENSE.Canal_venta;
DROP TABLE IF EXISTS PLATENSE.Aspecto;
DROP TABLE IF EXISTS PLATENSE.Alianza;
DROP TABLE IF EXISTS PLATENSE.Pais;


DROP SCHEMA IF EXISTS PLATENSE;
-- ==========================================
-- NIVEL 1: TABLAS BASE (INDEPENDIENTES)
-- ==========================================
GO
CREATE SCHEMA PLATENSE
GO


CREATE TABLE PLATENSE.Pais (
	nro_pais INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Alianza(
	nro_alianza INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Aspecto (
	tipo_aspecto INT IDENTITY(1,1) PRIMARY KEY,
	descripcion VARCHAR(255)
);

CREATE TABLE PLATENSE.Canal_venta(
	nro_canal INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Medio_pago(
	nro_medio INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Estado (
	nro_estado INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Proveedor (
	nro_proveedor INT IDENTITY(1,1) PRIMARY KEY,
	nombre VARCHAR(255),
	mail VARCHAR(255),
	telefono VARCHAR(255)
); 

-- ==========================================
-- NIVEL 2: PRIMER NIVEL DE DEPENDENCIA
-- ==========================================

CREATE TABLE PLATENSE.Provincia (
	nro_provincia INT IDENTITY(1,1) PRIMARY KEY,
	nro_pais INT FOREIGN KEY REFERENCES PLATENSE.Pais,
	nombre VARCHAR(255),
);

CREATE TABLE PLATENSE.Aerolinea (
	aerolinea_codigo CHAR(2) PRIMARY KEY,
	nro_pais INT FOREIGN KEY REFERENCES PLATENSE.Pais(nro_pais),
	nro_alianza INT FOREIGN KEY REFERENCES PLATENSE.Alianza(nro_alianza),
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Excursion (
	nro_excursion INT IDENTITY(1,1) PRIMARY KEY,
	nro_proveedor INT FOREIGN KEY REFERENCES PLATENSE.Proveedor(nro_proveedor),
	precio DECIMAL(12,3),
	duracion INT,
	horario DATETIME,
	nombre VARCHAR(255),
	descripcion VARCHAR(255)
);

-- ==========================================
-- NIVEL 3: BLOQUE GEOGRÁFICO Y ENTIDADES
-- ==========================================

CREATE TABLE PLATENSE.Ciudad (
	nro_ciudad INT IDENTITY(1,1) PRIMARY KEY,
	nro_provincia INT FOREIGN KEY REFERENCES PLATENSE.Provincia,
	nombre VARCHAR(255)
	);

CREATE TABLE PLATENSE.Localidad (
	cod_postal INT IDENTITY(1,1) PRIMARY KEY,
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Cliente (
	nro_cliente INT IDENTITY(1,1) PRIMARY KEY,
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad,
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	dni VARCHAR(255),
	mail VARCHAR(255),
	telefono VARCHAR(255),
	domicilio VARCHAR(255),
	fecha_nacimiento DATE
);

CREATE TABLE PLATENSE.Aeropuerto (
	aeropuerto_codigo CHAR(3) PRIMARY KEY,
	nombre VARCHAR(255),
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad
);

CREATE TABLE PLATENSE.Hospedaje (
	nro_hospedaje INT IDENTITY(1,1) PRIMARY KEY,
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad,
	direccion VARCHAR(255),
	hora_check_in TIME,
	hora_check_out TIME,
	precio DECIMAL(12, 3),
	incluye_desayuno CHAR(1),
	nombre VARCHAR(255)
); 

-- ==========================================
-- NIVEL 4: COMERCIAL, AGENTES Y VUELOS
-- ==========================================

CREATE TABLE PLATENSE.Agencia(
	nro_agencia INT IDENTITY(1,1) PRIMARY KEY,
	cod_postal INT FOREIGN KEY REFERENCES PLATENSE.Localidad,
	direccion VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255)
);

CREATE TABLE PLATENSE.Agente (
	nro_legajo INT IDENTITY(1,1) PRIMARY KEY,
	nro_agencia INT FOREIGN KEY REFERENCES PLATENSE.Agencia,
	cod_postal INT FOREIGN KEY REFERENCES PLATENSE.Localidad,
	nombre VARCHAR(255),
	apellido VARCHAR(255),
	domicilio VARCHAR(255),
	dni VARCHAR(255),
	fecha_nacimiento DATE,
	telefono VARCHAR(255),
	mail VARCHAR(255)
);

CREATE TABLE PLATENSE.Vuelo (
	nro_vuelo INT IDENTITY(1,1) PRIMARY KEY,
	aerolinea_codigo CHAR(2) FOREIGN KEY REFERENCES PLATENSE.Aerolinea(aerolinea_codigo),
	nro_aeropuerto_origen CHAR(3) FOREIGN KEY REFERENCES PLATENSE.Aeropuerto(aeropuerto_codigo),
	nro_aeropuerto_destino CHAR(3) FOREIGN KEY REFERENCES PLATENSE.Aeropuerto(aeropuerto_codigo),
	fecha_hora_salida DATETIME,
	fecha_hora_llegada DATETIME,
	precio DECIMAL(12, 3),
	duracion TIME,
	incluye_carry CHAR(1),
	inlcuye_valija CHAR(1)
);

CREATE TABLE PLATENSE.Encuesta_Satisfaccion (
	nro_encuesta INT IDENTITY(1,1) PRIMARY KEY,
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	fecha DATE,
	comentario VARCHAR(255)
);

CREATE TABLE PLATENSE.AspectoXEncuesta (
	tipo_aspecto INT FOREIGN KEY REFERENCES PLATENSE.Aspecto,
	nro_encuesta INT FOREIGN KEY REFERENCES PLATENSE.Encuesta_Satisfaccion,
	puntaje INT,
	PRIMARY KEY (tipo_aspecto, nro_encuesta)
);

-- ==========================================
-- NIVEL 5: SOLICITUDES Y PROPUESTAS
-- ==========================================

CREATE TABLE PLATENSE.Solicitud_Cotizacion (
	nro_solicitud INT IDENTITY(1,1) PRIMARY KEY,
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	fecha_solicitud DATE,
	fecha_inicio_tentativa DATE,
	fecha_fin_tentativa DATE,
	cantidad_dias INT,
	cantidad_pasajeros INT,
	observaciones VARCHAR(255),
	presupuesto_estimado DECIMAL(12, 3)
);

CREATE TABLE PLATENSE.Ciudades_destino (
	nro_solicitud INT FOREIGN KEY REFERENCES PLATENSE.Solicitud_Cotizacion(nro_solicitud),
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad,
	PRIMARY KEY (nro_solicitud, nro_ciudad)
);

CREATE TABLE PLATENSE.Habitacion (
	codigo_habitacion INT IDENTITY(1,1) PRIMARY KEY,
	nro_hospedaje INT FOREIGN KEY REFERENCES PLATENSE.Hospedaje(nro_hospedaje),
	numero_habitacion INT,
	descripcion VARCHAR(255),
	precio_noche DECIMAL(12,3)
); 

CREATE TABLE PLATENSE.Propuesta_Personalizada (
	nro_propuesta INT IDENTITY(1,1) PRIMARY KEY,
	nro_solicitud INT FOREIGN KEY REFERENCES PLATENSE.Solicitud_Cotizacion(nro_solicitud),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_estado INT FOREIGN KEY REFERENCES PLATENSE.Estado(nro_estado),
	nro_hospedaje INT FOREIGN KEY REFERENCES PLATENSE.Hospedaje(nro_hospedaje),
	nro_vuelo INT FOREIGN KEY REFERENCES PLATENSE.Vuelo(nro_vuelo),
	fecha_emision DATE,
	vigencia DATE,
	fecha_desde DATE,
	fecha_hasta DATE,
	subtotal DECIMAL(12,3),
	descuento DECIMAL(12,3),
	importe_total DECIMAL(12,3),
	detalle VARCHAR(255)
);

-- ==========================================
-- NIVEL 6: VENTAS Y RESERVAS
-- ==========================================

CREATE TABLE PLATENSE.Venta (
	nro_venta INT IDENTITY(1,1) PRIMARY KEY,
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	nro_canal_venta INT FOREIGN KEY REFERENCES PLATENSE.Canal_Venta(nro_canal),
	nro_medio_pago INT FOREIGN KEY REFERENCES PLATENSE.Medio_Pago(nro_medio),
	nro_propuesta INT FOREIGN KEY REFERENCES PLATENSE.Propuesta_Personalizada(nro_propuesta),
	fecha DATE,
	subtotal DECIMAL(12, 3),
	descuento DECIMAL(12, 3),
	importe_total DECIMAL(12, 3)
);

CREATE TABLE PLATENSE.Reserva_Vuelo (
	nro_venta INT FOREIGN KEY REFERENCES PLATENSE.Venta(nro_venta),
	nro_vuelo INT FOREIGN KEY REFERENCES PLATENSE.Vuelo(nro_vuelo),
	cantidad INT,
	precio DECIMAL(12,3),
	subtotal DECIMAL(12,3),
	cod_reserva VARCHAR(255),
	PRIMARY KEY(nro_venta, nro_vuelo)
);

CREATE TABLE PLATENSE.Reserva_Excursion (
	nro_venta INT,
	nro_excursion INT,
	fecha_realizacion DATETIME,
	cantidad INT,
	precio DECIMAL(12, 3),
	codigo_reserva VARCHAR(255),
	subtotal DECIMAL(12, 3),
	PRIMARY KEY (nro_venta, nro_excursion),
	FOREIGN KEY (nro_venta) REFERENCES PLATENSE.Venta(nro_venta),
	FOREIGN KEY (nro_excursion) REFERENCES PLATENSE.Excursion(nro_excursion)
); 

CREATE TABLE PLATENSE.Reserva_Habitacion (
	nro_venta INT ,
	codigo_habitacion INT,
	fecha_hora_ingreso DATETIME,
	fecha_hora_egreso DATETIME,
	cantidad_habitaciones INT,
	precio DECIMAL(12, 3),
	tipo_habitacion VARCHAR(255),
	codigo_reserva VARCHAR(255),
	subtotal DECIMAL(12, 3),
	PRIMARY KEY (nro_venta, codigo_habitacion),
	FOREIGN KEY (nro_venta) REFERENCES PLATENSE.Venta(nro_venta),
	FOREIGN KEY (codigo_habitacion) REFERENCES PLATENSE.Habitacion(codigo_habitacion)
);

--ROLLBACK TRANSACTION


--Migración de datos
CREATE PROCEDURE migrarPaises AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Pais (nombre)
			SELECT DISTINCT Hospedaje_Pais FROM gd_esquema.Maestra WHERE Hospedaje_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aerolinea_Pais FROM gd_esquema.Maestra WHERE Aerolinea_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Salida_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Llegada_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Pais IS NOT NULL;
		COMMIT TRANSACTION
		PRINT 'Paises migrados con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de paises', 16, 1)
	END CATCH
END

--EXEC migrarPaises;

CREATE PROCEDURE migrarAlianzas AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Alianza
		SELECT DISTINCT Aerolinea_Alianza FROM gd_esquema.Maestra WHERE Aerolinea_Alianza IS NOT NULL;
		COMMIT TRANSACTION
		PRINT 'Alianzas migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de alianzas',16,1)
	END CATCH
END

--SELECT * FROM PLATENSE.Alianza
--EXEC migrarAlianzas


CREATE PROCEDURE migrarAspectos AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Aspecto
			SELECT DISTINCT Aspecto_Aspecto FROM gd_esquema.Maestra WHERE Aspecto_Aspecto IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Aspectos migrados con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de aspectos',16,1)
	END CATCH
END
--EXEC migrarAspectos

CREATE PROCEDURE migrarCanales_venta AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Canal_venta
			SELECT DISTINCT Venta_Canal_Venta FROM gd_esquema.Maestra WHERE Venta_Canal_Venta IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Canales de venta migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de canales de venta',16,1)
	END CATCH
END
--EXEC migrarCanales_venta

CREATE PROCEDURE migrarMedios_pago AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Medio_pago
			SELECT DISTINCT Venta_Medio_Pago FROM gd_esquema.Maestra WHERE Venta_Medio_Pago IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Medios de pago migrados con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de medios de pago',16,1)
	END CATCH
END
--EXEC migrarMedios_pago

CREATE PROCEDURE migrarEstados AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Estado
			SELECT DISTINCT Propuesta_Estado FROM gd_esquema.Maestra WHERE Propuesta_Estado IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Estados migrados con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de estados',16,1)
	END CATCH
END
--EXEC migrarEstados

CREATE PROCEDURE migrarProveedores AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Proveedor
			SELECT DISTINCT Proveedor_Nombre, Proveedor_Mail, Proveedor_Telefono FROM gd_esquema.Maestra 
				WHERE Proveedor_Nombre IS NOT NULL AND Proveedor_Mail IS NOT NULL AND Proveedor_Telefono IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Proveedores migrados con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de proveedores',16,1)
	END CATCH
END
--EXEC migrarProveedores

CREATE PROCEDURE migrarExcursiones AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			INSERT INTO PLATENSE.Excursion (nro_proveedor, nombre,descripcion,horario,duracion,precio)
			SELECT DISTINCT 
				P.nro_proveedor,M.Excursion_Nombre, M.Excursion_Descripcion, M.Excursion_Horario,M.Excursion_Duracion, M.Excursion_Precio 
						FROM gd_esquema.Maestra M
						JOIN PLATENSE.Proveedor P ON M.Proveedor_Nombre = P.nombre
							WHERE Excursion_Nombre IS NOT NULL AND 
							Excursion_Descripcion IS NOT NULL AND
							Excursion_Horario IS NOT NULL AND
							Excursion_Duracion IS NOT NULL AND
							Excursion_Precio IS NOT NULL 
		COMMIT TRANSACTION
		PRINT 'Excursiones migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de excursiones',16,1)
	END CATCH
END
--EXEC migrarExcursiones


CREATE PROCEDURE migrarAerolineas AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Aerolinea
			SELECT DISTINCT M.Aerolinea_Codigo, P.nro_pais, A.nro_alianza, M.Aerolinea_Nombre
				FROM gd_esquema.Maestra M
				JOIN PLATENSE.Pais P ON M.Aerolinea_Pais = P.nombre
				JOIN PLATENSE.Alianza A ON M.Aerolinea_Alianza = A.nombre
				WHERE Aerolinea_Codigo IS NOT NULL
		COMMIT TRANSACTION
		PRINT 'Aerolineas migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de aerolineas',16,1)
	END CATCH
END
--EXEC migrarAerolineas


-----------------------------PENDIENTE--------------------------------
CREATE PROCEDURE migrarProvincias AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Provincia
			SELECT DISTINCT M.Agencia_Provincia FROM gd_esquema.Maestra M WHERE Agencia_Provincia IS NOT NULL
			UNION
			SELECT DISTINCT M.Agente_Provincia FROM gd_esquema.Maestra M WHERE Agente_Provincia IS NOT NULL
			UNION
			SELECT DISTINCT M.Cliente_Provincia FROM gd_esquema.Maestra M WHERE Cliente_Provincia IS NOT NULL
			
			--De alguna forma debemos conectarlo con el pais, el tema es que en ningun momento se relacionanan de forma directa.
			--Observamos que hay una relacion entre la provincia y la localidad en agencia, agente y cliente

		COMMIT TRANSACTION
		PRINT 'Provincias migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de provincias',16,1)
	END CATCH
END


-------------------------------PENDIENTE-----------------------------------
CREATE PROCEDURE migrarCiudades AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Ciudad
			SELECT DISTINCT Detalle_Solicitud_Ciudad  FROM gd_esquema.Maestra WHERE Detalle_Solicitud_Ciudad IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Salida_Ciudad  FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Ciudad IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Llegada_Ciudad  FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Ciudad IS NOT NULL
			UNION
			SELECT DISTINCT Hospedaje_Ciudad  FROM gd_esquema.Maestra WHERE Hospedaje_Ciudad IS NOT NULL

			--No encontramos forma de unirlo con las provincias
			--Vemos cierta union entre la ciudad y los paises dentro de aeropuerto y hospedaje por ejemplo

		COMMIT TRANSACTION
		PRINT 'Ciudades migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de ciudades',16,1)
	END CATCH
END

----------------------------PENDIENTE------------------------------
CREATE PROCEDURE migrarLocalidades AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Localidad
			SELECT DISTINCT Agencia_Localidad FROM gd_esquema.Maestra WHERE Agencia_Localidad IS NOT NULL
			UNION
			SELECT DISTINCT Agente_Localidad FROM gd_esquema.Maestra WHERE Agente_Localidad IS NOT NULL
			UNION
			SELECT DISTINCT Cliente_Localidad FROM gd_esquema.Maestra WHERE Cliente_Localidad IS NOT NULL
			--Se relaciona con provincia

		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

--------------------PENDIENTE-----------------------
CREATE PROCEDURE migrarClientes AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Cliente
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

--------------------PENDIENTE-------------------------
CREATE PROCEDURE migrarAeropuertos AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Aeropuerto
			SELECT DISTINCT  Aeropuerto_Salida_Codigo AS Aeropuerto_Codigo, Aeropuerto_Salida_Descripcion 
			AS Aeropuerto_Nombre, Aeropuerto_Salida_Ciudad AS Aeropuerto_Ciudad
			FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Codigo IS NOT NULL
			UNION 
			SELECT DISTINCT Aeropuerto_Llegada_Codigo, Aeropuerto_Llegada_Descripcion, 
			Aeropuerto_Llegada_Ciudad
			FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Codigo IS NOT NULL

		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

--------------------PENDIENTE---------------------
CREATE PROCEDURE migrarHospedajes AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Hospedaje
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

----------------PENDIENTE-----------------------
CREATE PROCEDURE migrarAgencias AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Agencia
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

----------------PENDIENTE-------------------------
CREATE PROCEDURE migrarAgentes AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Agente
			--Codigo
			 --Tener en cuenta que ya existe un legajo. Lo utilizamos como PRIMARY KEY?
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

----------------PENDIENTE------------------------
CREATE PROCEDURE migrarVuelos AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Vuelo
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

-----------------PENDIENTE--------------------------
CREATE PROCEDURE migrarEncuestas_satifaccion AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Encuesta_Satisfaccion
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarAspectosXEncuestas AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.AspectoXEncuesta
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarSolicitudes_cotizacion AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Solicitud_Cotizacion
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarCiudades_destino AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Ciudades_destino
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarHabitaciones AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Habitacion
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarPropuestas_personalizadas AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Propuesta_Personalizada
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarVentas AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Venta
			SELECT M.Venta_Nro_Venta, M.Cliente_Dni, M.Agente_Legajo, CV.nro_canal, MP.nro_medio,  --De forma provisoria queda así el legajo, debe ser el legajo de PLATENSE.Agente
			M.Venta_Fecha_Venta, M.Venta_Subtotal, M.Venta_Descuento, M.Venta_Importe_Total
			FROM gd_esquema.Maestra M
				JOIN PLATENSE.Canal_venta CV ON M.Venta_Canal_Venta = CV.nombre
				JOIN PLATENSE.Medio_pago MP ON M.Venta_Medio_Pago = MP.nombre

		COMMIT TRANSACTION
		PRINT 'Ventas migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de ventas',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarReservas_vuelo AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Reserva_Vuelo
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarReservas_excursion AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Reserva_Excursion
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END

---------------PENDIENTE-------------------
CREATE PROCEDURE migrarReservas_habitaciones AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		INSERT INTO PLATENSE.Reserva_Habitacion
		--Codigo
		COMMIT TRANSACTION
		PRINT 'X migradas con exito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Error en la migración de X',16,1)
	END CATCH
END


