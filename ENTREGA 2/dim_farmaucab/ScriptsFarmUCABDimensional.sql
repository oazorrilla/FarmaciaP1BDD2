--CREATE DATABASE STANDS
DROP SCHEMA IF EXISTS dim_farmaucab CASCADE;

-- Crear esquema dim_farmaucab

CREATE SCHEMA dim_farmaucab;

-- Cambiar al esquema
SET search_path TO dim_farmaucab;

--Create DimProducto table
CREATE TABLE dim_farmaucab.DimProducto (
    SK_Producto NUMERIC PRIMARY KEY,
    IdProducto NUMERIC  NULL,
    NombProduct VARCHAR(200)   NULL,
    DescripcionProduct VARCHAR(200)   NULL,
    PrecioProduct NUMERIC(10, 2)   NULL,  
    idCategoria NUMERIC  NULL,
    NombCategoria VARCHAR(200)  NULL,
    DescripcionCategoria VARCHAR(200)  NULL
);

-- Create DimCliente table
CREATE TABLE dim_farmaucab.DimCliente (
    SK_Cliente NUMERIC PRIMARY KEY,
    IdCliente NUMERIC  NULL,
    primNombCliente VARCHAR(100)   NULL,
    SegNombCliente VARCHAR(50) NULL,
    primApellidoCliente VARCHAR(100) NULL,
    SegApeliidoCliente VARCHAR(50) NULL,
    CICliente VARCHAR(45)  NULL,
    FechaNacCliente DATE  NULL,
    GeneroCliente VARCHAR(20)  NULL    
);



-- Create DimSucursal table
CREATE TABLE dim_farmaucab.DimSucursal (
    SK_Sucursal NUMERIC PRIMARY KEY,
    idsucursal NUMERIC  NULL,
    NombSucursal VARCHAR(100)  NULL,
    DirecSucursal VARCHAR(100)  NULL,
    RifSucursal VARCHAR(20)  NULL,
    idinventario NUMERIC NULL,
    nombreinventario VARCHAR(50) NULL,
    cantidadinventario NUMERIC NULL
);

-- Create DimTiempo table
CREATE TABLE dim_farmaucab.DimTiempo (
    sk_tiempo NUMERIC PRIMARY KEY,
    cod_anio NUMERIC NULL,
    cod_trimestre NUMERIC  NULL,
    des_trimestre VARCHAR(100)  NULL,
    cod_mes NUMERIC  NULL,
    desc_mes VARCHAR(100)  NULL,
    desc_mes_corta VARCHAR(100)  NULL,
    cod_semana NUMERIC  NULL,
    cod_dia_anio NUMERIC  NULL,
    cod_dia_mes NUMERIC  NULL,
    cod_dia_semana NUMERIC  NULL,
    desc_dia_semana VARCHAR(100)  NULL,
    fecha date  NULL
);

-- Create FactVenta table
CREATE TABLE dim_farmaucab.FactVenta (
    id_fact_venta SERIAL PRIMARY KEY,
    SK_Producto NUMERIC NULL,
    SK_Cliente NUMERIC NULL,
    SK_Sucursal NUMERIC NULL,
    SK_fec_venta NUMERIC NULL,
    MontoTotalVenta NUMERIC(10, 2) NULL,
    MetodoDePago VARCHAR(50) NULL,
    cantidad_unitaria_prod  NUMERIC NULL,
    precio_unitario_prod NUMERIC NULL,
    FOREIGN KEY (SK_Producto) REFERENCES dim_farmaucab.DimProducto(SK_Producto),
    FOREIGN KEY (SK_Cliente) REFERENCES dim_farmaucab.DimCliente(SK_Cliente),
    FOREIGN KEY (SK_Sucursal) REFERENCES dim_farmaucab.DimSucursal(SK_Sucursal),
    FOREIGN KEY (SK_fec_venta) REFERENCES dim_farmaucab.DimTiempo(SK_Tiempo)
);

-- Create FactCompra table
CREATE TABLE dim_farmaucab.FactCompra (
    id_fact_compra SERIAL NOT NULL,
    SK_Producto NUMERIC NULL,
    SK_Sucursal NUMERIC NULL,
    SK_fec_compra NUMERIC NULL,
    CantidadUnitaria NUMERIC NULL,
    precio_unitario_prod NUMERIC NULL,
    monto NUMERIC(10, 2) NULL,
    FOREIGN KEY (SK_Producto) REFERENCES dim_farmaucab.DimProducto(SK_Producto),
    FOREIGN KEY (SK_Sucursal) REFERENCES dim_farmaucab.DimSucursal(SK_Sucursal),
    FOREIGN KEY (SK_fec_compra) REFERENCES dim_farmaucab.DimTiempo(SK_Tiempo)
);
