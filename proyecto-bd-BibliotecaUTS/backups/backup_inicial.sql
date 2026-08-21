-- backup_inicial.sql
-- Ejecutar en SQL Server con una cuenta que tenga permisos para respaldar la BD.
-- Cambiar la ruta si SQL Server no tiene acceso a C:\Backups.
USE master;
GO
BACKUP DATABASE BibliotecaUTS
TO DISK = 'C:\Backups\BibliotecaUTS_backup_inicial.bak'
WITH INIT, FORMAT,
     NAME = 'Backup inicial BibliotecaUTS';
GO
