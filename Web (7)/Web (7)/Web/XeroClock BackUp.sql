PGDMP  *        
        
    |         	   XeroClock    16.4    16.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    27453 	   XeroClock    DATABASE     ~   CREATE DATABASE "XeroClock" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "XeroClock";
                postgres    false                        3079    27629    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false            �           0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            C           1255    27614 Y   actualizarcliente(integer, character varying, character varying, text, character varying)    FUNCTION     �  CREATE FUNCTION public.actualizarcliente(p_id_cliente integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Cliente
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_cliente = p_id_cliente;
    END;
    $$;
 �   DROP FUNCTION public.actualizarcliente(p_id_cliente integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false            A           1255    27606 +   actualizarcompra(integer, integer, numeric)    FUNCTION       CREATE FUNCTION public.actualizarcompra(p_id_compra integer, p_id_proveedor integer, p_total numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Compra SET id_proveedor = p_id_proveedor, total = p_total WHERE id_compra = p_id_compra;
    END;
    $$;
 e   DROP FUNCTION public.actualizarcompra(p_id_compra integer, p_id_proveedor integer, p_total numeric);
       public          postgres    false            ;           1255    27693 C   actualizardetalleventa(integer, integer, integer, integer, numeric)    FUNCTION     �  CREATE FUNCTION public.actualizardetalleventa(p_id_detalle integer, p_id_venta integer, p_id_reloj integer, p_cantidad integer, p_precio_unitario numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE DetalleVenta
    SET id_venta = p_id_venta,
        id_reloj = p_id_reloj,
        cantidad = p_cantidad,
        precio_unitario = p_precio_unitario
    WHERE id_detalle = p_id_detalle;
END;
$$;
 �   DROP FUNCTION public.actualizardetalleventa(p_id_detalle integer, p_id_venta integer, p_id_reloj integer, p_cantidad integer, p_precio_unitario numeric);
       public          postgres    false            -           1255    27622 Z   actualizarempleado(integer, character varying, character varying, text, character varying)    FUNCTION     �  CREATE FUNCTION public.actualizarempleado(p_id_empleado integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Empleado
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_empleado = p_id_empleado;
    END;
    $$;
 �   DROP FUNCTION public.actualizarempleado(p_id_empleado integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false                       1255    27679    actualizarfechainventario()    FUNCTION     �   CREATE FUNCTION public.actualizarfechainventario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_actualizacion := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;
 2   DROP FUNCTION public.actualizarfechainventario();
       public          postgres    false            >           1255    27610 /   actualizarinventario(integer, integer, integer)    FUNCTION     6  CREATE FUNCTION public.actualizarinventario(p_id_inventario integer, p_id_reloj integer, p_cantidad integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Inventario
        SET id_reloj = p_id_reloj, cantidad = p_cantidad
        WHERE id_inventario = p_id_inventario;
    END;
    $$;
 l   DROP FUNCTION public.actualizarinventario(p_id_inventario integer, p_id_reloj integer, p_cantidad integer);
       public          postgres    false            0           1255    27626 Y   actualizarloginempleado(integer, character varying, character varying, character varying)    FUNCTION       CREATE FUNCTION public.actualizarloginempleado(p_id_login integer, p_usuario character varying, p_contrasena character varying, p_cargo character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE LoginEmpleado
    SET usuario = p_usuario,
        contrasena = crypt(p_contrasena, gen_salt('bf')),
        cargo = p_cargo
    WHERE id_login = p_id_login;
END;
$$;
 �   DROP FUNCTION public.actualizarloginempleado(p_id_login integer, p_usuario character varying, p_contrasena character varying, p_cargo character varying);
       public          postgres    false            @           1255    27598 +   actualizarmarca(integer, character varying)    FUNCTION     �   CREATE FUNCTION public.actualizarmarca(p_id_marca integer, p_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Marca SET nombre = p_nombre WHERE id_marca = p_id_marca;
    END;
    $$;
 V   DROP FUNCTION public.actualizarmarca(p_id_marca integer, p_nombre character varying);
       public          postgres    false                       1255    27594 [   actualizarproveedor(integer, character varying, character varying, text, character varying)    FUNCTION     �  CREATE FUNCTION public.actualizarproveedor(p_id_proveedor integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Proveedor
        SET nombre = p_nombre, telefono = p_telefono, direccion = p_direccion, email = p_email
        WHERE id_proveedor = p_id_proveedor;
    END;
    $$;
 �   DROP FUNCTION public.actualizarproveedor(p_id_proveedor integer, p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false            %           1255    27602 L   actualizarreloj(integer, character varying, numeric, text, integer, integer)    FUNCTION     �  CREATE FUNCTION public.actualizarreloj(p_id_reloj integer, p_modelo character varying, p_precio numeric, p_descripcion text, p_id_marca integer, p_id_proveedor integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Relojes
        SET modelo = p_modelo, precio = p_precio, descripcion = p_descripcion, id_marca = p_id_marca, id_proveedor = p_id_proveedor
        WHERE id_reloj = p_id_reloj;
    END;
    $$;
 �   DROP FUNCTION public.actualizarreloj(p_id_reloj integer, p_modelo character varying, p_precio numeric, p_descripcion text, p_id_marca integer, p_id_proveedor integer);
       public          postgres    false                       1255    27618 3   actualizarventa(integer, integer, integer, numeric)    FUNCTION     N  CREATE FUNCTION public.actualizarventa(p_id_venta integer, p_id_cliente integer, p_id_empleado integer, p_total numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Venta
        SET id_cliente = p_id_cliente, id_empleado = p_id_empleado, total = p_total
        WHERE id_venta = p_id_venta;
    END;
    $$;
 x   DROP FUNCTION public.actualizarventa(p_id_venta integer, p_id_cliente integer, p_id_empleado integer, p_total numeric);
       public          postgres    false            �            1255    27681    aumentarinventariotrascompra()    FUNCTION     �  CREATE FUNCTION public.aumentarinventariotrascompra() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Inventario
    SET cantidad = cantidad + 
        (SELECT SUM(cantidad) FROM DetalleCompra WHERE DetalleCompra.id_compra = NEW.id_compra)
    WHERE Inventario.id_reloj IN 
        (SELECT id_reloj FROM DetalleCompra WHERE DetalleCompra.id_compra = NEW.id_compra);
    RETURN NEW;
END;
$$;
 5   DROP FUNCTION public.aumentarinventariotrascompra();
       public          postgres    false            1           1255    27612 K   crearcliente(character varying, character varying, text, character varying)    FUNCTION     P  CREATE FUNCTION public.crearcliente(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Cliente (nombre, telefono, direccion, email)
        VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$;
 �   DROP FUNCTION public.crearcliente(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false                       1255    27604    crearcompra(integer, numeric)    FUNCTION     �   CREATE FUNCTION public.crearcompra(p_id_proveedor integer, p_total numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Compra (id_proveedor, total) VALUES (p_id_proveedor, p_total);
    END;
    $$;
 K   DROP FUNCTION public.crearcompra(p_id_proveedor integer, p_total numeric);
       public          postgres    false                       1255    27691 5   creardetalleventa(integer, integer, integer, numeric)    FUNCTION     L  CREATE FUNCTION public.creardetalleventa(p_id_venta integer, p_id_reloj integer, p_cantidad integer, p_precio_unitario numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO DetalleVenta (id_venta, id_reloj, cantidad, precio_unitario)
    VALUES (p_id_venta, p_id_reloj, p_cantidad, p_precio_unitario);
END;
$$;
    DROP FUNCTION public.creardetalleventa(p_id_venta integer, p_id_reloj integer, p_cantidad integer, p_precio_unitario numeric);
       public          postgres    false                        1255    27620 L   crearempleado(character varying, character varying, text, character varying)    FUNCTION     R  CREATE FUNCTION public.crearempleado(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Empleado (nombre, telefono, direccion, email)
        VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$;
 �   DROP FUNCTION public.crearempleado(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false            /           1255    27608 *   crearinventario(integer, integer, integer)    FUNCTION        CREATE FUNCTION public.crearinventario(p_id_reloj integer, p_cantidad integer, p_id_compra integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Inventario (id_reloj, cantidad, id_compra)
        VALUES (p_id_reloj, p_cantidad, p_id_compra);
    END;
    $$;
 c   DROP FUNCTION public.crearinventario(p_id_reloj integer, p_cantidad integer, p_id_compra integer);
       public          postgres    false            .           1255    27624 T   crearloginempleado(integer, character varying, character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.crearloginempleado(p_id_empleado integer, p_usuario character varying, p_contrasena character varying, p_cargo character varying DEFAULT 'vendedor'::character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO LoginEmpleado (id_empleado, usuario, contrasena, cargo)
    VALUES (p_id_empleado, p_usuario, crypt(p_contrasena, gen_salt('bf')), p_cargo);
END;
$$;
 �   DROP FUNCTION public.crearloginempleado(p_id_empleado integer, p_usuario character varying, p_contrasena character varying, p_cargo character varying);
       public          postgres    false            ,           1255    27596    crearmarca(character varying)    FUNCTION     �   CREATE FUNCTION public.crearmarca(p_nombre character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Marca (nombre) VALUES (p_nombre);
    END;
    $$;
 =   DROP FUNCTION public.crearmarca(p_nombre character varying);
       public          postgres    false            �            1255    27592 M   crearproveedor(character varying, character varying, text, character varying)    FUNCTION     L  CREATE FUNCTION public.crearproveedor(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Proveedor (nombre, telefono, direccion, email) VALUES (p_nombre, p_telefono, p_direccion, p_email);
    END;
    $$;
 �   DROP FUNCTION public.crearproveedor(p_nombre character varying, p_telefono character varying, p_direccion text, p_email character varying);
       public          postgres    false            E           1255    27600 >   crearreloj(character varying, numeric, text, integer, integer)    FUNCTION     y  CREATE FUNCTION public.crearreloj(p_modelo character varying, p_precio numeric, p_descripcion text, p_id_marca integer, p_id_proveedor integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Relojes (modelo, precio, descripcion, id_marca, id_proveedor)
        VALUES (p_modelo, p_precio, p_descripcion, p_id_marca, p_id_proveedor);
    END;
    $$;
 �   DROP FUNCTION public.crearreloj(p_modelo character varying, p_precio numeric, p_descripcion text, p_id_marca integer, p_id_proveedor integer);
       public          postgres    false            *           1255    27616 %   crearventa(integer, integer, numeric)    FUNCTION       CREATE FUNCTION public.crearventa(p_id_cliente integer, p_id_empleado integer, p_total numeric) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Venta (id_cliente, id_empleado, total)
        VALUES (p_id_cliente, p_id_empleado, p_total);
    END;
    $$;
 _   DROP FUNCTION public.crearventa(p_id_cliente integer, p_id_empleado integer, p_total numeric);
       public          postgres    false            B           1255    27615    eliminarcliente(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarcliente(p_id_cliente integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Cliente WHERE id_cliente = p_id_cliente;
    END;
    $$;
 <   DROP FUNCTION public.eliminarcliente(p_id_cliente integer);
       public          postgres    false            "           1255    27607    eliminarcompra(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarcompra(p_id_compra integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Compra WHERE id_compra = p_id_compra;
    END;
    $$;
 :   DROP FUNCTION public.eliminarcompra(p_id_compra integer);
       public          postgres    false                       1255    27694    eliminardetalleventa(integer)    FUNCTION     �   CREATE FUNCTION public.eliminardetalleventa(p_id_detalle integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM DetalleVenta WHERE id_detalle = p_id_detalle;
END;
$$;
 A   DROP FUNCTION public.eliminardetalleventa(p_id_detalle integer);
       public          postgres    false            6           1255    27623    eliminarempleado(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarempleado(p_id_empleado integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Empleado WHERE id_empleado = p_id_empleado;
    END;
    $$;
 >   DROP FUNCTION public.eliminarempleado(p_id_empleado integer);
       public          postgres    false            �            1255    27611    eliminarinventario(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarinventario(p_id_inventario integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Inventario WHERE id_inventario = p_id_inventario;
    END;
    $$;
 B   DROP FUNCTION public.eliminarinventario(p_id_inventario integer);
       public          postgres    false            �            1255    27627    eliminarloginempleado(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarloginempleado(p_id_login integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM LoginEmpleado WHERE id_login = p_id_login;
END;
$$;
 @   DROP FUNCTION public.eliminarloginempleado(p_id_login integer);
       public          postgres    false                       1255    27599    eliminarmarca(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarmarca(p_id_marca integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Marca WHERE id_marca = p_id_marca;
    END;
    $$;
 8   DROP FUNCTION public.eliminarmarca(p_id_marca integer);
       public          postgres    false                       1255    27595    eliminarproveedor(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarproveedor(p_id_proveedor integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Proveedor WHERE id_proveedor = p_id_proveedor;
    END;
    $$;
 @   DROP FUNCTION public.eliminarproveedor(p_id_proveedor integer);
       public          postgres    false            I           1255    27603    eliminarreloj(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarreloj(p_id_reloj integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Relojes WHERE id_reloj = p_id_reloj;
    END;
    $$;
 8   DROP FUNCTION public.eliminarreloj(p_id_reloj integer);
       public          postgres    false            G           1255    27619    eliminarventa(integer)    FUNCTION     �   CREATE FUNCTION public.eliminarventa(p_id_venta integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Venta WHERE id_venta = p_id_venta;
    END;
    $$;
 8   DROP FUNCTION public.eliminarventa(p_id_venta integer);
       public          postgres    false            7           1255    27613    leerclientes()    FUNCTION       CREATE FUNCTION public.leerclientes() RETURNS TABLE(id_cliente integer, nombre character varying, telefono character varying, direccion text, email character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Cliente;
    END;
    $$;
 %   DROP FUNCTION public.leerclientes();
       public          postgres    false            #           1255    27605    leercompras()    FUNCTION     �   CREATE FUNCTION public.leercompras() RETURNS TABLE(id_compra integer, id_proveedor integer, fecha_compra date, total numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Compra;
    END;
    $$;
 $   DROP FUNCTION public.leercompras();
       public          postgres    false            J           1255    27692    leerdetallesventa()    FUNCTION     �   CREATE FUNCTION public.leerdetallesventa() RETURNS TABLE(id_detalle integer, id_venta integer, id_reloj integer, cantidad integer, precio_unitario numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM DetalleVenta;
END;
$$;
 *   DROP FUNCTION public.leerdetallesventa();
       public          postgres    false            �            1255    27621    leerempleados()    FUNCTION       CREATE FUNCTION public.leerempleados() RETURNS TABLE(id_empleado integer, nombre character varying, telefono character varying, direccion text, email character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Empleado;
    END;
    $$;
 &   DROP FUNCTION public.leerempleados();
       public          postgres    false            (           1255    27609    leerinventario()    FUNCTION       CREATE FUNCTION public.leerinventario() RETURNS TABLE(id_inventario integer, id_reloj integer, cantidad integer, id_compra integer, fecha_actualizacion timestamp without time zone)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Inventario;
    END;
    $$;
 '   DROP FUNCTION public.leerinventario();
       public          postgres    false                       1255    27625    leerloginsempleado()    FUNCTION       CREATE FUNCTION public.leerloginsempleado() RETURNS TABLE(id_login integer, id_empleado integer, usuario character varying, contrasena character varying, cargo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT * FROM LoginEmpleado;
END;
$$;
 +   DROP FUNCTION public.leerloginsempleado();
       public          postgres    false            K           1255    27597    leermarcas()    FUNCTION     �   CREATE FUNCTION public.leermarcas() RETURNS TABLE(id_marca integer, nombre character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Marca;
    END;
    $$;
 #   DROP FUNCTION public.leermarcas();
       public          postgres    false            $           1255    27593    leerproveedores()    FUNCTION     )  CREATE FUNCTION public.leerproveedores() RETURNS TABLE(id_proveedor integer, nombre character varying, telefono character varying, direccion text, email character varying, fecha_registro date)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Proveedor;
    END;
    $$;
 (   DROP FUNCTION public.leerproveedores();
       public          postgres    false            =           1255    27601    leerrelojes()    FUNCTION     $  CREATE FUNCTION public.leerrelojes() RETURNS TABLE(id_reloj integer, modelo character varying, precio numeric, descripcion text, id_marca integer, id_proveedor integer, fecha_registro date)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Relojes;
    END;
    $$;
 $   DROP FUNCTION public.leerrelojes();
       public          postgres    false            8           1255    27617    leerventas()    FUNCTION     �   CREATE FUNCTION public.leerventas() RETURNS TABLE(id_venta integer, id_cliente integer, id_empleado integer, fecha_venta date, total numeric)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY SELECT * FROM Venta;
    END;
    $$;
 #   DROP FUNCTION public.leerventas();
       public          postgres    false            �            1255    27683    reducirinventariotrasventa()    FUNCTION     �   CREATE FUNCTION public.reducirinventariotrasventa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Inventario
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_reloj = NEW.id_reloj;
    RETURN NEW;
END;
$$;
 3   DROP FUNCTION public.reducirinventariotrasventa();
       public          postgres    false            3           1255    27685    registrarventatotal()    FUNCTION     �   CREATE FUNCTION public.registrarventatotal() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE Venta
    SET total = total + (NEW.cantidad * NEW.precio_unitario)
    WHERE id_venta = NEW.id_venta;
    RETURN NEW;
END;
$$;
 ,   DROP FUNCTION public.registrarventatotal();
       public          postgres    false                       1255    27687    validarcantidadinventario()    FUNCTION     �  CREATE FUNCTION public.validarcantidadinventario() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;
 2   DROP FUNCTION public.validarcantidadinventario();
       public          postgres    false                       1255    27690 4   verificarlogin(character varying, character varying)    FUNCTION     �  CREATE FUNCTION public.verificarlogin(p_usuario character varying, p_contrasena character varying) RETURNS TABLE(id_login integer, id_empleado integer, usuario character varying, cargo character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT le.id_login, le.id_empleado, le.usuario, le.cargo
    FROM LoginEmpleado le
    WHERE le.usuario = p_usuario 
      AND le.contrasena = crypt(p_contrasena, le.contrasena);
END;
$$;
 b   DROP FUNCTION public.verificarlogin(p_usuario character varying, p_contrasena character varying);
       public          postgres    false            �            1259    27523    cliente    TABLE     �   CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(15),
    direccion text,
    email character varying(100)
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    27522    cliente_id_cliente_seq    SEQUENCE     �   CREATE SEQUENCE public.cliente_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.cliente_id_cliente_seq;
       public          postgres    false    227            �           0    0    cliente_id_cliente_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.cliente_id_cliente_seq OWNED BY public.cliente.id_cliente;
          public          postgres    false    226            �            1259    27492    compra    TABLE     �   CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    id_proveedor integer,
    fecha_compra date DEFAULT CURRENT_DATE,
    total numeric(10,2) NOT NULL
);
    DROP TABLE public.compra;
       public         heap    postgres    false            �            1259    27491    compra_id_compra_seq    SEQUENCE     �   CREATE SEQUENCE public.compra_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.compra_id_compra_seq;
       public          postgres    false    223            �           0    0    compra_id_compra_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.compra_id_compra_seq OWNED BY public.compra.id_compra;
          public          postgres    false    222            �            1259    27576    detalleventa    TABLE     �   CREATE TABLE public.detalleventa (
    id_detalle integer NOT NULL,
    id_venta integer,
    id_reloj integer,
    cantidad integer NOT NULL,
    precio_unitario numeric(10,2) NOT NULL
);
     DROP TABLE public.detalleventa;
       public         heap    postgres    false            �            1259    27575    detalleventa_id_detalle_seq    SEQUENCE     �   CREATE SEQUENCE public.detalleventa_id_detalle_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.detalleventa_id_detalle_seq;
       public          postgres    false    235            �           0    0    detalleventa_id_detalle_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE public.detalleventa_id_detalle_seq OWNED BY public.detalleventa.id_detalle;
          public          postgres    false    234            �            1259    27532    empleado    TABLE     �   CREATE TABLE public.empleado (
    id_empleado integer NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(15),
    direccion text,
    email character varying(100)
);
    DROP TABLE public.empleado;
       public         heap    postgres    false            �            1259    27531    empleado_id_empleado_seq    SEQUENCE     �   CREATE SEQUENCE public.empleado_id_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.empleado_id_empleado_seq;
       public          postgres    false    229            �           0    0    empleado_id_empleado_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.empleado_id_empleado_seq OWNED BY public.empleado.id_empleado;
          public          postgres    false    228            �            1259    27505 
   inventario    TABLE     �   CREATE TABLE public.inventario (
    id_inventario integer NOT NULL,
    id_reloj integer,
    cantidad integer NOT NULL,
    id_compra integer,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.inventario;
       public         heap    postgres    false            �            1259    27504    inventario_id_inventario_seq    SEQUENCE     �   CREATE SEQUENCE public.inventario_id_inventario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.inventario_id_inventario_seq;
       public          postgres    false    225            �           0    0    inventario_id_inventario_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public.inventario_id_inventario_seq OWNED BY public.inventario.id_inventario;
          public          postgres    false    224            �            1259    27543    loginempleado    TABLE       CREATE TABLE public.loginempleado (
    id_login integer NOT NULL,
    id_empleado integer,
    usuario character varying(50) NOT NULL,
    contrasena character varying(255) NOT NULL,
    cargo character varying(50) DEFAULT 'vendedor'::character varying
);
 !   DROP TABLE public.loginempleado;
       public         heap    postgres    false            �            1259    27542    loginempleado_id_login_seq    SEQUENCE     �   CREATE SEQUENCE public.loginempleado_id_login_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.loginempleado_id_login_seq;
       public          postgres    false    231            �           0    0    loginempleado_id_login_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.loginempleado_id_login_seq OWNED BY public.loginempleado.id_login;
          public          postgres    false    230            �            1259    27465    marca    TABLE     i   CREATE TABLE public.marca (
    id_marca integer NOT NULL,
    nombre character varying(100) NOT NULL
);
    DROP TABLE public.marca;
       public         heap    postgres    false            �            1259    27464    marca_id_marca_seq    SEQUENCE     �   CREATE SEQUENCE public.marca_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.marca_id_marca_seq;
       public          postgres    false    219            �           0    0    marca_id_marca_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.marca_id_marca_seq OWNED BY public.marca.id_marca;
          public          postgres    false    218            �            1259    27455 	   proveedor    TABLE     �   CREATE TABLE public.proveedor (
    id_proveedor integer NOT NULL,
    nombre character varying(100) NOT NULL,
    telefono character varying(15),
    direccion text,
    email character varying(100),
    fecha_registro date DEFAULT CURRENT_DATE
);
    DROP TABLE public.proveedor;
       public         heap    postgres    false            �            1259    27454    proveedor_id_proveedor_seq    SEQUENCE     �   CREATE SEQUENCE public.proveedor_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.proveedor_id_proveedor_seq;
       public          postgres    false    217            �           0    0    proveedor_id_proveedor_seq    SEQUENCE OWNED BY     Y   ALTER SEQUENCE public.proveedor_id_proveedor_seq OWNED BY public.proveedor.id_proveedor;
          public          postgres    false    216            �            1259    27472    relojes    TABLE       CREATE TABLE public.relojes (
    id_reloj integer NOT NULL,
    modelo character varying(100) NOT NULL,
    precio numeric(10,2) NOT NULL,
    descripcion text,
    id_marca integer,
    id_proveedor integer,
    fecha_registro date DEFAULT CURRENT_DATE
);
    DROP TABLE public.relojes;
       public         heap    postgres    false            �            1259    27471    relojes_id_reloj_seq    SEQUENCE     �   CREATE SEQUENCE public.relojes_id_reloj_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.relojes_id_reloj_seq;
       public          postgres    false    221            �           0    0    relojes_id_reloj_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.relojes_id_reloj_seq OWNED BY public.relojes.id_reloj;
          public          postgres    false    220            �            1259    27558    venta    TABLE     �   CREATE TABLE public.venta (
    id_venta integer NOT NULL,
    id_cliente integer,
    id_empleado integer,
    fecha_venta date DEFAULT CURRENT_DATE,
    total numeric(10,2) NOT NULL
);
    DROP TABLE public.venta;
       public         heap    postgres    false            �            1259    27557    venta_id_venta_seq    SEQUENCE     �   CREATE SEQUENCE public.venta_id_venta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.venta_id_venta_seq;
       public          postgres    false    233            �           0    0    venta_id_venta_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.venta_id_venta_seq OWNED BY public.venta.id_venta;
          public          postgres    false    232            �            1259    27666    vistainventario    VIEW     �  CREATE VIEW public.vistainventario AS
 SELECT relojes.modelo AS modeloreloj,
    marca.nombre AS marca,
    proveedor.nombre AS proveedor,
    inventario.cantidad AS cantidaddisponible
   FROM (((public.inventario
     JOIN public.relojes ON ((inventario.id_reloj = relojes.id_reloj)))
     JOIN public.marca ON ((relojes.id_marca = marca.id_marca)))
     JOIN public.proveedor ON ((relojes.id_proveedor = proveedor.id_proveedor)));
 "   DROP VIEW public.vistainventario;
       public          postgres    false    221    225    225    221    221    221    219    219    217    217            �            1259    27675    vistarelojesproveedor    VIEW     P  CREATE VIEW public.vistarelojesproveedor AS
 SELECT relojes.modelo AS modeloreloj,
    marca.nombre AS marca,
    proveedor.nombre AS proveedor,
    relojes.precio
   FROM ((public.relojes
     JOIN public.marca ON ((relojes.id_marca = marca.id_marca)))
     JOIN public.proveedor ON ((relojes.id_proveedor = proveedor.id_proveedor)));
 (   DROP VIEW public.vistarelojesproveedor;
       public          postgres    false    219    219    221    221    221    221    217    217            �            1259    27671    vistaventas    VIEW     ~  CREATE VIEW public.vistaventas AS
 SELECT venta.id_venta AS idventa,
    cliente.nombre AS nombrecliente,
    empleado.nombre AS nombreempleado,
    venta.fecha_venta AS fechaventa,
    venta.total AS totalventa
   FROM ((public.venta
     JOIN public.cliente ON ((venta.id_cliente = cliente.id_cliente)))
     JOIN public.empleado ON ((venta.id_empleado = empleado.id_empleado)));
    DROP VIEW public.vistaventas;
       public          postgres    false    227    227    229    229    233    233    233    233    233            �           2604    27526    cliente id_cliente    DEFAULT     x   ALTER TABLE ONLY public.cliente ALTER COLUMN id_cliente SET DEFAULT nextval('public.cliente_id_cliente_seq'::regclass);
 A   ALTER TABLE public.cliente ALTER COLUMN id_cliente DROP DEFAULT;
       public          postgres    false    227    226    227            �           2604    27495    compra id_compra    DEFAULT     t   ALTER TABLE ONLY public.compra ALTER COLUMN id_compra SET DEFAULT nextval('public.compra_id_compra_seq'::regclass);
 ?   ALTER TABLE public.compra ALTER COLUMN id_compra DROP DEFAULT;
       public          postgres    false    222    223    223            �           2604    27579    detalleventa id_detalle    DEFAULT     �   ALTER TABLE ONLY public.detalleventa ALTER COLUMN id_detalle SET DEFAULT nextval('public.detalleventa_id_detalle_seq'::regclass);
 F   ALTER TABLE public.detalleventa ALTER COLUMN id_detalle DROP DEFAULT;
       public          postgres    false    234    235    235            �           2604    27535    empleado id_empleado    DEFAULT     |   ALTER TABLE ONLY public.empleado ALTER COLUMN id_empleado SET DEFAULT nextval('public.empleado_id_empleado_seq'::regclass);
 C   ALTER TABLE public.empleado ALTER COLUMN id_empleado DROP DEFAULT;
       public          postgres    false    228    229    229            �           2604    27508    inventario id_inventario    DEFAULT     �   ALTER TABLE ONLY public.inventario ALTER COLUMN id_inventario SET DEFAULT nextval('public.inventario_id_inventario_seq'::regclass);
 G   ALTER TABLE public.inventario ALTER COLUMN id_inventario DROP DEFAULT;
       public          postgres    false    224    225    225            �           2604    27546    loginempleado id_login    DEFAULT     �   ALTER TABLE ONLY public.loginempleado ALTER COLUMN id_login SET DEFAULT nextval('public.loginempleado_id_login_seq'::regclass);
 E   ALTER TABLE public.loginempleado ALTER COLUMN id_login DROP DEFAULT;
       public          postgres    false    231    230    231            �           2604    27468    marca id_marca    DEFAULT     p   ALTER TABLE ONLY public.marca ALTER COLUMN id_marca SET DEFAULT nextval('public.marca_id_marca_seq'::regclass);
 =   ALTER TABLE public.marca ALTER COLUMN id_marca DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    27458    proveedor id_proveedor    DEFAULT     �   ALTER TABLE ONLY public.proveedor ALTER COLUMN id_proveedor SET DEFAULT nextval('public.proveedor_id_proveedor_seq'::regclass);
 E   ALTER TABLE public.proveedor ALTER COLUMN id_proveedor DROP DEFAULT;
       public          postgres    false    217    216    217            �           2604    27475    relojes id_reloj    DEFAULT     t   ALTER TABLE ONLY public.relojes ALTER COLUMN id_reloj SET DEFAULT nextval('public.relojes_id_reloj_seq'::regclass);
 ?   ALTER TABLE public.relojes ALTER COLUMN id_reloj DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    27561    venta id_venta    DEFAULT     p   ALTER TABLE ONLY public.venta ALTER COLUMN id_venta SET DEFAULT nextval('public.venta_id_venta_seq'::regclass);
 =   ALTER TABLE public.venta ALTER COLUMN id_venta DROP DEFAULT;
       public          postgres    false    232    233    233            �          0    27523    cliente 
   TABLE DATA           Q   COPY public.cliente (id_cliente, nombre, telefono, direccion, email) FROM stdin;
    public          postgres    false    227    �       �          0    27492    compra 
   TABLE DATA           N   COPY public.compra (id_compra, id_proveedor, fecha_compra, total) FROM stdin;
    public          postgres    false    223   �       �          0    27576    detalleventa 
   TABLE DATA           a   COPY public.detalleventa (id_detalle, id_venta, id_reloj, cantidad, precio_unitario) FROM stdin;
    public          postgres    false    235   :�       �          0    27532    empleado 
   TABLE DATA           S   COPY public.empleado (id_empleado, nombre, telefono, direccion, email) FROM stdin;
    public          postgres    false    229   W�       �          0    27505 
   inventario 
   TABLE DATA           g   COPY public.inventario (id_inventario, id_reloj, cantidad, id_compra, fecha_actualizacion) FROM stdin;
    public          postgres    false    225   ��       �          0    27543    loginempleado 
   TABLE DATA           Z   COPY public.loginempleado (id_login, id_empleado, usuario, contrasena, cargo) FROM stdin;
    public          postgres    false    231   �       �          0    27465    marca 
   TABLE DATA           1   COPY public.marca (id_marca, nombre) FROM stdin;
    public          postgres    false    219   ��       �          0    27455 	   proveedor 
   TABLE DATA           e   COPY public.proveedor (id_proveedor, nombre, telefono, direccion, email, fecha_registro) FROM stdin;
    public          postgres    false    217   ��       �          0    27472    relojes 
   TABLE DATA           p   COPY public.relojes (id_reloj, modelo, precio, descripcion, id_marca, id_proveedor, fecha_registro) FROM stdin;
    public          postgres    false    221   �       �          0    27558    venta 
   TABLE DATA           V   COPY public.venta (id_venta, id_cliente, id_empleado, fecha_venta, total) FROM stdin;
    public          postgres    false    233   #�       �           0    0    cliente_id_cliente_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.cliente_id_cliente_seq', 1, false);
          public          postgres    false    226            �           0    0    compra_id_compra_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.compra_id_compra_seq', 1, false);
          public          postgres    false    222            �           0    0    detalleventa_id_detalle_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public.detalleventa_id_detalle_seq', 1, false);
          public          postgres    false    234            �           0    0    empleado_id_empleado_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.empleado_id_empleado_seq', 2, true);
          public          postgres    false    228            �           0    0    inventario_id_inventario_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public.inventario_id_inventario_seq', 1, false);
          public          postgres    false    224            �           0    0    loginempleado_id_login_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.loginempleado_id_login_seq', 2, true);
          public          postgres    false    230            �           0    0    marca_id_marca_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.marca_id_marca_seq', 1, false);
          public          postgres    false    218            �           0    0    proveedor_id_proveedor_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.proveedor_id_proveedor_seq', 1, false);
          public          postgres    false    216            �           0    0    relojes_id_reloj_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.relojes_id_reloj_seq', 1, false);
          public          postgres    false    220            �           0    0    venta_id_venta_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venta_id_venta_seq', 1, false);
          public          postgres    false    232            �           2606    27530    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    227            �           2606    27498    compra compra_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_pkey PRIMARY KEY (id_compra);
 <   ALTER TABLE ONLY public.compra DROP CONSTRAINT compra_pkey;
       public            postgres    false    223                       2606    27581    detalleventa detalleventa_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_pkey PRIMARY KEY (id_detalle);
 H   ALTER TABLE ONLY public.detalleventa DROP CONSTRAINT detalleventa_pkey;
       public            postgres    false    235            �           2606    27541    empleado empleado_email_key 
   CONSTRAINT     W   ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_email_key UNIQUE (email);
 E   ALTER TABLE ONLY public.empleado DROP CONSTRAINT empleado_email_key;
       public            postgres    false    229            �           2606    27539    empleado empleado_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.empleado
    ADD CONSTRAINT empleado_pkey PRIMARY KEY (id_empleado);
 @   ALTER TABLE ONLY public.empleado DROP CONSTRAINT empleado_pkey;
       public            postgres    false    229            �           2606    27511    inventario inventario_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_pkey PRIMARY KEY (id_inventario);
 D   ALTER TABLE ONLY public.inventario DROP CONSTRAINT inventario_pkey;
       public            postgres    false    225            �           2606    27549     loginempleado loginempleado_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.loginempleado
    ADD CONSTRAINT loginempleado_pkey PRIMARY KEY (id_login);
 J   ALTER TABLE ONLY public.loginempleado DROP CONSTRAINT loginempleado_pkey;
       public            postgres    false    231            �           2606    27551 '   loginempleado loginempleado_usuario_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.loginempleado
    ADD CONSTRAINT loginempleado_usuario_key UNIQUE (usuario);
 Q   ALTER TABLE ONLY public.loginempleado DROP CONSTRAINT loginempleado_usuario_key;
       public            postgres    false    231            �           2606    27470    marca marca_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.marca
    ADD CONSTRAINT marca_pkey PRIMARY KEY (id_marca);
 :   ALTER TABLE ONLY public.marca DROP CONSTRAINT marca_pkey;
       public            postgres    false    219            �           2606    27463    proveedor proveedor_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id_proveedor);
 B   ALTER TABLE ONLY public.proveedor DROP CONSTRAINT proveedor_pkey;
       public            postgres    false    217            �           2606    27480    relojes relojes_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_pkey PRIMARY KEY (id_reloj);
 >   ALTER TABLE ONLY public.relojes DROP CONSTRAINT relojes_pkey;
       public            postgres    false    221                       2606    27564    venta venta_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_pkey PRIMARY KEY (id_venta);
 :   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_pkey;
       public            postgres    false    233                       2620    27680 $   inventario actualizarfechainventario    TRIGGER     �   CREATE TRIGGER actualizarfechainventario BEFORE UPDATE ON public.inventario FOR EACH ROW EXECUTE FUNCTION public.actualizarfechainventario();
 =   DROP TRIGGER actualizarfechainventario ON public.inventario;
       public          postgres    false    258    225                       2620    27682 #   compra aumentarinventariotrascompra    TRIGGER     �   CREATE TRIGGER aumentarinventariotrascompra AFTER INSERT ON public.compra FOR EACH ROW EXECUTE FUNCTION public.aumentarinventariotrascompra();
 <   DROP TRIGGER aumentarinventariotrascompra ON public.compra;
       public          postgres    false    223    254                       2620    27684 '   detalleventa reducirinventariotrasventa    TRIGGER     �   CREATE TRIGGER reducirinventariotrasventa AFTER INSERT ON public.detalleventa FOR EACH ROW EXECUTE FUNCTION public.reducirinventariotrasventa();
 @   DROP TRIGGER reducirinventariotrasventa ON public.detalleventa;
       public          postgres    false    235    240                       2620    27686     detalleventa registrarventatotal    TRIGGER     �   CREATE TRIGGER registrarventatotal AFTER INSERT ON public.detalleventa FOR EACH ROW EXECUTE FUNCTION public.registrarventatotal();
 9   DROP TRIGGER registrarventatotal ON public.detalleventa;
       public          postgres    false    235    307                       2620    27688 &   detalleventa validarcantidadinventario    TRIGGER     �   CREATE TRIGGER validarcantidadinventario BEFORE INSERT ON public.detalleventa FOR EACH ROW EXECUTE FUNCTION public.validarcantidadinventario();
 ?   DROP TRIGGER validarcantidadinventario ON public.detalleventa;
       public          postgres    false    235    264                       2606    27499    compra compra_id_proveedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT compra_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);
 I   ALTER TABLE ONLY public.compra DROP CONSTRAINT compra_id_proveedor_fkey;
       public          postgres    false    223    217    4845                       2606    27587 '   detalleventa detalleventa_id_reloj_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_id_reloj_fkey FOREIGN KEY (id_reloj) REFERENCES public.relojes(id_reloj);
 Q   ALTER TABLE ONLY public.detalleventa DROP CONSTRAINT detalleventa_id_reloj_fkey;
       public          postgres    false    235    221    4849                       2606    27582 '   detalleventa detalleventa_id_venta_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalleventa
    ADD CONSTRAINT detalleventa_id_venta_fkey FOREIGN KEY (id_venta) REFERENCES public.venta(id_venta);
 Q   ALTER TABLE ONLY public.detalleventa DROP CONSTRAINT detalleventa_id_venta_fkey;
       public          postgres    false    235    4865    233                       2606    27517 $   inventario inventario_id_compra_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_compra_fkey FOREIGN KEY (id_compra) REFERENCES public.compra(id_compra);
 N   ALTER TABLE ONLY public.inventario DROP CONSTRAINT inventario_id_compra_fkey;
       public          postgres    false    223    4851    225                       2606    27512 #   inventario inventario_id_reloj_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.inventario
    ADD CONSTRAINT inventario_id_reloj_fkey FOREIGN KEY (id_reloj) REFERENCES public.relojes(id_reloj);
 M   ALTER TABLE ONLY public.inventario DROP CONSTRAINT inventario_id_reloj_fkey;
       public          postgres    false    221    225    4849            	           2606    27552 ,   loginempleado loginempleado_id_empleado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.loginempleado
    ADD CONSTRAINT loginempleado_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);
 V   ALTER TABLE ONLY public.loginempleado DROP CONSTRAINT loginempleado_id_empleado_fkey;
       public          postgres    false    231    229    4859                       2606    27481    relojes relojes_id_marca_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_id_marca_fkey FOREIGN KEY (id_marca) REFERENCES public.marca(id_marca);
 G   ALTER TABLE ONLY public.relojes DROP CONSTRAINT relojes_id_marca_fkey;
       public          postgres    false    4847    219    221                       2606    27486 !   relojes relojes_id_proveedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.relojes
    ADD CONSTRAINT relojes_id_proveedor_fkey FOREIGN KEY (id_proveedor) REFERENCES public.proveedor(id_proveedor);
 K   ALTER TABLE ONLY public.relojes DROP CONSTRAINT relojes_id_proveedor_fkey;
       public          postgres    false    217    221    4845            
           2606    27565    venta venta_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 E   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_id_cliente_fkey;
       public          postgres    false    4855    233    227                       2606    27570    venta venta_id_empleado_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venta
    ADD CONSTRAINT venta_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES public.empleado(id_empleado);
 F   ALTER TABLE ONLY public.venta DROP CONSTRAINT venta_id_empleado_fkey;
       public          postgres    false    233    4859    229            �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�=̽
�0@���).����I�b�U���r����&!M|z���|���|����� ]�+���&J��j�0H�K¾����k9.YW���N�ld���o��VJ=���#���c,�3�;��9�qƒ�{���^	!>�.�      �      x������ � �      �   �   x�5���   �3>�gMf9�2�Y.�(��%Xj>}u�{���Tw�^�mlH��Ď\���٢q�/�#KO����#h��_AHp	���������DL	-ڮ��n, �q)����K>���f���Z�z��U֯�M�wj|3|C
R]�Ȋà�9׌�ޣcY��y:�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �     