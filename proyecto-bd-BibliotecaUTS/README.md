# Proyecto Integrador - Capa de Base de Datos

## Proyecto
**BibliotecaUTS - Sistema de solicitudes de impresión**

## Integrantes
- Camila Videri Marquez Garcia

## Problema
El sistema busca digitalizar la gestión de solicitudes de impresión de estudiantes de la biblioteca, permitiendo registrar archivos, tipo de impresión, copias, páginas, fecha y hora de recogida, impresora, costo y estado del pago.

## Tecnologías
- Microsoft SQL Server
- SQL
- Windows Forms (aplicación consumidora de la base de datos)
- Git y GitHub

## Estructura

```text
proyecto-bd-BibliotecaUTS/
├── README.md
├── docs/
│   ├── etapa-1-requerimientos/
│   │   ├── historias_usuario.pdf
│   │   ├── especificaciones_tecnicas.pdf
│   │   └── modelo_dominio.png
│   └── etapa-2-modelado/
│       ├── diagrama_entidad_relacion.png
│       ├── diagrama_relacional.png
│       └── diccionario_datos.xlsx
├── sql/
│   ├── 01_ddl_schema.sql
│   ├── 02_seed_data.sql
│   ├── 03_dml_transaccional.sql
│   └── 04_dml_analitico_avanzado.sql
└── backups/
    └── backup_inicial.sql
```

## Orden de ejecución

1. `sql/01_ddl_schema.sql`
2. `sql/02_seed_data.sql`
3. `sql/03_dml_transaccional.sql`
4. `sql/04_dml_analitico_avanzado.sql`
5. Opcional: `backups/backup_inicial.sql` para generar el respaldo `.bak`.

## Modelo de datos

- **Alumnos**: almacena la matrícula, nombre, correo y carrera.
- **Impresoras**: almacena las impresoras disponibles, su ubicación, estado y tipo.
- **SolicitudesImpresion**: registra cada solicitud y relaciona al alumno con una impresora.

Relaciones:
- Un alumno puede tener muchas solicitudes.
- Una impresora puede estar asociada a muchas solicitudes.
- Cada solicitud pertenece a un alumno y puede tener una impresora asignada.

## Validaciones principales

Se utilizan `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `DEFAULT`, `CHECK` e índices para mantener la integridad de los datos y facilitar las búsquedas.

## Consultas analíticas

El archivo `04_dml_analitico_avanzado.sql` contiene:
- 3 consultas con `INNER JOIN`.
- 3 consultas de agregación y agrupación.
- 2 consultas con `HAVING`.
- Comentarios que explican la pregunta de negocio de cada consulta.
