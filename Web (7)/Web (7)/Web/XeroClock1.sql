--Tabla: Proveedor 
    CREATE TABLE Proveedor (
        id_proveedor SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        telefono VARCHAR(15),
        direccion TEXT,
        email VARCHAR(100),
        fecha_registro DATE DEFAULT CURRENT_DATE
    );

	--Tabla: Marca
    CREATE TABLE Marca (
        id_marca SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );

	--Tabla: Relojes
    CREATE TABLE Relojes (
        id_reloj SERIAL PRIMARY KEY,
        modelo VARCHAR(100) NOT NULL,
        precio DECIMAL(10, 2) NOT NULL,
        descripcion TEXT,
        id_marca INT REFERENCES Marca(id_marca),
        id_proveedor INT REFERENCES Proveedor(id_proveedor),
        fecha_registro DATE DEFAULT CURRENT_DATE
    );

	 --Tabla: Compra
    CREATE TABLE Compra (
        id_compra SERIAL PRIMARY KEY,
        id_proveedor INT REFERENCES Proveedor(id_proveedor),
        fecha_compra DATE DEFAULT CURRENT_DATE,
        total DECIMAL(10, 2) NOT NULL
    );   

	--Tabla: Inventario
    CREATE TABLE Inventario (
        id_inventario SERIAL PRIMARY KEY,
        id_reloj INT REFERENCES Relojes(id_reloj),
        cantidad INT NOT NULL,
        id_compra INT REFERENCES Compra(id_compra),
        fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

	    --Tabla: Cliente
    CREATE TABLE Cliente (
        id_cliente SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        telefono VARCHAR(15),
        direccion TEXT,
        email VARCHAR(100)
    );

	    --Tabla: Venta
    CREATE TABLE Venta (
        id_venta SERIAL PRIMARY KEY,
        id_cliente INT REFERENCES Cliente(id_cliente),
        id_empleado INT REFERENCES Empleado(id_empleado),
        fecha_venta DATE DEFAULT CURRENT_DATE,
        total DECIMAL(10, 2) NOT NULL
    );

	    --Tabla: DetalleVenta
    CREATE TABLE DetalleVenta (
        id_detalle SERIAL PRIMARY KEY,
        id_venta INT REFERENCES Venta(id_venta),
        id_reloj INT REFERENCES Relojes(id_reloj),
        cantidad INT NOT NULL,
        precio_unitario DECIMAL(10, 2) NOT NULL
    );

	--Tabla: Empleado
    CREATE TABLE Empleado (
        id_empleado SERIAL PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        telefono VARCHAR(15),
        direccion TEXT,
        email VARCHAR(100) UNIQUE
    );

   -- Tabla: LoginEmpleado 
CREATE TABLE LoginEmpleado (
    id_login SERIAL PRIMARY KEY,
    id_empleado INT REFERENCES Empleado(id_empleado),
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    cargo VARCHAR(50) DEFAULT 'vendedor'
);

-- Proveedor Procedimientos Almacenados (CRUD)


    CREATE OR REPLACE FUNCTION CrearProveedor(p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Proveedor (nombre, telefono, direccion, email) VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Proveedor
    CREATE OR REPLACE FUNCTION LeerProveedores()
    RETURNS TABLE(id_proveedor INT, nombre VARCHAR, telefono VARCHAR, direccion TEXT, email VARCHAR, fecha_registro DATE) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Proveedor;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Proveedor
    CREATE OR REPLACE FUNCTION ActualizarProveedor(p_id_proveedor INT, p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Proveedor
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_proveedor = p_id_proveedor;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Proveedor
    CREATE OR REPLACE FUNCTION EliminarProveedor(p_id_proveedor INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Proveedor WHERE id_proveedor = p_id_proveedor;
    END;
    $$ LANGUAGE plpgsql;

	-- Marca Procedimientos Almacenados (CRUD)

-- Crear Marca
    CREATE OR REPLACE FUNCTION CrearMarca(p_nombre VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Marca (nombre) VALUES (p_nombre);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Marcas
    CREATE OR REPLACE FUNCTION LeerMarcas()
    RETURNS TABLE(id_marca INT, nombre VARCHAR) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Marca;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Marcas
    CREATE OR REPLACE FUNCTION ActualizarMarca(p_id_marca INT, p_nombre VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Marca SET nombre = p_nombre WHERE id_marca = p_id_marca;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Marca
    CREATE OR REPLACE FUNCTION EliminarMarca(p_id_marca INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Marca WHERE id_marca = p_id_marca;
    END;
    $$ LANGUAGE plpgsql;

	-- Reloj Procedimientos Almacenados (CRUD)

-- Crear Reloj
    CREATE OR REPLACE FUNCTION CrearReloj(p_modelo VARCHAR(100), p_precio DECIMAL(10, 2), p_descripcion TEXT, p_id_marca INT, p_id_proveedor INT)
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Relojes (modelo, precio, descripcion, id_marca, id_proveedor)
        VALUES (p_modelo, p_precio, p_descripcion, p_id_marca, p_id_proveedor);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Reloj
    CREATE OR REPLACE FUNCTION LeerRelojes()
    RETURNS TABLE(id_reloj INT, modelo VARCHAR, precio DECIMAL, descripcion TEXT, id_marca INT, id_proveedor INT, fecha_registro DATE) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Relojes;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Reloj
    CREATE OR REPLACE FUNCTION ActualizarReloj(p_id_reloj INT, p_modelo VARCHAR(100), p_precio DECIMAL(10, 2), p_descripcion TEXT, p_id_marca INT, p_id_proveedor INT)
    RETURNS VOID AS $$
    BEGIN
        UPDATE Relojes
        SET modelo = p_modelo, precio = p_precio, descripcion = p_descripcion, id_marca = p_id_marca, id_proveedor = p_id_proveedor
        WHERE id_reloj = p_id_reloj;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Reloj
    CREATE OR REPLACE FUNCTION EliminarReloj(p_id_reloj INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Relojes WHERE id_reloj = p_id_reloj;
    END;
    $$ LANGUAGE plpgsql;

	-- Compra Procedimientos Almacenados (CRUD)

-- Crear Compra
    CREATE OR REPLACE FUNCTION CrearCompra(p_id_proveedor INT, p_total DECIMAL(10, 2))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Compra (id_proveedor, total) VALUES (p_id_proveedor, p_total);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Compra
    CREATE OR REPLACE FUNCTION LeerCompras()
    RETURNS TABLE(id_compra INT, id_proveedor INT, fecha_compra DATE, total DECIMAL) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Compra;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar compra
    CREATE OR REPLACE FUNCTION ActualizarCompra(p_id_compra INT, p_id_proveedor INT, p_total DECIMAL(10, 2))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Compra SET id_proveedor = p_id_proveedor, total = p_total WHERE id_compra = p_id_compra;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Compra 
    CREATE OR REPLACE FUNCTION EliminarCompra(p_id_compra INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Compra WHERE id_compra = p_id_compra;
    END;
    $$ LANGUAGE plpgsql;

	 -- Inventario Procedimientos Almacenados (CRUD)

 -- Crear Inventario 
    CREATE OR REPLACE FUNCTION CrearInventario(p_id_reloj INT, p_cantidad INT, p_id_compra INT)
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Inventario (id_reloj, cantidad, id_compra)
        VALUES (p_id_reloj, p_cantidad, p_id_compra);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Inventario 
    CREATE OR REPLACE FUNCTION LeerInventario()
    RETURNS TABLE(id_inventario INT, id_reloj INT, cantidad INT, id_compra INT, fecha_actualizacion TIMESTAMP) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Inventario;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Inventario 
    CREATE OR REPLACE FUNCTION ActualizarInventario(p_id_inventario INT, p_id_reloj INT, p_cantidad INT)
    RETURNS VOID AS $$
    BEGIN
        UPDATE Inventario
        SET id_reloj = p_id_reloj, cantidad = p_cantidad
        WHERE id_inventario = p_id_inventario;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Inventario 
    CREATE OR REPLACE FUNCTION EliminarInventario(p_id_inventario INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Inventario WHERE id_inventario = p_id_inventario;
    END;
    $$ LANGUAGE plpgsql;

	-- Cliente Procedimientos Almacenados (CRUD)

-- Crear Cliente 
    CREATE OR REPLACE FUNCTION CrearCliente(p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Cliente (nombre, telefono, direccion, email)
        VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$ LANGUAGE plpgsql;

--Leer Cliente 
    CREATE OR REPLACE FUNCTION LeerClientes()
    RETURNS TABLE(id_cliente INT, nombre VARCHAR, telefono VARCHAR, direccion TEXT, email VARCHAR) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Cliente;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Cliente 
    CREATE OR REPLACE FUNCTION ActualizarCliente(p_id_cliente INT, p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Cliente
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_cliente = p_id_cliente;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Cliente 
    CREATE OR REPLACE FUNCTION EliminarCliente(p_id_cliente INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Cliente WHERE id_cliente = p_id_cliente;
    END;
    $$ LANGUAGE plpgsql;

	-- Venta Procedimientos Almacenados (CRUD)

-- Crear Venta
    CREATE OR REPLACE FUNCTION CrearVenta(p_id_cliente INT, p_id_empleado INT, p_total DECIMAL(10, 2))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Venta (id_cliente, id_empleado, total)
        VALUES (p_id_cliente, p_id_empleado, p_total);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Venta
    CREATE OR REPLACE FUNCTION LeerVentas()
    RETURNS TABLE(id_venta INT, id_cliente INT, id_empleado INT, fecha_venta DATE, total DECIMAL) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Venta;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Venta
    CREATE OR REPLACE FUNCTION ActualizarVenta(p_id_venta INT, p_id_cliente INT, p_id_empleado INT, p_total DECIMAL(10, 2))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Venta
        SET id_cliente = p_id_cliente, id_empleado = p_id_empleado, total = p_total
        WHERE id_venta = p_id_venta;
    END;
    $$ LANGUAGE plpgsql;

--Eliminar Venta
    CREATE OR REPLACE FUNCTION EliminarVenta(p_id_venta INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Venta WHERE id_venta = p_id_venta;
    END;
    $$ LANGUAGE plpgsql;

	-- Empleado Procedimientos Almacenados (CRUD)

-- Crear Empleado 
    CREATE OR REPLACE FUNCTION CrearEmpleado(p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        INSERT INTO Empleado (nombre, telefono, direccion, email)
        VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$ LANGUAGE plpgsql;

-- Leer Empleado 
    CREATE OR REPLACE FUNCTION LeerEmpleados()
    RETURNS TABLE(id_empleado INT, nombre VARCHAR, telefono VARCHAR, direccion TEXT, email VARCHAR) AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Empleado;
    END;
    $$ LANGUAGE plpgsql;

-- Actualizar Empleado
    CREATE OR REPLACE FUNCTION ActualizarEmpleado(p_id_empleado INT, p_nombre VARCHAR(100), p_telefono VARCHAR(15), p_direccion TEXT, p_email VARCHAR(100))
    RETURNS VOID AS $$
    BEGIN
        UPDATE Empleado
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_empleado = p_id_empleado;
    END;
    $$ LANGUAGE plpgsql;

-- Eliminar Empleado 
    CREATE OR REPLACE FUNCTION EliminarEmpleado(p_id_empleado INT)
    RETURNS VOID AS $$
    BEGIN
        DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
    END;
    $$ LANGUAGE plpgsql;

	-- LoginEmpleado Procedimientos Almacenados (CRUD)

-- Crear LoginEmpleado
CREATE OR REPLACE FUNCTION CrearLoginEmpleado(
    p_id_empleado INT, 
    p_usuario VARCHAR(50), 
    p_contrasena VARCHAR(255), 
    p_cargo VARCHAR(50) DEFAULT 'vendedor'
) RETURNS VOID AS $$
BEGIN
    INSERT INTO LoginEmpleado (id_empleado, usuario, contrasena, cargo)
    VALUES (p_id_empleado, p_usuario, crypt(p_contrasena, gen_salt('bf')), p_cargo);
END;
$$ LANGUAGE plpgsql;

-- Leer LoginEmpleado
CREATE OR REPLACE FUNCTION LeerLoginsEmpleado()
RETURNS TABLE(id_login INT, id_empleado INT, usuario VARCHAR, contrasena VARCHAR, cargo VARCHAR) AS $$
BEGIN
    RETURN QUERY SELECT * FROM LoginEmpleado;
END;
$$ LANGUAGE plpgsql;

-- Actualizar LoginEmpleado
CREATE OR REPLACE FUNCTION ActualizarLoginEmpleado(
    p_id_login INT, 
    p_usuario VARCHAR(50), 
    p_contrasena VARCHAR(255), 
    p_cargo VARCHAR(50)
) RETURNS VOID AS $$
BEGIN
    UPDATE LoginEmpleado
    SET usuario = p_usuario,
        contrasena = crypt(p_contrasena, gen_salt('bf')),
        cargo = p_cargo
    WHERE id_login = p_id_login;
END;
$$ LANGUAGE plpgsql;


-- Eliminar LoginEmpleado
CREATE OR REPLACE FUNCTION EliminarLoginEmpleado(p_id_login INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM LoginEmpleado WHERE id_login = p_id_login;
END;
$$ LANGUAGE plpgsql;

--- < Más Funciones > ---

-- Verificación de Cuenta
CREATE OR REPLACE FUNCTION VerificarLogin(
    p_usuario VARCHAR(50), 
    p_contrasena VARCHAR(255)
) RETURNS BOOLEAN AS $$
DECLARE
    contrasena_almacenada VARCHAR;
BEGIN
    -- Obtener la contraseña almacenada para el usuario dado
    SELECT contrasena INTO contrasena_almacenada 
    FROM LoginEmpleado 
    WHERE usuario = p_usuario;

    -- Si no se encuentra el usuario, retornar FALSE
    IF NOT FOUND THEN
        RETURN FALSE;
    END IF;

    -- Verificar si la contraseña ingresada coincide con la almacenada
    IF crypt(p_contrasena, contrasena_almacenada) = contrasena_almacenada THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Vista # 1. VistaInventario
CREATE OR REPLACE VIEW VistaInventario AS
SELECT 
    Relojes.modelo AS ModeloReloj, 
    Marca.nombre AS Marca, 
    Proveedor.nombre AS Proveedor, 
    Inventario.cantidad AS CantidadDisponible
FROM Inventario
JOIN Relojes ON Inventario.id_reloj = Relojes.id_reloj
JOIN Marca ON Relojes.id_marca = Marca.id_marca
JOIN Proveedor ON Relojes.id_proveedor = Proveedor.id_proveedor;

-- Vista # 2. VistaVentas
	
CREATE OR REPLACE VIEW VistaVentas AS
SELECT 
    Venta.id_venta AS IDVenta, 
    Cliente.nombre AS NombreCliente, 
    Empleado.nombre AS NombreEmpleado, 
    Venta.fecha_venta AS FechaVenta, 
    Venta.total AS TotalVenta
FROM 
    Venta
JOIN 
    Cliente ON Venta.id_cliente = Cliente.id_cliente
JOIN 
    Empleado ON Venta.id_empleado = Empleado.id_empleado;

-- Vista # 3. VistaRelojesProveedor
	
CREATE OR REPLACE VIEW VistaRelojesProveedor AS
SELECT 
    Relojes.modelo AS ModeloReloj, 
    Marca.nombre AS Marca, 
    Proveedor.nombre AS Proveedor, 
    Relojes.precio AS Precio
FROM 
    Relojes
JOIN 
    Marca ON Relojes.id_marca = Marca.id_marca
JOIN 
    Proveedor ON Relojes.id_proveedor = Proveedor.id_proveedor;
	
-- Disparador # 1. ActualizarFechaInventario

	CREATE OR REPLACE FUNCTION ActualizarFechaInventario()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_actualizacion := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ActualizarFechaInventario
BEFORE UPDATE ON Inventario
FOR EACH ROW
EXECUTE FUNCTION ActualizarFechaInventario();

-- Disparador # 2. AumentarInventarioTrasCompra

CREATE OR REPLACE FUNCTION AumentarInventarioTrasCompra()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Inventario
    SET cantidad = cantidad + 
        (SELECT SUM(cantidad) FROM DetalleCompra WHERE DetalleCompra.id_compra = NEW.id_compra)
    WHERE Inventario.id_reloj IN 
        (SELECT id_reloj FROM DetalleCompra WHERE DetalleCompra.id_compra = NEW.id_compra);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER AumentarInventarioTrasCompra
AFTER INSERT ON Compra
FOR EACH ROW
EXECUTE FUNCTION AumentarInventarioTrasCompra();

-- Disparador # 3. ReducirInventarioTrasVenta
CREATE OR REPLACE FUNCTION ReducirInventarioTrasVenta()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Inventario
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_reloj = NEW.id_reloj;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ReducirInventarioTrasVenta
AFTER INSERT ON DetalleVenta
FOR EACH ROW
EXECUTE FUNCTION ReducirInventarioTrasVenta();


-- Disparador # 4. RegistrarVentaTotal
CREATE OR REPLACE FUNCTION RegistrarVentaTotal()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Venta
    SET total = total + (NEW.cantidad * NEW.precio_unitario)
    WHERE id_venta = NEW.id_venta;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER RegistrarVentaTotal
AFTER INSERT ON DetalleVenta
FOR EACH ROW
EXECUTE FUNCTION RegistrarVentaTotal();

-- Disparador # 5. ValidarCantidadInventario
CREATE OR REPLACE FUNCTION ValidarCantidadInventario()
RETURNS TRIGGER AS $$
DECLARE
    cant_disponible INT;
BEGIN
    SELECT cantidad INTO cant_disponible 
    FROM Inventario 
    WHERE id_reloj = NEW.id_reloj;
    
    IF cant_disponible < NEW.cantidad THEN
        RAISE EXCEPTION 'No hay suficiente cantidad de este reloj en el inventario.';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ValidarCantidadInventario
BEFORE INSERT ON DetalleVenta
FOR EACH ROW
EXECUTE FUNCTION ValidarCantidadInventario();