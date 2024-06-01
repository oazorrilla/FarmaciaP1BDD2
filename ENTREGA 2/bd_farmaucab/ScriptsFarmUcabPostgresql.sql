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
    FOREIGN KEY (fk_id_lugar) REFERENCES lugar(idLugar)
);

------------------SUCURSAL
CREATE TABLE IF NOT EXISTS bd_farmaucab.Sucursal(
    idSucursal	SERIAL PRIMARY KEY,
    NombSucursal   VARCHAR(50) NOT NULL,
    DirecSucursal  VARCHAR(50) NOT NULL,
    RIFSucursal    VARCHAR(20) NOT NULL,
    fk_id_lugar	   integer not null,
    constraint check_rif_sucursal check ((RIFSucursal)::text ~ '^([Jj]{1}-[0-9]{10}$)'::text),	
    CONSTRAINT fk_id_lugar FOREIGN KEY (fk_id_lugar) REFERENCES lugar(idLugar)
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
  fk_id_sucursal integer not null,
  CONSTRAINT fk_id_sucursal FOREIGN KEY (fk_id_sucursal) REFERENCES sucursal(idSucursal)  
);

-----------DETALLE_COMPRA
CREATE TABLE IF NOT EXISTS bd_farmaucab.DetalleCompra (
  Compra_idCompra INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  monto FLOAT NOT NULL,
  cantidadUnitaria INT NOT NULL,
  PRIMARY KEY (Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra) REFERENCES Compra(idCompra),
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto)
);

------------------INVENTARIO
CREATE TABLE IF NOT EXISTS bd_farmaucab.Inventario (
  idInventario SERIAL PRIMARY KEY,
  NombreInventario VARCHAR(50) NOT NULL,
  CantidadInventario FLOAT NOT NULL,
  fk_id_sucursal integer not null,
  FOREIGN KEY (fk_id_sucursal) REFERENCES Sucursal(idSucursal)
);

------------------STOCK_INVENTARIO
CREATE TABLE IF NOT EXISTS bd_farmaucab.StockInventario(
  Inventario_idInventario INTEGER NOT NULL,
  Compra_idCompra INTEGER NOT NULL,
  Producto_idProducto INTEGER NOT NULL,
  PRIMARY KEY (Inventario_idInventario,Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra,Producto_idProducto) REFERENCES DetalleCompra(Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Inventario_idInventario) REFERENCES Inventario(IdInventario)
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
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto),
  FOREIGN KEY (Categoria_idCategoria) REFERENCES Categoria(idCategoria),
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
  FechaVenta timestamp NOT NULL,
  MontoTotalVenta FLOAT NOT NULL,
  MetodoPago VARCHAR(45) NOT NULL,
  Cliente_idCliente INT NOT NULL,
  fk_id_sucursal integer not null,
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente),
  FOREIGN KEY (fk_id_sucursal) REFERENCES Sucursal(idSucursal)
);

------------------DETALLE_VENTA
CREATE TABLE IF NOT EXISTS bd_farmaucab.DetalleVenta (
  idDetalleVenta SERIAL,
  CantidadUnitariaDetalleVenta INT NOT NULL,
  PrecioDetalleVenta FLOAT NOT NULL,
  Venta_idVenta INT NOT NULL,
  Inventario_idInventario INT NOT NULL,
  PRIMARY KEY (idDetalleVenta,Venta_idVenta),
  FOREIGN KEY (Venta_idVenta) REFERENCES Venta(idVenta),
  FOREIGN KEY (Inventario_idInventario) REFERENCES Inventario(idInventario)
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
INSERT INTO bd_farmaucab.Compra (monto,fk_id_sucursal) VALUES
--sucursal 1
(22349.1,1),
(31528.5,1),
(31484.6,1),
(87656.5,1),
(52045,1),
(105372,1),
(24124.5,1),
(41604.5,1),
(12765.1,1),
(54040,1),
(20995.3,1),
(6550,1),
(47502.5,1),
(55726.4,1),
(120560,1),
--sucursal 2
(23276,2),
(33183,2),
(51986,2),
(24300,2),
(33180,2),
(28150,2),
(22607,2),
(14100,2),
(38565,2),
(9514.5,2),
--sucursal 3
(5155,3),
(10263,3),
(6530,3),
(10941,3),
(29677.5,3),
(33727.5,3),
(9045,3);

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

--Inserciones en la tabla Inventario
INSERT INTO bd_farmaucab.Inventario (NombreInventario, CantidadInventario, fk_id_sucursal) VALUES
--sucursal 1
('Acetaminofen 650mg', 200,1),
('Atamel Forte 650mg', 300,1),
('Apiret 180mg/5ml', 150,1),
('Migren', 200,1),
('Diclofenac Potasico 50mg', 500,1),
('Dol Plus', 300,1),
('Dencorub 40mg', 180,1),
('Femmex ultra 200/10mg', 400,1),
('Tiocolchicosido Calox 4mg', 450,1),
('Atamel 500mg', 200,1),
('Ibuprofeno 400mg', 700,1),
('Festal', 300,1),
('Liolactil 250mg', 150,1),
('Teragrip Forte 24h', 350,1),
('Hexomedine Colutorio Aerosol 30g', 180,1),
--sucursal 2
--16
('Acetaminofen 650mg', 50, 2),
('Atamel Forte 650mg', 215, 2),
('Apiret 180mg/5ml', 70, 2),
('Migren', 80, 2),
('Diclofenac Potasico 50mg', 320, 2),
('Dol Plus', 150, 2),
('Dencorub 40mg', 50, 2),
('Femmex ultra 200/10mg', 250, 2),
('Tiocolchicosido Calox 4mg', 200, 2),
('Atamel 500mg', 80, 2),
('Ibuprofeno 400mg', 170, 2),
('Festal', 60, 2),
('Liolactil 250mg', 50, 2),
('Teragrip Forte 24h', 100, 2),
('Hexomedine Colutorio Aerosol 30g', 90, 2),
--sucursal 3
--31
('Acetaminofen 650mg', 30, 3),
('Atamel Forte 650mg', 60, 3),
('Apiret 180mg/5ml', 25, 3),
('Migren', 30, 3),
('Diclofenac Potasico 50mg', 30, 3),
('Dol Plus', 20, 3),
('Dencorub 40mg', 20, 3),
('Femmex ultra 200/10mg', 50, 3),
('Tiocolchicosido Calox 4mg', 50, 3),
('Atamel 500mg', 45, 3),
('Ibuprofeno 400mg', 50, 3),
('Festal', 20, 3),
('Liolactil 250mg', 15, 3),
('Teragrip Forte 24h', 40, 3),
('Hexomedine Colutorio Aerosol 30g', 15, 3);

--Inserciones en la tabla StockInventario
INSERT INTO bd_farmaucab.StockInventario (Inventario_idInventario,Compra_idCompra,Producto_idProducto) VALUES
--sucursal 1
(1,1,1),(1,9,1),(1,11,1),
(2,2,2),(2,8,2),(2,11,2),
(3,3,3),(3,10,3),
(4,4,4),
(5,1,5),(5,8,5),(5,12,5),(5,13,5),
(6,4,6),
(7,5,7),
(8,4,8),(8,8,8),(8,13,8),
(9,5,9),(9,14,9),
(10,2,10),(10,11,10),
(11,1,11),(11,8,11),(11,11,11),(11,13,11),(11,15,11),
(12,6,12),(12,15,12),
(13,6,13),
(14,3,14),(14,9,14),(14,10,14),(14,14,14),
(15,7,15),(15,10,15),
--sucursal 2
(16,16,1),
(17,16,2), (17,25,2),
(18,17,3),
(19,22,4),
(20,23,5), (20,24,5),
(21,22,6),
(22,20,7),
(23,21,8), (23,24,8),
(24,20,9),
(25,16,10),
(26,25,11), (26,21,11),
(27,18,12),
(28,18,13),
(29,17,14),
(30,19,15),
--sucursal 3
(31,29,1),
(32,27,2),
(33,30,3),
(34,28,4),
(35,26,5),
(36,28,6),
(37,31,7),
(38,29,8),
(39,31,9),
(40,27,10),
(41,26,11),
(42,30,12),
(43,30,13),
(44,30,14),
(44,30,15);


-- Inserciones en la tabla Venta
INSERT INTO bd_farmaucab.Venta (FechaVenta, MontoTotalVenta, MetodoPago, Cliente_idCliente, fk_id_sucursal) VALUES
--sucursal 1
('2024-04-01 15:45:00', 1051.4, 'Tarjeta de crédito', 4,1),
('2024-04-01 12:30:00', 481.4, 'Efectivo', 7,1),
('2024-04-01 12:00:00', 191.3, 'Efectivo', 10,1),
('2024-04-02 16:00:00', 182, 'Efectivo', 15,1),
('2024-04-03 14:00:00', 1531.8, 'Tarjeta de crédito', 1,1),
('2024-04-04 11:00:00', 425.1, 'Efectivo', 11,1),
('2024-04-05 17:00:00', 531.8, 'Tarjeta de crédito', 3,1),
('2024-04-08 17:00:00', 1005.2, 'Tarjeta de crédito', 6,1),
('2024-04-08 19:00:00', 1395, 'Tarjeta de crédito', 13,1),
('2024-04-08 15:00:00', 704.7, 'Tarjeta de crédito', 8,1),
('2024-04-08 13:00:00', 381.8, 'Efectivo', 5,1),
('2024-04-08 15:30:00', 581.8, 'Tarjeta de crédito', 12,1),
('2024-04-08 16:45:00', 422.7, 'Tarjeta de crédito', 14,1),
('2024-04-09 12:00:00', 2158.2, 'Tarjeta de crédito', 2,1),
('2024-04-09 13:45:00', 2702, 'Otro', 9,1),
('2024-04-10 9:00:00', 302.8, 'Efectivo', 4,1),
('2024-04-10 20:30:00', 140.9, 'Efectivo', 5,1),
('2024-04-11 9:30:00', 542.4, 'Tarjeta de crédito', 1,1),
('2024-04-12 10:30:00', 600.6, 'Tarjeta de crédito', 2,1),
('2024-04-15 13:45:00', 390.6, 'Efectivo', 2,1),
('2024-04-16 19:15:00', 90.6 ,'Efectivo', 11,1),
('2024-04-17 11:20:00', 652.7, 'Tarjeta de crédito', 11,1),
('2024-04-18 12:30:00', 602.1, 'Tarjeta de crédito', 11,1),
('2024-04-19 16:30:00', 480.4, 'Efectivo', 3,1),
('2024-04-22 17:30:00', 493.3, 'Tarjeta de crédito', 1,1),
('2024-04-22 18:00:00', 211.5, 'Efectivo', 15,1),
('2024-05-16', 302.0, 'Tarjeta de crédito', 1, 1),   --id 27
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
--sucursal 2
('2024-04-16', 302.0, 'Tarjeta de crédito', 1, 2),    --id 42
('2024-04-17', 404.5, 'Efectivo', 2, 2),
('2024-04-18', 1963.5, 'Tarjeta de crédito', 3, 2), 
('2024-04-19', 752.0, 'Efectivo', 4, 2),
('2024-04-20', 2820.6, 'Tarjeta de crédito', 5, 2), 
('2024-06-21', 1532.0, 'Tarjeta de crédito', 6, 2),
('2024-06-22', 2007.0, 'Efectivo', 7, 2), 
('2024-06-23', 1409.0, 'Efectivo', 8, 2),
('2024-06-24', 1202.0, 'Tarjeta de crédito', 9, 2), 
('2024-06-25', 808.0, 'Tarjeta de crédito', 10, 2),
('2024-05-26', 6006.0, 'Efectivo', 11, 2), 
('2024-05-27', 957.0, 'Efectivo', 12, 2),
('2024-05-28', 4804.0, 'Tarjeta de crédito', 13, 2), 
('2024-05-29', 158.0, 'Tarjeta de crédito', 14, 2),
('2024-05-30', 2700.0, 'Efectivo', 15, 2),
--sucursal 3
('2024-05-16', 302.0, 'Tarjeta de crédito', 1, 3),    --id 57
('2024-05-17', 404.5, 'Efectivo', 2, 3),
('2024-06-18', 1963.5, 'Tarjeta de crédito', 3, 3), 
('2024-04-19', 752.0, 'Efectivo', 4, 3),
('2024-05-20', 2820.6, 'Tarjeta de crédito', 5, 3), 
('2024-06-21', 1532.0, 'Tarjeta de crédito', 6, 3),
('2024-04-22', 2007.0, 'Efectivo', 7, 3), 
('2024-05-23', 1409.0, 'Efectivo', 8, 3),
('2024-06-24', 1202.0, 'Tarjeta de crédito', 9, 3), 
('2024-04-25', 808.0, 'Tarjeta de crédito', 10, 3),
('2024-05-26', 6006.0, 'Efectivo', 11, 3), 
('2024-06-27', 957.0, 'Efectivo', 12, 3),
('2024-04-28', 4804.0, 'Tarjeta de crédito', 13, 3), 
('2024-06-29', 158.0, 'Tarjeta de crédito', 14, 3),
('2024-05-30', 2700.0, 'Efectivo', 15, 3);


-- Inserciones en la tabla Detalle de venta
INSERT INTO bd_farmaucab.Detalleventa (CantidadUnitariaDetalleVenta, PrecioDetalleVenta, Venta_idVenta, Inventario_idInventario) VALUES
--sucursal 1
(3,30.2,1,1), (4,30.2,2,1), (2,30.2,3,1), (2,30.2,4,1), (3,30.2,21,1),
(5,80.9,5,2), (3,80.9,6,2), (2,80.9,16,2),
(2,130.9,7,3), (1,130.9,3,3),
(4,150.4,8,4), (3,150.4,9,4), (1,150.4,20,4), (1,150.4,22,4),
(4,70.5,5,5), (4,70.5,10,5), (2,70.5,9,5), (2,70.5,16,5), (2,70.5,18,5), (3,70.5,25,5), (3,70.5,26,5),
(4,100.9,8,6), (1,100.9,22,6),
(1,100,11,7), (3,100,12,7),
(3,200.7,5,8), (4,200.7,9,8), (2,200.7,18,8), (2,200.7,22,8), (3,200.7,23,8),
(2,140.9,11,9), (3,140.9,10,9), (4,140.9,12,9), (3,140.9,13,9), (1,140.9,17,9), (2,140.9,25,9),
(3,120.2,2,10),
(4,60.8,5,11), (3,60.8,6,11), (2,60.8,4,11),
(2,600.6,14,12), (2,600.6,15,12), (1,600.6,19,12),
(3,319,14,13),
(4,240.2,1,14), (4,240.2,15,14), (1,240.2,20,14), (2,240.2,24,14),
(1,270,7,15), (2,270,15,15),
-----detalle de venta de erick
--sucursal 2

--sucursal 3

;

*/
