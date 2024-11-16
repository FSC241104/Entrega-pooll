from flask import Flask, render_template, make_response, redirect, url_for, request, flash, session
from config import Config
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.exc import SQLAlchemyError
# Importar entidades y procedimientos
from app.models.entities import Proveedor, Marca, Relojes, Compra, Inventario, Cliente, Venta, Empleado, LoginEmpleado, DetalleVenta
from app.procedures import ModelProveedor, ModelMarca, ModelRelojes, ModelInventario, ModelVenta, ModelCompra, ModelCliente, ModelEmpleado, ModelLoginEmpleado, ModelDetalleVenta

app = Flask(__name__)
app.config.from_object(Config)
db = SQLAlchemy(app)

# ----------- Rutas -----------

# Ruta del Home para el layout de "Clientes"
@app.route('/')
def home():
    return render_template('home.html')  # Renderiza la plantilla home.html

# Ruta para la página About
@app.route('/about')
def about():
    return render_template('about.html')

# Ruta para el Catálogo
@app.route('/catalog')
def catalog():
    try:
        # Obtener la información del inventario desde la base de datos
        productos = ModelInventario().obtener_informacion_inventario(db)

        # Simulamos añadir rutas manuales para imágenes
        for producto in productos:
            producto['ruta_imagen'] = f"/static/img/{producto['nombre_reloj'].lower().replace(' ', '_')}.jpg"

        return render_template('catalog.html', productos=productos)
    except Exception as ex:
        flash(f"Error al cargar el catálogo: {ex}", "danger")
    return render_template('catalog.html', productos=productos)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['username']  # Campo del formulario de login
        contrasena = request.form['password']  # Campo del formulario de login

        login_model = ModelLoginEmpleado()

        try:
            # Verificar las credenciales del usuario con el procedimiento almacenado
            empleado = login_model.verificar_login(db, usuario, contrasena)
            if empleado:
                session['usuario'] = empleado['usuario']
                session['id_empleado'] = empleado['id_empleado']  # Guardar ID del empleado
                session['cargo'] = empleado['cargo']

                flash('Inicio de sesión exitoso', 'success')
                if empleado['cargo'].lower() == 'vendedor':
                    return redirect(url_for('vendedor_home'))
                elif empleado['cargo'].lower() == 'administrador':
                    return redirect(url_for('empleado_home'))
            else:
                flash('Credenciales incorrectas.', 'danger')
        except Exception as e:
            flash(f"Error al iniciar sesión: {e}", 'danger')

    return render_template('login.html')

# Login Codigo comentado
'''
# Ruta para iniciar sesión
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        usuario = request.form['username']
        contrasena = request.form['password']

        try:
            user_info = ModelLoginEmpleado().verificar_login(db, usuario, contrasena)
            if user_info:
                session['usuario'] = user_info['usuario']
                session['cargo'] = user_info['cargo']
                
                if user_info['cargo'].lower() == 'administrador':
                    return redirect(url_for('empleado_home'))
                elif user_info['cargo'].lower() == 'vendedor':
                    return redirect(url_for('vendedor_home'))
            else:
                flash('Credenciales incorrectas.', 'danger')
        except Exception as e:
            flash(f"Error al iniciar sesión: {e}", 'danger')

    return render_template('login.html')
'''
# Ruta para cerrar sesión
@app.route('/logout')
def logout():
    session.clear()
    flash("Sesión cerrada exitosamente.", "success")
    return redirect(url_for('login'))

# Ruta de página principal protegida
@app.route('/index')
def index():
    if 'usuario' in session:
        return render_template('home.html', usuario=session['usuario'])
    else:
        flash("Por favor, inicie sesión primero.", "warning")
        return redirect(url_for('login'))

# Ruta para restablecer la contraseña
@app.route('/empleado/forgot_password', methods=['GET', 'POST'])
def forgot_password():
    if request.method == 'POST':
        nombre = request.form.get('nombre')
        telefono = request.form.get('telefono')
        direccion = request.form.get('direccion')
        email = request.form.get('email')
        nueva_contrasena = request.form.get('nueva_contrasena')

        empleado_model = ModelEmpleado()
        mensaje = empleado_model.cambiar_contrasena_verificada(db, nombre, telefono, direccion, email, nueva_contrasena)

        if "Error" in mensaje:
            flash(mensaje, "danger")
        else:
            flash("Contraseña actualizada exitosamente.", "success")
            return redirect(url_for('login'))

    return render_template('forgot_password.html')

# ----------------------------------------------------------

# Home según Rol: Administrador
@app.route('/empleado/home')
def empleado_home():
    if 'usuario' not in session or session.get('cargo') != 'Administrador':
        flash("Acceso no autorizado. Inicia sesión como Administrador.", "danger")
        return redirect(url_for('login'))
    return render_template('empleado_home.html', usuario=session['usuario'])

# Gestión de Usuarios: Registrar LoginEmpleado
@app.route('/empleado/registrar', methods=['GET', 'POST'])
def register_user():
    login_model = ModelLoginEmpleado()
    empleado_model = ModelEmpleado()

    # Obtener todos los empleados para el desplegable
    empleados = empleado_model.leer_empleados(db)

    if request.method == 'POST':
        id_empleado = request.form.get('id_empleado')
        usuario = request.form.get('usuario')
        contrasena = request.form.get('contrasena')
        cargo = request.form.get('cargo', 'Vendedor')  # Por defecto Vendedor si no se especifica

        # Crear una instancia de LoginEmpleado
        nuevo_login = LoginEmpleado(id_login=None, id_empleado=id_empleado, usuario=usuario, contrasena=contrasena, cargo=cargo)

        # Llamar al procedimiento para crear el login
        try:
            login_model.crear_login(db, nuevo_login)
            flash("Usuario registrado exitosamente.", "success")
            return redirect(url_for('login'))
        except Exception as e:
            flash(f"Error al registrar usuario: {e}", "danger")

    return render_template('register.html', empleados=empleados)

# ----------------------------------------------------------

# Gestión de Proveedores
@app.route('/empleado/proveedores', methods=['GET', 'POST'])
def manage_proveedores():
    proveedor_model = ModelProveedor()

    if request.method == 'POST':
        if 'crear' in request.form:
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            nuevo_proveedor = Proveedor(id_proveedor=None, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            proveedor_model.crear_proveedor(db, nuevo_proveedor)
            flash("Proveedor creado exitosamente.", "success")
            return redirect(url_for('manage_proveedores'))
        
        elif 'actualizar' in request.form:
            id_proveedor = int(request.form.get('id_proveedor'))
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            proveedor = Proveedor(id_proveedor=id_proveedor, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            proveedor_model.actualizar_proveedor(db, proveedor)
            flash("Proveedor actualizado exitosamente.", "success")
            return redirect(url_for('manage_proveedores'))
        
        elif 'eliminar' in request.form:
            id_proveedor = int(request.form.get('id_proveedor'))
            proveedor_model.eliminar_proveedor(db, id_proveedor)
            flash("Proveedor eliminado exitosamente.", "success")
            return redirect(url_for('manage_proveedores'))

    proveedores = proveedor_model.leer_proveedores(db)
    return render_template('manage_proveedores.html', proveedores=proveedores)

# Gestión de Clientes
@app.route('/empleado/clientes', methods=['GET', 'POST'])
def manage_clientes():
    cliente_model = ModelCliente()

    if request.method == 'POST':
        if 'crear' in request.form:
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            nuevo_cliente = Cliente(id_cliente=None, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            cliente_model.crear_cliente(db, nuevo_cliente)
            flash("Cliente creado exitosamente.", "success")
            return redirect(url_for('manage_clientes'))
        
        elif 'actualizar' in request.form:
            id_cliente = int(request.form.get('id_cliente'))
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            cliente = Cliente(id_cliente=id_cliente, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            cliente_model.actualizar_cliente(db, cliente)
            flash("Cliente actualizado exitosamente.", "success")
            return redirect(url_for('manage_clientes'))
        
        elif 'eliminar' in request.form:
            id_cliente = int(request.form.get('id_cliente'))
            cliente_model.eliminar_cliente(db, id_cliente)
            flash("Cliente eliminado exitosamente.", "success")
            return redirect(url_for('manage_clientes'))

    clientes = cliente_model.leer_clientes(db)
    return render_template('manage_clientes.html', clientes=clientes)


# Gestión de Relojes
@app.route('/empleado/relojes', methods=['GET', 'POST'])
def manage_relojes():
    reloj_model = ModelRelojes()
    marcas = reloj_model.obtener_marcas(db)
    proveedores = reloj_model.obtener_proveedores(db)

    if request.method == 'POST':
        if 'crear' in request.form:
            modelo = request.form.get('modelo')
            precio = request.form.get('precio')
            descripcion = request.form.get('descripcion')
            id_marca = request.form.get('id_marca')
            id_proveedor = request.form.get('id_proveedor')
            reloj_model.crear_reloj(db, modelo, precio, descripcion, id_marca, id_proveedor)
            flash('Reloj creado exitosamente.', 'success')
            return redirect(url_for('manage_relojes'))

        elif 'actualizar' in request.form:
            id_reloj = request.form.get('id_reloj')
            modelo = request.form.get('modelo')
            precio = request.form.get('precio')
            descripcion = request.form.get('descripcion')
            id_marca = request.form.get('id_marca')
            id_proveedor = request.form.get('id_proveedor')
            reloj_model.actualizar_reloj(db, id_reloj, modelo, precio, descripcion, id_marca, id_proveedor)
            flash('Reloj actualizado exitosamente.', 'success')
            return redirect(url_for('manage_relojes'))

        elif 'eliminar' in request.form:
            id_reloj = request.form.get('id_reloj')
            reloj_model.eliminar_reloj(db, id_reloj)
            flash('Reloj eliminado exitosamente.', 'success')
            return redirect(url_for('manage_relojes'))

    relojes = reloj_model.leer_relojes_con_detalles(db)
    return render_template('manage_relojes.html', relojes=relojes, marcas=marcas, proveedores=proveedores)


# Gestión de Ventas
# Ruta para la gestión de ventas
@app.route('/empleado/ventas', methods=['GET', 'POST'])
def manage_ventas():
    venta_model = ModelVenta()
    
    # Obtener datos para los formularios
    clientes = venta_model.obtener_clientes(db)
    empleados = venta_model.obtener_empleados(db)
    
    if request.method == 'POST':
        if 'crear' in request.form:
            try:
                id_cliente = request.form.get('id_cliente')
                id_empleado = request.form.get('id_empleado')
                total = float(request.form.get('total'))
                
                nueva_venta = Venta(
                    id_cliente=id_cliente,
                    id_empleado=id_empleado,
                    total=total
                )
                venta_model.crear_venta(db, nueva_venta)
                flash('Venta creada exitosamente.', 'success')
            except Exception as ex:
                flash(f"Error al crear la venta: {ex}", 'danger')
            return redirect(url_for('manage_ventas'))

        elif 'actualizar' in request.form:
            try:
                id_venta = request.form.get('id_venta')
                id_cliente = request.form.get('id_cliente')
                id_empleado = request.form.get('id_empleado')
                total = float(request.form.get('total'))
                
                venta_actualizada = Venta(
                    id_venta=id_venta,
                    id_cliente=id_cliente,
                    id_empleado=id_empleado,
                    total=total
                )
                venta_model.actualizar_venta(db, venta_actualizada)
                flash('Venta actualizada exitosamente.', 'success')
            except Exception as ex:
                flash(f"Error al actualizar la venta: {ex}", 'danger')
            return redirect(url_for('manage_ventas'))

        elif 'eliminar' in request.form:
            try:
                id_venta = request.form.get('id_venta')
                venta_model.eliminar_venta(db, id_venta)
                flash('Venta eliminada exitosamente.', 'success')
            except Exception as ex:
                flash(f"Error al eliminar la venta: {ex}", 'danger')
            return redirect(url_for('manage_ventas'))

    # Leer ventas existentes   
    try:
        ventas = venta_model.leer_ventas(db)
        return render_template('manage_ventas.html', ventas=ventas, clientes=clientes, empleados=empleados)
    except Exception as ex:
        flash(f"Error al cargar las ventas: {ex}", 'danger')
        return redirect(url_for('empleado_home'))

# Gestión de Marcas
@app.route('/empleado/marcas', methods=['GET', 'POST'])
def manage_marcas():
    marca_model = ModelMarca()

    if request.method == 'POST':
        if 'crear' in request.form:
            nombre = request.form.get('nombre')
            nueva_marca = Marca(id_marca=None, nombre=nombre)
            marca_model.crear_marca(db, nueva_marca)
            flash("Marca creada exitosamente.", "success")
            return redirect(url_for('manage_marcas'))
        
        elif 'actualizar' in request.form:
            id_marca = int(request.form.get('id_marca'))
            nombre = request.form.get('nombre')
            marca = Marca(id_marca=id_marca, nombre=nombre)
            marca_model.actualizar_marca(db, marca)
            flash("Marca actualizada exitosamente.", "success")
            return redirect(url_for('manage_marcas'))
        
        elif 'eliminar' in request.form:
            id_marca = int(request.form.get('id_marca'))
            marca_model.eliminar_marca(db, id_marca)
            flash("Marca eliminada exitosamente.", "success")
            return redirect(url_for('manage_marcas'))

    marcas = marca_model.leer_marcas(db)
    return render_template('manage_marcas.html', marcas=marcas)

# Ruta para Detalle de Ventas
@app.route('/empleado/detalle_ventas', methods=['GET', 'POST'])
def manage_detalle_ventas():
    detalle_venta_model = ModelDetalleVenta()

    if request.method == 'POST':
        if 'crear' in request.form:
            id_venta = request.form.get('id_venta')
            id_reloj = request.form.get('id_reloj')
            cantidad = request.form.get('cantidad')
            precio_unitario = request.form.get('precio_unitario')

            nuevo_detalle = DetalleVenta(
                id_venta=id_venta,
                id_reloj=id_reloj,
                cantidad=cantidad,
                precio_unitario=precio_unitario
            )

            try:
                detalle_venta_model.crear_detalle(db, nuevo_detalle)
                flash('Detalle de venta creado exitosamente.', 'success')
            except Exception as ex:
                flash(f'Error al crear el detalle de venta: {ex}', 'danger')

        elif 'actualizar' in request.form:
            id_detalle = request.form.get('id_detalle')
            id_venta = request.form.get('id_venta')
            id_reloj = request.form.get('id_reloj')
            cantidad = request.form.get('cantidad')
            precio_unitario = request.form.get('precio_unitario')

            detalle_actualizado = DetalleVenta(
                id_detalle=id_detalle,
                id_venta=id_venta,
                id_reloj=id_reloj,
                cantidad=cantidad,
                precio_unitario=precio_unitario
            )

            try:
                detalle_venta_model.actualizar_detalle(db, detalle_actualizado)
                flash('Detalle de venta actualizado exitosamente.', 'success')
            except Exception as ex:
                flash(f'Error al actualizar el detalle de venta: {ex}', 'danger')

        elif 'eliminar' in request.form:
            id_detalle = request.form.get('id_detalle')
            try:
                detalle_venta_model.eliminar_detalle(db, id_detalle)
                flash('Detalle de venta eliminado exitosamente.', 'success')
            except Exception as ex:
                flash(f'Error al eliminar el detalle de venta: {ex}', 'danger')

    try:
        detalles = detalle_venta_model.leer_detalles(db)
        ventas = detalle_venta_model.obtener_ventas(db)
        relojes = detalle_venta_model.obtener_relojes(db)
    except Exception as ex:
        flash(f'Error al cargar los datos: {ex}', 'danger')
        detalles, ventas, relojes = [], [], []

    return render_template(
        'manage_detalle_ventas.html',
        detalles=detalles,
        ventas=ventas,
        relojes=relojes
    )

# Gestión de Inventario
@app.route('/empleado/inventario', methods=['GET', 'POST'])
def manage_inventario():
    inventario_model = ModelInventario()

    if request.method == 'POST':
        # Crear Inventario
        if 'crear' in request.form:
            id_reloj = int(request.form.get('id_reloj'))
            id_compra = int(request.form.get('id_compra'))
            cantidad = int(request.form.get('cantidad'))
            try:
                inventario_model.crear_inventario(db, id_reloj, id_compra, cantidad)
                flash('Inventario creado exitosamente.', 'success')
            except Exception as e:
                flash(f'Error al crear inventario: {str(e)}', 'danger')
            return redirect(url_for('manage_inventario'))

        # Actualizar Inventario
        elif 'actualizar' in request.form:
            id_inventario = int(request.form.get('id_inventario'))
            id_reloj = int(request.form.get('id_reloj'))
            id_compra = int(request.form.get('id_compra'))
            cantidad = int(request.form.get('cantidad'))
            try:
                inventario_model.actualizar_inventario(db, id_inventario, id_reloj, id_compra, cantidad)
                flash('Inventario actualizado exitosamente.', 'success')
            except Exception as e:
                flash(f'Error al actualizar inventario: {str(e)}', 'danger')
            return redirect(url_for('manage_inventario'))

        # Eliminar Inventario
        elif 'eliminar' in request.form:
            id_inventario = int(request.form.get('id_inventario'))
            try:
                inventario_model.eliminar_inventario(db, id_inventario)
                flash('Inventario eliminado exitosamente.', 'success')
            except Exception as e:
                flash(f'Error al eliminar inventario: {str(e)}', 'danger')
            return redirect(url_for('manage_inventario'))

    # Leer Inventario
    try:
        inventarios = inventario_model.leer_inventario_con_detalles(db)
        relojes = inventario_model.obtener_relojes(db)
        compras = inventario_model.obtener_compras(db)
    except Exception as e:
        flash(f'Error al cargar inventario: {str(e)}', 'danger')
        inventarios, relojes, compras = [], [], []

    return render_template('manage_inventario.html', inventarios=inventarios, relojes=relojes, compras=compras)

# Ruta para la gestión de compras
@app.route('/empleado/compras', methods=['GET', 'POST'])
def manage_compras():
    compra_model = ModelCompra()

    # Crear Compra
    if request.method == 'POST' and 'crear' in request.form:
        try:
            id_proveedor = int(request.form.get('id_proveedor'))
            id_reloj = int(request.form.get('id_reloj'))
            total = float(request.form.get('total'))
            
            nueva_compra = Compra(
                id_compra=None, 
                id_proveedor=id_proveedor, 
                id_reloj=id_reloj, 
                total=total
            )
            
            compra_model.crear_compra(db, nueva_compra)
            flash("Compra creada exitosamente.", "success")
        except Exception as ex:
            flash(f"Error al crear la compra: {ex}", "danger")
        return redirect(url_for('manage_compras'))

    # Actualizar Compra
    if request.method == 'POST' and 'actualizar' in request.form:
        try:
            id_compra = int(request.form.get('id_compra'))
            id_proveedor = int(request.form.get('id_proveedor'))
            id_reloj = int(request.form.get('id_reloj'))
            total = float(request.form.get('total'))
            
            compra_actualizada = Compra(
                id_compra=id_compra, 
                id_proveedor=id_proveedor, 
                id_reloj=id_reloj, 
                total=total
            )
            
            compra_model.actualizar_compra(db, compra_actualizada)
            flash("Compra actualizada exitosamente.", "success")
        except Exception as ex:
            flash(f"Error al actualizar la compra: {ex}", "danger")
        return redirect(url_for('manage_compras'))

    # Eliminar Compra
    if request.method == 'POST' and 'eliminar' in request.form:
        try:
            id_compra = int(request.form.get('id_compra'))
            compra_model.eliminar_compra(db, id_compra)
            flash("Compra eliminada exitosamente.", "success")
        except Exception as ex:
            flash(f"Error al eliminar la compra: {ex}", "danger")
        return redirect(url_for('manage_compras'))

    # Cargar Compras, Proveedores y Relojes
    try:
        compras = compra_model.leer_compras(db)
        proveedores = compra_model.obtener_proveedores(db)
        relojes = compra_model.obtener_relojes(db)
        
        return render_template(
            'manage_compras.html', 
            compras=compras, 
            proveedores=proveedores, 
            relojes=relojes
        )
    except Exception as ex:
        flash(f"Error al cargar los datos: {ex}", "danger")
        return redirect(url_for('empleado_home'))
    
# Gestión de Empleados
@app.route('/empleado/empleados', methods=['GET', 'POST'])
def manage_empleados():
    empleado_model = ModelEmpleado()

    if request.method == 'POST':
        if 'crear' in request.form:
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            nuevo_empleado = Empleado(id_empleado=None, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            empleado_model.crear_empleado(db, nuevo_empleado)
            flash("Empleado creado exitosamente.", "success")
            return redirect(url_for('manage_empleados'))
        
        elif 'actualizar' in request.form:
            id_empleado = int(request.form.get('id_empleado'))
            nombre = request.form.get('nombre')
            telefono = request.form.get('telefono')
            direccion = request.form.get('direccion')
            email = request.form.get('email')
            empleado = Empleado(id_empleado=id_empleado, nombre=nombre, telefono=telefono, direccion=direccion, email=email)
            empleado_model.actualizar_empleado(db, empleado)
            flash("Empleado actualizado exitosamente.", "success")
            return redirect(url_for('manage_empleados'))
        
        elif 'eliminar' in request.form:
            id_empleado = int(request.form.get('id_empleado'))
            empleado_model.eliminar_empleado(db, id_empleado)
            flash("Empleado eliminado exitosamente.", "success")
            return redirect(url_for('manage_empleados'))

    empleados = empleado_model.leer_empleados(db)
    return render_template('manage_empleados.html', empleados=empleados)


# ----------- Fin de Rutas -----------

@app.route('/empleado/manage_loginempleado', methods=['GET', 'POST'])
def manage_loginempleado():
    login_model = ModelLoginEmpleado()
    empleado_model = ModelEmpleado()

    # Obtener empleados para el desplegable
    empleados = empleado_model.leer_empleados(db)

    if request.method == 'POST':
        accion = request.form.get('accion')
        id_login = request.form.get('id_login')
        id_empleado = request.form.get('id_empleado')
        usuario = request.form.get('usuario')
        contrasena = request.form.get('contrasena')
        cargo = request.form.get('cargo')

        try:
            if accion == 'crear':
                nuevo_login = LoginEmpleado(None, id_empleado, usuario, contrasena, cargo)
                login_model.crear_login(db, nuevo_login)
                flash('LoginEmpleado creado exitosamente.', 'success')

            elif accion == 'actualizar':
                login_actualizado = LoginEmpleado(id_login, id_empleado, usuario, contrasena, cargo)
                login_model.actualizar_login(db, login_actualizado)
                flash('LoginEmpleado actualizado con éxito.', 'info')

            elif accion == 'eliminar':
                login_model.eliminar_login(db, id_login)
                flash('LoginEmpleado eliminado con éxito.', 'warning')

        except Exception as e:
            flash(f'Error: {e}', 'danger')

    # Leer todos los LoginEmpleados para la tabla
    logins = login_model.leer_logins(db)

    return render_template('manage_loginempleado.html', empleados=empleados, logins=logins)

# --------------------------------------------------------------------------------------
# Home según Rol: Vendedor


'''

# *** VENDEDOR CRUD Y PAGINAS *** #

'''

@app.route('/vendedor/home')
def vendedor_home():
    if 'cargo' in session and session['cargo'].lower() == 'vendedor':
        return render_template('vendedor_home.html')
    else:
        flash("No tienes permiso para acceder a esta sección.", "danger")
        return redirect(url_for('login'))

# Vendedor Home
'''
@app.route('/vendedor/home')
def vendedor_home():
    if 'usuario' not in session or session.get('cargo') != 'Vendedor':
        flash("Acceso no autorizado. Inicia sesión como Vendedor.", "danger")
        return redirect(url_for('login'))
    return render_template('vendedor_home.html', usuario=session['usuario'])
'''
# Pre aprobado
@app.route('/vendedor/clientes', methods=['GET', 'POST'])
def vendedor_manage_clientes():
    cliente_model = ModelCliente()

    try:
        if request.method == 'POST':
            if 'crear' in request.form:
                nombre = request.form['nombre']
                telefono = request.form['telefono']
                direccion = request.form['direccion']
                email = request.form['email']

                if not nombre or not telefono or not direccion or not email:
                    flash("Todos los campos son obligatorios.", "danger")
                    return redirect(url_for('vendedor_manage_clientes'))

                nuevo_cliente = Cliente(None, nombre, telefono, direccion, email)
                cliente_model.crear_cliente(db, nuevo_cliente)
                flash("Cliente creado exitosamente.", "success")

            elif 'actualizar' in request.form:
                id_cliente = int(request.form['id_cliente'])
                nombre = request.form['nombre']
                telefono = request.form['telefono']
                direccion = request.form['direccion']
                email = request.form['email']

                if not id_cliente or not nombre or not telefono or not direccion or not email:
                    flash("Todos los campos son obligatorios para actualizar.", "danger")
                    return redirect(url_for('vendedor_manage_clientes'))

                cliente = Cliente(id_cliente, nombre, telefono, direccion, email)
                cliente_model.actualizar_cliente(db, cliente)
                flash("Cliente actualizado exitosamente.", "success")

            elif 'buscar' in request.form:
                criterio = request.form['criterio']
                query = f"%{criterio}%"
                clientes = cliente_model.buscar_clientes(db, query)
                return render_template('vendedor_manage_clientes.html', clientes=clientes)

        clientes = cliente_model.leer_clientes(db)
        return render_template('vendedor_manage_clientes.html', clientes=clientes)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_manage_clientes'))

@app.route('/vendedor/ventas', methods=['GET', 'POST'])
def vendedor_manage_ventas():
    cliente_model = ModelCliente()
    venta_model = ModelVenta()

    try:
        if 'cargo' not in session or session['cargo'].lower() != 'vendedor':
            flash("No tienes permiso para acceder a esta sección.", "danger")
            return redirect(url_for('login'))

        if request.method == 'POST':
            if 'crear' in request.form:
                id_cliente = request.form['id_cliente']
                id_empleado = session['id_empleado']  # ID del vendedor en sesión
                total = request.form['total']

                if not id_cliente or not total:
                    flash("Todos los campos son obligatorios para registrar la venta.", "danger")
                    return redirect(url_for('vendedor_manage_ventas'))

                try:
                    nueva_venta = Venta(None, id_cliente, id_empleado, float(total))
                    venta_model.crear_venta(db, nueva_venta)
                    flash("Venta creada exitosamente.", "success")
                except Exception as ex:
                    flash(f"Error al crear la venta: {ex}", "danger")

            elif 'buscar' in request.form:
                criterio = request.form['criterio']
                ventas = venta_model.buscar_ventas(db, f"%{criterio}%")
                clientes = cliente_model.obtener_clientes(db)
                return render_template('vendedor_manage_ventas.html', ventas=ventas, clientes=clientes)

        # Mostrar todas las ventas y clientes al cargar la página
        ventas = venta_model.leer_ventas(db)
        clientes = cliente_model.obtener_clientes(db)
        return render_template('vendedor_manage_ventas.html', ventas=ventas, clientes=clientes)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_manage_ventas'))

# Codigo Vendedor ventas
'''
@app.route('/vendedor/ventas', methods=['GET', 'POST'])
def vendedor_manage_ventas():
    cliente_model = ModelCliente()
    venta_model = ModelVenta()

    try:
        if request.method == 'POST':
            if 'crear' in request.form:
                # Capturar datos del formulario
                id_cliente = request.form.get('id_cliente')
                id_empleado = session.get('id_empleado')  # ID del vendedor en sesión
                total = request.form.get('total')

                # Validación de campos
                if not id_cliente or not id_empleado or not total:
                    flash("Todos los campos son obligatorios para registrar la venta.", "danger")
                    return redirect(url_for('vendedor_manage_ventas'))

                try:
                    total = float(total)  # Validar que el total sea un número
                except ValueError:
                    flash("El total debe ser un número válido.", "danger")
                    return redirect(url_for('vendedor_manage_ventas'))

                # Crear la nueva venta
                nueva_venta = Venta(None, id_cliente, id_empleado, total)
                venta_model.crear_venta(db, nueva_venta)
                flash("Venta creada exitosamente.", "success")
                return redirect(url_for('vendedor_manage_ventas'))

            elif 'buscar' in request.form:
                # Manejo de búsqueda
                criterio = request.form['criterio']
                query = f"%{criterio}%"
                ventas = venta_model.buscar_ventas(db, query)
                clientes = cliente_model.obtener_clientes(db)
                return render_template('vendedor_manage_ventas.html', ventas=ventas, clientes=clientes)

        # Cargar datos de ventas y clientes para el formulario
        clientes = venta_model.obtener_clientes(db)
        ventas = venta_model.leer_ventas(db)
        return render_template('vendedor_manage_ventas.html', ventas=ventas, clientes=clientes)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_manage_ventas'))
'''


@app.route('/vendedor/detalle_ventas', methods=['GET', 'POST'])
def vendedor_manage_detalle_ventas():
    detalle_venta_model = ModelDetalleVenta()
    venta_model = ModelVenta()
    reloj_model = ModelRelojes()

    try:
        # Validar si el usuario tiene el rol correcto
        if 'cargo' not in session or session['cargo'].lower() != 'vendedor':
            flash("No tienes permiso para acceder a esta sección.", "danger")
            return redirect(url_for('login'))

        if request.method == 'POST':
            if 'crear' in request.form:
                # Captura de datos del formulario
                id_venta = request.form.get('id_venta')
                id_reloj = request.form.get('id_reloj')
                cantidad = request.form.get('cantidad')

                # Validación de campos obligatorios
                if not id_venta or not id_reloj or not cantidad:
                    flash("Todos los campos son obligatorios.", "danger")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))

                try:
                    # Validar cantidad como entero positivo
                    cantidad = int(cantidad)
                    if cantidad <= 0:
                        flash("La cantidad debe ser mayor a 0.", "danger")
                        return redirect(url_for('vendedor_manage_detalle_ventas'))
                except ValueError:
                    flash("La cantidad debe ser un número entero válido.", "danger")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))

                try:
                    # Obtener precio del reloj
                    reloj = reloj_model.obtener_reloj_por_id(db, id_reloj)
                    if not reloj:
                        flash("Reloj no encontrado.", "danger")
                        return redirect(url_for('vendedor_manage_detalle_ventas'))

                    precio_unitario = reloj.precio
                    nuevo_detalle = DetalleVenta(None, id_venta, id_reloj, cantidad, precio_unitario)

                    # Crear el detalle de venta
                    detalle_venta_model.crear_detalle(db, nuevo_detalle)
                    flash("Detalle de venta creado exitosamente.", "success")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))
                except Exception as ex:
                    flash(f"Error al crear detalle de venta: {ex}", "danger")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))

            elif 'buscar' in request.form:
                # Capturar el criterio de búsqueda
                criterio = request.form.get('criterio')
                if criterio:
                    try:
                        detalles = detalle_venta_model.buscar_detalle_ventas(db, f"%{criterio}%")
                        flash(f"Resultados de búsqueda para '{criterio}'", "info")
                    except Exception as ex:
                        flash(f"Error al buscar detalles de ventas: {ex}", "danger")
                        detalles = []
                else:
                    flash("Debe ingresar un criterio de búsqueda.", "warning")
                    detalles = []

                # Volver a cargar las listas de ventas y relojes
                ventas = venta_model.leer_ventas(db)
                relojes = reloj_model.leer_relojes_con_detalles(db)
                return render_template('vendedor_manage_detalle_ventas.html', detalles=detalles, ventas=ventas, relojes=relojes)

        # Cargar datos para la vista
        detalles = detalle_venta_model.leer_detalles(db)
        ventas = venta_model.leer_ventas(db)
        relojes = reloj_model.leer_relojes_con_detalles(db)
        return render_template('vendedor_manage_detalle_ventas.html', detalles=detalles, ventas=ventas, relojes=relojes)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_manage_detalle_ventas'))


'''
# Pre Aprobado
@app.route('/vendedor/detalle_ventas', methods=['GET', 'POST'])
def vendedor_manage_detalle_ventas():
    detalle_venta_model = ModelDetalleVenta()
    venta_model = ModelVenta()
    reloj_model = ModelRelojes()

    try:
        if request.method == 'POST':
            if 'crear' in request.form:
                id_venta = request.form['id_venta']
                id_reloj = request.form['id_reloj']
                cantidad = int(request.form['cantidad'])

                if not id_venta or not id_reloj or not cantidad:
                    flash("Todos los campos son obligatorios para crear un detalle de venta.", "danger")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))

                reloj = reloj_model.obtener_reloj_por_id(db, id_reloj)
                if not reloj:
                    flash("Reloj no encontrado.", "danger")
                    return redirect(url_for('vendedor_manage_detalle_ventas'))

                precio_unitario = reloj.precio
                nuevo_detalle = DetalleVenta(None, id_venta, id_reloj, cantidad, precio_unitario)

                detalle_venta_model.crear_detalle(db, nuevo_detalle)
                flash("Detalle de venta creado exitosamente.", "success")

        detalles = detalle_venta_model.leer_detalles(db)
        ventas = venta_model.leer_ventas(db)
        relojes = reloj_model.leer_relojes_con_detalles(db)
        return render_template('vendedor_manage_detalle_ventas.html', detalles=detalles, ventas=ventas, relojes=relojes)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_manage_detalle_ventas'))
'''

# Pre Aprobado
@app.route('/vendedor/inventario', methods=['GET', 'POST'])
def vendedor_manage_inventario():
    inventario_model = ModelInventario()

    try:
        if request.method == 'POST' and 'buscar' in request.form:
            criterio = f"%{request.form['criterio']}%"
            inventarios = inventario_model.buscar_inventario(db, criterio)
            return render_template('vendedor_manage_inventario.html', inventarios=inventarios)

        inventarios = inventario_model.leer_inventario_con_detalles(db)
        return render_template('vendedor_manage_inventario.html', inventarios=inventarios)

    except Exception as ex:
        flash(f"Error: {ex}", "danger")
        return redirect(url_for('vendedor_home'))

# --------------------------------------------------------------------------------------

# --------------------------------------------------------------------------------------


# --------------------------------------------------------------------------------------    


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
