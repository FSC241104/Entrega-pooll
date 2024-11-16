# models.py

''' Lista de Entities '''
# 1. Entity Proveedor 
# 2. Entity Marca
# 3. Entity Reloj
# 4. Entity Compra
# 5. Entity Inventario 
# 6. Entity Cliente
# 7. Entity Venta 
# 8. Entity DetalleVenta 
# 9. Entity Empleado 
# 10. Entity LoginEmpleado 
'''         Fin         '''

# 1. Entity Proveedor 
class Proveedor:
    def __init__(self, id_proveedor, nombre, telefono=None, direccion=None, email=None, fecha_registro=None):
        self.id_proveedor = id_proveedor
        self.nombre = nombre
        self.telefono = telefono
        self.direccion = direccion
        self.email = email
        self.fecha_registro = fecha_registro

    def __repr__(self):
        return f"<Proveedor id_proveedor={self.id_proveedor}, nombre={self.nombre}, telefono={self.telefono}>"

# 2. Entity Marca
class Marca:
    def __init__(self, id_marca, nombre):
        self.id_marca = id_marca
        self.nombre = nombre

    def __repr__(self):
        return f"<Marca id_marca={self.id_marca}, nombre={self.nombre}>"

# 3. Entity Reloj
class Relojes:
    def __init__(self, id_reloj, modelo, precio, descripcion=None, id_marca=None, id_proveedor=None, fecha_registro=None):
        self.id_reloj = id_reloj
        self.modelo = modelo
        self.precio = precio
        self.descripcion = descripcion
        self.id_marca = id_marca
        self.id_proveedor = id_proveedor
        self.fecha_registro = fecha_registro

    def __repr__(self):
        return f"<Relojes id_reloj={self.id_reloj}, modelo={self.modelo}, precio={self.precio}>"

# 4. Entity Compra
class Compra:
    def __init__(self, id_compra=None, id_proveedor=None, id_reloj=None, total=None, fecha_compra=None):
        self.id_compra = id_compra
        self.id_proveedor = id_proveedor
        self.id_reloj = id_reloj
        self.total = total
        self.fecha_compra = fecha_compra

    def __repr__(self):
        return (
            f"<Compra id_compra={self.id_compra}, id_proveedor={self.id_proveedor}, "
            f"id_reloj={self.id_reloj}, total={self.total}, fecha_compra={self.fecha_compra}>"
        )

    
# 5. Entity Inventario 
class Inventario:
    def __init__(self, id_inventario=None, id_reloj=None, cantidad=None, id_compra=None, fecha_actualizacion=None):
        self.id_inventario = id_inventario
        self.id_reloj = id_reloj
        self.cantidad = cantidad
        self.id_compra = id_compra
        self.fecha_actualizacion = fecha_actualizacion

    def __repr__(self):
        return (
            f"<Inventario id_inventario={self.id_inventario}, id_reloj={self.id_reloj}, "
            f"cantidad={self.cantidad}, id_compra={self.id_compra}, fecha_actualizacion={self.fecha_actualizacion}>"
        )

# 6. Entity Cliente
class Cliente:
    def __init__(self, id_cliente, nombre, telefono=None, direccion=None, email=None):
        self.id_cliente = id_cliente
        self.nombre = nombre
        self.telefono = telefono
        self.direccion = direccion
        self.email = email

    def __repr__(self):
        return f"<Cliente id_cliente={self.id_cliente}, nombre={self.nombre}>"

# 7. Entity Venta
# entities.py
class Venta:
    def __init__(self, id_venta=None, id_cliente=None, id_empleado=None, total=None, fecha_venta=None):
        self.id_venta = id_venta
        self.id_cliente = id_cliente
        self.id_empleado = id_empleado
        self.total = total
        self.fecha_venta = fecha_venta

    def __repr__(self):
        return (
            f"<Venta id_venta={self.id_venta}, id_cliente={self.id_cliente}, "
            f"id_empleado={self.id_empleado}, total={self.total}, fecha_venta={self.fecha_venta}>"
        )

# 8. Entity DetalleVenta
class DetalleVenta:
    def __init__(self, id_detalle=None, id_venta=None, id_reloj=None, cantidad=None, precio_unitario=None):
        self.id_detalle = id_detalle
        self.id_venta = id_venta
        self.id_reloj = id_reloj
        self.cantidad = cantidad
        self.precio_unitario = precio_unitario

    def __repr__(self):
        return (
            f"<DetalleVenta id_detalle={self.id_detalle}, id_venta={self.id_venta}, "
            f"id_reloj={self.id_reloj}, cantidad={self.cantidad}, "
            f"precio_unitario={self.precio_unitario}>"
        )



# 9. Entity Empleado
class Empleado:
    def __init__(self, id_empleado, nombre, telefono=None, direccion=None, email=None):
        self.id_empleado = id_empleado
        self.nombre = nombre
        self.telefono = telefono
        self.direccion = direccion
        self.email = email

    def __repr__(self):
        return f"<Empleado id_empleado={self.id_empleado}, nombre={self.nombre}>"

# 10. Entity Empleado
class LoginEmpleado:
    def __init__(self, id_login, id_empleado, usuario, contrasena, cargo='vendedor'):
        self.id_login = id_login
        self.id_empleado = id_empleado
        self.usuario = usuario
        self.contrasena = contrasena
        self.cargo = cargo

    def __repr__(self):
        return f"<LoginEmpleado id_login={self.id_login}, usuario={self.usuario}, cargo={self.cargo}>"