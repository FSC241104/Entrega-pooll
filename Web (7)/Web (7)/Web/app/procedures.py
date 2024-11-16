# procedures.py
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
import psycopg2
from psycopg2.extras import RealDictCursor

# Importa todas las entidades de models.py
from app.models.entities import Proveedor, Marca, Relojes, Compra, Inventario, Cliente, Venta, DetalleVenta, Empleado, LoginEmpleado

''' Lista de Entities '''
# 1. ModelProveedor
# 2. ModelMarca
# 3. ModelRelojes
# 4. ModelCompra
# 5. ModelInventario 
# 6. ModelCliente
# 7. ModelVenta 
# 8. ModelDetalleVenta 
# 9. ModelEmpleado 
# 10. ModelLoginEmpleado 
'''         Fin         '''

class ModelProveedor:

# Crear Proveedor    

    def crear_proveedor(self, db, proveedor):
        try:
            consulta = text("SELECT CrearProveedor(:nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "nombre": proveedor.nombre,
                "telefono": proveedor.telefono,
                "direccion": proveedor.direccion,
                "email": proveedor.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Leer Proveedor
    def leer_proveedores(self, db):
        try:
            consulta = text("SELECT * FROM LeerProveedores()")
            result = db.session.execute(consulta).fetchall()
            return [Proveedor(*row) for row in result]
        except Exception as ex:
            raise Exception(ex)

# Actualizar Proovedot
    def actualizar_proveedor(self, db, proveedor):
        try:
            consulta = text("SELECT ActualizarProveedor(:id_proveedor, :nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "id_proveedor": proveedor.id_proveedor,
                "nombre": proveedor.nombre,
                "telefono": proveedor.telefono,
                "direccion": proveedor.direccion,
                "email": proveedor.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Eliminar Proveedor
    def eliminar_proveedor(self, db, id_proveedor):
        try:
            consulta = text("SELECT EliminarProveedor(:id_proveedor)")
            db.session.execute(consulta, {"id_proveedor": id_proveedor})
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

class ModelMarca:

# Crear Marca
    def crear_marca(self, db, marca):
        try:
            consulta = text("SELECT CrearMarca(:nombre)")
            db.session.execute(consulta, {"nombre": marca.nombre})
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Leer Marca
    def leer_marcas(self, db):
        try:
            consulta = text("SELECT * FROM LeerMarcas()")
            result = db.session.execute(consulta).fetchall()
            return [Marca(*row) for row in result]
        except Exception as ex:
            raise Exception(ex)

# Actualizar Marca
    def actualizar_marca(self, db, marca):
        try:
            consulta = text("SELECT ActualizarMarca(:id_marca, :nombre)")
            db.session.execute(consulta, {
                "id_marca": marca.id_marca,
                "nombre": marca.nombre
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Eliminar Marca    
    def eliminar_marca(self, db, id_marca):
        try:
            consulta = text("SELECT EliminarMarca(:id_marca)")
            db.session.execute(consulta, {"id_marca": id_marca})
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

class ModelRelojes:
    def crear_reloj(self, db, modelo, precio, descripcion, id_marca, id_proveedor):
        query = """
        SELECT CrearReloj(:modelo, :precio, :descripcion, :id_marca, :id_proveedor)
        """
        db.session.execute(text(query), {
            'modelo': modelo,
            'precio': precio,
            'descripcion': descripcion,
            'id_marca': id_marca,
            'id_proveedor': id_proveedor
        })
        db.session.commit()

    def leer_relojes_con_detalles(self, db):
        query = """
        SELECT 
            R.id_reloj, 
            R.modelo, 
            R.precio, 
            R.descripcion, 
            M.id_marca, 
            M.nombre AS marca_nombre, 
            P.id_proveedor, 
            P.nombre AS proveedor_nombre, 
            R.fecha_registro
        FROM Relojes R
        JOIN Marca M ON R.id_marca = M.id_marca
        JOIN Proveedor P ON R.id_proveedor = P.id_proveedor
        """
        result = db.session.execute(text(query))
        return result.fetchall()

    def actualizar_reloj(self, db, id_reloj, modelo, precio, descripcion, id_marca, id_proveedor):
        query = """
        SELECT ActualizarReloj(:id_reloj, :modelo, :precio, :descripcion, :id_marca, :id_proveedor)
        """
        db.session.execute(text(query), {
            'id_reloj': id_reloj,
            'modelo': modelo,
            'precio': precio,
            'descripcion': descripcion,
            'id_marca': id_marca,
            'id_proveedor': id_proveedor
        })
        db.session.commit()

    def eliminar_reloj(self, db, id_reloj):
        query = """
        SELECT EliminarReloj(:id_reloj)
        """
        db.session.execute(text(query), {'id_reloj': id_reloj})
        db.session.commit()

    def obtener_marcas(self, db):
        query = "SELECT id_marca, nombre FROM Marca"
        result = db.session.execute(text(query))
        return result.fetchall()

    def obtener_proveedores(self, db):
        query = "SELECT id_proveedor, nombre FROM Proveedor"
        result = db.session.execute(text(query))
        return result.fetchall()
    
    def obtener_reloj_por_id(self, db, id_reloj):
        """
        Obtiene un reloj específico por su ID.
        """
        query = """
        SELECT id_reloj, modelo, precio, descripcion, id_marca, id_proveedor
        FROM Relojes
        WHERE id_reloj = :id_reloj
        """
        try:
            result = db.session.execute(text(query), {'id_reloj': id_reloj}).mappings().fetchone()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener el reloj: {ex}")

class ModelCompra:
    def crear_compra(self, db, compra):
        try:
            query = """
            INSERT INTO Compra (id_proveedor, id_reloj, total) 
            VALUES (:id_proveedor, :id_reloj, :total)
            """
            db.session.execute(text(query), {
                'id_proveedor': compra.id_proveedor,
                'id_reloj': compra.id_reloj,
                'total': compra.total
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al crear la compra: {ex}")

    def leer_compras(self, db):
        try:
            query = """
            SELECT 
                C.id_compra, 
                C.total, 
                C.fecha_compra, 
                P.id_proveedor, 
                P.nombre AS proveedor_nombre,
                R.id_reloj,
                R.modelo AS reloj_nombre
            FROM Compra C
            JOIN Proveedor P ON C.id_proveedor = P.id_proveedor
            JOIN Relojes R ON C.id_reloj = R.id_reloj
            """
            result = db.session.execute(text(query))
            # Usar .mappings() para garantizar acceso por nombres
            return [
                {
                    'id_compra': row['id_compra'],
                    'id_proveedor': row['id_proveedor'],
                    'proveedor_nombre': row['proveedor_nombre'],
                    'id_reloj': row['id_reloj'],
                    'reloj_nombre': row['reloj_nombre'],
                    'total': row['total'],
                    'fecha_compra': row['fecha_compra']
                } 
                for row in result.mappings()
            ]
        except Exception as ex:
            raise Exception(f"Error al leer las compras: {ex}")
            
    def actualizar_compra(self, db, compra):
        try:
            query = """
            UPDATE Compra 
            SET id_proveedor = :id_proveedor, 
                id_reloj = :id_reloj, 
                total = :total
            WHERE id_compra = :id_compra
            """
            db.session.execute(text(query), {
                'id_compra': compra.id_compra,
                'id_proveedor': compra.id_proveedor,
                'id_reloj': compra.id_reloj,
                'total': compra.total
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al actualizar la compra: {ex}")

    def eliminar_compra(self, db, id_compra):
        try:
            query = "DELETE FROM Compra WHERE id_compra = :id_compra"
            db.session.execute(text(query), {'id_compra': id_compra})
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al eliminar la compra: {ex}")

    def obtener_proveedores(self, db):
        try:
            query = "SELECT id_proveedor, nombre FROM Proveedor"
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al obtener proveedores: {ex}")

    def obtener_relojes(self, db):
        try:
            query = "SELECT id_reloj, modelo FROM Relojes"
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al obtener relojes: {ex}")

class ModelInventario:
    def leer_inventario_con_detalles(self, db):
        query = """
        SELECT 
            I.id_inventario,
            I.cantidad,
            R.id_reloj,
            R.modelo AS reloj_modelo,
            C.id_compra,
            CONCAT('Compra #', C.id_compra) AS compra_info
        FROM Inventario I
        JOIN Relojes R ON I.id_reloj = R.id_reloj
        JOIN Compra C ON I.id_compra = C.id_compra
        """
        result = db.session.execute(text(query))
        return result.fetchall()

    def crear_inventario(self, db, id_reloj, id_compra, cantidad):
        query = """
        INSERT INTO Inventario (id_reloj, id_compra, cantidad)
        VALUES (:id_reloj, :id_compra, :cantidad)
        """
        db.session.execute(text(query), {
            'id_reloj': id_reloj,
            'id_compra': id_compra,
            'cantidad': cantidad
        })
        db.session.commit()

    def actualizar_inventario(self, db, id_inventario, id_reloj, id_compra, cantidad):
        query = """
        UPDATE Inventario
        SET id_reloj = :id_reloj, 
            id_compra = :id_compra, 
            cantidad = :cantidad
        WHERE id_inventario = :id_inventario
        """
        db.session.execute(text(query), {
            'id_inventario': id_inventario,
            'id_reloj': id_reloj,
            'id_compra': id_compra,
            'cantidad': cantidad
        })
        db.session.commit()

    def eliminar_inventario(self, db, id_inventario):
        query = "DELETE FROM Inventario WHERE id_inventario = :id_inventario"
        db.session.execute(text(query), {'id_inventario': id_inventario})
        db.session.commit()

    def obtener_catalogo_productos(self, db):
        query = """
        SELECT 
            I.id_inventario,
            I.cantidad,
            R.id_reloj,
            R.modelo AS nombre,
            R.precio,
            R.descripcion,
            R.imagen_url,
            CONCAT('Compra #', C.id_compra) AS compra_info
        FROM Inventario I
        JOIN Relojes R ON I.id_reloj = R.id_reloj
        JOIN Compra C ON I.id_compra = C.id_compra
        """
        try:
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener el catálogo: {ex}")
        
    def obtener_inventario_consolidado(self, db):
        """
        Obtiene información consolidada del inventario, combinando cantidades de relojes con la misma referencia.
        """
        query = """
        SELECT 
            R.modelo AS nombre_reloj,
            M.nombre AS marca,
            R.descripcion,
            R.precio AS precio_inventario,
            SUM(I.cantidad) AS cantidad_disponible
        FROM Inventario I
        JOIN Relojes R ON I.id_reloj = R.id_reloj
        JOIN Marca M ON R.id_marca = M.id_marca
        GROUP BY R.modelo, M.nombre, R.descripcion, R.precio
        ORDER BY M.nombre, R.modelo
        """
        try:
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener inventario consolidado: {ex}")
        
    def obtener_informacion_inventario(self, db):
        """
        Obtiene la información consolidada del inventario, combinando la cantidad total de relojes con la misma referencia.
        """
        try:
            query = """
            SELECT 
                M.nombre AS marca,
                R.modelo AS nombre_reloj,
                R.descripcion,
                R.precio AS precio_inventario,
                SUM(I.cantidad) AS cantidad_disponible
            FROM Inventario I
            JOIN Relojes R ON I.id_reloj = R.id_reloj
            JOIN Marca M ON R.id_marca = M.id_marca
            GROUP BY M.nombre, R.modelo, R.descripcion, R.precio
            ORDER BY M.nombre, R.modelo;
            """
            result = db.session.execute(text(query))
            return result.mappings().all()
        except Exception as ex:
            raise Exception(f"Error al obtener la información del inventario: {ex}")

    def obtener_relojes(self, db):
        query = "SELECT id_reloj, modelo FROM Relojes"
        result = db.session.execute(text(query))
        return result.fetchall()

    def obtener_compras(self, db):
        query = "SELECT id_compra FROM Compra"
        result = db.session.execute(text(query))
        return result.fetchall()

    def buscar_inventario(self, db, criterio):
        """
        Busca inventarios que coincidan con un criterio en el modelo del reloj o cantidad disponible.
        """
        try:
            query = """
            SELECT I.id_inventario, R.modelo AS reloj_modelo, I.cantidad
            FROM Inventario I
            JOIN Relojes R ON I.id_reloj = R.id_reloj
            WHERE R.modelo ILIKE :criterio
            OR CAST(I.cantidad AS TEXT) ILIKE :criterio
            """
            result = db.session.execute(text(query), {'criterio': criterio}).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al buscar inventario: {ex}")

    def leer_inventario_con_detalles(self, db):
        query = """
        SELECT 
            I.id_inventario,
            I.cantidad,
            R.id_reloj,
            R.modelo AS reloj_modelo,
            C.id_compra,
            CONCAT('Compra #', C.id_compra) AS compra_info
        FROM Inventario I
        JOIN Relojes R ON I.id_reloj = R.id_reloj
        JOIN Compra C ON I.id_compra = C.id_compra
        """
        try:
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al leer el inventario: {ex}")
        
class ModelCliente:
# Crear Cliente    
    def crear_cliente(self, db, cliente):
        try:
            consulta = text("SELECT CrearCliente(:nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "nombre": cliente.nombre,
                "telefono": cliente.telefono,
                "direccion": cliente.direccion,
                "email": cliente.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Leer Cliente
    def leer_clientes(self, db):
        try:
            consulta = text("SELECT * FROM LeerClientes()")
            result = db.session.execute(consulta).fetchall()
            return [Cliente(*row) for row in result]
        except Exception as ex:
            raise Exception(ex)

# Actualizar Cliente
    def actualizar_cliente(self, db, cliente):
        try:
            consulta = text("SELECT ActualizarCliente(:id_cliente, :nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "id_cliente": cliente.id_cliente,
                "nombre": cliente.nombre,
                "telefono": cliente.telefono,
                "direccion": cliente.direccion,
                "email": cliente.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Actualizar Cliente
    def eliminar_cliente(self, db, id_cliente):
        try:
            consulta = text("SELECT EliminarCliente(:id_cliente)")
            db.session.execute(consulta, {"id_cliente": id_cliente})
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)
    
    def buscar_clientes(self, db, criterio):
        """
        Busca clientes que coincidan con un criterio en nombre, teléfono, dirección o email.
        """
        try:
            query = """
            SELECT id_cliente, nombre, telefono, direccion, email
            FROM Cliente
            WHERE nombre ILIKE :criterio
            OR telefono ILIKE :criterio
            OR direccion ILIKE :criterio
            OR email ILIKE :criterio
            """
            result = db.session.execute(text(query), {'criterio': criterio}).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al buscar clientes: {ex}")
        
    def obtener_clientes(self, db):
        """
        Retrieves all clients for dropdown selection.
        """
        try:
            query = "SELECT id_cliente, nombre FROM Cliente"
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener clientes: {ex}")

class ModelVenta:
    
    def crear_venta(self, db, venta):
        """
        Inserts a new sale into the Venta table.
        """
        try:
            query = """
            INSERT INTO Venta (id_cliente, id_empleado, total)
            VALUES (:id_cliente, :id_empleado, :total)
            """
            db.session.execute(text(query), {
                'id_cliente': venta.id_cliente,
                'id_empleado': venta.id_empleado,
                'total': venta.total
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al crear la venta: {ex}")
    
    def leer_ventas(self, db):
        """
        Reads all sales along with client and employee details.
        """
        try:
            print("aaaa")
            query = """
            SELECT 
                V.id_venta,
                C.nombre AS cliente_nombre,
                E.nombre AS empleado_nombre,
                V.total,
                V.fecha_venta
            FROM Venta V
            JOIN Cliente C ON V.id_cliente = C.id_cliente
            JOIN Empleado E ON V.id_empleado = E.id_empleado
            """
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al leer las ventas: {ex}")

    def actualizar_venta(self, db, venta):
        """
        Updates an existing sale in the Venta table.
        """
        try:
            query = """
            UPDATE Venta 
            SET id_cliente = :id_cliente, 
                id_empleado = :id_empleado, 
                total = :total
            WHERE id_venta = :id_venta
            """
            db.session.execute(text(query), {
                'id_venta': venta.id_venta,
                'id_cliente': venta.id_cliente,
                'id_empleado': venta.id_empleado,
                'total': venta.total
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al actualizar la venta: {ex}")

    def eliminar_venta(self, db, id_venta):
        """
        Deletes a sale from the Venta table.
        """
        try:
            query = "DELETE FROM Venta WHERE id_venta = :id_venta"
            db.session.execute(text(query), {'id_venta': id_venta})
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al eliminar la venta: {ex}")

    def obtener_clientes(self, db):
        """
        Retrieves all clients for dropdown selection.
        """
        try:
            query = "SELECT id_cliente, nombre FROM Cliente"
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener clientes: {ex}")

    def obtener_empleados(self, db):
        """
        Retrieves all employees for dropdown selection.
        """
        try:
            query = "SELECT id_empleado, nombre FROM Empleado"
            result = db.session.execute(text(query)).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al obtener empleados: {ex}")

    def buscar_ventas(self, db, criterio):
        """
        Busca ventas que coincidan con un criterio en el nombre del cliente, fecha o total.
        """
        try:
            query = """
            SELECT V.id_venta, V.total, V.fecha_venta, C.nombre AS cliente_nombre, E.nombre AS empleado_nombre
            FROM Venta V
            JOIN Cliente C ON V.id_cliente = C.id_cliente
            JOIN Empleado E ON V.id_empleado = E.id_empleado
            WHERE C.nombre ILIKE :criterio
            OR CAST(V.total AS TEXT) ILIKE :criterio
            OR CAST(V.fecha_venta AS TEXT) ILIKE :criterio
            """
            result = db.session.execute(text(query), {'criterio': criterio}).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al buscar ventas: {ex}")
        
class ModelDetalleVenta:
    def leer_detalles(self, db):
        """
        Reads all sales details including relevant data from associated tables.
        """
        query = """
        SELECT 
            DV.id_detalle,
            DV.id_venta,
            DV.id_reloj,
            R.modelo AS reloj_modelo,
            DV.cantidad,
            DV.precio_unitario,
            V.id_cliente,
            C.nombre AS cliente_nombre,
            V.fecha_venta
        FROM DetalleVenta DV
        JOIN Venta V ON DV.id_venta = V.id_venta
        JOIN Cliente C ON V.id_cliente = C.id_cliente
        JOIN Relojes R ON DV.id_reloj = R.id_reloj
        """
        try:
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al leer los detalles de ventas: {ex}")

    def crear_detalle(self, db, detalle):
        """
        Inserts a new sale detail into the DetalleVenta table.
        """
        query = """
        INSERT INTO DetalleVenta (id_venta, id_reloj, cantidad, precio_unitario)
        VALUES (:id_venta, :id_reloj, :cantidad, :precio_unitario)
        """
        try:
            db.session.execute(text(query), {
                'id_venta': detalle.id_venta,
                'id_reloj': detalle.id_reloj,
                'cantidad': detalle.cantidad,
                'precio_unitario': detalle.precio_unitario
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al crear el detalle de venta: {ex}")

    def actualizar_detalle(self, db, detalle):
        """
        Updates an existing sale detail in the DetalleVenta table.
        """
        query = """
        UPDATE DetalleVenta
        SET id_venta = :id_venta,
            id_reloj = :id_reloj,
            cantidad = :cantidad,
            precio_unitario = :precio_unitario
        WHERE id_detalle = :id_detalle
        """
        try:
            db.session.execute(text(query), {
                'id_detalle': detalle.id_detalle,
                'id_venta': detalle.id_venta,
                'id_reloj': detalle.id_reloj,
                'cantidad': detalle.cantidad,
                'precio_unitario': detalle.precio_unitario
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al actualizar el detalle de venta: {ex}")

    def eliminar_detalle(self, db, id_detalle):
        """
        Deletes a sale detail by its ID.
        """
        query = "DELETE FROM DetalleVenta WHERE id_detalle = :id_detalle"
        try:
            db.session.execute(text(query), {'id_detalle': id_detalle})
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al eliminar el detalle de venta: {ex}")

    def obtener_ventas(self, db):
        """
        Retrieves all sales from the Venta table.
        """
        query = """
        SELECT id_venta, CONCAT('Venta #', id_venta, ' - Cliente: ', C.nombre) AS descripcion 
        FROM Venta V 
        JOIN Cliente C ON V.id_cliente = C.id_cliente
        """
        try:
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al obtener las ventas: {ex}")

    def obtener_relojes(self, db):
        """
        Retrieves all watches from the Relojes table.
        """
        query = "SELECT id_reloj, modelo FROM Relojes"
        try:
            result = db.session.execute(text(query))
            return result.fetchall()
        except Exception as ex:
            raise Exception(f"Error al obtener los relojes: {ex}")
        
    def buscar_detalle_ventas(self, db, criterio):
        """
        Busca detalles de ventas que coincidan con un criterio en el modelo del reloj, nombre del cliente o cantidad.
        """
        try:
            query = """
            SELECT DV.id_detalle, DV.id_venta, DV.id_reloj, R.modelo AS reloj_modelo, 
                   DV.cantidad, DV.precio_unitario, C.nombre AS cliente_nombre
            FROM DetalleVenta DV
            JOIN Venta V ON DV.id_venta = V.id_venta
            JOIN Cliente C ON V.id_cliente = C.id_cliente
            JOIN Relojes R ON DV.id_reloj = R.id_reloj
            WHERE R.modelo ILIKE :criterio
            OR C.nombre ILIKE :criterio
            OR CAST(DV.cantidad AS TEXT) ILIKE :criterio
            """
            result = db.session.execute(text(query), {'criterio': criterio}).mappings().all()
            return result
        except Exception as ex:
            raise Exception(f"Error al buscar detalles de ventas: {ex}")
        
class ModelEmpleado:

# Crear Empleado    
    def crear_empleado(self, db, empleado):
        try:
            consulta = text("SELECT CrearEmpleado(:nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "nombre": empleado.nombre,
                "telefono": empleado.telefono,
                "direccion": empleado.direccion,
                "email": empleado.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Leer Empleado
    def leer_empleados(self, db):
        try:
            consulta = text("SELECT * FROM LeerEmpleados()")
            result = db.session.execute(consulta).fetchall()
            return [Empleado(*row) for row in result]
        except Exception as ex:
            raise Exception(ex)

# Actualizar Empleado
    def actualizar_empleado(self, db, empleado):
        try:
            consulta = text("SELECT ActualizarEmpleado(:id_empleado, :nombre, :telefono, :direccion, :email)")
            db.session.execute(consulta, {
                "id_empleado": empleado.id_empleado,
                "nombre": empleado.nombre,
                "telefono": empleado.telefono,
                "direccion": empleado.direccion,
                "email": empleado.email
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

# Eliminar Empleado
    def eliminar_empleado(self, db, id_empleado):
        try:
            consulta = text("SELECT EliminarEmpleado(:id_empleado)")
            db.session.execute(consulta, {"id_empleado": id_empleado})
            db.session.commit()
        except Exception as ex:
            raise Exception(ex)

class ModelLoginEmpleado:

    # Crear LoginEmpleado    
    def crear_login(self, db, login):
        """
        Inserta un nuevo LoginEmpleado en la base de datos utilizando el procedimiento almacenado CrearLoginEmpleado.
        """
        try:
            consulta = text("SELECT CrearLoginEmpleado(:id_empleado, :usuario, :contrasena, :cargo)")
            db.session.execute(consulta, {
                "id_empleado": login.id_empleado,
                "usuario": login.usuario,
                "contrasena": login.contrasena,
                "cargo": login.cargo  # Incluye el campo cargo
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al crear LoginEmpleado: {ex}")

    # Leer todos los LoginEmpleado
    def leer_logins(self, db):
        try:
            consulta = text("SELECT * FROM LeerLoginsEmpleado()")
            result = db.session.execute(consulta).fetchall()
            return [
                LoginEmpleado(
                    id_login=row[0],        # Índice para id_login
                    id_empleado=row[1],     # Índice para id_empleado
                    usuario=row[2],         # Índice para usuario
                    contrasena=row[3],      # Índice para contrasena
                    cargo=row[4]            # Índice para cargo
                ) for row in result
            ]
        except Exception as ex:
            raise Exception(f"Error al leer LoginsEmpleado: {ex}")


    # Actualizar LoginEmpleado
    def actualizar_login(self, db, login):
        """
        Actualiza un LoginEmpleado utilizando el procedimiento almacenado ActualizarLoginEmpleado.
        """
        try:
            consulta = text("SELECT ActualizarLoginEmpleado(:id_login, :usuario, :contrasena, :cargo)")
            db.session.execute(consulta, {
                "id_login": login.id_login,
                "usuario": login.usuario,
                "contrasena": login.contrasena,
                "cargo": login.cargo
            })
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al actualizar LoginEmpleado: {ex}")

    # Eliminar LoginEmpleado
    def eliminar_login(self, db, id_login):
        """
        Elimina un LoginEmpleado utilizando el procedimiento almacenado EliminarLoginEmpleado.
        """
        try:
            consulta = text("SELECT EliminarLoginEmpleado(:id_login)")
            db.session.execute(consulta, {"id_login": id_login})
            db.session.commit()
        except Exception as ex:
            raise Exception(f"Error al eliminar LoginEmpleado: {ex}")

    # Verificar LoginEmpleado   
    def verificar_login(self, db, usuario, contrasena):
        """
        Verifica el usuario y la contraseña utilizando el procedimiento almacenado VerificarLogin.
        """
        try:
            consulta = text("""
                SELECT id_login, id_empleado, usuario, cargo 
                FROM LoginEmpleado 
                WHERE usuario = :usuario 
                AND contrasena = crypt(:contrasena, contrasena)
            """)
            result = db.session.execute(consulta, {
                "usuario": usuario,
                "contrasena": contrasena
            }).mappings().fetchone()  # Usamos .mappings() para convertir las filas a diccionarios
            
            if result:
                return dict(result)  # Convertimos el resultado en un diccionario para usar índices de cadena
            else:
                return None
        except Exception as ex:
            raise Exception(f"Error al verificar LoginEmpleado: {ex}")
