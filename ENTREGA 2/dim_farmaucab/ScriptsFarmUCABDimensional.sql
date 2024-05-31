--CREATE DATABASE STANDS
DROP SCHEMA IF EXISTS dim_farmaucab CASCADE;

-- Crear esquema dim_farmaucab

CREATE SCHEMA dim_farmaucab;

-- Cambiar al esquema
SET search_path TO dim_farmaucab;

--Create DimProducto table
CREATE TABLE dim_farmaucab.DimProducto (
    SK_Producto NUMERIC PRIMARY KEY,
    IdProducto NUMERIC NOT NULL,
    NombProduct VARCHAR(100)  NOT NULL,
    DescripcionProduct VARCHAR(100)  NOT NULL,
    PrecioProduct NUMERIC(10, 2)  NOT NULL,  
    idCategoria NUMERIC NOT NULL,
    NombCategoria VARCHAR(50) NOT NULL,
    DescripcionCategoria VARCHAR(200) NOT NULL
);

-- Create DimCliente table
CREATE TABLE dim_farmaucab.DimCliente (
    SK_Cliente NUMERIC PRIMARY KEY,
    IdCliente NUMERIC NOT NULL,
    NombCliente VARCHAR(100)  NOT NULL,
    ApellidoCliente VARCHAR(100)  NOT NULL,
    CedulaCliente VARCHAR(20)  NOT NULL,
    FechaNacCliente DATE NOT NULL,
    GeneroCliente VARCHAR(20) NOT NULL
);

-- Create DimInventario table
CREATE TABLE dim_farmaucab.DimInventario (
    SK_Inventario NUMERIC PRIMARY KEY,
    NombreInventario VARCHAR(100)  NOT NULL,
    CantidadInventario NUMERIC NOT NULL
);


-- Create DimSucursal table
CREATE TABLE dim_farmaucab.DimSucursal (
    SK_Sucursal NUMERIC PRIMARY KEY,
    NombSucursal VARCHAR(100)  NOT NULL,
    DirecSucursal VARCHAR(100)  NOT NULL,
    RifSucursal VARCHAR(20)  NOT NULL
);

-- Create DimTiempo table
CREATE TABLE dim_farmaucab.DimTiempo (
    sk_tiempo NUMERIC PRIMARY KEY,
    cod_anio NUMERIC NOT NULL,
    cod_trimestre NUMERIC NOT NULL,
    des_trimestre VARCHAR(100) NOT NULL,
    cod_mes NUMERIC NOT NULL,
    desc_mes VARCHAR(100) NOT NULL,
    desc_mes_corta VARCHAR(100) NOT NULL,
    cod_semana NUMERIC NOT NULL,
    cod_dia_anio NUMERIC NOT NULL,
    cod_dia_mes NUMERIC NOT NULL,
    cod_dia_semana NUMERIC NOT NULL,
    desc_dia_semana VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL
);

-- Create FactVenta table
CREATE TABLE dim_farmaucab.FactVenta (
    SK_Producto NUMERIC,
    SK_Cliente NUMERIC,
    SK_Sucursal NUMERIC,
    SK_fec_venta NUMERIC,
    MontoTotalVenta NUMERIC(10, 2),
    MetodoDePago VARCHAR(50),
    cantidad_unitaria_prod  NUMERIC,
    precio_unitario_prod NUMERIC,
    PRIMARY KEY (SK_Producto,SK_Cliente,SK_Sucursal,SK_fec_venta),
    FOREIGN KEY (SK_Producto) REFERENCES dim_farmaucab.DimProducto(SK_Producto),
    FOREIGN KEY (SK_Cliente) REFERENCES dim_farmaucab.DimCliente(SK_Cliente),
    FOREIGN KEY (SK_Sucursal) REFERENCES dim_farmaucab.DimSucursal(SK_Sucursal),
    FOREIGN KEY (SK_fec_venta) REFERENCES dim_farmaucab.DimTiempo(SK_Tiempo)
);

-- Create FactCompra table
CREATE TABLE dim_farmaucab.FactCompra (
    SK_fec_compra NUMERIC,
    Monto NUMERIC(10, 2),
    SK_Producto NUMERIC,
    CantidadUnitaria NUMERIC,
    precio_unitario_prod NUMERIC,
    PRIMARY KEY (SK_fec_compra, SK_fec_venta),
    FOREIGN KEY (SK_fec_compra) REFERENCES dim_farmaucab.DimTiempo(SK_Tiempo),
    FOREIGN KEY (SK_Producto) REFERENCES dim_farmaucab.DimProducto(SK_Producto)
);