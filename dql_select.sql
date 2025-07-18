-- 1. Encuentra el cliente que ha realizado la mayor cantidad de alquileres en los últimos 6 meses.
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(a.id_alquiler) AS total_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY c.id_cliente
ORDER BY total_alquileres DESC
LIMIT 1;

-- 2.Lista las cinco películas más alquiladas durante el último año.
SELECT p.titulo, COUNT(a.id_alquiler) AS veces_alquilada
FROM alquiler a
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY p.id_pelicula
ORDER BY veces_alquilada DESC
LIMIT 5;

-- 3. Obtén el total de ingresos y la cantidad de alquileres realizados por cada categoría de película.
SELECT c.nombre AS categoria, COUNT(a.id_alquiler) AS total_alquileres, SUM(pago.total) AS ingresos
FROM categoria c
JOIN pelicula_categoria pc ON c.id_categoria = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
JOIN pago ON a.id_alquiler = pago.id_alquiler
GROUP BY c.id_categoria;

-- 4. Calcula el número total de clientes que han realizado alquileres por cada idioma disponible en un mes específico.
SELECT i.nombre AS idioma, COUNT(DISTINCT a.id_cliente) AS clientes
FROM alquiler a
JOIN inventario inv ON a.id_inventario = inv.id_inventario
JOIN pelicula p ON inv.id_pelicula = p.id_pelicula
JOIN idioma i ON p.id_idioma = i.id_idioma
WHERE MONTH(a.fecha_alquiler) = 3 AND YEAR(a.fecha_alquiler) = 2025
GROUP BY i.id_idioma;

-- 5. Encuentra a los clientes que han alquilado todas las películas de una misma categoría.
SELECT c.id_cliente, c.nombre, c.apellidos
FROM cliente c
WHERE NOT EXISTS (
  SELECT pc.id_pelicula
  FROM pelicula_categoria pc
  WHERE pc.id_categoria = 1 
  AND NOT EXISTS (
    SELECT 1
    FROM alquiler a
    JOIN inventario i ON a.id_inventario = i.id_inventario
    WHERE a.id_cliente = c.id_cliente
    AND i.id_pelicula = pc.id_pelicula
  )
);

-- 6.Lista las tres ciudades con más clientes activos en el último trimestre
SELECT ci.nombre AS ciudad, COUNT(DISTINCT cl.id_cliente) AS clientes_activos
FROM ciudad ci
JOIN direccion d ON ci.id_ciudad = d.id_ciudad
JOIN cliente cl ON d.id_direccion = cl.id_direccion
JOIN alquiler a ON cl.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY ci.id_ciudad
ORDER BY clientes_activos DESC
LIMIT 3;

-- 7.Muestra las cinco categorías con menos alquileres registrados en el último año.
SELECT c.nombre, COUNT(a.id_alquiler) AS total_alquileres
FROM categoria c
JOIN pelicula_categoria pc ON c.id_categoria = pc.id_categoria
JOIN pelicula p ON pc.id_pelicula = p.id_pelicula
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
GROUP BY c.id_categoria
ORDER BY total_alquileres ASC
LIMIT 5;

-- 8. Calcula el promedio de días que un cliente tarda en devolver las películas alquiladas.
SELECT c.id_cliente, c.nombre, c.apellidos,
AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS promedio_dias
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente;

-- 9. Encuentra los cinco empleados que gestionaron más alquileres en la categoría de Acción.
SELECT e.id_empleado, e.nombre, e.apellidos, COUNT(a.id_alquiler) AS total_alquileres
FROM empleado e
JOIN alquiler a ON e.id_empleado = a.id_empleado
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria c ON pc.id_categoria = c.id_categoria
WHERE c.nombre = 'Acción'
GROUP BY e.id_empleado
ORDER BY total_alquileres DESC
LIMIT 5;

-- 10. Genera un informe de los clientes con alquileres más recurrentes.
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(a.id_alquiler) AS cantidad_alquileres
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
GROUP BY c.id_cliente
ORDER BY cantidad_alquileres DESC
LIMIT 10;

-- 11. Calcula el costo promedio de alquiler por idioma de las películas.
SELECT i.nombre AS idioma, AVG(p.total) AS promedio_monto
FROM idioma i
JOIN pelicula p1 ON i.id_idioma = p1.id_idioma
JOIN inventario i2 ON p1.id_pelicula = i2.id_pelicula
JOIN alquiler a ON i2.id_inventario = a.id_inventario
JOIN pago p ON a.id_alquiler = p.id_alquiler
GROUP BY i.id_idioma;

-- 12. Lista las cinco películas con mayor duración alquiladas en el último año.
SELECT p.titulo, p.duracion
FROM pelicula p
JOIN inventario i ON p.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.duracion DESC
LIMIT 5;

-- 13. Muestra los clientes que más alquilaron películas de Comedia.
SELECT c.id_cliente, c.nombre, c.apellidos, COUNT(*) AS total
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN inventario i ON a.id_inventario = i.id_inventario
JOIN pelicula p ON i.id_pelicula = p.id_pelicula
JOIN pelicula_categoria pc ON p.id_pelicula = pc.id_pelicula
JOIN categoria cat ON pc.id_categoria = cat.id_categoria
WHERE cat.nombre = 'Comedia'
GROUP BY c.id_cliente
ORDER BY total DESC
LIMIT 10;

-- 14.Encuentra la cantidad total de días alquilados por cada cliente en el último mes.
SELECT c.id_cliente, c.nombre, c.apellidos,
SUM(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler)) AS total_dias
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
  AND a.fecha_devolucion IS NOT NULL
GROUP BY c.id_cliente;

-- 15. Muestra el número de alquileres diarios en cada almacén durante el último trimestre.
SELECT a.id_almacen, DATE(al.fecha_alquiler) AS fecha, COUNT(al.id_alquiler) AS total
FROM alquiler al
JOIN inventario i ON al.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE al.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY a.id_almacen, DATE(al.fecha_alquiler)
ORDER BY a.id_almacen, fecha;

-- 16. Calcula los ingresos totales generados por cada almacén en el último semestre.
SELECT a.id_almacen, SUM(p.total) AS total_ingresos
FROM pago p
JOIN alquiler al ON p.id_alquiler = al.id_alquiler
JOIN inventario i ON al.id_inventario = i.id_inventario
JOIN almacen a ON i.id_almacen = a.id_almacen
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
GROUP BY a.id_almacen;

-- 17. Encuentra el cliente que ha realizado el alquiler más caro en el último año.
SELECT c.id_cliente, c.nombre, c.apellidos, p.total
FROM cliente c
JOIN alquiler a ON c.id_cliente = a.id_cliente
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
ORDER BY p.total DESC
LIMIT 1;

-- 18. Lista las cinco categorías con más ingresos generados durante los últimos tres meses.
SELECT c.nombre, SUM(p.total) AS ingresos
FROM categoria c
JOIN pelicula_categoria pc ON c.id_categoria = pc.id_categoria
JOIN pelicula p1 ON pc.id_pelicula = p1.id_pelicula
JOIN inventario i ON p1.id_pelicula = i.id_pelicula
JOIN alquiler a ON i.id_inventario = a.id_inventario
JOIN pago p ON a.id_alquiler = p.id_alquiler
WHERE p.fecha_pago >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
GROUP BY c.id_categoria
ORDER BY ingresos DESC
LIMIT 5;

-- 19. Obtén la cantidad de películas alquiladas por cada idioma en el último mes.
SELECT i.nombre AS idioma, COUNT(DISTINCT a.id_alquiler) AS total_alquileres
FROM idioma i
JOIN pelicula p ON i.id_idioma = p.id_idioma
JOIN inventario inv ON p.id_pelicula = inv.id_pelicula
JOIN alquiler a ON inv.id_inventario = a.id_inventario
WHERE a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH)
GROUP BY i.id_idioma;

-- 20. Lista los clientes que no han realizado ningún alquiler en el último año.
SELECT c.id_cliente, c.nombre, c.apellidos
FROM cliente c
LEFT JOIN alquiler a ON c.id_cliente = a.id_cliente
AND a.fecha_alquiler >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
WHERE a.id_alquiler IS NULL;