-- 02_seed_data.sql
-- Datos semilla para pruebas y demostración.
USE BibliotecaUTS;
GO

-- 10 alumnos de prueba.
INSERT INTO dbo.Alumnos (Matricula, Nombre, Correo, Carrera) VALUES
('5325100197', 'BRICEÑO FLORES ÁNGEL', '5325100197@uts.edu.mx', 'DSM'),
('5325100020', 'CRUZ IZAGUIRRE RAÚL', '5325100020@uts.edu.mx', 'DSM'),
('5325100019', 'CRUZ IZAGUIRRE SAÚL', '5325100019@uts.edu.mx', 'DSM'),
('5325100132', 'GAMBOA VÁZQUEZ JORGE LUIS', '5325100132@uts.edu.mx', 'DSM'),
('5325300002', 'GARCÍA MIRANDA IRVING ARIEL', '5325300002@uts.edu.mx', 'DSM'),
('5325100395', 'GASTÉLUM HERNÁNDEZ ESTRELLA', '5325100395@uts.edu.mx', 'DSM'),
('5325100011', 'MÁRQUEZ GARCÍA CAMILA VIDERI', '5325100011@uts.edu.mx', 'DSM'),
('5325100134', 'MARTÍNEZ RODRÍGUEZ JESÚS FERNANDO', '5325100134@uts.edu.mx', 'DSM'),
('5325100006', 'MENERA LÓPEZ PABLO NOÉ', '5325100006@uts.edu.mx', 'DSM'),
('5324100130', 'MERAZ ROCHA HARRY DANIEL', '5324100130@uts.edu.mx', 'DSM');
GO

-- 5 impresoras.
INSERT INTO dbo.Impresoras (Nombre, Ubicacion, Estado, Tipo) VALUES
('Impresora Biblioteca 01', 'Biblioteca - Recepción', 'Disponible', 'Blanco y negro'),
('Impresora Biblioteca 02', 'Biblioteca - Recepción', 'Ocupada', 'Color'),
('Impresora Centro de Cómputo 01', 'Centro de Cómputo', 'Disponible', 'Color'),
('Impresora Centro de Cómputo 02', 'Centro de Cómputo', 'Disponible', 'Blanco y negro'),
('Impresora Administración', 'Área administrativa', 'Fuera de servicio', 'Blanco y negro');
GO

-- 10 solicitudes de impresión.
INSERT INTO dbo.SolicitudesImpresion
(Matricula, NombreArchivo, RutaArchivo, TipoImpresion, CantidadCopias,
 NumeroPaginas, FechaSolicitud, FechaRecogida, HoraRecogida, Estado,
 IdImpresora, MetodoPago, CostoTotal, EstadoPago)
VALUES
('5325100197','tarea_bd.pdf','C:\Biblioteca\5325100197\tarea_bd.pdf','Blanco y negro',2,5,'2026-08-18 08:30','2026-08-18','10:00','Completada',1,'Efectivo',10.00,'Pagado'),
('5325100020','reporte_sql.pdf','C:\Biblioteca\5325100020\reporte_sql.pdf','Color',1,8,'2026-08-18 09:15','2026-08-18','11:00','Lista para recoger',2,'Tarjeta',24.00,'Pagado'),
('5325100019','investigacion.docx','C:\Biblioteca\5325100019\investigacion.docx','Blanco y negro',3,10,'2026-08-18 10:00','2026-08-18','13:00','En proceso',1,'Transferencia',30.00,'Pagado'),
('5325100132','presentacion.pdf','C:\Biblioteca\5325100132\presentacion.pdf','Color',2,12,'2026-08-18 10:45','2026-08-19','09:30','En espera',3,NULL,72.00,'Pendiente'),
('5325300002','actividad_01.pdf','C:\Biblioteca\5325300002\actividad_01.pdf','Blanco y negro',1,4,'2026-08-18 11:20','2026-08-19','10:30','Completada',4,'Efectivo',8.00,'Pagado'),
('5325100395','ensayo.docx','C:\Biblioteca\5325100395\ensayo.docx','Blanco y negro',2,7,'2026-08-18 12:10','2026-08-19','12:00','Cancelada',1,'Efectivo',28.00,'Cancelado'),
('5325100011','proyecto_final.pdf','C:\Biblioteca\5325100011\proyecto_final.pdf','Color',1,15,'2026-08-19 08:20','2026-08-19','14:00','Lista para recoger',2,'Tarjeta',45.00,'Pagado'),
('5325100134','diagrama_bd.png','C:\Biblioteca\5325100134\diagrama_bd.png','Color',3,3,'2026-08-19 09:40','2026-08-20','10:00','En proceso',3,'Transferencia',27.00,'Pagado'),
('5325100006','manual_usuario.pdf','C:\Biblioteca\5325100006\manual_usuario.pdf','Blanco y negro',2,9,'2026-08-19 11:00','2026-08-20','12:30','En espera',4,NULL,36.00,'Pendiente'),
('5324100130','evidencias.pdf','C:\Biblioteca\5324100130\evidencias.pdf','Blanco y negro',1,6,'2026-08-19 13:30','2026-08-20','15:00','En espera',1,NULL,12.00,'Pendiente');
GO
