-- 01_ddl_schema.sql
-- Base de datos: BibliotecaUTS
-- Definición del esquema, claves, restricciones e índices.

IF DB_ID(N'BibliotecaUTS') IS NULL
BEGIN
    CREATE DATABASE BibliotecaUTS;
END
GO

USE BibliotecaUTS;
GO

-- Tablas hijas primero se eliminan para permitir ejecutar nuevamente el script.
IF OBJECT_ID(N'dbo.SolicitudesImpresion', N'U') IS NOT NULL
    DROP TABLE dbo.SolicitudesImpresion;
GO
IF OBJECT_ID(N'dbo.Impresoras', N'U') IS NOT NULL
    DROP TABLE dbo.Impresoras;
GO
IF OBJECT_ID(N'dbo.Alumnos', N'U') IS NOT NULL
    DROP TABLE dbo.Alumnos;
GO

-- Tabla padre: alumnos.
CREATE TABLE dbo.Alumnos
(
    Matricula VARCHAR(20) NOT NULL
        CONSTRAINT PK_Alumnos PRIMARY KEY,
    Nombre VARCHAR(150) NOT NULL,
    Correo VARCHAR(150) NULL,
    Carrera VARCHAR(100) NULL
);
GO

-- Catálogo de impresoras.
CREATE TABLE dbo.Impresoras
(
    IdImpresora INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_Impresoras PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Ubicacion VARCHAR(100) NULL,
    Estado VARCHAR(20) NOT NULL
        CONSTRAINT DF_Impresoras_Estado DEFAULT N'Disponible'
        CONSTRAINT CK_Impresoras_Estado
            CHECK (Estado IN (N'Disponible', N'Ocupada', N'Fuera de servicio')),
    Tipo VARCHAR(20) NOT NULL
        CONSTRAINT DF_Impresoras_Tipo DEFAULT N'Blanco y negro'
        CONSTRAINT CK_Impresoras_Tipo
            CHECK (Tipo IN (N'Blanco y negro', N'Color'))
);
GO

-- Tabla transaccional de solicitudes de impresión.
CREATE TABLE dbo.SolicitudesImpresion
(
    IdSolicitud INT IDENTITY(1,1) NOT NULL
        CONSTRAINT PK_SolicitudesImpresion PRIMARY KEY,
    Matricula VARCHAR(20) NOT NULL
        CONSTRAINT FK_Solicitudes_Alumnos
            REFERENCES dbo.Alumnos(Matricula),
    NombreArchivo VARCHAR(255) NOT NULL,
    RutaArchivo VARCHAR(500) NOT NULL,
    TipoImpresion VARCHAR(20) NOT NULL
        CONSTRAINT CK_TipoImpresion
            CHECK (TipoImpresion IN (N'Blanco y negro', N'Color')),
    CantidadCopias INT NOT NULL
        CONSTRAINT CK_CantidadCopias CHECK (CantidadCopias > 0),
    NumeroPaginas INT NOT NULL
        CONSTRAINT CK_NumeroPaginas CHECK (NumeroPaginas > 0),
    FechaSolicitud DATETIME NOT NULL
        CONSTRAINT DF_Solicitudes_FechaSolicitud DEFAULT GETDATE(),
    FechaRecogida DATE NOT NULL,
    HoraRecogida VARCHAR(10) NOT NULL,
    Estado VARCHAR(20) NOT NULL
        CONSTRAINT DF_Solicitudes_Estado DEFAULT N'En espera'
        CONSTRAINT CK_Estado
            CHECK (Estado IN
                (N'En espera', N'En proceso', N'Lista para recoger',
                 N'Completada', N'Cancelada')),
    IdImpresora INT NULL
        CONSTRAINT FK_Solicitudes_Impresoras
            REFERENCES dbo.Impresoras(IdImpresora),
    MetodoPago VARCHAR(20) NULL
        CONSTRAINT CK_MetodoPago
            CHECK (MetodoPago IS NULL OR
                   MetodoPago IN (N'Efectivo', N'Tarjeta', N'Transferencia')),
    CostoTotal DECIMAL(10,2) NULL
        CONSTRAINT CK_CostoTotal
            CHECK (CostoTotal IS NULL OR CostoTotal >= 0),
    EstadoPago VARCHAR(20) NOT NULL
        CONSTRAINT DF_Solicitudes_EstadoPago DEFAULT N'Pendiente'
        CONSTRAINT CK_EstadoPago
            CHECK (EstadoPago IN (N'Pendiente', N'Pagado', N'Cancelado'))
);
GO

CREATE INDEX IX_SolicitudesImpresion_Matricula
    ON dbo.SolicitudesImpresion(Matricula);
GO

CREATE INDEX IX_SolicitudesImpresion_Estado
    ON dbo.SolicitudesImpresion(Estado);
GO
