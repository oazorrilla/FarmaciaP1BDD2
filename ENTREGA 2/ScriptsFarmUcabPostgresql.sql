------------------LUGAR
CREATE TABLE IF NOT EXISTS Lugar(
    idLugar  SERIAL PRIMARY KEY,
    TipoLugar VARCHAR(50) NOT NULL,
    NombLugar VARCHAR(50) NOT NULL,
    fk_id_lugar integer null,
    CONSTRAINT fk_id_lugar FOREIGN KEY (fk_id_lugar) REFERENCES lugar(id_lugar)
);

------------------SUCURSAL
CREATE TABLE IF NOT EXISTS Sucursal(
    idSucursal	SERIAL PRIMARY KEY,
    NombSucursal   VARCHAR(50) NOT NULL,
    DirecSucursal  VARCHAR(50) NOT NULL,
    RIFSucursal    VARCHAR(20) NOT NULL,
    fk_id_lugar	   integer not null,
    constraint check_rif_sucursal check ((RIFSucursal)::text ~ '^([Jj]{1}-[0-9]{10}$)'::text),	
    CONSTRAINT fk_id_lugar FOREIGN KEY (fk_id_lugar) REFERENCES lugar(id_lugar)
);

------------------IMAGEN
CREATE TABLE IF NOT EXISTS Imagen (
    idImagen  SERIAL PRIMARY KEY,
    NombImagen VARCHAR(50) NOT NULL,
    ArchivoImagen bytea
);

------------------PRODUCTO
CREATE TABLE IF NOT EXISTS Producto (
  idProducto SERIAL PRIMARY KEY,
  NombProduct VARCHAR(50) NOT NULL,
  DescripcionProduct VARCHAR(200) NOT NULL,
  PrecioProduct FLOAT NOT NULL,
  fk_imagen int,   
  FOREIGN KEY (fk_imagen) REFERENCES Imagen(idImagen)
);

------------COMPRA
CREATE TABLE IF NOT EXISTS Compra (
  idCompra SERIAL PRIMARY KEY,
  monto FLOAT NOT NULL,
  fk_id_sucursal integer not null,
  CONSTRAINT fk_id_sucursal FOREIGN KEY (fk_id_sucursal) REFERENCES sucursal(idSucursal)  
);

-----------DETALLE_COMPRA
CREATE TABLE IF NOT EXISTS DetalleCompra (
  Compra_idCompra INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  monto FLOAT NOT NULL,
  cantidadUnitaria INT NOT NULL,
  PRIMARY KEY (Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra) REFERENCES Compra(idCompra),
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto)
);

------------------INVENTARIO
CREATE TABLE IF NOT EXISTS Inventario (
  idInventario SERIAL PRIMARY KEY,
  NombreInventario VARCHAR(50) NOT NULL,
  CantidadInventario FLOAT NOT NULL,
  fk_id_sucursal integer not null,
  FOREIGN KEY (fk_id_sucursal) REFERENCES Sucursal(idSucursal)
);

------------------STOCK_INVENTARIO
CREATE TABLE IF NOT EXISTS StockInventario(
  Inventario_idInventario INTEGER NOT NULL,
  Compra_idCompra INTEGER NOT NULL,
  Producto_idProducto INTEGER NOT NULL,
  PRIMARY KEY (Inventario_idInventario,Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Compra_idCompra,Producto_idProducto) REFERENCES DetalleCompra(Compra_idCompra,Producto_idProducto),
  FOREIGN KEY (Inventario_idInventario) REFERENCES Inventario(IdInventario)
);

------------------EMPLEADO
CREATE TABLE IF NOT EXISTS Empleado (
  idEmpleado SERIAL PRIMARY KEY,
  PrimNombEmpleado VARCHAR(45) NOT NULL,
  SegNombEmpleado VARCHAR(45),
  PrimApellidoEmpleado VARCHAR(45) NOT NULL,
  CIEmpleado VARCHAR(45) NOT NULL,
  FechaEmpleado DATE NOT NULL,
  Sueldo INT NOT NULL,
  fk_imagen int,
  fk_id_sucursal integer not null,   
  FOREIGN KEY (fk_imagen) REFERENCES Imagen(idImagen),
  foreign key (fk_id_sucursal) REFERENCES Sucursal(idSucursal)
);

------------------COSTO
CREATE TABLE IF NOT EXISTS Costo (
  idCosto SERIAL PRIMARY KEY,
  NombreCosto VARCHAR(50) NOT NULL,
  monto FLOAT NOT NULL,
  fk_id_sucursal integer not null,
    FOREIGN KEY (fk_id_sucursal) REFERENCES Sucursal(idSucursal)
);

----------------DESCGASTOS
CREATE TABLE IF NOT EXISTS DescGastos (
  idDescGastos SERIAL PRIMARY KEY NOT NULL,
  DescripcionCosto VARCHAR (200) NOT NULL,
  Fecha DATE NOT NULL,
  Empleado_idEmpleado INT,
  Compra_idCompra INT,
  Costo_idCosto INT,
  FOREIGN KEY (Costo_idCosto) REFERENCES Costo(idCosto),
  FOREIGN KEY (Empleado_idEmpleado) REFERENCES Empleado(idEmpleado),
  FOREIGN KEY (Compra_idCompra) REFERENCES Compra(idCompra)
);

------------------CATEGORIA
CREATE TABLE IF NOT EXISTS Categoria (
  idCategoria SERIAL PRIMARY KEY,
  NombCategoria VARCHAR(50) NOT NULL,
  DescripcionCategoria VARCHAR(200) NOT NULL
);

------------------CATEGORIA_PROD
CREATE TABLE IF NOT EXISTS CategoriaProd (
  Categoria_idCategoria INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto),
  FOREIGN KEY (Categoria_idCategoria) REFERENCES Categoria(idCategoria),
  PRIMARY KEY (Categoria_idCategoria,Producto_idProducto)
);

------------------CLIENTE
CREATE TABLE IF NOT EXISTS Cliente (
  idCliente SERIAL PRIMARY KEY,
  PrimNombCliente VARCHAR(50) NOT NULL,
  SegNombCliente VARCHAR(50),
  PrimApellidoCliente VARCHAR(50) NOT NULL,
  SegApeliidoCliente VARCHAR(50),
  CICliente VARCHAR(45),
  FechaNacCliente DATE NOT NULL,
  fk_imagen int,   
  FOREIGN KEY (fk_imagen) REFERENCES Imagen(idImagen)
);

------------------VENTA
CREATE TABLE IF NOT EXISTS Venta (
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
CREATE TABLE IF NOT EXISTS DetalleVenta (
  idDetalleVenta SERIAL,
  CantidadUnitariaDetalleVenta INT NOT NULL,
  PrecioDetalleVenta FLOAT NOT NULL,
  Venta_idVenta INT NOT NULL,
  Inventario_idInventario INT NOT NULL,
  PRIMARY KEY (idDetalleVenta,Venta_idVenta),
  FOREIGN KEY (Venta_idVenta) REFERENCES Venta(idVenta),
  FOREIGN KEY (Inventario_idInventario) REFERENCES Inventario(idInventario)
);


----------------LOG DE TURNO
CREATE TABLE IF NOT EXISTS Turno_Laboral (
    idTurno             SERIAL PRIMARY KEY,
    FechaInicio         TIMESTAMP NOT NULL,
    FechaFin            TIMESTAMP NOT NULL
);

----------------REGISTRO ASISTENCIA
CREATE TABLE IF NOT EXISTS RegistroAsistencia (
    TurnoLaboral_idTurnoLaboral INT NOT NULL,
    Empleado_idEmpleado         INT NOT NULL,
    FOREIGN KEY (TurnoLaboral_idTurnoLaboral) REFERENCES Turno_Laboral (idTurno),
    FOREIGN KEY (Empleado_idEmpleado) REFERENCES Empleado (idEmpleado),
    PRIMARY KEY (TurnoLaboral_idTurnoLaboral, Empleado_idEmpleado)
);

---------------------------------------------- Alter table de los check -------------------------------------------------------------------
ALTER TABLE Venta
ADD CONSTRAINT CHK_MetodoPago
CHECK (MetodoPago IN ('Tarjeta de crédito', 'Otro', 'Efectivo'));

ALTER TABLE Inventario
ADD CONSTRAINT CHK_StockProduct
CHECK (CantidadInventario >= 0);
 
------------------------------------Insert-----------------------------------------------------------------------------------

/*
-- Inserciones en la tabla Sucursal
INSERT INTO Sucursal (NombSucursal, DirecSucursal, RIFSucursal, fk_id_lugar) VALUES
('FarmaUcab Santa Paula','Calle Tauro', 'J-3067658921',1002),
('FarmaUcab Colinas de Tamanaco','Calle Valencia', 'J-3056972120',1003),
('FarmaUcab Chacao', 'Calle Elice', 'J-3069874121',704);

-- Inserciones en la tabla Lugar en otro script

-- Inserciones en la tabla Imagen
INSERT INTO Imagen (NombImagen, ArchivoImagen) VALUES
('User', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\User.png')),
('Acetaminofén', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Acetaminofen.jpg')),
('Apiret', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Apiret.jpg')),
('Atamel', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Atamel.jpg')),
('Atamel Forte', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\AtamelForte.jpg')),
('Dencorub', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Dencorub.jpg')),
('Diclofenac', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Diclofenac.jpg')),
('Dol', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Dol.jpg')),
('Femmextra', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Femmextra.jpg')),
('Festal', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Festal.jpg')),
('Hexomedine', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Hexomedine.jpg')),
('Ibuprofeno', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Ibuprofeno.jpg')),
('Liolactil', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Liolactil.jpg')),
('Migren', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Migren.jpg')),
('Teragrip', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Teragrip.jpg')),
('Tiocolchicosido', pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\Tiocolchicosido.jpg')),
('Usuario femenino',pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\usuario-fem.jpg')),  --17
('Usuario masculino, pg_read_binary_file('C:\\Users\\PC\\Downloads\\ImagesReports\\usuario-masc.png'));  --18

-- Inserciones en la tabla Producto
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProducto, fk_imagen) VALUES
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
INSERT INTO Categoria (NombCategoria, DescripcionCategoria) VALUES
('Dolor de garganta', 'Medicamentos para infecciones de garganta.'),
('Antigripal', 'Medicamentos para combatir la gripe.'),
('Digestivo', 'Medicamentos con efectos sobre el sistema gastrointestinal.'),
('Dolor General', 'Medicamentos para el malestar general.'),
('Analgesico y antipiretico', 'Medicamentos diseñados para aliviar el dolor (muscular, de cabeza, articulaciones), o reducir la fiebre.'),
('Relajante/Dolor Muscular y articular', 'Medicamentos para relajar los músculos y reducir la tensión, la rigidez y el dolor'.),
('Neuroactivadores','Medicamentos que funcionan como activadores cerebrales.'),
('Antimigrañosos', 'Medicamentos que alivian el dolor y la inflamación, se usa específicamente para el dolor de cabeza causada por la migraña.'),
('Ansiolitico sedante', 'Medicamentos que deprimen o desaceleran determinadas funciones del cuerpo o la actividad de un órgano, como el corazón.');

---Inserciones CategoriaProd
INSERT INTO CategoriaProd (Categoria_idCategoria, Producto_idProducto) VALUES
(1,15),(2,14),(3,13),(3,12),(4,11),(5,10),(5,5),(5,1),(6,9),(6,8),(6,7),(7,6),(8,4),(8,2),(9,3);

-- Inserciones en la tabla Cliente
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, fk_imagen) VALUES
('Luis', 'Alberto', 'Martínez', 'Pérez', '13765432', '1975-05-15',18),
('Ana', NULL, 'González', 'López', '21765432', '1982-08-20',17),
('María', 'Andrea', 'Gil','Flores', '20345678', '1985-01-01',17),
('Juan', 'Diego', 'López', NULL, '23765432', '1990-02-02',18),
('Ana', 'Laura', 'Martínez', NULL, '24654321', '1995-03-03',17),
('Pedro', NULL, 'García', 'Leon','25543210', '2000-04-04',18),
('Carlos', NULL, 'Sánchez', NULL, '30432109', '2005-05-05',18),
('Isabela', NULL, 'Pérez', 'Lara', '34321098', '2010-06-06',17),
('Roberto', 'Antonio', 'Ramírez', NULL, '26210987', '2000-07-07',18),
('Laura', NULL, 'Flores', NULL, '27109876', '2001-08-08',17),
('David', 'Antonio', 'Mendoza', NULL, '28098765', '2001-09-09',18),
('Jennifer', NULL, 'Morales', NULL, '19876543', '1994-10-10',17),
('José', 'Gregorio', 'Silva', NULL, '23876543', '1989-11-11',18),
('Mariana', NULL, 'Blanco', 'Salcedo', '20954321', '1985-01-01',17),
('Andrés', NULL, 'Fernández', 'Garcia','25543210', '1990-02-02',18),
('Patricia', NULL, 'Romero', NULL, '24835385', '1995-03-03',17),
('Francisco', NULL, 'Torres', NULL, '26891098', '2000-04-04',18),
('Juan', 'Carlos', 'Pérez', 'Gómez', '27111222', '2000-01-01',18),                  
('María', 'Isabel', 'López', 'García', '27333444', '1995-05-05,17),             
('Luis', NULL, 'González', 'Pérez','27555666', '1980-10-10',18),             
('Ana', 'María', 'Rodríguez', 'Ortiz', '27777888', '1975-12-12',17),
('Luisa', 'Fernanda', 'Hernández', 'Rodriguez', '27999000', '1965-06-06',17),
('Elena', 'María', 'Gómez', 'Romero', '27111221', '1960-04-04',17);

-- Inserciones en la tabla Empleado
INSERT INTO Empleado (PrimNombEmpleado, SegNombEmpleado, PrimApellidoEmpleado, CIEmpleado, FechaEmpleado,Sueldo,fk_imagen,fk_id_sucursal) VALUES
('Juan', 'Carlos', 'Pérez', '22893736', '1990-01-01',1000,18,1),
('Andrea', NULL, 'Gomez', '19357298', '1980-01-01',700,17,1),
('Jose', 'Alejandro', 'López', '20846594', '1983-02-02',700,18,1),
('Andreina', NULL, 'Martínez', '17929437', '1978-03-03',500,17,1),
('Carlos', 'Alberto', 'García', '15202857', '1979-04-04',500,18,1),
('Leandro', NULL, 'Sánchez', '15836480', '1979-05-05',1000,18,1),
('Isabel', NULL, 'Pérez', '19735491', '1985-06-06',1000,17,1),
('Adrian', NULL, 'Ramírez', '22038363', '1990-07-07',600,18,1),
('Laura', 'Andrea', 'Flores', '19274654', '1985-08-08',600,17,1),
('David', NULL, 'Mendoza', '21098765', '1988-09-09',600,18,1),
('Jennifer', NULL, 'Morales', '19053739', '1980-10-10',800,17,1),
('Diego', NULL, 'Fuentes', '19990386', '1981-11-11',800,18,1),
('Mariana', 'Andrea', 'Blanco', '20963461', '1986-01-01',1500,17,1),
('Andrés', 'Ignacio', 'Fernández', '19027353', '1983-02-02',900,18,1),
('Patricia', NULL, 'Romero', '18027354', '1980-03-03',650,17,1),
('Francisco', 'Alejandro', 'Torres', '19027469', '1979-04-04',650,18,1),
('Ana', 'Isabel', 'García','27991001', '1990-05-15', 1000,17,2),
('Pedro',null, 'Saa', '27112222', '1985-12-31', 700,18,2),
('Virginia', 'María', 'Rodríguez','27332442', '1995-08-20', 600,17,2),
('Alejandro', null,'González','27552662', '1980-06-10', 600,18,2),
('María', 'José', 'Bastidas', '27772882', '1992-11-25', 600,17,2),
('Carlos', null,'La Riva', '27992002', '1975-03-05', 700,18,2),
('Alejandra', 'Lucía', 'Ramirez', '27113223', '1988-02-15',800,17,2),
('Diego', null,'Tejero', '27333442', '1998-09-30',500,18,2),
('Valentina', 'Elena', 'Trejo','27552662', '1993-04-12', 800,17,2),
('Daniel', null,'Carro','27772882', '2000-01-01', 1500,18,2),
('Vanessa', 'Isabel', 'Dorta', '27992002', '1990-05-15', 1000,17,2),
('Ignacio', null,'Col', '28111222', '1985-12-31', 500,18,2),                       
('Victoria', 'María', 'Rodríguez', '28333444', '1995-08-20', 900,17,2),
('Eduardo', null,'Lopez', '28555666', '1980-06-10', 1000,18,2),
('Nicole', 'Andrea', 'Silva', '28777888', '1992-11-25', 650,17,2),
('Vicente',null, 'Gomez','28999000', '1975-03-05', 1000,18,3),
('Reina', 'Lucía', 'Nunez', '28111221', '1988-02-15', 600,17,3),
('Reinaldo', null,'Nones', '28331441', '1998-09-30', 500,18,3),
('Cristina', 'Elena', 'Trombo', '28551661', '1993-04-12',600,17,3),
('Marcos', null,'Pombo', '28771881', '2000-01-01', 800,18,3),
('Geraldine', 'Isabel', 'Tovar', '28991001', '1990-05-15', 1500,17,3),
('Jorge', null,'Paredes','28112222', '1985-12-31', 700,18,3),
('Gabriela', 'María', 'Mantilla', '28332442', '1995-08-20',650,17,3);

/*
--Inserciones en la tabla
INSERT INTO Turno_Laboral (FechaInicio, FechaFin) VALUES
--ENERO
('2024-01-08 9:00:00', '2024-01-08 17:00:00'), ('2024-01-09 9:00:00', '2024-01-09 17:00:00'), ('2024-01-10 9:00:00', '2024-01-10 17:00:00'),
('2024-01-11 9:00:00', '2024-01-11 17:00:00'), ('2024-01-12 9:00:00', '2024-01-12 17:00:00'), ('2024-01-15 9:00:00', '2024-01-15 17:00:00'),
('2024-01-16 9:00:00', '2024-01-16 17:00:00'), ('2024-01-17 9:00:00', '2024-01-17 17:00:00'), ('2024-01-18 9:00:00', '2024-01-18 17:00:00'),
('2024-01-19 9:00:00', '2024-01-19 17:00:00'), ('2024-01-22 9:00:00', '2024-01-22 17:00:00'), ('2024-01-23 9:00:00', '2024-01-23 17:00:00'),
('2024-01-24 9:00:00', '2024-01-24 17:00:00'), ('2024-01-25 9:00:00', '2024-01-25 17:00:00'), ('2024-01-26 9:00:00', '2024-01-26 17:00:00'),
('2024-01-29 9:00:00', '2024-01-29 17:00:00'), ('2024-01-30 9:00:00', '2024-01-30 17:00:00'), ('2024-01-31 9:00:00', '2024-01-31 17:00:00'),
--FEBRERO
('2024-02-01 9:00:00', '2024-02-01 17:00:00'), ('2024-02-02 9:00:00', '2024-02-02 17:00:00'), ('2024-02-04 9:00:00', '2024-02-04 17:00:00'),
('2024-02-05 9:00:00', '2024-02-05 17:00:00'), ('2024-02-06 9:00:00', '2024-02-06 17:00:00'), ('2024-02-07 9:00:00', '2024-02-07 17:00:00'),
('2024-02-08 9:00:00', '2024-02-08 17:00:00'), ('2024-02-09 9:00:00', '2024-02-09 17:00:00'), ('2024-02-12 9:00:00', '2024-02-12 17:00:00'),
('2024-02-13 9:00:00', '2024-02-13 17:00:00'), ('2024-02-14 9:00:00', '2024-02-14 17:00:00'), ('2024-02-15 9:00:00', '2024-02-15 17:00:00'),
('2024-02-16 9:00:00', '2024-02-16 17:00:00'), ('2024-02-19 9:00:00', '2024-02-19 17:00:00'), ('2024-02-20 9:00:00', '2024-02-20 17:00:00'),
('2024-02-21 9:00:00', '2024-02-21 17:00:00'), ('2024-02-22 9:00:00', '2024-02-22 17:00:00'), ('2024-02-23 9:00:00', '2024-02-23 17:00:00'),
('2024-02-26 9:00:00', '2024-02-26 17:00:00'), ('2024-02-27 9:00:00', '2024-02-27 17:00:00'), ('2024-02-28 9:00:00', '2024-02-28 17:00:00'),
('2024-02-29 9:00:00', '2024-02-29 17:00:00'),
--MARZO
('2024-03-01 9:00:00', '2024-03-01 17:00:00'), ('2024-03-04 9:00:00', '2024-03-04 17:00:00'),
('2024-03-05 9:00:00', '2024-03-05 17:00:00'), ('2024-03-06 9:00:00', '2024-03-06 17:00:00'), ('2024-03-07 9:00:00', '2024-03-07 17:00:00'),
('2024-03-08 9:00:00', '2024-03-08 17:00:00'), ('2024-03-11 9:00:00', '2024-03-11 17:00:00'), ('2024-03-12 9:00:00', '2024-03-12 17:00:00'),
('2024-03-13 9:00:00', '2024-03-13 17:00:00'), ('2024-03-14 9:00:00', '2024-03-14 17:00:00'), ('2024-03-15 9:00:00', '2024-03-15 17:00:00'),
('2024-03-18 9:00:00', '2024-03-18 17:00:00'), ('2024-03-19 9:00:00', '2024-03-19 17:00:00'), ('2024-03-20 9:00:00', '2024-03-20 17:00:00'),
('2024-03-21 9:00:00', '2024-03-21 17:00:00'), ('2024-03-22 9:00:00', '2024-03-22 17:00:00'), ('2024-03-25 9:00:00', '2024-03-25 17:00:00'),
('2024-03-26 9:00:00', '2024-03-26 17:00:00'), ('2024-03-27 9:00:00', '2024-03-27 17:00:00'), ('2024-03-28 9:00:00', '2024-03-28 17:00:00'),
('2024-03-29 9:00:00', '2024-03-29 17:00:00'),
--ABRIL
('2024-04-01 9:00:00', '2024-04-01 17:00:00'), ('2024-04-02 9:00:00', '2024-04-02 17:00:00'), ('2024-04-03 9:00:00', '2024-04-03 17:00:00'),('2024-04-04 9:00:00', '2024-04-04 17:00:00'), ('2024-04-05 9:00:00', '2024-04-05 17:00:00'), 
('2024-04-08 9:00:00', '2024-04-08 17:00:00'), ('2024-04-09 9:00:00', '2024-04-09 17:00:00'), ('2024-04-10 9:00:00', '2024-04-10 17:00:00'), ('2024-04-11 9:00:00', '2024-04-11 17:00:00'), ('2024-04-12 9:00:00', '2024-04-12 17:00:00'), 
('2024-04-15 9:00:00', '2024-04-15 17:00:00'), ('2024-04-16 9:00:00', '2024-04-16 17:00:00'), ('2024-04-17 9:00:00', '2024-04-17 17:00:00'), ('2024-04-18 9:00:00', '2024-04-18 17:00:00'), ('2024-04-19 9:00:00', '2024-04-19 17:00:00'), 
('2024-04-22 9:00:00', '2024-04-22 17:00:00'), ('2024-04-23 9:00:00', '2024-04-23 17:00:00'), ('2024-04-24 9:00:00', '2024-04-24 17:00:00'), ('2024-04-25 9:00:00', '2024-04-25 17:00:00'), ('2024-04-26 9:00:00', '2024-04-26 17:00:00'), 
('2024-04-27 9:00:00', '2024-04-27 17:00:00'), ('2024-04-28 9:00:00', '2024-04-28 17:00:00'),
('2024-04-29 9:00:00', '2024-04-29 17:00:00'), ('2024-04-30 9:00:00', '2024-04-30 17:00:00'),
--MAYO
('2024-05-01 9:00:00', '2024-05-01 17:00:00'), ('2024-05-02 9:00:00', '2024-05-02 17:00:00'), ('2024-05-03 9:00:00', '2024-05-03 17:00:00'),
('2024-05-06 9:00:00', '2024-05-06 17:00:00'), ('2024-05-07 9:00:00', '2024-05-07 17:00:00'), ('2024-05-08 9:00:00', '2024-05-08 17:00:00'), ('2024-05-09 9:00:00', '2024-05-09 17:00:00'), ('2024-05-10 9:00:00', '2024-05-10 17:00:00'), 
('2024-05-13 9:00:00', '2024-05-13 17:00:00'), ('2024-05-14 9:00:00', '2024-05-14 17:00:00'), ('2024-05-15 9:00:00', '2024-05-15 17:00:00'), ('2024-05-16 9:00:00', '2024-05-16 17:00:00'), ('2024-05-17 9:00:00', '2024-05-17 17:00:00'), 
('2024-05-20 9:00:00', '2024-05-20 17:00:00'), ('2024-05-21 9:00:00', '2024-05-21 17:00:00'), ('2024-05-22 9:00:00', '2024-05-22 17:00:00'), ('2024-05-23 9:00:00', '2024-05-23 17:00:00'), ('2024-05-24 9:00:00', '2024-05-24 17:00:00'),
('2024-05-27 9:00:00', '2024-05-27 17:00:00'), ('2024-05-28 9:00:00', '2024-05-28 17:00:00'), ('2024-05-29 9:00:00', '2024-05-29 17:00:00'), ('2024-05-30 9:00:00', '2024-05-30 17:00:00'), ('2024-05-31 9:00:00', '2024-05-31 17:00:00')
;

-- SI SE USA TABLA LOG HAY QUE ACOMODAR IDS DE TURNOS
--Inserciones en la tabla Log
--------------------------------100% asistencia
INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(1, 12) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(1, 61) AS idTurno
) AS Turno_laboral;

INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(18, 24) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(1, 61) AS idTurno
) AS Turno_laboral;

INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(32,35) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(1, 61) AS idTurno
) AS Turno_laboral;

-------------------------------mala asistencia
INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT 13 AS idEmpleado, idTurno
FROM generate_series(20, 50) AS idTurno;
----------------------------mala asistencia 2
INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(14, 15) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(25, 61) AS idTurno
)AS Mal_Turno ;

INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(25,31) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(25, 61) AS idTurno
)AS Mal_Turno ;

INSERT INTO RegistroAsistencia (Empleado_idEmpleado, TurnoLaboral_idTurnoLaboral)
SELECT idEmpleado, idTurno
FROM (
    SELECT *
    FROM generate_series(36,39) AS idEmpleado
) AS empleados
CROSS JOIN (
    SELECT *
    FROM generate_series(25, 61) AS idTurno
)AS Mal_Turno ;
*/

-- Inserciones en la tabla Compra
INSERT INTO Compra (monto,fk_id_sucursal) VALUES
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

--sucursal 3
;

-- Inserciones en la tabla DetalleCompra
INSERT INTO DetalleCompra (Compra_idCompra, Producto_idProducto, monto, cantidadUnitaria) VALUES
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

--sucursal 3

;

--Inserciones en la tabla Inventario
INSERT INTO Inventario (NombreInventario, CantidadInventario, fk_id_sucursal) VALUES
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

--sucursal 3

;

--Inserciones en la tabla StockInventario
INSERT INTO StockInventario (Inventario_idInventario,Compra_idCompra,Producto_idProducto) VALUES
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

--sucursal 3

;


-- Inserciones en la tabla Venta
INSERT INTO Venta (FechaVenta, MontoTotalVenta, MetodoPago, Cliente_idCliente, fk_id_sucursal) VALUES
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
--sucursal 2

--sucursal 3

;

-- Inserciones en la tabla Detalle de venta
INSERT INTO Detalleventa (CantidadUnitariaDetalleVenta, PrecioDetalleVenta, Venta_idVenta, Inventario_idInventario) VALUES
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
--sucursal 2

--sucursal 3

;

-- Inserciones en la tabla Costo
INSERT INTO Costo (NombreCosto, monto,fk_id_sucursal) VALUES
--sucursal 1
('Pago de productos- Reabastecimiento de inventario', 714304,1),
('Pago de sueldo a empleados', 81000,1),--ACTUALIZAR TOTAL
--sucursal 2
('Pago de productos- Reabastecimiento de inventario', 714304,1),
('Pago de sueldo a empleados', 81000,1),--ACTUALIZAR TOTAL
--sucursal 3
('Pago de productos- Reabastecimiento de inventario', 714304,1),
('Pago de sueldo a empleados', 81000,1)--ACTUALIZAR TOTAL
;

--REVISAR A VER SI SE NECESITA LA TABLA
-- Inserciones en la tabla DescGastos
INSERT INTO DescGastos (DescripcionCosto, Fecha, Empleado_idEmpleado, Compra_idCompra, Costo_idCosto) VALUES
--sucursal 1
('Reabastecimiento de Acetaminofen, Diclofenac Potasico e Ibuprofeno.', '2024-02-05', NULL, 1,1),
('Reabastecimiento de Atamel Forte y Atamel.', '2024-02-05', NULL, 2,1),
('Reabastecimiento de Apiret y Teragrip Forte Noche.', '2024-02-05', NULL, 3,1),
('Reabastecimiento de Migren, Dol Plus, Femmex Ultra.', '2024-02-05', NULL, 4,1),
('Reabastecimiento de Dencorub y Tiocolchicosido.', '2024-02-06', NULL, 5,1),
('Reabastecimiento de Festal y Liolactil.', '2024-02-06', NULL, 6,1),
('Reabastecimiento de Hexomedine.', '2024-02-06', NULL, 7,1),
('Reabastecimiento de Atamel Forte, Diclofenac Potasico, Femmex Ultra y Ibuprofeno.', '2024-03-06', NULL, 8,1),
('Reabastecimiento de Acetaminofen y Teragrip Forte Noche.', '2024-03-05', NULL, 9,1),
('Reabastecimiento de Apiret, Teragrip Forte Noche y Hexomedine.', '2024-03-06', NULL, 10,1),
('Reabastecimiento de Acetaminofen, Atamel Forte, Atamel y Ibuprofeno.', '2024-04-07', NULL, 11,1),
('Reabastecimiento de Diclofenac Potasico.', '2024-04-07', NULL, 12,1),
('Reabastecimiento de Diclofenac Potasico, Femmex Ultra e Ibuprofeno.', '2024-04-07', NULL, 13,1),
('Reabastecimiento de Tiocolchicosido y Teragrip Forte Noche.', '2024-04-07', NULL, 14,1),
('Reabastecimiento de Ibuprofeno y Festal.', '2024-04-07', NULL, 15,1)
-- Inserciones en la tabla DescGastos
INSERT INTO DescGastos (DescripcionCosto, Fecha, Empleado_idEmpleado, Compra_idCompra, Costo_idCosto) VALUES
('Pago semanal a empleados de seguridad', '2024-02-09', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-02-09', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-02-16', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-02-16', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-02-23', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-02-23', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-03-01', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-03-01', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-03-08', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-03-08', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-03-15', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-03-15', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-03-22', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-03-22', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-03-29', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-03-29', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-04-05', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-04-05', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-04-12', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-04-12', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-04-19', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-04-19', 5,NULL,NULL),
('Pago semanal a empleados de seguridad', '2024-04-26', 4,NULL,NULL), ('Pago semanal a empleados de seguridad', '2024-04-26', 5,NULL,NULL),
('Pago quincenal a supervisor', '2024-02-16', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-02-16', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-02-16', 7,NULL,NULL),
('Pago quincenal a supervisor', '2024-03-01', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-03-01', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-03-01', 7,NULL,NULL),
('Pago quincenal a supervisor', '2024-03-15', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-03-15', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-03-15', 7,NULL,NULL),
('Pago quincenal a supervisor', '2024-03-29', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-03-29', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-03-29', 7,NULL,NULL),
('Pago quincenal a supervisor', '2024-04-12', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-04-12', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-04-12', 7,NULL,NULL),
('Pago quincenal a supervisor', '2024-04-26', 1,NULL,NULL), ('Pago quincenal a supervisor', '2024-04-26', 6,NULL,NULL),  ('Pago quincenal a supervisor', '2024-04-26', 7,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-02-16', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-02-16', 3,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-03-01', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-03-01', 3,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-03-15', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-03-15', 3,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-03-29', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-03-29', 3,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-04-12', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-04-12', 3,NULL,NULL),
('Pago quincenal a empleado de almacen', '2024-04-26', 2,NULL,NULL), ('Pago quincenal a empleado de empleados de almacen', '2024-04-26', 3,NULL,NULL),
('Pago quincenal a cajero', '2024-02-16', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-02-16', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-02-16', 10,NULL,NULL),
('Pago quincenal a cajero', '2024-03-01', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-03-01', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-03-01', 10,NULL,NULL),
('Pago quincenal a cajero', '2024-03-15', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-03-15', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-03-15', 10,NULL,NULL),
('Pago quincenal a cajero', '2024-03-29', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-03-29', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-03-29', 10,NULL,NULL),
('Pago quincenal a cajero', '2024-04-12', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-04-12', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-04-12', 10,NULL,NULL),
('Pago quincenal a cajero', '2024-04-26', 8,NULL,NULL), ('Pago quincenal a cajero', '2024-04-26', 9,NULL,NULL),  ('Pago quincenal a cajero', '2024-04-26', 10,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-02-16', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-02-16', 12,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-03-01', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-03-01', 12,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-03-15', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-03-15', 12,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-03-29', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-03-29', 12,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-04-12', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-04-12', 12,NULL,NULL),
('Pago quincenal a encargado de limpieza', '2024-04-26', 11,NULL,NULL), ('Pago quincenal a encargado de limpieza', '2024-04-26', 12,NULL,NULL),
('Pago quincenal a gerente', '2024-02-16', 13,NULL,NULL),
('Pago quincenal a gerente', '2024-03-01', 13,NULL,NULL),
('Pago quincenal a gerente', '2024-03-15', 13,NULL,NULL),
('Pago quincenal a gerente', '2024-03-29', 13,NULL,NULL),
('Pago quincenal a gerente', '2024-04-12', 13,NULL,NULL),
('Pago quincenal a gerente', '2024-04-26', 13,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-02-16', 14,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-03-01', 14,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-03-15', 14,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-03-29', 14,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-04-12', 14,NULL,NULL),
('Pago quincenal a encargado de mercadeo', '2024-04-26', 14,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-02-16', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-02-16', 16,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-03-01', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-03-01', 16,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-03-15', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-03-15', 16,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-03-29', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-03-29', 16,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-04-12', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-04-12', 16,NULL,NULL),
('Pago quincenal a encargado de estantes', '2024-04-26', 15,NULL,NULL), ('Pago quincenal a encargado de estantes', '2024-04-26', 16,NULL,NULL);


*/