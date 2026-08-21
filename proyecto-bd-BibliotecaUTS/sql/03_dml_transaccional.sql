-- 03_dml_transaccional.sql
-- Operaciones CRUD y procedimientos almacenados usados por la aplicación Windows Forms.
USE BibliotecaUTS;
GO

IF OBJECT_ID(N'dbo.sp_InsertarSolicitud', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_InsertarSolicitud;
GO
CREATE PROCEDURE dbo.sp_InsertarSolicitud
    @Matricula VARCHAR(20),
    @NombreArchivo VARCHAR(255),
    @RutaArchivo VARCHAR(500),
    @TipoImpresion VARCHAR(20),
    @CantidadCopias INT,
    @NumeroPaginas INT,
    @FechaRecogida DATE,
    @HoraRecogida VARCHAR(10),
    @IdImpresora INT = NULL,
    @MetodoPago VARCHAR(20) = NULL,
    @CostoTotal DECIMAL(10,2) = NULL,
    @EstadoPago VARCHAR(20) = N'Pendiente',
    @IdSolicitud INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.SolicitudesImpresion
    (Matricula, NombreArchivo, RutaArchivo, TipoImpresion, CantidadCopias,
     NumeroPaginas, FechaRecogida, HoraRecogida, Estado, IdImpresora,
     MetodoPago, CostoTotal, EstadoPago)
    VALUES
    (@Matricula, @NombreArchivo, @RutaArchivo, @TipoImpresion, @CantidadCopias,
     @NumeroPaginas, @FechaRecogida, @HoraRecogida, N'En espera', @IdImpresora,
     @MetodoPago, @CostoTotal, @EstadoPago);

    SET @IdSolicitud = CONVERT(INT, SCOPE_IDENTITY());
END
GO

IF OBJECT_ID(N'dbo.sp_ObtenerSolicitudes', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ObtenerSolicitudes;
GO
CREATE PROCEDURE dbo.sp_ObtenerSolicitudes
    @Texto VARCHAR(255) = NULL,
    @Estado VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT s.IdSolicitud, s.Matricula, a.Nombre, a.Correo,
           s.NombreArchivo, s.RutaArchivo, s.TipoImpresion,
           s.CantidadCopias, s.NumeroPaginas, s.FechaSolicitud,
           s.FechaRecogida, s.HoraRecogida, s.Estado,
           s.IdImpresora, i.Nombre AS NombreImpresora,
           s.MetodoPago, s.CostoTotal, s.EstadoPago
    FROM dbo.SolicitudesImpresion AS s
    INNER JOIN dbo.Alumnos AS a ON a.Matricula = s.Matricula
    LEFT JOIN dbo.Impresoras AS i ON i.IdImpresora = s.IdImpresora
    WHERE (@Texto IS NULL OR @Texto = ''
           OR s.Matricula LIKE '%' + @Texto + '%'
           OR a.Nombre LIKE '%' + @Texto + '%'
           OR s.NombreArchivo LIKE '%' + @Texto + '%')
      AND (@Estado IS NULL OR @Estado = '' OR s.Estado = @Estado)
    ORDER BY s.FechaSolicitud DESC;
END
GO

IF OBJECT_ID(N'dbo.sp_ObtenerSolicitudPorId', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ObtenerSolicitudPorId;
GO
CREATE PROCEDURE dbo.sp_ObtenerSolicitudPorId
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT s.IdSolicitud, s.Matricula, a.Nombre, a.Correo,
           s.NombreArchivo, s.RutaArchivo, s.TipoImpresion,
           s.CantidadCopias, s.NumeroPaginas, s.FechaSolicitud,
           s.FechaRecogida, s.HoraRecogida, s.Estado,
           s.IdImpresora, i.Nombre AS NombreImpresora,
           s.MetodoPago, s.CostoTotal, s.EstadoPago
    FROM dbo.SolicitudesImpresion AS s
    INNER JOIN dbo.Alumnos AS a ON a.Matricula = s.Matricula
    LEFT JOIN dbo.Impresoras AS i ON i.IdImpresora = s.IdImpresora
    WHERE s.IdSolicitud = @IdSolicitud;
END
GO

IF OBJECT_ID(N'dbo.sp_ActualizarSolicitud', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ActualizarSolicitud;
GO
CREATE PROCEDURE dbo.sp_ActualizarSolicitud
    @IdSolicitud INT,
    @TipoImpresion VARCHAR(20),
    @CantidadCopias INT,
    @FechaRecogida DATE,
    @HoraRecogida VARCHAR(10),
    @Estado VARCHAR(20),
    @IdImpresora INT = NULL,
    @MetodoPago VARCHAR(20) = NULL,
    @CostoTotal DECIMAL(10,2) = NULL,
    @EstadoPago VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS
    (
        SELECT 1 FROM dbo.SolicitudesImpresion
        WHERE IdSolicitud = @IdSolicitud
    )
    BEGIN
        THROW 50001, 'No existe la solicitud con el ID especificado.', 1;
    END;

    UPDATE dbo.SolicitudesImpresion
    SET TipoImpresion = @TipoImpresion,
        CantidadCopias = @CantidadCopias,
        FechaRecogida = @FechaRecogida,
        HoraRecogida = @HoraRecogida,
        Estado = @Estado,
        IdImpresora = @IdImpresora,
        MetodoPago = @MetodoPago,
        CostoTotal = @CostoTotal,
        EstadoPago = COALESCE(@EstadoPago, EstadoPago)
    WHERE IdSolicitud = @IdSolicitud;
END
GO

IF OBJECT_ID(N'dbo.sp_ActualizarEstadoSolicitud', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_ActualizarEstadoSolicitud;
GO
CREATE PROCEDURE dbo.sp_ActualizarEstadoSolicitud
    @IdSolicitud INT,
    @Estado VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE dbo.SolicitudesImpresion
    SET Estado = @Estado
    WHERE IdSolicitud = @IdSolicitud;
END
GO

IF OBJECT_ID(N'dbo.sp_EliminarSolicitud', N'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_EliminarSolicitud;
GO
CREATE PROCEDURE dbo.sp_EliminarSolicitud
    @IdSolicitud INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM dbo.SolicitudesImpresion
    WHERE IdSolicitud = @IdSolicitud;
END
GO

-- Ejemplos de uso directo de las operaciones transaccionales.
-- INSERT: se ejecuta mediante el procedimiento almacenado.
DECLARE @NuevoId INT;
EXEC dbo.sp_InsertarSolicitud
    @Matricula = '5325100197',
    @NombreArchivo = 'ejemplo_crud.pdf',
    @RutaArchivo = 'C:\Biblioteca\ejemplo_crud.pdf',
    @TipoImpresion = 'Blanco y negro',
    @CantidadCopias = 1,
    @NumeroPaginas = 2,
    @FechaRecogida = '2026-08-21',
    @HoraRecogida = '09:00',
    @IdImpresora = 1,
    @MetodoPago = 'Efectivo',
    @CostoTotal = 4.00,
    @EstadoPago = 'Pendiente',
    @IdSolicitud = @NuevoId OUTPUT;
SELECT @NuevoId AS IdSolicitudGenerada;
GO

-- SELECT puntual.
SELECT *
FROM dbo.SolicitudesImpresion
WHERE IdSolicitud = 1;
GO

-- UPDATE de prueba: cambia solamente el estado y después se restaura.
UPDATE dbo.SolicitudesImpresion
SET Estado = 'En proceso'
WHERE IdSolicitud = 1;
GO

-- DELETE de prueba: elimina la solicitud creada arriba.
-- Se usa el ID generado por la operación INSERT anterior en una ejecución independiente.
-- Si se ejecuta como bloque completo, el ID recién creado es el mayor ID.
DELETE FROM dbo.SolicitudesImpresion
WHERE IdSolicitud = (SELECT MAX(IdSolicitud) FROM dbo.SolicitudesImpresion);
GO
