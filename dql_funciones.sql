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

