🎬 Sistema de Alquiler de Películas – Examen Final SQL
📘 Descripción del Proyecto
Este proyecto consiste en el desarrollo de una base de datos relacional orientada al sistema de alquiler de películas. Como parte del examen final, se ha implementado una solución completa que abarca:

Creación de tablas y relaciones entre entidades.

Inserción de datos relevantes para simular un entorno real.

Consultas SQL avanzadas para obtener estadísticas y métricas.

Funciones SQL personalizadas para cálculos específicos.

Triggers para mantener la integridad de los datos y registrar eventos.

Eventos SQL programados para tareas automáticas periódicas.

El objetivo es simular un sistema real de una videotienda digital, gestionando clientes, películas, alquileres, empleados, idiomas y categorías.

📊 Funcionalidades Implementadas
1. Consultas SQL destacadas:
Cliente con más alquileres en 6 meses

Películas más alquiladas del año

Ingresos por categoría

Clientes que alquilaron todas las películas de una categoría

Ciudades con más clientes activos

Alquiler promedio por idioma y cliente

Alquileres diarios por almacén

2. Funciones SQL:

TotalIngresosCliente(ClienteID, Año)

PromedioDuracionAlquiler(PeliculaID)

IngresosPorCategoria(CategoriaID)

DescuentoFrecuenciaCliente(ClienteID)

EsClienteVIP(ClienteID)

3. Triggers:

ActualizarTotalAlquileresEmpleado

AuditarActualizacionCliente

RegistrarHistorialDeCosto

NotificarEliminacionAlquiler

RestringirAlquilerConSaldoPendiente

4. Eventos Programados:

InformeAlquileresMensual

ActualizarSaldoPendienteCliente

AlertaPeliculasNoAlquiladas

LimpiarAuditoriaCada6Meses

ActualizarCategoriasPopulares

🧩 Diagrama Relacional
El archivo Diagrama.jpg incluido representa el modelo entidad-relación (MER) de la base de datos. Incluye entidades como Cliente, Empleado, Película, Alquiler, Categoría, Idioma, etc., con sus respectivas claves primarias y foráneas.

👤 Autor y Contacto
Nombre: [Edwin Camilo Corzo Sanchez]
Correo: [corzosanchezedwincamilo971@gmail.com]
Fecha de entrega: Julio 2025
Profesor: [Johlver Pardo]

