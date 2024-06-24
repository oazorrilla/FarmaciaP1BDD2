--CREATE DATABASE STANDS

-- Crear esquema
DROP SCHEMA IF EXISTS bd_farmaucab CASCADE;
CREATE SCHEMA bd_farmaucab;

-- Cambiar al esquema
SET search_path TO bd_farmaucab;

------------------LUGAR
CREATE TABLE IF NOT EXISTS bd_farmaucab.Lugar(
    idLugar  SERIAL PRIMARY KEY,
    TipoLugar VARCHAR(50) NOT NULL,
    NombLugar VARCHAR(50) NOT NULL,
    fk_id_lugar integer null,
    FOREIGN KEY (fk_id_lugar) REFERENCES bd_farmaucab.lugar(idLugar)
);

------------------SUCURSAL
CREATE TABLE IF NOT EXISTS bd_farmaucab.Sucursal(
    idSucursal	SERIAL PRIMARY KEY,
    NombSucursal   VARCHAR(50) NOT NULL,
    DirecSucursal  VARCHAR(50) NOT NULL,
    RIFSucursal    VARCHAR(20) NOT NULL,
    fk_id_lugar	   integer not null,
    constraint check_rif_sucursal check ((RIFSucursal)::text ~ '^([Jj]{1}-[0-9]{10}$)'::text),	
    CONSTRAINT fk_id_lugar FOREIGN KEY (fk_id_lugar) REFERENCES bd_farmaucab.lugar(idLugar)
);


------------------PRODUCTO
CREATE TABLE IF NOT EXISTS bd_farmaucab.Producto (
  idProducto SERIAL PRIMARY KEY,
  NombProduct VARCHAR(50) NOT NULL,
  DescripcionProduct VARCHAR(200) NOT NULL,
  PrecioProduct FLOAT NOT NULL
);

------------COMPRA
CREATE TABLE IF NOT EXISTS bd_farmaucab.Compra (
  idCompra SERIAL PRIMARY KEY,
  monto FLOAT NOT NULL,
  fecha_compra date NOT NULL,
  fk_id_sucursal integer not null,
  CONSTRAINT fk_id_sucursal FOREIGN KEY (fk_id_sucursal) REFERENCES bd_farmaucab.sucursal(idSucursal)  
);

-----------DETALLE_COMPRA
CREATE TABLE IF NOT EXISTS bd_farmaucab.DetalleCompra (
  Compra_idCompra INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  monto FLOAT NOT NULL,
  cantidadUnitaria INT NOT NULL,
  PRIMARY KEY (Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra) REFERENCES bd_farmaucab.Compra(idCompra),
  FOREIGN KEY (Producto_idProducto) REFERENCES bd_farmaucab.Producto(idProducto)
);

------------------INVENTARIO
CREATE TABLE IF NOT EXISTS bd_farmaucab.Inventario (
  idInventario SERIAL PRIMARY KEY,
  NombreInventario VARCHAR(50) NOT NULL,
  CantidadInventario NUMERIC NOT NULL,
  fk_id_sucursal integer not null,
  FOREIGN KEY (fk_id_sucursal) REFERENCES bd_farmaucab.Sucursal(idSucursal)
);

------------------STOCK_INVENTARIO
CREATE TABLE IF NOT EXISTS bd_farmaucab.StockInventario(
  Inventario_idInventario INTEGER NOT NULL,
  Compra_idCompra INTEGER NOT NULL,
  Producto_idProducto INTEGER NOT NULL,
  PRIMARY KEY (Inventario_idInventario,Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra,Producto_idProducto) REFERENCES bd_farmaucab.DetalleCompra(Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Inventario_idInventario) REFERENCES bd_farmaucab.Inventario(IdInventario)
);

------------------CATEGORIA
CREATE TABLE IF NOT EXISTS bd_farmaucab.Categoria (
  idCategoria SERIAL PRIMARY KEY,
  NombCategoria VARCHAR(50) NOT NULL,
  DescripcionCategoria VARCHAR(200) NOT NULL
);

------------------CATEGORIA_PROD
CREATE TABLE IF NOT EXISTS bd_farmaucab.CategoriaProd (
  Categoria_idCategoria INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  FOREIGN KEY (Producto_idProducto) REFERENCES bd_farmaucab.Producto(idProducto),
  FOREIGN KEY (Categoria_idCategoria) REFERENCES bd_farmaucab.Categoria(idCategoria),
  PRIMARY KEY (Categoria_idCategoria,Producto_idProducto)
);

------------------CLIENTE
CREATE TABLE IF NOT EXISTS bd_farmaucab.Cliente (
  idCliente SERIAL PRIMARY KEY,
  PrimNombCliente VARCHAR(50) NOT NULL,
  SegNombCliente VARCHAR(50),
  PrimApellidoCliente VARCHAR(50) NOT NULL,
  SegApeliidoCliente VARCHAR(50),
  CICliente VARCHAR(45),
  FechaNacCliente DATE NOT NULL,
  GeneroCliente VARCHAR(20) NOT NULL
);

------------------VENTA
CREATE TABLE IF NOT EXISTS bd_farmaucab.Venta (
  idVenta SERIAL PRIMARY KEY,
  FechaVenta date NOT NULL,
  MontoTotalVenta NUMERIC (10,2) NOT NULL,
  MetodoPago VARCHAR(50) NOT NULL,
  Cliente_idCliente INT NOT NULL,
  fk_id_sucursal integer not null,
  FOREIGN KEY (Cliente_idCliente) REFERENCES bd_farmaucab.Cliente(idCliente),
  FOREIGN KEY (fk_id_sucursal) REFERENCES bd_farmaucab.Sucursal(idSucursal)
);

------------------DETALLE_VENTA
CREATE TABLE IF NOT EXISTS bd_farmaucab.DetalleVenta (
  idDetalleVenta SERIAL,
  CantidadUnitariaDetalleVenta INT NOT NULL,
  PrecioDetalleVenta FLOAT NOT NULL,
  Venta_idVenta INT NOT NULL,
  fk_stock_prod INT NOT NULL,
  fk_stock_compra INT NOT NULL,
  fk_stock_inv INT NOT NULL,
  PRIMARY KEY (idDetalleVenta,Venta_idVenta),
  FOREIGN KEY (Venta_idVenta) REFERENCES bd_farmaucab.Venta(idVenta),
  constraint fk_stock FOREIGN KEY (fk_stock_inv, fk_stock_compra, fk_stock_prod) REFERENCES bd_farmaucab.stockinventario(inventario_idinventario, compra_idcompra, producto_idproducto)
);



---------------------------------------------- Alter table de los check -------------------------------------------------------------------
ALTER TABLE bd_farmaucab.Venta
ADD CONSTRAINT CHK_MetodoPago
CHECK (MetodoPago IN ('Tarjeta de crédito', 'Otro', 'Efectivo'));

ALTER TABLE bd_farmaucab.Inventario
ADD CONSTRAINT CHK_StockProduct
CHECK (CantidadInventario >= 0);
 
------------------------------------Insert-----------------------------------------------------------------------------------

/*
-- Inserciones en la tabla Sucursal
INSERT INTO bd_farmaucab.Sucursal (NombSucursal, DirecSucursal, RIFSucursal, fk_id_lugar) VALUES
('FarmaUcab Santa Paula','Calle Tauro', 'J-3067658921',1002),
('FarmaUcab Colinas de Tamanaco','Calle Valencia', 'J-3056972120',1003),
('FarmaUcab Chacao', 'Calle Elice', 'J-3069874121',704);

-- Inserciones en la tabla Lugar en otro script

-- Inserciones en la tabla Producto
INSERT INTO bd_farmaucab.Producto (NombProduct, DescripcionProduct, PrecioProduct) VALUES
('Acetaminofen 650mg', 'Analgésico y antipirético. Inhibe la síntesis de prostaglandinas en el SNC y bloquea la generación del impulso doloroso a nivel periférico.', 27.26),
('Atamel Forte 650mg', 'Indicado como analgésico y antipirético en enfermedades que se acompañan de dolor y fiebre, como el resfriado común y otras infecciones virales.', 79.95),
('Apiret 180mg/5ml', 'Analgésico y antipirético. Bloquea la generación del impulso doloroso a nivel periférico.', 125.87),
('Migren', 'Contra el dolor de cabeza y el dolor de cabeza asociado a Migraña', 145.37),
('Diclofenac Potasico 50mg', 'Tratamiento de las afecciones que cursan con inflamación y/o dolor de intensidad leve a moderada.', 65.50),
('Dol Plus', 'Indicado en el tratamiento sintomático de las cefaleas vasculares.', 99.90),
('Dencorub 40mg', 'Acondicionador muscular', 99.0),
('Femmex ultra 200/10mg', 'Tratamiento del dolor abdominal tipo cólico de moderada a fuerte intensidad.', 190.75),
('Tiocolchicosido Calox 4mg', 'Relajante muscular que inhibe las contracciones y que se utiliza en procesos reumáticos, traumatismos y para alivio de la hipertonía uterina', 136.90),
('Atamel 500mg', 'Alivia el dolor, fiebre y malestar general.', 114.25),
('Ibuprofeno 400mg', 'Inhibición de la síntesis de prostaglandinas a nivel periférico.', 57.85),
('Festal', 'Alivio temporal sintomatico de los trastornos de la digestion.', 579.66),
('Liolactil 250mg', 'Coadyuvante en la restitución de la flora bacteriana intestinal, secundaria o no a terapia antibiótica.', 316.04),
('Teragrip Forte 24h', 'Tratamiento sintomático del resfriado común.', 236.22),
('Hexomedine Colutorio Aerosol 30g', 'Afecciones dolorosas e inflamatorias de la mucosa bucofaringea.', 268.05);

-- Inserciones en la tabla Categoria
INSERT INTO bd_farmaucab.Categoria (NombCategoria, DescripcionCategoria) VALUES
('Dolor de garganta', 'Medicamentos para infecciones de garganta.'),
('Antigripal', 'Medicamentos para combatir la gripe.'),
('Digestivo', 'Medicamentos con efectos sobre el sistema gastrointestinal.'),
('Dolor General', 'Medicamentos para el malestar general.'),
('Analgesico y antipiretico', 'Medicamentos diseñados para aliviar el dolor (muscular, de cabeza, articulaciones), o reducir la fiebre.'),
('Relajante/Dolor Muscular y articular', 'Medicamentos para relajar los músculos y reducir la tensión, la rigidez y el dolor.'),
('Neuroactivadores','Medicamentos que funcionan como activadores cerebrales.'),
('Antimigrañosos', 'Medicamentos que alivian el dolor y la inflamación, se usa específicamente para el dolor de cabeza causada por la migraña.'),
('Ansiolitico sedante', 'Medicamentos que deprimen o desaceleran determinadas funciones del cuerpo o la actividad de un órgano, como el corazón.');

---Inserciones CategoriaProd
INSERT INTO bd_farmaucab.CategoriaProd (Categoria_idCategoria, Producto_idProducto) VALUES
(1,15),(2,14),(3,13),(3,12),(4,11),(5,10),(5,5),(5,1),(6,9),(6,8),(6,7),(7,6),(8,4),(8,2),(9,3);

-- Inserciones en la tabla Cliente
INSERT INTO bd_farmaucab.Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, GeneroCliente) VALUES
('Luis', 'Alberto', 'Martínez', 'Pérez', '13765432', '1975-05-15','Masculino'),
('Ana', NULL, 'González', 'López', '21765432', '1982-08-20','Femenino'),
('María', 'Andrea', 'Gil','Flores', '20345678', '1985-01-01','Femenino'),
('Juan', 'Diego', 'López', NULL, '23765432', '1990-02-02','Masculino'),
('Ana', 'Laura', 'Martínez', NULL, '24654321', '1995-03-03','Femenino'),
('Pedro', NULL, 'García', 'Leon','25543210', '2000-04-04','Masculino'),
('Carlos', NULL, 'Sánchez', NULL, '30432109', '2005-05-05','Masculino'),
('Isabela', NULL, 'Pérez', 'Lara', '34321098', '2010-06-06','Femenino'),
('Roberto', 'Antonio', 'Ramírez', NULL, '26210987', '2000-07-07','Masculino'),
('Laura', NULL, 'Flores', NULL, '27109876', '2001-08-08','Femenino'),
('David', 'Antonio', 'Mendoza', NULL, '28098765', '2001-09-09','Masculino'),
('Jennifer', NULL, 'Morales', NULL, '19876543', '1994-10-10','Femenino'),
('José', 'Gregorio', 'Silva', NULL, '23876543', '1989-11-11','Masculino'),
('Mariana', NULL, 'Blanco', 'Salcedo', '20954321', '1985-01-01','Femenino'),
('Andrés', NULL, 'Fernández', 'Garcia','25543210', '1990-02-02','Masculino'),
('Patricia', NULL, 'Romero', NULL, '24835385', '1995-03-03','Femenino'),
('Francisco', NULL, 'Torres', NULL, '26891098', '2000-04-04','Masculino'),
('Juan', 'Carlos', 'Pérez', 'Gómez', '27111222', '2000-01-01','Masculino'),                  
('María', 'Isabel', 'López', 'García', '27333444', '1995-05-05','Femenino'),             
('Luis', NULL, 'González', 'Pérez','27555666', '1980-10-10','Masculino'),             
('Ana', 'María', 'Rodríguez', 'Ortiz', '27777888', '1975-12-12','Femenino'),
('Luisa', 'Fernanda', 'Hernández', 'Rodriguez', '27999000', '1965-06-06','Femenino'),
('Elena', 'María', 'Gómez', 'Romero', '27111221', '1960-04-04','Femenino');


-- Inserciones en la tabla Compra
INSERT INTO bd_farmaucab.Compra (monto, fecha_compra, fk_id_sucursal) VALUES
--sucursal 1
(22349.1, '2024-01-08', 1),
(31528.5,'2024-01-08', 1),
(31484.6,'2024-01-08', 1),
(87656.5,'2024-01-08',1),
(52045,'2024-01-08',1),
(105372,'2024-01-09',1),
(24124.5,'2024-01-09',1),
(41604.5,'2024-01-09',1),
(12765.1,'2024-01-09',1),
(54040,'2024-01-09',1),
(20995.3,'2024-01-10',1),
(6550,'2024-01-10',1),
(47502.5,'2024-01-10',1),
(55726.4,'2024-01-10',1),
(120560,'2024-01-10',1),
--sucursal 2
(23276,'2024-01-08',2),
(33183,'2024-01-08',2),
(51986,'2024-01-08',2),
(24300,'2024-01-08',2),
(33180,'2024-01-08',2),
(28150,'2024-01-09',2),
(22607,'2024-01-09',2),
(14100,'2024-01-09',2),
(38565,'2024-01-09',2),
(9514.5,'2024-01-09',2),
--sucursal 3
(5155,'2024-01-08',3),
(10263,'2024-01-08',3),
(6530,'2024-01-08',3),
(10941,'2024-01-11',3),
(29677.5,'2024-01-11',3),
(33727.5,'2024-01-11',3),
(9045,'2024-01-11',3);


-- Inserciones en la tabla DetalleCompra
INSERT INTO bd_farmaucab.DetalleCompra (Compra_idCompra, Producto_idProducto, monto, cantidadUnitaria) VALUES
--sucursal 1
(1,1,954.1,35),(1,5,9825,150),(1,11,11570,200),
(2,2,14391,180), (2,10,17137.5,150),
(3,3,12587,100), (3,14,18897.6,80),
(4,4,29074,200), (4,6,29970,300), (4,8,28612.5,150),
(5,7,17820,180), (5,9,34225,250),
(6,12,57966,100), (6,13,47406,150),
(7,15,24124.5,90),
(8,2,4797,60), (8,5,5240,80), (8,8,22890,120), (8,11,8677.5,150),
(9,1,954.1,35), (9,14,11811,50),
(10,3,6293.5,50), (10,14,23622,100), (10,15,24124.5,90),
(11,1,3543.8,130), (11,2,4797,60), (11,10,5712.5,50), (11,11,6942,120),
(12,5,6550,100),
(13,5,11135,170), (13,8,24797.5,130), (13,11,11570,200),
(14,9,27380,200), (14,14,28346.4,120),
(15,11,1735.5,30), (15,12,115932,200),
--sucursal 2
(16,1,1525,50), (16,2,12135,150), (16,10,9616,80),
(17,3,9163,70), (17,14,24020,100), 
(18,12,36036,60), (18,13,15950,50),
(19,15,24300,90),
(20,7,5000,50), (20,9,29980,200),
(21,8,20070,100), (21,11,6080,100),
(22,4,12032,80), (22,6,15135,150),
(23,5,14100,200),
(24,5,8460,120), (24,8,30105,150),
(25,11,4256,70), (25,2,5258.5,65),
--sucursal 3
(26,5,2115,30), (26,11,3040,50),
(27,2,4854,60), (27,10,5409,45),
(28,4,4512,30), (28,6,2018,20),
(29,1,906,30), (29,8,10035,50),
(30,3,3272.5,25), (30,12,12012,20), (30,13,4785,15), (30,14,9608,40), (30,15,4050,15),
(31,7,2000,20), (31,9,7045,50);

INSERT INTO bd_farmaucab.Inventario (NombreInventario, CantidadInventario, fk_id_sucursal) VALUES
('Inventario de FarmaUcab Santa Paula', 4560,1),
('Inventario de FarmaUcab Colinas de Tamanaco', 1935,2),
('Inventario de FarmaUcab Chacao', 500,3);

--Inserciones en la tabla StockInventario
INSERT INTO bd_farmaucab.StockInventario (Inventario_idInventario,Compra_idCompra,Producto_idProducto) VALUES
--sucursal 1
(1,1,1),(1,9,1),(1,11,1),
(1,2,2),(1,8,2),(1,11,2),
(1,3,3),(1,10,3),
(1,4,4),
(1,1,5),(1,8,5),(1,12,5),(1,13,5),
(1,4,6),
(1,5,7),
(1,4,8),(1,8,8),(1,13,8),
(1,5,9),(1,14,9),
(1,2,10),(1,11,10),
(1,1,11),(1,8,11),(1,11,11),(1,13,11),(1,15,11),
(1,6,12),(1,15,12),
(1,6,13),
(1,3,14),(1,9,14),(1,10,14),(1,14,14),
(1,7,15),(1,10,15),
--sucursal 2
(2,16,1),
(2,16,2), (2,25,2),
(2,17,3),
(2,22,4),
(2,23,5), (2,24,5),
(2,22,6),
(2,20,7),
(2,21,8), (2,24,8),
(2,20,9),
(2,16,10),
(2,25,11), (2,21,11),
(2,18,12),
(2,18,13),
(2,17,14),
(2,19,15),
--sucursal 3
(3,29,1),
(3,27,2),
(3,30,3),
(3,28,4),
(3,26,5),
(3,28,6),
(3,31,7),
(3,29,8),
(3,31,9),
(3,27,10),
(3,26,11),
(3,30,12),
(3,30,13),
(3,30,14),
(3,30,15);


-- Inserciones en la tabla Venta
INSERT INTO bd_farmaucab.Venta (FechaVenta, MontoTotalVenta, MetodoPago, Cliente_idCliente, fk_id_sucursal) VALUES
---------------sucursal 1
('2024-04-01', 1051.4, 'Tarjeta de crédito', 4,1),
('2024-04-01', 481.4, 'Efectivo', 7,1),
('2024-04-01', 191.3, 'Efectivo', 10,1),
('2024-04-02', 182, 'Efectivo', 15,1),
('2024-04-03', 1531.8, 'Tarjeta de crédito', 1,1),
('2024-04-04', 425.1, 'Efectivo', 11,1),
('2024-04-05', 531.8, 'Tarjeta de crédito', 3,1),
('2024-04-08', 1005.2, 'Tarjeta de crédito', 6,1),
('2024-04-08', 1395, 'Tarjeta de crédito', 13,1),
('2024-04-08', 704.7, 'Tarjeta de crédito', 8,1),
('2024-04-08', 381.8, 'Efectivo', 5,1),
('2024-04-08', 581.8, 'Tarjeta de crédito', 12,1),
('2024-04-08', 422.7, 'Tarjeta de crédito', 14,1),
('2024-04-09', 2158.2, 'Tarjeta de crédito', 2,1),
('2024-04-09', 2702, 'Otro', 9,1),
('2024-04-10', 302.8, 'Efectivo', 4,1),
('2024-04-10', 140.9, 'Efectivo', 5,1),
('2024-04-11', 542.4, 'Tarjeta de crédito', 1,1),
('2024-04-12', 600.6, 'Tarjeta de crédito', 2,1),
('2024-04-15', 390.6, 'Efectivo', 2,1),
('2024-04-16', 90.6 ,'Efectivo', 11,1),
('2024-04-17', 652.7, 'Tarjeta de crédito', 11,1),
('2024-04-18', 602.1, 'Tarjeta de crédito', 11,1),
('2024-04-19', 480.4, 'Efectivo', 3,1),
('2024-04-22', 493.3, 'Tarjeta de crédito', 1,1),
('2024-04-22', 211.5, 'Efectivo', 15,1),
('2024-05-16', 302.0, 'Tarjeta de crédito', 1, 1), 
('2024-05-17', 404.5, 'Efectivo', 2, 1),
('2024-05-18', 1963.5, 'Tarjeta de crédito', 3, 1), 
('2024-05-19', 752.0, 'Efectivo', 4, 1),
('2024-06-20', 2820.6, 'Tarjeta de crédito', 5, 1), 
('2024-06-21', 1532.0, 'Tarjeta de crédito', 6, 1),
('2024-06-22', 2007.0, 'Efectivo', 7, 1), 
('2024-04-23', 1409.0, 'Efectivo', 8, 1),
('2024-04-24', 1202.0, 'Tarjeta de crédito', 9, 1), 
('2024-04-25', 808.0, 'Tarjeta de crédito', 10, 1),
('2024-05-26', 6006.0, 'Efectivo', 11, 1), 
('2024-05-27', 957.0, 'Efectivo', 12, 1),
('2024-06-28', 4804.0, 'Tarjeta de crédito', 13, 1), 
('2024-04-29', 158.0, 'Tarjeta de crédito', 14, 1),
('2024-05-30', 2700.0, 'Efectivo', 15, 1),
-------------sucursal 2
('2024-04-16', 302.0, 'Tarjeta de crédito', 16, 2), 
('2024-04-17', 404.5, 'Efectivo', 13, 2),
('2024-04-18', 1963.5, 'Tarjeta de crédito', 17, 2), 
('2024-04-19', 752.0, 'Efectivo', 12, 2),
('2024-04-20', 2820.6, 'Tarjeta de crédito', 18, 2), 
('2024-06-21', 1532.0, 'Tarjeta de crédito', 11, 2),
('2024-06-22', 2007.0, 'Efectivo', 19, 2), 
('2024-06-23', 1409.0, 'Efectivo', 9, 2),
('2024-06-24', 1202.0, 'Tarjeta de crédito', 20, 2), 
('2024-06-25', 808.0, 'Tarjeta de crédito', 10, 2),
('2024-05-26', 6006.0, 'Efectivo', 21, 2), 
('2024-05-27', 957.0, 'Efectivo', 7, 2),
('2024-05-28', 4804.0, 'Tarjeta de crédito', 19, 2), 
('2024-05-29', 158.0, 'Tarjeta de crédito', 14, 2),
('2024-05-30', 2700.0, 'Efectivo', 10, 2),
--------------sucursal 3
('2024-05-16', 302.0, 'Tarjeta de crédito', 10, 3), 
('2024-05-17', 404.5, 'Efectivo', 9, 3),
('2024-06-18', 1963.5, 'Tarjeta de crédito', 11, 3), 
('2024-04-19', 752.0, 'Efectivo', 18, 3),
('2024-05-20', 2820.6, 'Tarjeta de crédito', 12, 3), 
('2024-06-21', 1532.0, 'Tarjeta de crédito', 17, 3),
('2024-04-22', 2007.0, 'Efectivo', 19, 3), 
('2024-05-23', 1409.0, 'Efectivo', 16, 3),
('2024-06-24', 1202.0, 'Tarjeta de crédito', 21, 3), 
('2024-04-25', 808.0, 'Tarjeta de crédito', 14, 3),
('2024-05-26', 6006.0, 'Efectivo', 1, 3), 
('2024-06-27', 957.0, 'Efectivo', 13, 3),
('2024-04-28', 4804.0, 'Tarjeta de crédito', 20, 3), 
('2024-06-29', 158.0, 'Tarjeta de crédito', 7, 3),
('2024-05-30', 2700.0, 'Efectivo', 15, 3),
------sucursal 1
    -- Venta 72 con 2 detalles
    ('2024-05-02', (3 * 27.26) + (6 * 125.87), 'Tarjeta de crédito', 1, 1),
    -- Venta 73 con 2 detalles
    ('2024-05-03', (4 * 145.37) + (7 * 99.00), 'Efectivo', 2, 1),
    -- Venta 74 con 2 detalles
    ('2024-05-04', (2 * 99.90) + (5 * 99.90), 'Otro', 3, 1),
    -- Venta 75 con 2 detalles
    ('2024-05-11', (1 * 65.50) + (4 * 136.90), 'Tarjeta de crédito', 4, 1),
    -- Venta 76 con 2 detalles
    ('2024-05-12', (6 * 114.25) + (3 * 57.85), 'Efectivo', 5, 1),
    -- Venta 77 con 2 detalles
    ('2024-06-13', (7 * 236.22) + (2 * 316.04), 'Tarjeta de crédito', 1, 1),
    -- Venta 78 con 2 detalles
    ('2024-06-11', (5 * 579.66) + (1 * 268.05), 'Efectivo', 2, 1),
    -- Venta 79 con 2 detalles
    ('2024-06-12', (3 * 99.00) + (6 * 99.90), 'Otro', 3, 1),
    -- Venta 80 con 2 detalles
    ('2024-07-14', (4 * 125.87) + (7 * 145.37), 'Tarjeta de crédito', 4, 1),
    -- Venta 81 con 2 detalles
    ('2024-07-02', (2 * 79.95) + (5 * 65.50), 'Efectivo', 5, 1),
-- Inserciones en la tabla Venta para la Sucursal 2
-- Venta 82 con 3 detalles
    ('2024-05-21', (4 * 125.87) + (7 * 99.00) + (3 * 27.26), 'Tarjeta de crédito', 6, 2),
    -- Venta 83 con 2 detalles
    ('2024-05-25', (6 * 79.95) + (2 * 79.95), 'Efectivo', 7, 2),
    -- Venta 84 con 2 detalles
    ('2024-05-17', (5 * 99.90) + (1 * 136.90), 'Otro', 8, 2),
    -- Venta 85 con 3 detalles
    ('2024-05-18', (4 * 190.75) + (6 * 57.85) + (3 * 114.25), 'Tarjeta de crédito', 9, 2),
    -- Venta 86 con 2 detalles
    ('2024-06-21', (7 * 145.37) + (2 * 579.66), 'Efectivo', 10, 2),
    -- Venta 87 con 3 detalles
    ('2024-06-18', (5 * 316.04) + (1 * 236.22) + (3 * 268.05), 'Tarjeta de crédito', 6, 2),
    -- Venta 88 con 2 detalles
    ('2024-06-19', (3 * 268.05) + (6 * 125.87), 'Efectivo', 7, 2),
    -- Venta 89 con 2 detalles
    ('2024-07-18', (4 * 79.95) + (7 * 27.26), 'Otro', 8, 2),
    -- Venta 90 con 4 detalles
    ('2024-07-01', (2 * 99.90) + (5 * 65.50) + (3 * 125.87) + (4 * 27.26), 'Tarjeta de crédito', 9, 2),
    -- Venta 91 con 3 detalles
    ('2024-07-03', (4 * 125.87) + (3 * 190.75) + (6 * 57.85), 'Efectivo', 10, 2),
-- Inserciones en la tabla Venta para la Sucursal 3
-- Venta 92 con 3 detalles
    ('2024-05-01', (3 * 79.95) + (5 * 125.87) + (4 * 99.90), 'Tarjeta de crédito', 11, 3),
    -- Venta 93 con 2 detalles
    ('2024-05-03', (4 * 27.26) + (6 * 136.90), 'Efectivo', 12, 3),
    -- Venta 94 con 3 detalles
    ('2024-05-11', (2 * 99.90) + (3 * 57.85) + (5 * 114.25), 'Otro', 13, 3),
    -- Venta 95 con 4 detalles
    ('2024-05-10', (2 * 125.87) + (3 * 145.37) + (5 * 79.95) + (4 * 316.04), 'Tarjeta de crédito', 14, 3),
    -- Venta 96 con 2 detalles
    ('2024-06-12', (7 * 99.00) + (2 * 268.05), 'Efectivo', 15, 3),
    -- Venta 97 con 2 detalles
    ('2024-06-04', (6 * 114.25) + (1 * 236.22), 'Tarjeta de crédito', 11, 3),
    -- Venta 98 con 2 detalles
    ('2024-06-10', (3 * 190.75) + (5 * 65.50), 'Efectivo', 12, 3),
    -- Venta 99 con 2 detalles
    ('2024-07-13', (4 * 57.85) + (7 * 579.66), 'Otro', 13, 3),
    -- Venta 100 con 3 detalles
    ('2024-07-01', (3 * 79.95) + (4 * 99.00) + (5 * 57.85), 'Tarjeta de crédito', 14, 3),
    -- Venta 101 con 3 detalles
    ('2024-07-12', (4 * 125.87) + (3 * 190.75) + (6 * 57.85), 'Efectivo', 15, 3)
;


-- Inserciones en la tabla Detalle de venta 
INSERT INTO bd_farmaucab.Detalleventa (CantidadUnitariaDetalleVenta, PrecioDetalleVenta, Venta_idVenta, fk_stock_inv, fk_stock_compra, fk_stock_prod) VALUES
--sucursal 1
(3,30.2,1,1,1,1), (4,30.2,2,1,1,1), (2,30.2,3,1,1,1), (2,30.2,4,1,1,1), (3,30.2,21,1,1,1),
(5,80.9,5,1,2,2), (3,80.9,6,1,2,2), (2,80.9,16,1,2,2),
(2,130.9,7,1,3,3), (1,130.9,3,1,3,3),
(4,150.4,8,1,4,4), (3,150.4,9,1,4,4), (1,150.4,20,1,4,4), (1,150.4,22,1,4,4),
(4,70.5,5,1,1,5), (4,70.5,10,1,1,5), (2,70.5,9,1,1,5), (2,70.5,16,1,1,5), (2,70.5,18,1,8,5), (3,70.5,25,1,8,5), (3,70.5,26,1,8,5),
(4,100.9,8,1,4,6), (1,100.9,22,1,4,6),
(1,100,11,1,5,7), (3,100,12,1,5,7),
(3,200.7,5,1,4,8), (4,200.7,9,1,4,8), (2,200.7,18,1,8,8), (2,200.7,22,1,8,8), (3,200.7,23,1,8,8),
(2,140.9,11,1,5,9), (3,140.9,10,1,5,9), (4,140.9,12,1,14,9), (3,140.9,13,1,14,9), (1,140.9,17,1,14,9), (2,140.9,25,1,14,9),
(3,120.2,2,1,11,10),
(4,60.8,5,1,11,11), (3,60.8,6,1,11,11), (2,60.8,4,1,11,11),
(2,600.6,14,1,15,12), (2,600.6,15,1,15,12), (1,600.6,19,1,15,12),
(3,319,14,1,6,13),
(4,240.2,1,1,3,14), (4,240.2,15,1,3,14), (1,240.2,20,1,3,14), (2,240.2,24,1,3,14),
(1,270,7,1,7,15), (2,270,15,1,7,15),
(10, 302.0, 27, 1,9,1), (5, 404.5, 28, 1,11,2), (15, 1963.5, 29, 1,10,3), (8, 1203.2, 30, 1,4,4), (40, 2820.0, 31, 1,13,5),
(15, 1513.5, 36, 1,4,6), (10, 2007.0, 35, 1,8,8), (10, 1409.0, 34, 1,14,9), (10, 1202.0, 33, 1,11,10), (10, 808.0, 32, 1,13,11),
(10, 6006.0, 37, 1,15,12), (3, 957, 38, 1,6,13), (20, 4804.0, 39, 1,10,14), (1, 270, 40, 1,10,15), (15, 1500, 41, 1,5,7),
----------sucursal 2
(10, 302.0, 42, 2,16,1), (5, 404.5, 43, 2,23,5), (15, 1963.5, 44, 2,19,15), (8, 1203.2, 45, 2,16,2), (40, 2820, 46, 2,17,3),
(15, 1513.5, 51, 2,20,9), (10, 2007.0, 50, 2,21,8), (10, 1409.0, 49, 2,20,7), (10, 1202.0, 48, 2,22,6), (10, 808.0, 47, 2,22,4),
(10, 6006.0, 52, 2,16,10), (3, 957, 53, 2,25,11), (20, 4804.0, 54, 2,18,12), (1, 270, 55, 2,17,14), (15, 1500, 56, 2,18,13),
--------------sucursal 3
(10, 302, 57, 3,29,1), (5, 404.5, 58, 3,27,2), (15, 1963.5, 59, 3,30,3), (8, 1203.2, 60, 3,28,4), (40, 2820, 61, 3,26,5),
(15, 1513.5, 66, 3,27,10), (10, 2007, 65, 3,31,9), (10, 1409, 64, 3,29,8), (10, 1202, 63, 3,31,7), (10, 808, 62, 3,28,6),
(10, 6006, 67, 3,26,11), (3, 957, 68, 3,30,12), (20, 4804, 69, 3,30,13), (1, 270, 70, 3,30,14), (15, 1500, 71, 3,30,15),
-------sucursal 1
    -- Venta 72 con 2 detalles
    (3, 3 * 27.26, 72, 1, 9, 1),
    (6, 6 * 125.87, 72, 1, 10, 3),
    -- Venta 73 con 2 detalles
    (4, 4 * 145.37, 73, 1, 4, 4),
    (7, 7 * 99.00, 73, 1, 5, 7),
    -- Venta 74 con 2 detalles
    (2, 2 * 99.90, 74, 1, 4, 6),
    (5, 5 * 99.90, 74, 1, 4, 6),
    -- Venta 75 con 2 detalles
    (1, 1 * 65.50, 75, 1, 13, 5),
    (4, 4 * 136.90, 75, 1, 14, 9),
    -- Venta 76 con 2 detalles
    (6, 6 * 114.25, 76, 1, 11, 10),
    (3, 3 * 57.85, 76, 1, 13, 11),
    -- Venta 77 con 2 detalles
    (7, 7 * 236.22, 77, 1, 14, 14),
    (2, 2 * 316.04, 77, 1, 6, 13),
    -- Venta 78 con 2 detalles
    (5, 5 * 579.66, 78, 1, 15, 12),
    (1, 1 * 268.05, 78, 1, 7, 15),
    -- Venta 79 con 2 detalles
    (3, 3 * 99.00, 79, 1, 5, 7),
    (6, 6 * 99.90, 79, 1, 4, 6),
    -- Venta 80 con 2 detalles
    (4, 4 * 125.87, 80, 1, 10, 3),
    (7, 7 * 145.37, 80, 1, 4, 4),
    -- Venta 81 con 2 detalles
    (2, 2 * 79.95, 81, 1, 11, 2),
    (5, 5 * 65.50, 81, 1, 13, 5),
-- Inserciones en la tabla Detalle de venta para la Sucursal 2
    -- Venta 82 con 3 detalles
    (4, 4 * 125.87, 82, 2, 17, 3),
    (7, 7 * 99.00, 82, 2, 20, 7),
    (3, 3 * 27.26, 82, 2, 16, 1),
    -- Venta 83 con 2 detalles
    (6, 6 * 79.95, 83, 2, 16, 2),
    (2, 2 * 79.95, 83, 2, 16, 2),
    -- Venta 84 con 2 detalles
    (5, 5 * 99.90, 84, 2, 22, 6),
    (1, 1 * 136.90, 84, 2, 20, 9),
    -- Venta 85 con 3 detalles
    (4, 4 * 190.75, 85, 2, 21, 8),
    (6, 6 * 57.85, 85, 2, 25, 11),
    (3, 3 * 114.25, 85, 2, 16, 10),
    -- Venta 86 con 2 detalles
    (7, 7 * 145.37, 86, 2, 22, 4),
    (2, 2 * 579.66, 86, 2, 18, 12),
    -- Venta 87 con 3 detalles
    (5, 5 * 316.04, 87, 2, 18, 13),
    (1, 1 * 236.22, 87, 2, 17, 14),
    (3, 3 * 268.05, 87, 2, 19, 15),
    -- Venta 88 con 2 detalles
    (3, 3 * 268.05, 88, 2, 19, 15),
    (6, 6 * 125.87, 88, 2, 17, 3),
    -- Venta 89 con 2 detalles
    (4, 4 * 79.95, 89, 2, 16, 2),
    (7, 7 * 27.26, 89, 2, 16, 1),
    -- Venta 90 con 4 detalles
    (2, 2 * 99.90, 90, 2, 22, 6),
    (5, 5 * 65.50, 90, 2, 23, 5),
    (3, 3 * 125.87, 90, 2, 17, 3),
    (4, 4 * 27.26, 90, 2, 16, 1),
    -- Venta 91 con 3 detalles
    (4, 4 * 125.87, 91, 2, 17, 3),
    (3, 3 * 190.75, 91, 2, 21, 8),
    (6, 6 * 57.85, 91, 2, 25, 11),
-- Inserciones en la tabla Detalle de venta para la Sucursal 3
    -- Venta 92 con 3 detalles
    (3, 3 * 79.95, 92, 3, 27, 2),
    (5, 5 * 125.87, 92, 3, 29, 8),
    (4, 4 * 99.90, 92, 3, 28, 6),
    -- Venta 93 con 2 detalles
    (4, 4 * 27.26, 93, 3, 29, 1),
    (6, 6 * 136.90, 93, 3, 31, 9),
    -- Venta 94 con 3 detalles
    (2, 2 * 99.90, 94, 3, 28, 6),
    (3, 3 * 57.85, 94, 3, 26, 11),
    (5, 5 * 114.25, 94, 3, 27, 10),
    -- Venta 95 con 4 detalles
    (2, 2 * 125.87, 95, 3, 30, 3),
    (3, 3 * 145.37, 95, 3, 28, 4),
    (5, 5 * 79.95, 95, 3, 27, 2),
    (4, 4 * 316.04, 95, 3, 30, 13),
    -- Venta 96 con 2 detalles
    (7, 7 * 99.00, 96, 3, 31, 7),
    (2, 2 * 268.05, 96, 3, 30, 15),
    -- Venta 97 con 2 detalles
    (6, 6 * 114.25, 97, 3, 27, 10),
    (1, 1 * 236.22, 97, 3, 30, 14),
    -- Venta 98 con 2 detalles
    (3, 3 * 190.75, 98, 3, 29, 8),
    (5, 5 * 65.50, 98, 3, 26, 5),
    -- Venta 99 con 2 detalles
    (4, 4 * 57.85, 99, 3, 26, 11),
    (7, 7 * 579.66, 99, 3, 30, 12),
    -- Venta 100 con 3 detalles
    (3, 3 * 79.95, 100, 3, 27, 2),
    (4, 4 * 99.00, 100, 3, 31, 7),
    (5, 5 * 57.85, 100, 3, 26, 11),
    -- Venta 101 con 3 detalles
    (4, 4 * 125.87, 101, 3, 29, 8),
    (3, 3 * 190.75, 101, 3, 28, 6),
    (6, 6 * 57.85, 101, 3, 26, 11)
;
*/
