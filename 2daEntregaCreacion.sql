-- ==========================================
-- ELIMINACIÓN DE TABLAS EN ORDEN ESTRICTO
-- ==========================================

-- 1. Tablas de cruce y reservas finales
DROP TABLE IF EXISTS PLATENSE.Reserva_Habitacion;
DROP TABLE IF EXISTS PLATENSE.Reserva_Excursion;
DROP TABLE IF EXISTS PLATENSE.Reserva_Vuelo;
DROP TABLE IF EXISTS PLATENSE.AspectoXEncuesta;

-- 2. Transacciones comerciales
DROP TABLE IF EXISTS PLATENSE.Venta;
DROP TABLE IF EXISTS PLATENSE.Propuesta_vuelo;
DROP TABLE IF EXISTS PLATENSE.Propuesta_hospedaje;
DROP TABLE IF EXISTS PLATENSE.Propuesta_Personalizada;

-- 3. Entidades secundarias y la TABLA FANTASMA
DROP TABLE IF EXISTS PLATENSE.Habitacion;
DROP TABLE IF EXISTS PLATENSE.Ciudades_destino; -- ¡Agregada para matar la tabla vieja!
DROP TABLE IF EXISTS PLATENSE.Solicitud_Cotizacion;
DROP TABLE IF EXISTS PLATENSE.Encuesta_Satisfaccion;

-- 4. Operativa y Vuelos
DROP TABLE IF EXISTS PLATENSE.Vuelo;
DROP TABLE IF EXISTS PLATENSE.Agente;
DROP TABLE IF EXISTS PLATENSE.Agencia;
DROP TABLE IF EXISTS PLATENSE.Cliente;

-- 5. Bloque Geográfico y Entidades Físicas
DROP TABLE IF EXISTS PLATENSE.Hospedaje;
DROP TABLE IF EXISTS PLATENSE.Aeropuerto;
DROP TABLE IF EXISTS PLATENSE.Excursion;
DROP TABLE IF EXISTS PLATENSE.Localidad;
DROP TABLE IF EXISTS PLATENSE.Ciudad;
DROP TABLE IF EXISTS PLATENSE.Aerolinea;

-- 6. Tablas Base
DROP TABLE IF EXISTS PLATENSE.Provincia;
DROP TABLE IF EXISTS PLATENSE.Proveedor;
DROP TABLE IF EXISTS PLATENSE.Estado;
DROP TABLE IF EXISTS PLATENSE.Medio_pago;
DROP TABLE IF EXISTS PLATENSE.Canal_venta;
DROP TABLE IF EXISTS PLATENSE.Aspecto;
DROP TABLE IF EXISTS PLATENSE.Alianza;
DROP TABLE IF EXISTS PLATENSE.Pais;

DROP SCHEMA IF EXISTS PLATENSE;
GO
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
	nro_pais INT FOREIGN KEY REFERENCES PLATENSE.Pais,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Localidad (
	nro_localidad INT IDENTITY(1,1) PRIMARY KEY,
	nro_provincia INT FOREIGN KEY REFERENCES PLATENSE.Provincia,
	nombre VARCHAR(255)
);

CREATE TABLE PLATENSE.Cliente (
	nro_cliente INT IDENTITY(1,1) PRIMARY KEY,
	nro_localidad INT FOREIGN KEY REFERENCES PLATENSE.Localidad,
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
	nro_localidad INT FOREIGN KEY REFERENCES PLATENSE.Localidad,
	direccion VARCHAR(255),
	telefono VARCHAR(255),
	mail VARCHAR(255)
);

CREATE TABLE PLATENSE.Agente (
	nro_legajo INT PRIMARY KEY,
	nro_agencia INT FOREIGN KEY REFERENCES PLATENSE.Agencia,
	nro_localidad INT FOREIGN KEY REFERENCES PLATENSE.Localidad,
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
	aeropuerto_codigo_origen CHAR(3) FOREIGN KEY REFERENCES PLATENSE.Aeropuerto(aeropuerto_codigo),
	aeropuerto_codigo_destino CHAR(3) FOREIGN KEY REFERENCES PLATENSE.Aeropuerto(aeropuerto_codigo),
	fecha_salida DATE,
	hora_salida TIME,
	fecha_llegada DATE,
	hora_llegada TIME,
	precio DECIMAL(12, 3),
	duracion INT,
	incluye_carry CHAR(1),
	inlcuye_valija CHAR(1)
);

CREATE TABLE PLATENSE.Encuesta_Satisfaccion (
	nro_encuesta INT PRIMARY KEY,
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
	nro_solicitud INT PRIMARY KEY,
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	nro_ciudad INT FOREIGN KEY REFERENCES PLATENSE.Ciudad(nro_ciudad),
	fecha_solicitud DATE,
	fecha_inicio_tentativa DATE,
	fecha_fin_tentativa DATE,
	cantidad_dias INT,
	cantidad_pasajeros INT,
	observaciones VARCHAR(255),
	presupuesto_estimado DECIMAL(12, 3)
);

CREATE TABLE PLATENSE.Habitacion (
	codigo_habitacion INT IDENTITY(1,1) PRIMARY KEY,
	nro_hospedaje INT FOREIGN KEY REFERENCES PLATENSE.Hospedaje(nro_hospedaje),
	nombre VARCHAR(255),
	numero_habitacion INT,
	descripcion VARCHAR(255),
	precio_noche DECIMAL(12,3)
); 

CREATE TABLE PLATENSE.Propuesta_Personalizada (
	nro_propuesta INT PRIMARY KEY,
	nro_solicitud INT FOREIGN KEY REFERENCES PLATENSE.Solicitud_Cotizacion(nro_solicitud),
	nro_agente INT FOREIGN KEY REFERENCES PLATENSE.Agente(nro_legajo),
	nro_cliente INT FOREIGN KEY REFERENCES PLATENSE.Cliente(nro_cliente),
	nro_estado INT FOREIGN KEY REFERENCES PLATENSE.Estado(nro_estado),
	fecha_emision DATE,
	vigencia DATE,
	fecha_desde DATE,
	fecha_hasta DATE,
	subtotal DECIMAL(12,3),
	descuento DECIMAL(12,3),
	importe_total DECIMAL(12,3),
);


CREATE TABLE PLATENSE.Propuesta_vuelo (
	nro_propuesta_vuelo INT IDENTITY(1,1) PRIMARY KEY,
	nro_propuesta INT FOREIGN KEY REFERENCES PLATENSE.Propuesta_Personalizada,
	cantidad_pasajes INT,
	Precio DECIMAL(12,3),
	Subtotal DECIMAL(12,3),
)

CREATE TABLE PLATENSE.Propuesta_hospedaje (
	nro_propuesta_hospedaje INT IDENTITY(1,1) PRIMARY KEY,
	nro_propuesta INT FOREIGN KEY REFERENCES PLATENSE.Propuesta_Personalizada,
	Fecha_Desde DATE,
	Fecha_Hasta DATE,
	Cant INT,
	Precio DECIMAL(12,3),
	Subtotal DECIMAL(12,3)
)

-- ==========================================
-- NIVEL 6: VENTAS Y RESERVAS
-- ==========================================

CREATE TABLE PLATENSE.Venta (
	nro_venta INT PRIMARY KEY,
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
	PRIMARY KEY(nro_venta, cod_reserva)
);

CREATE TABLE PLATENSE.Reserva_Excursion (
	nro_venta INT,
	nro_excursion INT,
	fecha_realizacion DATETIME,
	cantidad INT,
	precio DECIMAL(12, 3),
	codigo_reserva VARCHAR(255),
	subtotal DECIMAL(12, 3),
	PRIMARY KEY (nro_venta, codigo_reserva),
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
	PRIMARY KEY (nro_venta, codigo_reserva),
	FOREIGN KEY (nro_venta) REFERENCES PLATENSE.Venta(nro_venta),
	FOREIGN KEY (codigo_habitacion) REFERENCES PLATENSE.Habitacion(codigo_habitacion)
);
GO


DROP PROCEDURE IF EXISTS migrarPaises
DROP PROCEDURE IF EXISTS migrarAlianzas
DROP PROCEDURE IF EXISTS migrarAspectos
DROP PROCEDURE IF EXISTS migrarCanales_venta
DROP PROCEDURE IF EXISTS migrarMedios_pago
DROP PROCEDURE IF EXISTS migrarEstados
DROP PROCEDURE IF EXISTS migrarProvincias
DROP PROCEDURE IF EXISTS migrarCiudades
DROP PROCEDURE IF EXISTS migrarProveedores
DROP PROCEDURE IF EXISTS migrarAerolineas
DROP PROCEDURE IF EXISTS migrarLocalidades
DROP PROCEDURE IF EXISTS migrarAeropuertos
DROP PROCEDURE IF EXISTS migrarExcursiones
DROP PROCEDURE IF EXISTS migrarClientes
DROP PROCEDURE IF EXISTS migrarAgencias
DROP PROCEDURE IF EXISTS migrarAgentes
DROP PROCEDURE IF EXISTS migrarHospedajes
DROP PROCEDURE IF EXISTS migrarHabitaciones
DROP PROCEDURE IF EXISTS migrarVuelos
DROP PROCEDURE IF EXISTS migrarEncuestas_satifaccion
DROP PROCEDURE IF EXISTS migrarAspectosXEncuestas
DROP PROCEDURE IF EXISTS migrarSolicitudes_cotizacion
DROP PROCEDURE IF EXISTS migrarPropuestas_personalizadas
DROP PROCEDURE IF EXISTS migrarVentas
DROP PROCEDURE IF EXISTS migrarReservas_vuelo
DROP PROCEDURE IF EXISTS migrarReservas_excursion
DROP PROCEDURE IF EXISTS migrarReservas_habitaciones
DROP PROCEDURE IF EXISTS migrarTODO
DROP PROCEDURE IF EXISTS migrarPropuesta_hospedaje
DROP PROCEDURE IF EXISTS migrarPropuesta_vuelo

GO
--Migración de datos
CREATE PROCEDURE migrarPaises AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Pais (nombre)
			SELECT DISTINCT Hospedaje_Pais FROM gd_esquema.Maestra WHERE Hospedaje_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aerolinea_Pais FROM gd_esquema.Maestra WHERE Aerolinea_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Salida_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Pais IS NOT NULL
			UNION
			SELECT DISTINCT Aeropuerto_Llegada_Pais FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Pais IS NOT NULL;
		PRINT 'Paises migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de paises', 16, 1)
	END CATCH
END


Go
CREATE PROCEDURE migrarAlianzas AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Alianza (nombre)
			SELECT DISTINCT Aerolinea_Alianza FROM gd_esquema.Maestra WHERE Aerolinea_Alianza IS NOT NULL;
		PRINT 'Alianzas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de alianzas',16,1)
	END CATCH
END


go
CREATE PROCEDURE migrarAspectos AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Aspecto (descripcion)
			SELECT DISTINCT Aspecto_Aspecto FROM gd_esquema.Maestra WHERE Aspecto_Aspecto IS NOT NULL
		PRINT 'Aspectos migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de aspectos',16,1)
	END CATCH
END
go
CREATE PROCEDURE migrarCanales_venta AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Canal_venta (nombre)
			SELECT DISTINCT Venta_Canal_Venta FROM gd_esquema.Maestra WHERE Venta_Canal_Venta IS NOT NULL
		PRINT 'Canales de venta migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de canales de venta',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarMedios_pago AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Medio_pago (nombre)
			SELECT DISTINCT Venta_Medio_Pago FROM gd_esquema.Maestra WHERE Venta_Medio_Pago IS NOT NULL
		PRINT 'Medios de pago migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de medios de pago',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarEstados AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Estado (nombre)
			SELECT DISTINCT Propuesta_Estado FROM gd_esquema.Maestra WHERE Propuesta_Estado IS NOT NULL
		PRINT 'Estados migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de estados',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarProveedores AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Proveedor (nombre, mail, telefono)
			SELECT DISTINCT Proveedor_Nombre, Proveedor_Mail, Proveedor_Telefono FROM gd_esquema.Maestra 
				WHERE Proveedor_Nombre IS NOT NULL AND Proveedor_Mail IS NOT NULL AND Proveedor_Telefono IS NOT NULL
		PRINT 'Proveedores migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de proveedores',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarExcursiones AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Excursion (nro_proveedor, nombre,descripcion,horario,duracion,precio)
			SELECT DISTINCT 
				P.nro_proveedor, M.Excursion_Nombre, M.Excursion_Descripcion, M.Excursion_Horario, M.Excursion_Duracion, M.Excursion_Precio 
						FROM gd_esquema.Maestra M
						JOIN PLATENSE.Proveedor P ON M.Proveedor_Nombre = P.nombre
							WHERE Excursion_Nombre IS NOT NULL AND 
							Excursion_Descripcion IS NOT NULL AND
							Excursion_Horario IS NOT NULL AND
							Excursion_Duracion IS NOT NULL AND
							Excursion_Precio IS NOT NULL 
		PRINT 'Excursiones migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de excursiones',16,1)
	END CATCH
END


go
CREATE PROCEDURE migrarAerolineas AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Aerolinea (aerolinea_codigo, nro_pais, nro_alianza, nombre)
			SELECT DISTINCT M.Aerolinea_Codigo, P.nro_pais, A.nro_alianza, M.Aerolinea_Nombre
				FROM gd_esquema.Maestra M
				JOIN PLATENSE.Pais P ON M.Aerolinea_Pais = P.nombre
				JOIN PLATENSE.Alianza A ON M.Aerolinea_Alianza = A.nombre
				WHERE Aerolinea_Codigo IS NOT NULL
		PRINT 'Aerolineas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de aerolineas',16,1)
	END CATCH
END



go
CREATE PROCEDURE migrarProvincias AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Provincia (nombre)
			SELECT DISTINCT M.Agencia_Provincia FROM gd_esquema.Maestra M WHERE Agencia_Provincia IS NOT NULL
			UNION
			SELECT DISTINCT M.Agente_Provincia FROM gd_esquema.Maestra M WHERE Agente_Provincia IS NOT NULL
			UNION
			SELECT DISTINCT M.Cliente_Provincia FROM gd_esquema.Maestra M WHERE Cliente_Provincia IS NOT NULL
			
		PRINT 'Provincias migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de provincias',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarCiudades AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Ciudad (nombre, nro_pais)
			SELECT ciudades.Aeropuerto_Salida_Ciudad, pais.nro_pais
			FROM (
				SELECT DISTINCT Aeropuerto_Salida_Ciudad, Aeropuerto_Salida_Pais
					FROM gd_esquema.Maestra 
					WHERE	Aeropuerto_Salida_Ciudad IS NOT NULL and
							Aeropuerto_Salida_Pais IS NOT NULL
				UNION 
				SELECT DISTINCT Aeropuerto_Llegada_Ciudad, Aeropuerto_Llegada_Pais
					FROM gd_esquema.Maestra 
					WHERE	Aeropuerto_Llegada_Ciudad IS NOT NULL and
							Aeropuerto_Llegada_Pais IS NOT NULL
			) AS ciudades
			JOIN PLATENSE.Pais pais ON ciudades.Aeropuerto_Salida_Pais = pais.nombre
		PRINT 'Ciudades migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de ciudades',16,1)
	END CATCH
END
go


CREATE PROCEDURE migrarLocalidades AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Localidad (nombre, nro_provincia)
		SELECT Agencia_Localidad nombreLocalidad, P.nro_provincia
		 FROM (
			SELECT DISTINCT M.Agencia_Localidad,M.Agencia_Provincia 
				FROM gd_esquema.Maestra M 
				WHERE M.Agencia_Localidad IS NOT NULL AND
					  M.Agencia_Provincia IS NOT NULL
			UNION
			SELECT DISTINCT M.Agente_Localidad,M.Agente_Provincia 
				FROM gd_esquema.Maestra M 
				WHERE M.Agente_Localidad IS NOT NULL AND
					  M.Agente_Provincia IS NOT NULL 
			UNION
			SELECT DISTINCT M.Cliente_Localidad,M.Cliente_Provincia 
				FROM gd_esquema.Maestra M 
				WHERE M.Cliente_Localidad IS NOT NULL AND
					  M.Cliente_Provincia IS NOT NULL
			) AS Origen
			JOIN PLATENSE.Provincia P ON Origen.Agencia_Provincia = P.nombre
		PRINT 'Localidades migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Localidades',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarClientes AS
BEGIN
	BEGIN TRY
				INSERT INTO PLATENSE.Cliente (dni, nombre, apellido, telefono, fecha_nacimiento, mail, nro_localidad, domicilio)
				SELECT DISTINCT M.Cliente_Dni, M.Cliente_Nombre, M.Cliente_Apellido,
						M.Cliente_Tel, M.Cliente_Fecha_Nac, M.Cliente_Mail, L.nro_localidad, M.Cliente_Direccion 
				FROM gd_esquema.Maestra M
					JOIN PLATENSE.Localidad L ON M.Cliente_Localidad = L.nombre
					JOIN PLATENSE.Provincia P ON L.nro_provincia = P.nro_provincia
				WHERE Cliente_Dni IS NOT NULL AND 
					  Cliente_Nombre IS NOT NULL AND
					  Cliente_Apellido IS NOT NULL AND
					  Cliente_Fecha_Nac IS NOT NULL AND
					  P.nombre = M.Cliente_Provincia
		PRINT 'Clientes migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Clientes',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarAeropuertos AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Aeropuerto (aeropuerto_codigo,nombre,nro_ciudad)
		SELECT aeropuerto_codigo, aeropuerto_nombre, C.nro_ciudad
		FROM(SELECT DISTINCT  Aeropuerto_Salida_Codigo AS Aeropuerto_Codigo, Aeropuerto_Salida_Descripcion 
			AS Aeropuerto_Nombre, Aeropuerto_Salida_Ciudad AS Aeropuerto_Ciudad
			FROM gd_esquema.Maestra WHERE Aeropuerto_Salida_Codigo IS NOT NULL
			UNION 
			SELECT DISTINCT Aeropuerto_Llegada_Codigo, Aeropuerto_Llegada_Descripcion, 
			Aeropuerto_Llegada_Ciudad
			FROM gd_esquema.Maestra WHERE Aeropuerto_Llegada_Codigo IS NOT NULL
			) AS Origen
			JOIN PLATENSE.Ciudad C ON Origen.aeropuerto_ciudad = C.nombre
		PRINT 'Aeropuertos migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Aeropuertos',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarHospedajes AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Hospedaje (nro_ciudad, direccion, hora_check_in, hora_check_out, precio, incluye_desayuno, nombre)
		SELECT DISTINCT C.nro_ciudad, M.Hospedaje_Direccion, M.Hospedaje_Check_In,
		M.Hospedaje_Check_Out, COALESCE(Detalle_Venta_Hospedaje_Precio_Unitario,
         Detalle_Propuesta_Hospedaje_Precio), M.Hospedaje_Incluye_Desayuno, M.Hospedaje_Nombre
		FROM gd_esquema.Maestra M 
			JOIN PLATENSE.Ciudad C ON C.nombre = M.Hospedaje_Ciudad
		WHERE M.Hospedaje_Nombre IS NOT NULL;
		PRINT 'Hospedajes migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Hospedajes',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarAgencias AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Agencia (nro_localidad, direccion, telefono, mail)
		SELECT DISTINCT L.nro_localidad, M.Agencia_Direccion, M.Agencia_Telefono, M.Agencia_Mail
		FROM gd_esquema.Maestra M 
		JOIN PLATENSE.Localidad L ON (L.nombre = M.Agencia_Localidad)
		JOIN PLATENSE.Provincia P ON (P.nro_provincia = L.nro_provincia)
		WHERE M.Agencia_Nro_Agencia IS NOT NULL AND
		p.nombre = M.Agencia_Provincia

		PRINT 'Agencias migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Agencias',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarAgentes AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Agente 
			(nro_legajo, nro_agencia ,nro_localidad ,nombre ,apellido ,domicilio ,dni ,fecha_nacimiento ,telefono ,mail)
		SELECT DISTINCT Agente_Legajo, A.nro_agencia, L.nro_localidad, Agente_Nombre, Agente_Apellido, 
		Agente_Direccion, Agente_Dni, Agente_Fecha_Nac, Agente_Telefono, Agente_Mail 
		FROM gd_esquema.Maestra 
		JOIN PLATENSE.Agencia A ON ( Agencia_Mail = A.mail)
		JOIN PLATENSE.Localidad L ON (L.nombre = Agente_Localidad)
		JOIN PLATENSE.Provincia P ON (L.nro_provincia = P.nro_provincia)
		WHERE Agente_Nombre IS NOT NULL AND
		p.nombre = Agente_Provincia
		PRINT 'Agentes migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Agentes',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarVuelos AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Vuelo (
			aerolinea_codigo, aeropuerto_codigo_origen, aeropuerto_codigo_destino, 
			fecha_salida, hora_salida, fecha_llegada, hora_llegada, precio, duracion, 
			incluye_carry, inlcuye_valija
		)
		SELECT DISTINCT M.Aerolinea_Codigo, M.Aeropuerto_Salida_Codigo, M.Aeropuerto_Llegada_Codigo,
		M.Vuelo_Fecha_Salida, M.Vuelo_Horario_Salida, M.Vuelo_Fecha_Llegada, M.Vuelo_Horario_Llegada,
		M.Vuelo_Precio, M.Vuelo_Duracion, M.Vuelo_Incluye_Carry, M.Vuelo_Incluye_Valija
		FROM gd_esquema.Maestra M
		WHERE M.Aerolinea_Codigo IS NOT NULL AND
			  M.Aeropuerto_Salida_Codigo IS NOT NULL AND 
			  M.Aeropuerto_Llegada_Codigo IS NOT NULL
		PRINT 'Vuelos migrados con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Vuelos',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarEncuestas_satifaccion AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Encuesta_Satisfaccion (nro_encuesta, nro_cliente, nro_agente, fecha, comentario)
		SELECT DISTINCT M.Encuesta_Codigo_Encuesta, C.nro_cliente, A.nro_legajo, M.Encuesta_Fecha_Encuesta, M.Encuesta_Comentarios
		FROM gd_esquema.Maestra M
			JOIN PLATENSE.Cliente C ON C.dni = M.Cliente_Dni
			JOIN PLATENSE.Agente A ON A.dni= M.Agente_Dni
		WHERE M.Encuesta_Codigo_Encuesta IS NOT NULL AND
			  M.Cliente_Dni IS NOT NULL AND
			  M.Agente_Dni IS NOT NULL AND
			  M.Encuesta_Fecha_Encuesta IS NOT NULL and
			  c.nombre = M.Cliente_Nombre


		PRINT 'Encuestas de satisfacción migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Encuestas de satisfacción',16,1)
	END CATCH
END
go

CREATE PROCEDURE migrarAspectosXEncuestas AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.AspectoXEncuesta (tipo_aspecto, nro_encuesta, puntaje)
		SELECT DISTINCT A.tipo_aspecto, M.Encuesta_Codigo_Encuesta, Detalle_Encuesta_Puntaje
		FROM gd_esquema.Maestra M
		JOIN PLATENSE.Aspecto A ON (A.descripcion = Aspecto_Aspecto)
		WHERE Detalle_Encuesta_Puntaje IS NOT NULL
		PRINT 'AspectoXEncuesta migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de AspectoXEncuesta',16,1)
	END CATCH
END
go
CREATE PROCEDURE migrarSolicitudes_cotizacion AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Solicitud_Cotizacion (
			nro_solicitud, nro_cliente, nro_agente, fecha_solicitud, fecha_inicio_tentativa, fecha_fin_tentativa,
			cantidad_dias, cantidad_pasajeros, observaciones, presupuesto_estimado,nro_ciudad
		)
		SELECT DISTINCT Solicitud_Nro_Solicitud, C.nro_cliente, A.nro_legajo,
		Solicitud_Fecha_Solicitud, Solicitud_Fecha_Inicio_Tentativa, Solicitud_Fecha_Fin_Tentativa,
		Detalle_Solicitud_Cant_Dias_Aprox, Solicitud_Cant_Pax, Solicitud_Observaciones, Solicitud_Presupuesto_Estimado,Ci.nro_ciudad
		FROM gd_esquema.Maestra 
		JOIN PLATENSE.Cliente C ON (C.dni = Cliente_Dni)
		JOIN PLATENSE.Agente A  ON (A.nro_legajo = Agente_Legajo)
		JOIN PLATENSE.Ciudad Ci ON (Ci.nombre = Detalle_Solicitud_Ciudad)
		WHERE Solicitud_Nro_Solicitud IS NOT NULL AND
		Cliente_Dni IS NOT NULL AND
		Agente_Legajo IS NOT NULL AND
		Detalle_Solicitud_Ciudad IS NOT NULL AND
		c.nombre = Cliente_Nombre

		PRINT 'Solicitud Cotizacion migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Solicitud Cotizacion',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarHabitaciones AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Habitacion 
						(nombre,descripcion,precio_noche,nro_hospedaje)
		SELECT DISTINCT Habitacion_Nombre, Habitacion_Descripcion, Habitacion_Precio_Noche, H.nro_hospedaje
		FROM gd_esquema.Maestra
		JOIN PLATENSE.Hospedaje H ON (H.precio = Detalle_Venta_Hospedaje_Precio_Unitario OR H.precio = Detalle_Propuesta_Hospedaje_Precio)
		WHERE Habitacion_Nombre IS NOT NULL
		PRINT 'Habitaciones migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Habitaciones',16,1)
	END CATCH
END
go


-- select distinct Solicitud_Nro_Solicitud from gd_esquema.Maestra

-- REVISAR
CREATE PROCEDURE migrarPropuestas_personalizadas AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Propuesta_Personalizada(
		nro_propuesta, nro_solicitud, nro_agente, nro_cliente, nro_estado, 
		fecha_emision, vigencia, fecha_desde, fecha_hasta, subtotal,descuento, importe_total)
		SELECT DISTINCT 
			M.Propuesta_Nro_Propuesta, M.Solicitud_Nro_Solicitud,
			M.Agente_Legajo, C.nro_cliente, E.nro_estado, M.Propuesta_Fecha_Emision,
			M.Propuesta_Vigencia_Hasta, M.Propuesta_Fecha_Desde, M.Propuesta_Fecha_Hasta,
			M.Propuesta_Subtotal, M.Propuesta_Descuento, M.Propuesta_Importe_Total
		FROM gd_esquema.Maestra M
		join PLATENSE.Cliente C ON C.dni = Cliente_Dni AND C.nombre = Cliente_Nombre
		join PLATENSE.Estado E ON E.nombre = Propuesta_Estado
		PRINT 'Propuestas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de propuestas',16,1)
	END CATCH
END
GO


CREATE PROCEDURE migrarPropuesta_vuelo AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Propuesta_vuelo (nro_propuesta, cantidad_pasajes, Precio, Subtotal)
		SELECT DISTINCT M.Propuesta_Nro_Propuesta, M.Detalle_Propuesta_Vuelo_Cant_Pasajes, M.Detalle_Propuesta_Vuelo_Precio, Detalle_Propuesta_Vuelo_Subtotal
		FROM gd_esquema.Maestra M
		where Detalle_Propuesta_Vuelo_Cant_Pasajes IS NOT NULL

		PRINT 'vuelos de propuestas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de vuelos de propuestas',16,1)
	END CATCH
END
GO


CREATE PROCEDURE migrarPropuesta_hospedaje AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Propuesta_hospedaje 
			(nro_propuesta, Fecha_Desde, Fecha_Hasta, Cant, Precio, Subtotal)
		SELECT DISTINCT 
		M.Propuesta_Nro_Propuesta, M.Detalle_Propuesta_Hospedaje_Fecha_Desde, 
		M.Detalle_Propuesta_Hospedaje_Fecha_Hasta, M.Detalle_Propuesta_Hospedaje_Cant, 
		M.Detalle_Propuesta_Hospedaje_Precio, M.Detalle_Propuesta_Hospedaje_Subtotal
		FROM gd_esquema.Maestra M
		WHERE Detalle_Propuesta_Hospedaje_Fecha_Desde IS NOT NULL AND
		Detalle_Propuesta_Hospedaje_Fecha_Hasta IS NOT NULL

		PRINT 'hospedajes de propuestas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de hospedajes de propuestas',16,1)
	END CATCH
END
GO




CREATE PROCEDURE migrarVentas AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Venta (nro_venta, nro_cliente, nro_agente, nro_canal_venta, nro_medio_pago, fecha, subtotal, descuento, importe_total)
			SELECT DISTINCT M.Venta_Nro_Venta, C.nro_cliente, M.Agente_Legajo, CV.nro_canal, MP.nro_medio,  
			M.Venta_Fecha_Venta, M.Venta_Subtotal, M.Venta_Descuento, M.Venta_Importe_Total
			FROM gd_esquema.Maestra M
				JOIN PLATENSE.Canal_venta CV ON M.Venta_Canal_Venta = CV.nombre
				JOIN PLATENSE.Medio_pago MP ON M.Venta_Medio_Pago = MP.nombre
				JOIN PLATENSE.Cliente C ON C.dni = Cliente_Dni AND C.nombre = Cliente_Nombre
				WHERE Venta_Nro_Venta IS NOT NULL
		PRINT 'Ventas migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de ventas',16,1)
	END CATCH
END
go
CREATE PROCEDURE migrarReservas_vuelo AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Reserva_Vuelo 
		(nro_venta, nro_vuelo, cantidad, precio, subtotal, cod_reserva)
		SELECT DISTINCT Ve.nro_venta, Vu.nro_vuelo, Detalle_Venta_Vuelo_Cantidad_Pasajes, 
		Detalle_Venta_Vuelo_Precio_Unitario, 
		Detalle_Venta_Vuelo_Subtotal, Detalle_Venta_Vuelo_Cod_Reserva
		FROM gd_esquema.Maestra 
		JOIN PLATENSE.Vuelo Vu ON (Vu.precio = Detalle_Venta_Vuelo_Precio_Unitario)
		JOIN PLATENSE.Venta Ve ON (Ve.nro_venta = Venta_Nro_Venta)
		WHERE 
		Detalle_Venta_Vuelo_Cod_Reserva IS NOT NULL
		PRINT 'Reservas Vuelos migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Reservas Vuelos',16,1)
	END CATCH
END
go
CREATE PROCEDURE migrarReservas_excursion AS
BEGIN
	BEGIN TRY
		INSERT INTO PLATENSE.Reserva_Excursion 
		(nro_venta, nro_excursion, fecha_realizacion, cantidad, precio, codigo_reserva, subtotal)
		SELECT DISTINCT Ve.nro_venta, Ex.nro_excursion, Detalle_Venta_Excursion_Fecha_Reserva, 
		Detalle_Venta_Excursion_Cant, Detalle_Venta_Excursion_Precio_Unitario,
		Detalle_Venta_Excursion_Cod_Reserva, Detalle_Venta_Excursion_Subtotal 
		FROM gd_esquema.Maestra
		JOIN PLATENSE.Excursion Ex ON (Ex.precio = Detalle_Venta_Excursion_Precio_Unitario)
		JOIN PLATENSE.Venta Ve ON (Ve.nro_venta = Venta_Nro_Venta)
		WHERE Detalle_Venta_Excursion_Cod_Reserva  
		IS NOT NULL
		PRINT 'Reservas Excursiones migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Reservas Excursiones',16,1)
	END CATCH
END

go
CREATE PROCEDURE migrarReservas_habitaciones AS
BEGIN
	BEGIN TRY
			INSERT INTO PLATENSE.Reserva_Habitacion 
					(nro_venta,codigo_habitacion,fecha_hora_ingreso,fecha_hora_egreso,cantidad_habitaciones,precio,codigo_reserva,subtotal) 
			SELECT DISTINCT 
			Ve.nro_venta, H.codigo_habitacion,  

			Detalle_Venta_Hospedaje_Fecha_Desde, Detalle_Venta_Hospedaje_Fecha_Hasta, 
			Detalle_Venta_Hospedaje_Cantidad, Detalle_Venta_Hospedaje_Precio_Unitario,
			Detalle_Venta_Hospedaje_Cod_Reserva, Detalle_Venta_Hospedaje_Subtotal 
			FROM gd_esquema.Maestra
			JOIN PLATENSE.Habitacion H ON (H.precio_noche = Detalle_Venta_Hospedaje_Precio_Unitario)
			JOIN PLATENSE.Venta Ve ON (Ve.nro_venta = Venta_Nro_Venta)
			WHERE Detalle_Venta_Hospedaje_Cod_Reserva IS NOT NULL
			PRINT 'Reservas Habitaciones migradas con exito'
	END TRY
	BEGIN CATCH
		RAISERROR('Error en la migración de Reservas Habitaciones',16,1)
	END CATCH
END
GO

CREATE PROCEDURE migrarTODO AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		EXEC migrarPaises
		EXEC migrarAlianzas
		EXEC migrarAspectos
		EXEC migrarCanales_venta
		EXEC migrarMedios_pago
		EXEC migrarEstados
		EXEC migrarProveedores
		EXEC migrarProvincias
		EXEC migrarAerolineas
		EXEC migrarExcursiones
		EXEC migrarCiudades
		EXEC migrarLocalidades
		EXEC migrarClientes
		EXEC migrarAeropuertos
		EXEC migrarHospedajes
		EXEC migrarAgencias
		EXEC migrarAgentes
		EXEC migrarVuelos
		EXEC migrarEncuestas_satifaccion
		EXEC migrarAspectosXEncuestas
		EXEC migrarSolicitudes_cotizacion
		EXEC migrarHabitaciones
		EXEC migrarPropuestas_personalizadas
		EXEC migrarPropuesta_hospedaje
		EXEC migrarPropuesta_vuelo
		EXEC migrarVentas
		EXEC migrarReservas_vuelo
		EXEC migrarReservas_excursion
		EXEC migrarReservas_habitaciones

		PRINT 'Todas las entidades migradas con exito'
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		
		RAISERROR('Error en la migración de todas las entidades: ',16,1)
	END CATCH
END
GO

EXEC migrarTODO