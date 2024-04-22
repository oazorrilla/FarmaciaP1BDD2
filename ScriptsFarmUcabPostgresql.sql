

CREATE TABLE IF NOT EXISTS Venta (
  idVenta SERIAL PRIMARY KEY,
  FechaVenta DATE NOT NULL,
  HoraVenta TIME NOT NULL,
  TotalVenta FLOAT NOT NULL
);

-- Table Inventario
CREATE TABLE IF NOT EXISTS Inventario (
  idInventario SERIAL PRIMARY KEY,
  CantidadInventario FLOAT NOT NULL,
  FechaEntregaInventario VARCHAR(45) NOT NULL
);

-- Table Costo
CREATE TABLE IF NOT EXISTS Costo (
  idCosto SERIAL PRIMARY KEY,
  MontoCosto FLOAT NOT NULL,
  FechaCosto DATE NOT NULL,
  DescripcionCosto VARCHAR(100) NOT NULL
);

-- Table Producto
CREATE TABLE IF NOT EXISTS Producto (
  idProducto SERIAL PRIMARY KEY,
  NombProduct VARCHAR(45) NOT NULL,
  DescripcionProduct VARCHAR(100) NOT NULL,
  PrecioProduct FLOAT NOT NULL,
  StockProduct int NOT NULL,
  Inventario_idInventario INT NOT NULL,
  Costo_idCosto INT NOT NULL,
  FOREIGN KEY (Inventario_idInventario) REFERENCES Inventario(idInventario),
  FOREIGN KEY (Costo_idCosto) REFERENCES Costo(idCosto)
);

-- Table Detalle
CREATE TABLE IF NOT EXISTS Detalle (
  Venta_idVenta INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  FOREIGN KEY (Venta_idVenta) REFERENCES Venta(idVenta),
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto)
);

-- Table CategoriaProd
CREATE TABLE IF NOT EXISTS CategoriaProd (
  idCategoriaProd SERIAL PRIMARY KEY,
  NombCategoriaProd VARCHAR(45) NOT NULL,
  DescripcionCategoriaProd VARCHAR(100) NOT NULL,
  Producto_idProducto INT NOT NULL,
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto)
);

-- Table Cliente
CREATE TABLE IF NOT EXISTS Cliente (
  idCliente SERIAL PRIMARY KEY,
  PrimNombCliente VARCHAR(45) NOT NULL,
  SegNombCliente VARCHAR(45),
  PrimApellidoCliente VARCHAR(45) NOT NULL,
  SegApeliidoCliente VARCHAR(45),
  CICliente VARCHAR(45),
  FechaNacCliente DATE NOT NULL,
  Venta_idVenta INT NOT NULL,
  FOREIGN KEY (Venta_idVenta) REFERENCES Venta(idVenta)
);

-- Table Compra
CREATE TABLE IF NOT EXISTS Compra (
  idCompra SERIAL PRIMARY KEY,
  FechaCompra DATE NOT NULL,
  MontoTotalCompra FLOAT NOT NULL,
  MetodoPago VARCHAR(45) NOT NULL,
  Cliente_idCliente INT NOT NULL,
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Table Tendencia
CREATE TABLE IF NOT EXISTS Tendencia (
  idTendencia SERIAL PRIMARY KEY,
  FechaInicioTendencia DATE NOT NULL,
  FechaFinTendencia DATE,
  DescripcionTendencia VARCHAR(100),
  TipoTendencia VARCHAR(45),
  Cliente_idCliente INT NOT NULL,
  FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- Table DetalleCompra
CREATE TABLE IF NOT EXISTS DetalleCompra (
  idDetalleCompra SERIAL PRIMARY KEY,
  CantidadDetalleCompra INT NOT NULL,
  PrecioDetalleCompra FLOAT NOT NULL,
  MontoTotalDetalleCompra FLOAT NOT NULL,
  Compra_idCompra INT NOT NULL,
  Producto_idProducto INT NOT NULL,
  FOREIGN KEY (Compra_idCompra) REFERENCES Compra(idCompra),
  FOREIGN KEY (Producto_idProducto) REFERENCES Producto(idProducto)
);

-- Table GastoOperativo
CREATE TABLE IF NOT EXISTS GastoOperativo (
  idGastoOperativo SERIAL PRIMARY KEY,
  FechaGastoOperativo DATE NOT NULL,
  DescripcionGastoOperativo VARCHAR(100) NOT NULL,
  MontoGastoOperativo FLOAT NOT NULL,
  Costo_idCosto INT NOT NULL,
  FOREIGN KEY (Costo_idCosto) REFERENCES Costo(idCosto)
);

-- Table Empleado
CREATE TABLE IF NOT EXISTS Empleado (
  idEmpleado SERIAL PRIMARY KEY,
  PrimNombEmpleado VARCHAR(45) NOT NULL,
  SegNombEmpleado VARCHAR(45),
  PrimApellidoEmpleado VARCHAR(45) NOT NULL,
  CIEmpleado VARCHAR(45) NOT NULL,
  FechaEmpleado DATE NOT NULL
);

-- Table Ausentismo
CREATE TABLE IF NOT EXISTS Ausentismo (
  idAusentismo SERIAL PRIMARY KEY,
  FechaInicioAusentismo DATE NOT NULL,
  FechaFinAusentismo DATE,
  DescripcionAusentismo VARCHAR(100),
  TipoAusencia VARCHAR(45) NOT NULL,
  DuracionAusentismos VARCHAR(45) NOT NULL,
  Empleado_idEmpleado INT NOT NULL,
  FOREIGN KEY (Empleado_idEmpleado) REFERENCES Empleado(idEmpleado)
);

-- Table Productividad
CREATE TABLE IF NOT EXISTS Productividad (
  idProductividad SERIAL PRIMARY KEY,
  FechaInicioProductividad DATE NOT NULL,
  FechaFinProductividad DATE,
  DescripcionProductividad VARCHAR(100),
  Empleado_idEmpleado INT NOT NULL,
  FOREIGN KEY (Empleado_idEmpleado) REFERENCES Empleado(idEmpleado)
);
---------------------------------------------- Alter table de los check -------------------------------------------------------------------
ALTER TABLE Compra
ADD CONSTRAINT CHK_MetodoPago
CHECK (MetodoPago IN ('Tarjeta de crédito', 'Transferencia bancaria', 'Efectivo'));

ALTER TABLE Producto
ADD CONSTRAINT CHK_StockProduct
CHECK (StockProduct >= 0);

ALTER TABLE Ausentismo
ADD CONSTRAINT CHK_TipoAusencia
CHECK (TipoAusencia IN ('Vacaciones', 'Enfermedad', 'Permiso sin goce de sueldo', 'Otro'));
------------------------------------Insert-----------------------------------------------------------------------------------

-- Inserciones en la tabla Venta
INSERT INTO Venta (FechaVenta, HoraVenta, TotalVenta) VALUES ('2024-04-11', '15:45:00', 200.75);
INSERT INTO Venta (FechaVenta, HoraVenta, TotalVenta) VALUES ('2024-04-12', '12:30:00', 350.00);

-- Inserciones en la tabla Inventario
INSERT INTO Inventario (CantidadInventario, FechaEntregaInventario) VALUES (150, '2024-04-11');
INSERT INTO Inventario (CantidadInventario, FechaEntregaInventario) VALUES (200, '2024-04-12');

-- Inserciones en la tabla Costo
INSERT INTO Costo (MontoCosto, FechaCosto, DescripcionCosto) VALUES (300.50, '2024-04-11', 'Compra de nuevos medicamentos');
INSERT INTO Costo (MontoCosto, FechaCosto, DescripcionCosto) VALUES (450.25, '2024-04-12', 'Inversión en equipo médico');

-- Inserciones en la tabla Producto
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProduct, StockProduct, Inventario_idInventario, Costo_idCosto) VALUES ('Amoxicilina', 'Antibiótico de amplio espectro', 7.99, 100, 2, 1);
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProduct, StockProduct, Inventario_idInventario, Costo_idCosto) VALUES ('Ibuprofeno', 'Analgésico y antiinflamatorio no esteroideo', 3.50, 120, 2, 2);

-- Inserciones en la tabla Detalle
INSERT INTO Detalle (Venta_idVenta, Producto_idProducto) VALUES (1, 1);
INSERT INTO Detalle (Venta_idVenta, Producto_idProducto) VALUES (2, 2);

-- Inserciones en la tabla CategoriaProd
INSERT INTO CategoriaProd (NombCategoriaProd, DescripcionCategoriaProd, Producto_idProducto) VALUES ('Antibióticos', 'Medicamentos infecciones bacterianas', 1);
INSERT INTO CategoriaProd (NombCategoriaProd, DescripcionCategoriaProd, Producto_idProducto) VALUES ('Analgésicos', 'Medicamentos que alivia el dolor', 2);

-- Inserciones en la tabla Cliente
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, Venta_idVenta) VALUES ('Luis', 'Alberto', 'Martínez', 'Pérez', '987654321', '1975-05-15', 1);
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, Venta_idVenta) VALUES ('Ana', NULL, 'González', 'López', '876543210', '1982-08-20', 2);

-- Inserciones en la tabla Compra
INSERT INTO Compra (FechaCompra, MontoTotalCompra, MetodoPago, Cliente_idCliente) VALUES ('2024-04-11', 100.25, 'Tarjeta de crédito', 1);
INSERT INTO Compra (FechaCompra, MontoTotalCompra, MetodoPago, Cliente_idCliente) VALUES ('2024-04-12', 150.00, 'Transferencia bancaria', 2);

-- Inserciones en la tabla Tendencia
INSERT INTO Tendencia (FechaInicioTendencia, FechaFinTendencia, DescripcionTendencia, TipoTendencia, Cliente_idCliente) VALUES ('2024-04-11', '2024-04-20', 'Descuento especial en productos seleccionados', 'Promoción', 1);
INSERT INTO Tendencia (FechaInicioTendencia, FechaFinTendencia, DescripcionTendencia, TipoTendencia, Cliente_idCliente) VALUES ('2024-04-12', '2024-04-15', 'Charla sobre cuidado de la piel', 'Evento', 2);

-- Inserciones en la tabla DetalleCompra
INSERT INTO DetalleCompra (CantidadDetalleCompra, PrecioDetalleCompra, MontoTotalDetalleCompra, Compra_idCompra, Producto_idProducto) VALUES (3, 7.50, 22.50, 1, 1);
INSERT INTO DetalleCompra (CantidadDetalleCompra, PrecioDetalleCompra, MontoTotalDetalleCompra, Compra_idCompra, Producto_idProducto) VALUES (2, 3.50, 7.00, 2, 2);

-- Inserciones en la tabla Venta
INSERT INTO Venta (FechaVenta, HoraVenta, TotalVenta) VALUES ('2024-04-10', '14:30:00', 150.50);

-- Inserciones en la tabla Inventario
INSERT INTO Inventario (CantidadInventario, FechaEntregaInventario) VALUES (100, '2024-04-10');

-- Inserciones en la tabla Costo
INSERT INTO Costo (MontoCosto, FechaCosto, DescripcionCosto) VALUES (200.75, '2024-04-10', 'Costo de adquisición de medicamentos');

-- Inserciones en la tabla Producto
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProduct, StockProduct, Inventario_idInventario, Costo_idCosto) VALUES ('Paracetamol', 'Analgesico para el dolor leve', 5.99, 50, 1, 1);

-- Inserciones en la tabla Detalle
INSERT INTO Detalle (Venta_idVenta, Producto_idProducto) VALUES (1, 1);

-- Inserciones en la tabla CategoriaProd
INSERT INTO CategoriaProd (NombCategoriaProd, DescripcionCategoriaProd, Producto_idProducto) VALUES ('Medicamentos', 'Productos farmacéuticos', 1);

-- Inserciones en la tabla Cliente
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, Venta_idVenta) VALUES ('María', 'José', 'Rodríguez', 'González', '123456789', '1980-01-01', 1);

-- Inserciones en la tabla Compra
INSERT INTO Compra (FechaCompra, MontoTotalCompra, MetodoPago, Cliente_idCliente) VALUES ('2024-04-10', 500.25, 'Efectivo', 1);

-- Inserciones en la tabla Tendencia
INSERT INTO Tendencia (FechaInicioTendencia, FechaFinTendencia, DescripcionTendencia, TipoTendencia, Cliente_idCliente) VALUES ('2024-04-10', '2024-04-20', 'Oferta en medicamentos', 'Promoción', 1);

-- Inserciones en la tabla DetalleCompra
INSERT INTO DetalleCompra (CantidadDetalleCompra, PrecioDetalleCompra, MontoTotalDetalleCompra, Compra_idCompra, Producto_idProducto) VALUES (2, 10.99, 21.98, 1, 1);

-- Inserciones en la tabla GastoOperativo
INSERT INTO GastoOperativo (FechaGasyoOperativo, DescripcionGastoOperativo, MontoGastoOperativo, Costo_idCosto) VALUES ('2024-04-10', 'Gasto en publicidad', 100.50, 1);

-- Inserciones en la tabla Empleado
INSERT INTO Empleado (PrimNombEmpleado, SegNombEmpleado, PrimApellidoEmpleado, CIEmpleado, FechaEmpleado) VALUES ('Juan', 'Carlos', 'Pérez', '987654321', '1990-01-01');

-- Inserciones en la tabla Ausentismo
INSERT INTO Ausentismo (FechaInicioAusentismo, FechaFinAusentismo, DescripcionAusentismo, TipoAusencia, DuracionAusentismos, Empleado_idEmpleado) VALUES ('2024-04-10', '2024-04-11', 'Licencia por enfermedad', 'Enfermedad', '2 días', 1);

-- Inserciones en la tabla Productividad
INSERT INTO Productividad (FechaInicioProductividad, FechaFinProductividad, DescripcionProductividad, Empleado_idEmpleado) VALUES ('2024-04-10', '2024-04-12', 'Alcanzó los objetivos del mes', 1);
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Inserciones en la tabla Venta
INSERT INTO Venta (FechaVenta, HoraVenta, TotalVenta) VALUES ('2024-04-13', '14:20:00', 180.45);
INSERT INTO Venta (FechaVenta, HoraVenta, TotalVenta) VALUES ('2024-04-14', '10:15:00', 250.80);

-- Inserciones en la tabla Inventario
INSERT INTO Inventario (CantidadInventario, FechaEntregaInventario) VALUES (180, '2024-04-13');
INSERT INTO Inventario (CantidadInventario, FechaEntregaInventario) VALUES (220, '2024-04-14');

-- Inserciones en la tabla Costo
INSERT INTO Costo (MontoCosto, FechaCosto, DescripcionCosto) VALUES (280.30, '2024-04-13', 'Compra de material de curación');
INSERT INTO Costo (MontoCosto, FechaCosto, DescripcionCosto) VALUES (400.60, '2024-04-14', 'Adquisición de medicamentos para resfriado');

-- Inserciones en la tabla Producto
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProduct, StockProduct, Inventario_idInventario, Costo_idCosto) VALUES ('Paracetamol', 'Analgésico y antipirético', 5.99, 150, 3, 3);
INSERT INTO Producto (NombProduct, DescripcionProduct, PrecioProduct, StockProduct, Inventario_idInventario, Costo_idCosto) VALUES ('Omeprazol', 'Inhibidor de la bomba de protones', 8.50, 200, 4, 4);

-- Inserciones en la tabla Detalle
INSERT INTO Detalle (Venta_idVenta, Producto_idProducto) VALUES (3, 3);
INSERT INTO Detalle (Venta_idVenta, Producto_idProducto) VALUES (4, 4);

-- Inserciones en la tabla CategoriaProd
INSERT INTO CategoriaProd (NombCategoriaProd, DescripcionCategoriaProd, Producto_idProducto) VALUES ('Analgésicos', 'Medicamentos para aliviar el dolor', 3);
INSERT INTO CategoriaProd (NombCategoriaProd, DescripcionCategoriaProd, Producto_idProducto) VALUES ('Antiácidos', 'Medicamentos para tratar la acidez estomacal', 4);

-- Inserciones en la tabla Cliente
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, Venta_idVenta) VALUES ('María', 'Isabel', 'Rodríguez', 'Sánchez', '765432109', '1980-03-25', 3);
INSERT INTO Cliente (PrimNombCliente, SegNombCliente, PrimApellidoCliente, SegApeliidoCliente, CICliente, FechaNacCliente, Venta_idVenta) VALUES ('Carlos', NULL, 'García', 'Pérez', '654321098', '1978-06-10', 4);

-- Inserciones en la tabla Compra
INSERT INTO Compra (FechaCompra, MontoTotalCompra, MetodoPago, Cliente_idCliente) VALUES ('2024-04-13', 120.75, 'Efectivo', 3);
INSERT INTO Compra (FechaCompra, MontoTotalCompra, MetodoPago, Cliente_idCliente) VALUES ('2024-04-14', 200.00, 'Tarjeta de crédito', 4);

-- Inserciones en la tabla Tendencia
INSERT INTO Tendencia (FechaInicioTendencia, FechaFinTendencia, DescripcionTendencia, TipoTendencia, Cliente_idCliente) VALUES ('2024-04-13', '2024-04-20', 'Oferta especial en productos de higiene personal', 'Promoción', 3);
INSERT INTO Tendencia (FechaInicioTendencia, FechaFinTendencia, DescripcionTendencia, TipoTendencia, Cliente_idCliente) VALUES ('2024-04-14', '2024-04-16', 'Charla sobre prevención de enfermedades cardiovasculares', 'Evento', 4);

-- Inserciones en la tabla DetalleCompra
INSERT INTO DetalleCompra (CantidadDetalleCompra, PrecioDetalleCompra, MontoTotalDetalleCompra, Compra_idCompra, Producto_idProducto) VALUES (2, 5.99, 11.98, 5, 3);
INSERT INTO DetalleCompra (CantidadDetalleCompra, PrecioDetalleCompra, MontoTotalDetalleCompra, Compra_idCompra, Producto_idProducto) VALUES (3, 8.50, 25.50, 6, 4);

-- Inserciones en la tabla GastoOperativo
INSERT INTO GastoOperativo (FechaGasyoOperativo, DescripcionGastoOperativo, MontoGastoOperativo, Costo_idCosto) VALUES ('2024-04-13', 'Compra de material de limpieza', 50.25, 3);
INSERT INTO GastoOperativo (FechaGasyoOperativo, DescripcionGastoOperativo, MontoGastoOperativo, Costo_idCosto) VALUES ('2024-04-14', 'Pago de servicios públicos', 80.60, 4);

-- Inserciones en la tabla Empleado
INSERT INTO Empleado (PrimNombEmpleado, SegNombEmpleado, PrimApellidoEmpleado, CIEmpleado, FechaEmpleado) VALUES ('Juan', 'Carlos', 'López', '12345678', '1990-07-15');
INSERT INTO Empleado (PrimNombEmpleado, SegNombEmpleado, PrimApellidoEmpleado, CIEmpleado, FechaEmpleado) VALUES ('Ana', 'María', 'Gómez', '87654321', '1988-05-20');

-- Inserciones en la tabla Ausentismo
INSERT INTO Ausentismo (FechaInicioAusentismo, FechaFinAusentismo, DescripcionAusentismo, TipoAusencia, DuracionAusentismos, Empleado_idEmpleado) VALUES ('2024-04-13', '2024-04-15', 'Licencia médica por gripe', 'Enfermedad', '3 días', 5);
INSERT INTO Ausentismo (FechaInicioAusentismo, FechaFinAusentismo, DescripcionAusentismo, TipoAusencia, DuracionAusentismos, Empleado_idEmpleado) VALUES ('2024-04-14', '2024-04-14', 'Permiso por asuntos personales', 'Permiso sin goce de sueldo', '1 día', 6);

-- Inserciones en la tabla Productividad
INSERT INTO Productividad (FechaInicioProductividad, FechaFinProductividad, DescripcionProductividad, Empleado_idEmpleado) VALUES ('2024-04-13', '2024-04-13', 'Desarrollo de nuevas estrategias de marketing', 5);
INSERT INTO Productividad (FechaInicioProductividad, FechaFinProductividad, DescripcionProductividad, Empleado_idEmpleado) VALUES ('2024-04-14', '2024-04-14', 'Capacitación sobre manejo de inventario', 6);
