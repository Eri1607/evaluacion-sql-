/*
Evaluacion Taller Mecanico 
Daniel Duarte
Erika Corredor
2877795

*/
CREATE DATABASE alquiler_vehiculo;
USE alquiler_vehiculo;

CREATE TABLE marca (
    idMarca INTEGER PRIMARY KEY AUTO_INCREMENT,

    nomMarcaVehiculo VARCHAR(50) NOT NULL
);


CREATE TABLE estado (
    idEstado INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    desEstado VARCHAR(50) NOT NULL
);

CREATE TABLE tipo (
    idTipo INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    desCorTipo VARCHAR(50) NOT NULL,    
    desAmpTipo VARCHAR(50) NOT NULL,
    preAlqTipo INT NOT NULL
);

CREATE TABLE vehiculo (
    idVehiculo INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    plaVehiculo VARCHAR(6) NOT NULL,
    idMarVehiculo INT NOT NULL,
    idTipVehiculo INT NOT NULL,
    idEstVehiculo INT NOT NULL,

    CONSTRAINT unique_plaVehiculo UNIQUE (plaVehiculo),
    CONSTRAINT vehiculoxmarca FOREIGN KEY (idMarVehiculo) REFERENCES marca(idMarca) ON DELETE CASCADE,
    CONSTRAINT vehiculoxestado FOREIGN KEY (idEstVehiculo) REFERENCES estado(idEstado) ON DELETE CASCADE,
    CONSTRAINT vehiculoxtipo FOREIGN KEY (idTipVehiculo) REFERENCES tipo(idTipo) ON DELETE CASCADE
);

CREATE TABLE cliente(
    idCliente INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    docCliente VARCHAR(50) NOT NULL,
    nomCliente VARCHAR(50) NOT NULL,
    apeCliente VARCHAR(50) NOT NULL,    
    emaCliente VARCHAR(50) NOT NULL,
    celCliente VARCHAR(50) NOT NULL
);

CREATE TABLE empleado(
    idEmpleado INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    nomEmpleado VARCHAR(50) NOT NULL,
    emaEmpleado VARCHAR(50) NOT NULL,
    celEmpleado VARCHAR(50) NOT NULL,
    conEmpleado VARCHAR(50) NOT NULL,
    usuEmpleado VARCHAR(50) NOT NULL,
    cargoEmpleado VARCHAR(50) NOT NULL,
    salario INT NOT NULL
);

CREATE TABLE alquiler (
    idAlquiler INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    idVehiculo INT NOT NULL,
    idCliente INT NOT NULL,
    idEmpleado INT NOT NULL,    

    fecInicioAlquiler DATETIME NOT NULL,
    fecFinAlquiler DATETIME NOT NULL,
    fecEntAlquiler DATETIME NULL,
    valAlquiler INT NOT NULL,

    CONSTRAINT alquilerxempleado FOREIGN KEY (idEmpleado) REFERENCES empleado(idEmpleado) ON DELETE CASCADE,
    CONSTRAINT alquilerxcliente FOREIGN KEY (idCliente) REFERENCES cliente(idCliente) ON DELETE CASCADE,
    CONSTRAINT alquilerxvehiculo FOREIGN KEY (idVehiculo) REFERENCES vehiculo(idVehiculo) ON DELETE CASCADE
);

CREATE TABLE metodo (
    idMetodo INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    tipoMetodo VARCHAR(50) NOT NULL,
    desMetodo VARCHAR(50) NOT NULL
);

CREATE TABLE pago (
    idPago INT AUTO_INCREMENT NOT NULL PRIMARY KEY,

    idAlquiler INT NOT NULL,
    idMetodo INT NOT NULL,
    fechaPago DATETIME NOT NULL,
    montoPago INT NOT NULL,

    CONSTRAINT pagoxalquiler FOREIGN KEY (idAlquiler) REFERENCES alquiler(idAlquiler),
    CONSTRAINT pagoxmetodo FOREIGN KEY (idMetodo) REFERENCES metodo(idMetodo)
);


-- insercion de datos
INSERT INTO marca (nomMarcaVehiculo) VALUES 
('Toyota'),
('Ford'),
('Chevrolet');

INSERT INTO estado (desEstado) VALUES 
('Disponible'),
('En mantenimiento'),
('Alquilado');

INSERT INTO tipo (desCorTipo, desAmpTipo, preAlqTipo) VALUES 
('Económico', 'Vehículo pequeño, bajo consumo', 50000),
('SUV', 'Vehículo utilitario deportivo', 120000),
('Lujo', 'Vehículo de alta gama', 250000);

INSERT INTO vehiculo (plaVehiculo, idMarVehiculo, idTipVehiculo, idEstVehiculo) VALUES 
('ABC123', 1, 1, 1),
('DEF456', 2, 2, 2),
('GHI789', 3, 3, 1);

INSERT INTO cliente (docCliente, nomCliente, apeCliente, emaCliente, celCliente) VALUES 
('12345678', 'Juan', 'Pérez', 'juan.perez@mail.com', '3001234567'),
('87654321', 'Ana', 'Gómez', 'ana.gomez@mail.com', '3107654321'),
('45678912', 'Luis', 'Martínez', 'luis.martinez@mail.com', '3159876543');

INSERT INTO empleado (nomEmpleado, emaEmpleado, celEmpleado, conEmpleado, usuEmpleado, cargoEmpleado, salario) VALUES 
('Carlos', 'carlos@mail.com', '3012345678', 'pass123', 'carlos123', 'Gerente', 2500000),
('Marta', 'marta@mail.com', '3023456789', 'pass456', 'marta456', 'Mecánico', 1800000),
('Pedro', 'pedro@mail.com', '3034567890', 'pass789', 'pedro789', 'Recepcionista', 1500000);

INSERT INTO alquiler (idVehiculo, idCliente, idEmpleado, fecInicioAlquiler, fecFinAlquiler, fecEntAlquiler, valAlquiler) VALUES 
(1, 1, 1, '2024-12-01 09:00:00', '2024-12-05 18:00:00', NULL, 200000),
(2, 2, 2, '2024-11-25 10:00:00', '2024-11-30 18:00:00', '2024-11-30 17:00:00', 600000),
(3, 3, 3, '2024-12-01 08:00:00', '2024-12-02 20:00:00', NULL, 250000);

INSERT INTO metodo (tipoMetodo, desMetodo) VALUES 
('Efectivo', 'Pago en efectivo realizado en oficina'),
('Tarjeta', 'Pago con tarjeta de crédito o débito'),
('Transferencia', 'Transferencia bancaria directa');

INSERT INTO pago (idAlquiler, idMetodo, fechaPago, montoPago) VALUES 
(1, 1, '2024-12-01 10:00:00', 200000), -- Efectivo
(2, 2, '2024-12-10 11:00:00', 600000), -- Tarjeta
(3, 3, '2024-12-01 09:00:00', 250000), -- Transferencia
(1, 2, '2024-12-05 09:00:00', 200000); -- Tarjeta


-- consultas
--  -  Listar todos los vehículos disponibles para alquilar.
SELECT m.nomMarcaVehiculo, v.plaVehiculo, e.desEstado
FROM vehiculo v 
JOIN marca m ON m.idMarca = v.idMarVehiculo
JOIN estado e ON e.idEstado = v.idEstVehiculo

WHERE e.desEstado = 'Disponible';

--  - Obtener el historial de alquileres de un cliente específico.

SELECT a.idAlquiler, a.fecInicioAlquiler, a.fecFinAlquiler, v.plaVehiculo, m.nomMarcaVehiculo, t.desAmpTipo, a.valAlquiler
FROM alquiler a
JOIN vehiculo v ON a.idVehiculo = v.idVehiculo
JOIN marca m ON v.idMarVehiculo = m.idMarca
JOIN tipo t ON v.idTipVehiculo = t.idTipo
WHERE a.idCliente = 2;

-- Listar los tipos de vehículos y sus tarifas.

SELECT idTipo, desAmpTipo, preAlqTipo
FROM tipo;

-- Consultar el detalle de un vehículo específico (marca, tipo, estado).
SELECT v.idVehiculo, v.plaVehiculo, m.nomMarcaVehiculo, t.desAmpTipo, e.desEstado
FROM Vehiculo v
JOIN marca m ON v.idMarVehiculo = m.idMarca
JOIN tipo t ON v.idTipVehiculo = t.idTipo
JOIN estado e ON v.idEstVehiculo = e.idEstado
WHERE v.idVehiculo = 1; 

-- Listar todos los clientes que tienen actualmente un vehículo alquilado.

SELECT DISTINCT c.idCliente, c.nomCliente, c.apeCliente, c.emaCliente, c.celCliente
FROM cliente c
JOIN alquiler a ON c.idCliente = a.idCliente
WHERE a.fecInicioAlquiler >= CURRENT_DATE;

-- Calcular el total de ingresos por alquileres en un período específico.

SELECT SUM(a.valAlquiler) AS total_ingresos
FROM alquiler a
WHERE a.fecInicioAlquiler >= '2024-12-01' AND a.fecFinAlquiler <= '2024-12-01';

-- Obtener el número de alquileres por cada tipo de vehículo.

SELECT t.desAmpTipo, COUNT(a.idAlquiler) AS total_alquileres
FROM alquiler a
JOIN vehiculo v ON a.idVehiculo = v.idVehiculo
JOIN tipo t ON v.idTipVehiculo = t.idTipo
GROUP BY t.desAmpTipo;

-- Listar las marcas de vehículos junto con la cantidad de vehículos de cada marca.

SELECT m.nomMarcaVehiculo, COUNT(v.idVehiculo) AS total_vehiculos
FROM marca m
JOIN vehiculo v ON m.idMarca = v.idMarVehiculo
GROUP BY m.nomMarcaVehiculo;

-- Listar los alquileres gestionados por un empleado específico.

SELECT a.idAlquiler, a.fecInicioAlquiler, a.fecFinAlquiler, v.plaVehiculo, m.nomMarcaVehiculo, t.desAmpTipo, a.valAlquiler
FROM alquiler a
JOIN vehiculo v ON a.idVehiculo = v.idVehiculo
JOIN marca m ON v.idMarVehiculo = m.idMarca
JOIN tipo t ON v.idTipVehiculo = t.idTipo
WHERE a.idEmpleado = 3; 

-- Obtener el total de pagos realizados por un cliente en un período específico.

SELECT SUM(p.montoPago) AS total_pagos
FROM pago p
JOIN alquiler a ON p.idAlquiler = a.idAlquiler
WHERE a.idCliente = 2 AND p.fechaPago BETWEEN '2024-12-01' AND '2024-12-12';

-- Listar los métodos de pago más utilizados en un período específico.
SELECT m.tipoMetodo AS Metodo_Pago, COUNT(p.idPago) AS Veces_Utilizadas
FROM pago p
JOIN metodo m ON p.idMetodo = m.idMetodo
WHERE p.fechaPago BETWEEN '2024-12-01' AND '2024-12-31'  -- Cambia las fechas según sea necesario
GROUP BY m.tipoMetodo
ORDER BY Veces_Utilizadas DESC;


-- Reglas del negocio
-- 1. Validar que solo vehículos "disponibles" puedan alquilarse
DELIMITER //
CREATE TRIGGER validar_estado_vehiculo
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    DECLARE estadoActual VARCHAR(50);

    SELECT desEstado INTO estadoActual
    FROM vehiculo v
    INNER JOIN estado e ON v.idEstVehiculo = e.idEstado
    WHERE v.idVehiculo = NEW.idVehiculo;

    IF estadoActual != 'Disponible' THEN
        SIGNAL SQLSTATE '123'
        SET MESSAGE_TEXT = 'El vehículo no está disponible para alquiler';
    END IF;
END;
// DELIMITER;

-- 2. Validar que los clientes proporcionen información de contacto válida
ALTER TABLE cliente
ADD CONSTRAINT chk_email_format CHECK (email LIKE '%_@__%.__%');
ADD CONSTRAINT chk_cel_cliente CHECK (celCliente REGEXP '^[0-9]{10}$');

-- 3. La tarifa de alquiler depende del tipo de vehículo y debe calcularse en función del número de días de alquiler.
--Relacionar la tabla tipo con la tabla vehiculo para determinar la tarifa diaria y calcular automáticamente el costo total del alquiler.
ALTER TABLE alquiler
ADD COLUMN tarifaDiaria INT NOT NULL,
ADD COLUMN diasAlquiler INT GENERATED ALWAYS AS (DATEDIFF(fecFinAlquiler, fecInicioAlquiler)) STORED,
ADD COLUMN costoTotal INT GENERATED ALWAYS AS (diasAlquiler * tarifaDiaria) STORED;

DELIMITER //
CREATE TRIGGER calcular_tarifa
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    SELECT preAlqTipo INTO NEW.tarifaDiaria
    FROM tipo
    WHERE idTipo = (SELECT idTipVehiculo FROM vehiculo WHERE idVehiculo = NEW.idVehiculo);
END;
//
DELIMITER ;
-------------------------------------------------------------------------------------------
CREATE TABLE tarifas (
    tipo_vehiculo VARCHAR(20) PRIMARY KEY,
    tarifa_diaria DECIMAL(10, 2) NOT NULL
);
INSERT INTO tarifas (tipo_vehiculo, tarifa_diaria) VALUES
('Camioneta', 150000.00),
('Deportivo', 160000.00),
('Convertible', 100000.00),
('Regular', 60000.00);


-- Relacionar tipos de vehículos con tarifas
CREATE TABLE tipo_vehiculo (
    idTipoVehiculo INT AUTO_INCREMENT PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL,
    tarifaDiaria DECIMAL(10, 2) NOT NULL
);

ALTER TABLE alquiler
ADD COLUMN tarifaDiaria DECIMAL(10, 2) NOT NULL,
ADD COLUMN diasAlquiler INT GENERATED ALWAYS AS (DATEDIFF(fechaFin, fechaInicio)) STORED,
ADD COLUMN costoTotal DECIMAL(10, 2) GENERATED ALWAYS AS (diasAlquiler * tarifaDiaria) STORED;

DELIMITER //

CREATE TRIGGER calcular_tarifa
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    DECLARE tarifa DECIMAL(10, 2);
    
    -- Obtener la tarifa del tipo de vehículo
    SELECT tarifaDiaria INTO tarifa
    FROM tarifas
    WHERE tipoVehiculo = (SELECT tipoVehiculo FROM vehiculo WHERE idVehiculo = NEW.idVehiculo);
    
    -- Asignar la tarifa y calcular el costo total
    SET NEW.tarifaDiaria = tarifa;
    SET NEW.diasAlquiler = DATEDIFF(NEW.fechaFin, NEW.fechaInicio);
    SET NEW.costoTotal = NEW.diasAlquiler * NEW.tarifaDiaria;
END; tarifa_diaria

DELIMITER ;

-- 4. Evitar solapamiento de fechas para el mismo vehículo
ALTER TABLE alquiler
ADD CONSTRAINT chk_fechas_solapamiento CHECK (
    NOT EXISTS (
        SELECT 1 FROM alquiler AS a
        WHERE a.idVehiculo = alquiler.idVehiculo
          AND (a.fecha_inicio < alquiler.fecha_fin AND a.fecha_fin > alquiler.fecha_inicio)
    )
);

-- 5. Asociar empleados con alquileres
ALTER TABLE alquiler
ADD COLUMN idEmpleado INT NOT NULL,
ADD FOREIGN KEY (idEmpleado) REFERENCES empleado(idEmpleado);

-- 6. Mantener tarifas históricas independientes de los cambios
ALTER TABLE alquiler
ADD COLUMN tarifa_historica DECIMAL(10, 2) NOT NULL;

-- Al insertar un nuevo alquiler, guardar la tarifa histórica
DELIMITER //
CREATE TRIGGER almacenar_tarifa_historica
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    SELECT tarifa_diaria INTO NEW.tarifa_historica
    FROM tipo_vehiculo
    WHERE idTipoVehiculo = (SELECT idTipoVehiculo FROM vehiculo WHERE idVehiculo = NEW.idVehiculo);
END;
//
DELIMITER ;

-- Los métodos de pago pueden ser variados (tarjeta, efectivo, transferencia), y cada pago debe registrar el método utilizado.
-- Esto ya se hace al momento de insertar los valores (linea 141)

-- 8. Los registros de pagos deben coincidir con los alquileres, y el monto total de cada pago debe corresponder al costo del alquiler.
ALTER TABLE pagos
ADD CONSTRAINT chk_monto_pago CHECK (monto = (SELECT costo_total FROM alquiler WHERE alquiler.idAlquiler = pagos.idAlquiler));




-- Reglas de negocio:

-- i. Los vehículos solo pueden ser alquilados si su estado es “disponible”.
--Crear un trigger para validar el estado del vehículo antes de insertar un nuevo registro en la tabla alquiler.
DELIMITER //
CREATE TRIGGER validar_estado_vehiculo
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    DECLARE estadoActual VARCHAR(50);
    SELECT desEstado INTO estadoActual
    FROM vehiculo v
    INNER JOIN estado e ON v.idEstVehiculo = e.idEstado
    WHERE v.idVehiculo = NEW.idVehiculo;
    IF estadoActual != 'Disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo no está disponible para alquiler';
    END IF;
END;
//
DELIMITER ;


-- ii. Cada cliente debe proporcionar información de contacto válida (email y teléfono).
-- Añadir restricciones de validación al formato del correo electrónico y número de teléfono en la tabla cliente.
ALTER TABLE cliente
ADD CONSTRAINT chk_email_cliente CHECK (emaCliente LIKE '%_@__%.__%'),
ADD CONSTRAINT chk_cel_cliente CHECK (celCliente REGEXP '^[0-9]{10}$');


-- iii. La tarifa de alquiler depende del tipo de vehículo y debe calcularse en función del número de días de alquiler.
--Relacionar la tabla tipo con la tabla vehiculo para determinar la tarifa diaria y calcular automáticamente el costo total del alquiler.
ALTER TABLE alquiler
ADD COLUMN tarifaDiaria INT NOT NULL,
ADD COLUMN diasAlquiler INT GENERATED ALWAYS AS (DATEDIFF(fecFinAlquiler, fecInicioAlquiler)) STORED,
ADD COLUMN costoTotal INT GENERATED ALWAYS AS (diasAlquiler * tarifaDiaria) STORED;

DELIMITER //
CREATE TRIGGER calcular_tarifa
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    SELECT preAlqTipo INTO NEW.tarifaDiaria
    FROM tipo
    WHERE idTipo = (SELECT idTipVehiculo FROM vehiculo WHERE idVehiculo = NEW.idVehiculo);
END;
//
DELIMITER ;


-- iv. Los registros de alquiler deben incluir fechas de inicio y fin, que no pueden solaparse para el mismo vehículo.
--Agregar una restricción para evitar solapamiento de fechas en la tabla alquiler.
DELIMITER //
CREATE TRIGGER validar_solapamiento
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM alquiler
        WHERE idVehiculo = NEW.idVehiculo
          AND (NEW.fecInicioAlquiler < fecFinAlquiler AND NEW.fecFinAlquiler > fecInicioAlquiler)
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo ya está reservado para las fechas seleccionadas';
    END IF;
END;
//
DELIMITER ;


-- v. Los empleados pueden gestionar múltiples alquileres, y cada alquiler está asociado a un solo empleado.
--Relacionar directamente la tabla empleado con la tabla alquiler y permitir múltiples asociaciones.
ALTER TABLE alquiler
ADD COLUMN idEmpleado INT NOT NULL,
ADD FOREIGN KEY (idEmpleado) REFERENCES empleado(idEmpleado);


-- vi. Las tarifas y tipos de vehículos se pueden actualizar sin afectar los alquileres pasados.
--Guardar las tarifas históricas en cada registro de alquiler al momento de su creación.
ALTER TABLE alquiler
ADD COLUMN tarifaHistorica INT NOT NULL;

DELIMITER //
CREATE TRIGGER almacenar_tarifa_historica
BEFORE INSERT ON alquiler
FOR EACH ROW
BEGIN
    SELECT preAlqTipo INTO NEW.tarifaHistorica
    FROM tipo
    WHERE idTipo = (SELECT idTipVehiculo FROM vehiculo WHERE idVehiculo = NEW.idVehiculo);
END;
//
DELIMITER ;


-- vii. Los métodos de pago pueden ser variados (tarjeta, efectivo, transferencia), y cada pago debe registrar el método utilizado.
--Ya implementado en la tabla pago con el campo idMetodo relacionado con la tabla metodo.

-- viii. Los registros de pagos deben coincidir con los alquileres, y el monto total de cada pago debe corresponder al costo del alquiler.
--Añadir una restricción para validar que el monto del pago corresponde al costo del alquiler.
ALTER TABLE pago
ADD CONSTRAINT chk_monto_pago CHECK (
    montoPago = (SELECT costoTotal FROM alquiler WHERE alquiler.idAlquiler = pago.idAlquiler)
);
