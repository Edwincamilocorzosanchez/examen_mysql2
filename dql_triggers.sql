-- 1. ActualizarTotalAlquileresEmpleado: Al registrar un alquiler, actualiza el total de alquileres gestionados por el empleado correspondiente.
DELIMITER //
CREATE TRIGGER ActualizarTotalAlquileresEmpleado
AFTER INSERT ON alquiler
FOR EACH ROW
BEGIN
    UPDATE staff
    SET total_rentals = IFNULL(total_rentals, 0) + 1
    WHERE staff_id = NEW.staff_id;
END;
//
DELIMITER ;


-- 2. AuditarActualizacionCliente: Cada vez que se modifica un cliente, registra el cambio en una tabla de auditoría.

DELIMITER //
CREATE TRIGGER AuditarActualizacionCliente
BEFORE UPDATE ON customer
FOR EACH ROW
BEGIN
    IF OLD.first_name != NEW.first_name THEN
        INSERT INTO cliente_auditoria (cliente_id, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_cliente, 'first_name', OLD.first_name, NEW.first_name);
    END IF;

    IF OLD.last_name != NEW.last_name THEN
        INSERT INTO cliente_auditoria (cliente_id, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_cliente, 'last_name', OLD.last_name, NEW.last_name);
    END IF;

    IF OLD.email != NEW.email THEN
        INSERT INTO cliente_auditoria (cliente_id, campo_modificado, valor_anterior, valor_nuevo)
        VALUES (OLD.id_cliente, 'email', OLD.email, NEW.email);
    END IF;
END;
//
DELIMITER ;

-- 3. RegistrarHistorialDeCosto: Guarda el historial de cambios en los costos de alquiler de las películas.

DELIMITER //
CREATE TRIGGER RegistrarHistorialDeCosto
BEFORE UPDATE ON film
FOR EACH ROW
BEGIN
    IF OLD.rental_rate != NEW.rental_rate THEN
        INSERT INTO historial_costos (film_id, costo_anterior, costo_nuevo)
        VALUES (OLD.film_id, OLD.rental_rate, NEW.rental_rate);
    END IF;
END;
//
DELIMITER ;

-- 4. NotificarEliminacionAlquiler: Registra una notificación cuando se elimina un registro de alquiler.

DELIMITER //
CREATE TRIGGER NotificarEliminacionAlquiler
BEFORE DELETE ON alquiler
FOR EACH ROW
BEGIN
    INSERT INTO alquiler_eliminado_log (id_alquiler, id_cliente)
    VALUES (OLD.id_alquiler, OLD.id_cliente);
END;
//
DELIMITER ;

-- 5.RestringirAlquilerConSaldoPendiente: Evita que un cliente con saldo pendiente pueda realizar nuevos alquileres.
DELIMITER //
CREATE TRIGGER RestringirAlquilerConSaldoPendiente
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    DECLARE saldo DECIMAL(10,2);
    SELECT SUM(total) - IFNULL((SELECT SUM(total) FROM pago WHERE id_cliente = NEW.id_cliente), 0)
    INTO saldo
    FROM pago
    WHERE id_cliente = NEW.id_cliente;

    IF saldo > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El cliente tiene saldo pendiente. No se puede registrar un nuevo alquiler.';
    END IF;
END;
//
DELIMITER ;