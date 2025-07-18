-- 1. TotalIngresosCliente(ClienteID, Año): Calcula los ingresos generados por un cliente en un año específico.
DELIMITER //
CREATE FUNCTION TotalIngresosCliente(id_cliente INT, anio INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(p.total)
    INTO total
    FROM pago p
    INNER JOIN rental a ON p.id_alquiler = a.id_alquiler
    WHERE p.id_cliente = id_cliente
      AND YEAR(p.fecha_pago) = anio;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- 2. PromedioDuracionAlquiler(PeliculaID): Retorna la duración promedio de alquiler de una película específica.
DELIMITER //
CREATE FUNCTION PromedioDuracionAlquiler(id_pelicula INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(DATEDIFF(a.fecha_devolucion, a.fecha_alquiler))
    INTO promedio
    FROM alquiler a
    INNER JOIN inventario i ON a.id_inventario = i.id_inventario
    WHERE i.film_id = id_pelicula;
    RETURN IFNULL(promedio, 0);
END;
//
DELIMITER ;

-- 3. IngresosPorCategoria(CategoriaID): Calcula los ingresos totales generados por una categoría específica de películas.
DELIMITER //
CREATE FUNCTION IngresosPorCategoria(id_categoria INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(p.total)
    INTO total
    FROM pago p
    INNER JOIN alquiler a ON p.id_alquiler = a.id_alquiler
    INNER JOIN inventario i ON a.id_inventario = i.id_inventario
    INNER JOIN film_category fc ON i.film_id = fc.film_id
    WHERE fc.category_id = id_categoria;
    RETURN IFNULL(total, 0);
END;
//
DELIMITER ;

-- 4. DescuentoFrecuenciaCliente(ClienteID): Calcula un descuento basado en la frecuencia de alquiler del cliente.
DELIMITER //
CREATE FUNCTION DescuentoFrecuenciaCliente(id_cliente INT)
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    DECLARE descuento DECIMAL(5,2);
    SELECT COUNT(*) INTO cantidad FROM alquiler WHERE id_cliente = id_cliente;

    IF cantidad >= 50 THEN
        SET descuento = 0.20;
    ELSEIF cantidad >= 30 THEN
        SET descuento = 0.10;
    ELSEIF cantidad >= 10 THEN
        SET descuento = 0.05;
    ELSE
        SET descuento = 0.00;
    END IF;

    RETURN descuento;
END;
//
DELIMITER ;

-- 5. EsClienteVIP(ClienteID): Verifica si un cliente es "VIP" basándose en la cantidad de alquileres realizados y los ingresos generados.
DELIMITER //
CREATE FUNCTION EsClienteVIP(id_cliente INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    DECLARE ingresos DECIMAL(10,2);

    SELECT COUNT(*), SUM(p.total)
    INTO cantidad, ingresos
    FROM pago p
    WHERE p.id_cliente = id_cliente;

    RETURN (cantidad >= 40 AND ingresos >= 500);
END;
//
DELIMITER ;