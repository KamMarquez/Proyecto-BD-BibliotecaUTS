-- 04_dml_analitico_avanzado.sql
-- Consultas de reportes, JOIN, agregación, agrupación y HAVING.
USE BibliotecaUTS;
GO

-- 1) JOIN: detalle de solicitudes con datos del alumno y la impresora.
-- Pregunta de negocio: ¿qué alumno solicitó cada impresión y qué impresora se utilizó?
SELECT s.IdSolicitud, s.Matricula, a.Nombre AS Alumno,
       s.NombreArchivo, s.TipoImpresion, s.CantidadCopias,
       s.Estado, i.Nombre AS Impresora
FROM dbo.SolicitudesImpresion AS s
INNER JOIN dbo.Alumnos AS a
    ON a.Matricula = s.Matricula
LEFT JOIN dbo.Impresoras AS i
    ON i.IdImpresora = s.IdImpresora
ORDER BY s.IdSolicitud;
GO

-- 2) JOIN: solicitudes por carrera.
-- Pregunta de negocio: ¿cuántas solicitudes y cuántas copias corresponden a cada carrera?
SELECT a.Carrera,
       COUNT(s.IdSolicitud) AS TotalSolicitudes,
       SUM(s.CantidadCopias) AS TotalCopias
FROM dbo.SolicitudesImpresion AS s
INNER JOIN dbo.Alumnos AS a
    ON a.Matricula = s.Matricula
GROUP BY a.Carrera
ORDER BY TotalSolicitudes DESC;
GO

-- 3) JOIN: impresoras y solicitudes atendidas.
-- Pregunta de negocio: ¿cuántas solicitudes ha atendido cada impresora?
SELECT i.IdImpresora, i.Nombre AS Impresora,
       i.Tipo, COUNT(s.IdSolicitud) AS TotalSolicitudes,
       SUM(ISNULL(s.CantidadCopias, 0)) AS TotalCopias
FROM dbo.Impresoras AS i
LEFT JOIN dbo.SolicitudesImpresion AS s
    ON s.IdImpresora = i.IdImpresora
GROUP BY i.IdImpresora, i.Nombre, i.Tipo
ORDER BY TotalSolicitudes DESC;
GO

-- 4) AGREGACIÓN: solicitudes por estado.
-- Pregunta de negocio: ¿cómo se distribuye la carga de trabajo según el estado?
SELECT Estado,
       COUNT(*) AS TotalSolicitudes,
       SUM(CantidadCopias) AS TotalCopias,
       AVG(CostoTotal) AS CostoPromedio,
       MAX(CostoTotal) AS CostoMaximo,
       MIN(CostoTotal) AS CostoMinimo
FROM dbo.SolicitudesImpresion
GROUP BY Estado
ORDER BY TotalSolicitudes DESC;
GO

-- 5) AGREGACIÓN: impresiones por tipo.
-- Pregunta de negocio: ¿qué tipo de impresión tiene mayor demanda?
SELECT TipoImpresion,
       COUNT(*) AS TotalSolicitudes,
       SUM(CantidadCopias) AS TotalCopias,
       SUM(NumeroPaginas * CantidadCopias) AS PaginasImpresas,
       AVG(CostoTotal) AS CostoPromedio
FROM dbo.SolicitudesImpresion
GROUP BY TipoImpresion
ORDER BY PaginasImpresas DESC;
GO

-- 6) AGREGACIÓN: pagos por método.
-- Pregunta de negocio: ¿cuánto dinero se ha registrado por cada método de pago?
SELECT MetodoPago,
       COUNT(*) AS TotalPagos,
       SUM(CostoTotal) AS IngresoTotal,
       AVG(CostoTotal) AS TicketPromedio,
       MAX(CostoTotal) AS PagoMayor,
       MIN(CostoTotal) AS PagoMenor
FROM dbo.SolicitudesImpresion
WHERE EstadoPago = 'Pagado'
GROUP BY MetodoPago;
GO

-- 7) HAVING: alumnos con más de una solicitud.
-- Pregunta de negocio: ¿qué alumnos han utilizado el servicio más de una vez?
SELECT a.Matricula, a.Nombre,
       COUNT(s.IdSolicitud) AS TotalSolicitudes
FROM dbo.Alumnos AS a
INNER JOIN dbo.SolicitudesImpresion AS s
    ON s.Matricula = a.Matricula
GROUP BY a.Matricula, a.Nombre
HAVING COUNT(s.IdSolicitud) > 1
ORDER BY TotalSolicitudes DESC;
GO

-- 8) HAVING: impresoras con promedio de copias mayor a 1.
-- Pregunta de negocio: ¿qué impresoras reciben solicitudes de mayor volumen?
SELECT i.IdImpresora, i.Nombre,
       COUNT(s.IdSolicitud) AS TotalSolicitudes,
       AVG(CAST(s.CantidadCopias AS DECIMAL(10,2))) AS PromedioCopias
FROM dbo.Impresoras AS i
INNER JOIN dbo.SolicitudesImpresion AS s
    ON s.IdImpresora = i.IdImpresora
GROUP BY i.IdImpresora, i.Nombre
HAVING AVG(CAST(s.CantidadCopias AS DECIMAL(10,2))) > 1
ORDER BY PromedioCopias DESC;
GO
