----1.Análisis de tendencias de ventas por período de tiempo--------
CREATE OR REPLACE FUNCTION analizar_tendencias_ventas(rango_inicio DATE, rango_fin DATE)
RETURNS TABLE (
    fecha DATE,
    total_ventas NUMERIC  -- Cambiado a NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT fecha, SUM(TotalVenta)::NUMERIC AS total_ventas
    FROM Venta
    WHERE FechaVenta BETWEEN rango_inicio AND rango_fin
    GROUP BY fecha
    ORDER BY fecha;
END;
$$ LANGUAGE plpgsql;
--------------- LLamada--------------------------------------------------------------------
SELECT * FROM analizar_tendencias_ventas('2024-01-01', '2024-12-31');
---------------------------------------------------------------------------------------------
------------2.Cálculo del valor promedio de las ventas por cliente-----------------
CREATE OR REPLACE FUNCTION calcular_valor_promedio_ventas_cliente()
RETURNS TABLE (
    idCliente INT,
    promedio_venta NUMERIC  -- Cambiado a NUMERIC
)
AS $$
BEGIN
    RETURN QUERY
    SELECT idCliente, AVG(TotalVenta)::NUMERIC AS promedio_venta
    FROM Venta
    GROUP BY idCliente;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM calcular_valor_promedio_ventas_cliente();
------------------------------ 3.determinar la frecuencia de compra de productos-------------------------------------------------
CREATE OR REPLACE FUNCTION determinar_frecuencia_compra_productos()
RETURNS TABLE (
    idProducto INT,
    frecuencia_compra DOUBLE PRECISION  -- Cambiado a DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT idProducto, COUNT(*)::DOUBLE PRECISION AS frecuencia_compra
    FROM DetalleCompra
    GROUP BY idProducto;
END;
$$ LANGUAGE plpgsql;
-------------------------------LLamada---------------------------------
SELECT * FROM determinar_frecuencia_compra_productos();
---------------------- 4. Predicción de ventas futuras utilizando modelos de series temporales-------------------------------------------
CREATE OR REPLACE FUNCTION predecir_ventas_futuras(rango_inicio DATE, rango_fin DATE)
RETURNS TABLE (
    fecha DATE,
    predicción_ventas NUMERIC
)
AS $$
BEGIN
    -- Implementa la lógica de predicción aquí utilizando modelos de series temporales
    -- Esta función devuelve una tabla con las fechas y las ventas predichas para ese período de tiempo
END;
$$ LANGUAGE plpgsql;
------------------------Llamada-----------------------------------------------------------
SELECT * FROM predecir_ventas_futuras('2024-05-01', '2024-06-30');

---------------------------------- 5. Identificar Productos menos vendidos------------------
CREATE OR REPLACE FUNCTION identificar_productos_menos_vendidos()
RETURNS TABLE (
    id_producto INT,
    nombre_producto VARCHAR(45),
    cantidad_vendida INTEGER  -- Cambiado a INTEGER
)
AS $$
BEGIN
    RETURN QUERY
    SELECT Producto.idProducto, Producto.NombProduct, COALESCE(SUM(DetalleCompra.CantidadDetalleCompra), 0)::INTEGER AS cantidad_vendida
    FROM Producto
    LEFT JOIN DetalleCompra ON Producto.idProducto = DetalleCompra.Producto_idProducto
    GROUP BY Producto.idProducto, Producto.NombProduct
    ORDER BY cantidad_vendida
    LIMIT 10;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM identificar_productos_menos_vendidos();
-------------------------- 6. Analisis de compra por metodo de pago---------------------------------------------------------
CREATE OR REPLACE FUNCTION analizar_compras_por_metodo_pago()
RETURNS TABLE (
    metodo_pago VARCHAR(45),
    numero_compras INTEGER,
    monto_total DOUBLE PRECISION  -- Cambiado a DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    SELECT MetodoPago,
           COUNT(*)::INTEGER AS numero_compras,
           SUM(MontoTotalCompra) AS monto_total
    FROM Compra
    GROUP BY MetodoPago;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM analizar_compras_por_metodo_pago();

------------------------------------------7.Productos en invnetario--------------------------------
CREATE OR REPLACE FUNCTION reporte_productos_en_inventario()
RETURNS TABLE (
    id_producto INT,
    nombre_producto VARCHAR(45),
    cantidad_inventario FLOAT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT idProducto, NombProduct, CantidadInventario
    FROM Producto
    JOIN Inventario ON Producto.Inventario_idInventario = Inventario.idInventario;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM reporte_productos_en_inventario();

----------------------------------------------------8.Productividad Empleado-------------------------------------------------------------------
CREATE OR REPLACE FUNCTION calcular_productividad_empleado(
    empleado_id INT,
    fecha_inicio DATE,
    fecha_fin DATE
)
RETURNS FLOAT AS $$
DECLARE
    total_horas_trabajadas INT;
    total_horas_no_trabajadas INT;
    productividad FLOAT;
BEGIN
    -- Calcular total de horas trabajadas por el empleado en el rango de fechas
    SELECT SUM(EXTRACT(HOUR FROM (FechaFinProductividad - FechaInicioProductividad)))
    INTO total_horas_trabajadas
    FROM Productividad
    WHERE Empleado_idEmpleado = empleado_id
    AND FechaInicioProductividad BETWEEN fecha_inicio AND fecha_fin;

    -- Calcular total de horas no trabajadas (ausencias) por el empleado en el rango de fechas
    SELECT SUM(EXTRACT(HOUR FROM (FechaFinAusentismo - FechaInicioAusentismo)))
    INTO total_horas_no_trabajadas
    FROM Ausentismo
    WHERE Empleado_idEmpleado = empleado_id
    AND FechaInicioAusentismo BETWEEN fecha_inicio AND fecha_fin;

    -- Calcular la productividad como el porcentaje de horas trabajadas sobre horas totales
    IF total_horas_trabajadas IS NULL THEN
        total_horas_trabajadas := 0;
    END IF;
    IF total_horas_no_trabajadas IS NULL THEN
        total_horas_no_trabajadas := 0;
    END IF;

    IF total_horas_trabajadas + total_horas_no_trabajadas > 0 THEN
        productividad := (total_horas_trabajadas / (total_horas_trabajadas + total_horas_no_trabajadas)) * 100;
    ELSE
        productividad := 0;
    END IF;

    RETURN productividad;
END;
$$ LANGUAGE plpgsql;
 select * from calcular_productividad_empleado();