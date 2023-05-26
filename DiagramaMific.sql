CREATE DATABASE Mificfinal

USE Mificfinal

CREATE SCHEMA perfil;

CREATE SCHEMA archivo

CREATE TABLE perfil.Entidad	(
	IdEntidad int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	NombreEntidad varchar(30) NOT NULL UNIQUE, 
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL
)
GO


CREATE TRIGGER trg_UpdateEntidad
ON perfil.Entidad -- Replace with your table name
AFTER UPDATE
AS
BEGIN
    -- Update the UsuarioEdicion and FechaEdicion columns for each updated row
    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM perfil.Entidad t -- Replace with your table name
    JOIN inserted i ON i.IdEntidad = t.IdEntidad -- Replace with your primary key column
END

CREATE TABLE perfil.Usuario(
	IdUsuario int PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	IdEntidad int not null,
	IdRol INT NOT NULL, 
	NombreCompleto varchar(50) NOT NULL, 
	Usuario varchar(50) NOT NULL UNIQUE, 
	Contraseña varbinary(32) NOT NULL, 
	Estado bit NOT NULL,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL

	CONSTRAINT fk_Id_Entidad FOREIGN KEY (IdEntidad) REFERENCES perfil.Entidad (IdEntidad) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_Id_Rol FOREIGN KEY (IdRol) REFERENCES perfil.Rol (IdRol) ON DELETE NO ACTION ON UPDATE NO ACTION 
)
GO 

CREATE TRIGGER trg_UpdateUsuario
ON perfil.Usuario -- Replace with your table name
AFTER UPDATE
AS
BEGIN
    -- Update the UsuarioEdicion and FechaEdicion columns for each updated row
    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM perfil.Usuario t -- Replace with your table name
    JOIN inserted i ON i.IdUsuario = t.IdUsuario -- Replace with your primary key column
END


CREATE TABLE perfil.Rol (
	IdRol INT PRIMARY KEY IDENTITY (1,1) NOT NULL, 
	NombreRol VARCHAR(50) NOT NULL UNIQUE, 
	Estado BIT DEFAULT 0, 
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT HOST_NAME(), 
	FechaEdicion DATETIME DEFAULT GETDATE(),
)
GO

CREATE TRIGGER trg_UpdateRol
ON perfil.Rol 
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM perfil.Rol t 
    JOIN inserted i ON i.IdRol = t.IdRol 
END

CREATE TABLE perfil.RegistroUsuario(
	IdRegistro int PRIMARY KEY IDENTITY(1,1) NOT NULL,
	IdUsuario int NOT NULL, 
	IdDocumento int NOT NULL, 
	IdReporte int NOT NULL,
	NombreRegistro varchar(30) NOT NULL, 
	FechaIngreso DateTime  NOT NULL DEFAULT current_timestamp,
	FechaSalida	Datetime2  NOT NULL DEFAULT current_timestamp,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
	CONSTRAINT fk_id_reporte FOREIGN KEY (IdReporte) REFERENCES perfil.Reporte (IdReporte) ON DELETE NO ACTION ON UPDATE NO ACTION, 
	CONSTRAINT fk_id_usuario FOREIGN KEY (IdUsuario) REFERENCES perfil.Usuario(IdUsuario) ON DELETE NO ACTION ON UPDATE NO ACTION ,
	CONSTRAINT fk_id_documento FOREIGN KEY (IdDocumento) REFERENCES archivo.Documento (IdDocumento) ON DELETE CASCADE ON UPDATE CASCADE

)
GO 

CREATE TRIGGER trg_UpdateRegistroUsuario
ON perfil.RegistroUsuario
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.RegistroUsuario t 
    JOIN inserted i ON i.IdRegistro = t.IdRegistro
END


CREATE TABLE perfil.Reporte(
	IdReporte INT PRIMARY KEY IDENTITY (1,1) NOT NULL, 
	IdDocumento INT NOT NULL,
	IdDocHistorial INT NOT NULL,
	NombreReporte VARCHAR(50) NOT NULL,
	FechaReporte DATETIME DEFAULT GETDATE(),
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
	CONSTRAINT ck_idusuario FOREIGN KEY (IdDocumento) REFERENCES archivo.Documento(IdDocumento),
	CONSTRAINT ck_idDocHistorial FOREIGN KEY (IdDocHistorial) REFERENCES archivo.DocumentoHistorial(IdDocHistorial) ON DELETE CASCADE ON UPDATE CASCADE
)
GO


CREATE TRIGGER trg_UpdateReporte
ON perfil.Reporte 
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM perfil.Reporte t 
    JOIN inserted i ON i.IdReporte = t.IdReporte 
END

CREATE TABLE archivo.Categoria
(
	IdCategoria INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	NombreCategoria VARCHAR(50) not NULL UNIQUE,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL
)
GO

CREATE TRIGGER trg_UpdateCategoria
ON archivo.Categoria 
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.Categoria t 
    JOIN inserted i ON i.IdCategoria = t.IdCategoria
END

CREATE TABLE archivo.Documento(
	IdDocumento INT PRIMARY KEY IDENTITY(1,1) NOT NULL, 
	IdCategoria INT NOT NULL,
	NombreDocumento varchar(50) not null, 
	Extension varchar(30) NOT NULL, 
	FechaSubida DATETIME DEFAULT GETDATE(),
	FechaExpiracion DATETIME NOT NULL, 
	NivelSeguridad INT NOT NULL, 
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL
	CONSTRAINT fk_id_Categoria FOREIGN KEY (idCategoria) REFERENCES archivo.Categoria (IdCategoria) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

CREATE TRIGGER trg_UpdateDocumento
ON archivo.Documento
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.Documento t 
    JOIN inserted i ON i.IdDocumento = t.IdDocumento
END


CREATE TABLE archivo.Permisos(
	IdPermiso INT PRIMARY KEY IDENTITY (1,1),
	IdRol INT NOT NULL, 
	Leer bit NOT NULL,
	Copiar bit NOT NULL,
	Descargar bit NOT NULL,
	Imprimir bit NOT NULL,
	DejarCompartir bit NOT NULL,
	Comentar bit NOT NULL,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
	CONSTRAINT fk_IdRole FOREIGN KEY (IdRol) REFERENCES perfil.Rol (IdRol) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

CREATE TRIGGER trg_UpdatePermisos
ON archivo.Permisos
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.Permisos t 
    JOIN inserted i ON i.IdPermiso = t.IdPermiso
END

CREATE TRIGGER InsertedRole
ON perfil.Rol
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO archivo.Permisos (IdRol, Leer, Copiar, Descargar, Imprimir, DejarCompartir, Comentar)
    SELECT IdRol,
        CASE
            WHEN NombreRol = 'Administrador' OR NombreRol = 'Basico' OR NombreRol = 'Intermedio' OR NombreRol = 'Avanzado' THEN 1
            ELSE 0
        END,
        CASE
            WHEN NombreRol = 'Administrador' OR NombreRol = 'Intermedio' OR NombreRol = 'Avanzado' THEN 1
            ELSE 0
        END,
        CASE
            WHEN NombreRol = 'Administrador' OR NombreRol = 'Avanzado' THEN 1
            ELSE 0
        END,
        CASE
            WHEN NombreRol = 'Administrador' THEN 1
            ELSE 0
        END,
        CASE
            WHEN NombreRol = 'Administrador' THEN 1
            ELSE 0
        END,
        CASE
            WHEN NombreRol = 'Administrador' THEN 1
            ELSE 0
        END
    FROM inserted;
END
GO


CREATE TABLE archivo.DocumentoProgramar(
	IdDocProgramar INT PRIMARY KEY IDENTITY (1,1),
	IdDocumento INT NOT NULL, 
	FechaSubida DATETIME DEFAULT GETDATE(), 
	FechaExpiracion DATETIME NOT NULL,
	TiempoRestante INT NOT NULL,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
	CONSTRAINT fk_Id_Documento FOREIGN KEY (IdDocumento) REFERENCES archivo.Documento (IdDocumento) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT CK_Fecha_Expira CHECK (TiempoRestante >=0 ) 

)
GO 

CREATE TRIGGER trg_UpdateDocumentoProgramar
ON archivo.DocumentoProgramar
AFTER UPDATE
AS
BEGIN
    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.DocumentoProgramar t 
    JOIN inserted i ON i.IdDocProgramar = t.IdDocProgramar
END


CREATE TRIGGER trg_ProgramarDocumento
ON archivo.documento
AFTER INSERT, UPDATE
AS 
BEGIN 
	IF EXISTS (SELECT * FROM INSERTED)
	BEGIN 
		DECLARE @IdDocumento INT, @FechaSubida DATETIME, @FechaExpiracion DATETIME, @TiempoRestante INT
		
		SELECT @IdDocumento = IdDocumento, @FechaSubida = FechaSubida, @FechaExpiracion = FechaExpiracion
		FROM INSERTED

		SET @TiempoRestante = CAST( DATEDIFF (DAY, GETDATE(), @FechaExpiracion) AS INT)


		INSERT INTO archivo.DocumentoProgramar (IdDocumento, FechaExpiracion, TiempoRestante)
		VALUES (@IdDocumento, @FechaExpiracion, @TiempoRestante)
	END
END 

CREATE TABLE archivo.DocumentoHistorial(
	IdDocHistorial INT PRIMARY KEY IDENTITY (1,1), 
	IdDocumento INT NOT NULL, 
	FechaCambio DATETIME NOT NULL, 
	TipoCambio VARCHAR(50) NOT NULL, 
	UsuarioCambio VARCHAR (50) NOT NULL,
	UsuarioCreacion varchar(50) DEFAULT HOST_NAME(), 
	FechaCreacion DATETIME DEFAULT GETDATE(),
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
)
GO

CREATE TRIGGER trg_UpdateDocumentoHistorial
ON archivo.DocumentoHistorial
AFTER UPDATE
AS
BEGIN

    UPDATE t
    SET UsuarioEdicion = HOST_NAME(), FechaEdicion = GETDATE()
    FROM archivo.DocumentoHistorial t 
    JOIN inserted i ON i.IdDocHistorial = t.IdDocHistorial
END


CREATE TRIGGER trg_CambiosDocumentos
ON archivo.Documento
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
   DECLARE @TipoCambio VARCHAR(50)

   IF EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
      SET @TipoCambio = 'Modificado'
   ELSE IF EXISTS(SELECT * FROM inserted)
      SET @TipoCambio = 'Creado'
   ELSE IF EXISTS(SELECT * FROM deleted)
      SET @TipoCambio = 'Eliminado'

   IF @TipoCambio IS NOT NULL
   BEGIN
      INSERT INTO archivo.DocumentoHistorial (IdDocumento, FechaCambio, TipoCambio, UsuarioCambio)
      SELECT 
         COALESCE(i.IdDocumento, d.IdDocumento) AS IdDocumento,
         GETDATE() AS FechaCambio,
         @TipoCambio AS TipoCambio,
         HOST_NAME() AS UsuarioCambio
      FROM inserted i
      FULL OUTER JOIN deleted d ON i.IdDocumento = d.IdDocumento
   END
END


SELECT * FROM archivo.Categoria
SELECT * FROM archivo.Documento
SELECT * FROM archivo.DocumentoHistorial
SELECT * FROM archivo.DocumentoProgramar
SELECT * FROM archivo.Permisos
SELECT * FROM perfil.Entidad
SELECT * FROM perfil.RegistroUsuario
SELECT * FROM perfil.Reporte
SELECT * FROM perfil.Rol
SELECT * FROM perfil.Usuario

INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (1, 'Documento1', 'pdf','2023-10-01',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (2, 'Documento2', 'pdf','2023-10-02',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (3, 'Documento3', 'pdf','2023-10-03',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (4, 'Documento4', 'pdf','2023-10-04',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (5, 'Documento5', 'pdf','2023-10-05',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (6, 'Documento6', 'pdf','2023-10-06',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (7, 'Documento7', 'pdf','2023-10-07',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (8, 'Documento8', 'pdf','2023-10-08',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (9, 'Documento9', 'pdf','2023-10-09',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (10, 'Documento10', 'pdf','2023-10-10',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (11, 'Documento11', 'pdf','2023-10-11',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (12, 'Documento12', 'pdf','2023-10-12',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (13, 'Documento13', 'pdf','2023-10-13',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (14, 'Documento14', 'pdf','2023-10-14',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (15, 'Documento15', 'pdf','2023-10-15',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (16, 'Documento16', 'pdf','2023-10-16',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (17, 'Documento17', 'pdf','2023-10-17',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (18, 'Documento18', 'pdf','2023-10-18',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (19, 'Documento19', 'pdf','2023-10-19',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (20, 'Documento20', 'pdf','2023-10-20',1)
INSERT INTO archivo.Categoria (NombreCategoria) Values ('Politica')
INSERT INTO archivo.Categoria (NombreCategoria) Values ('Educacion')
INSERT INTO archivo.Categoria (NombreCategoria) Values ('Ambiental')
INSERT INTO archivo.Categoria (NombreCategoria) Values ('Social')
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Instrumentos musicales');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Salud');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Fotografía');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Herramientas');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Computación');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Muebles');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Oficina');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Electrónica');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Hogar');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Deportes');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Moda');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Alimentación');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Juguetes');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Belleza');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Mascotas');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Libros');
INSERT INTO archivo.Categoria (NombreCategoria) VALUES ('Automóvil');

INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (1, 'Acuerdos Internacionales', 'pdf','2028-05-26',1)
INSERT INTO archivo.Documento (IdCategoria, NombreDocumento, Extension,FechaExpiracion, NivelSeguridad) VALUES (2, 'Educacion vial', 'pdf','2028-05-26',1)

INSERT INTO perfil.Entidad (NombreEntidad) Values ('INATEC')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('MINSA')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('INETER')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('MEFCCA')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UAM')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('MIFIC')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UCA')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UdeM')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('ENACAL')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('DISNORTE')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('DISSUR')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('ENEL')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UNAN')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UNI')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UNICIT')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UNICA')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('KEISER')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UCEM')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('UPOLI')
INSERT INTO perfil.Entidad (NombreEntidad) Values ('CSE')

SELECT * FROM archivo.Documento


INSERT INTO perfil.Entidad (NombreEntidad) Values ('INATEC')

INSERT INTO perfil.rol (NombreRol, Estado) VALUES ('Administrador', 1)
INSERT INTO perfil.rol (NombreRol, Estado) VALUES ('Basico', 1)
INSERT INTO perfil.rol (NombreRol, Estado) VALUES ('Intermedio', 1)
INSERT INTO perfil.rol (NombreRol, Estado) VALUES ('Avanzado', 1)

INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Carlos Hurtado', 'lapuerca', 15623, 1)
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'Gabriel Muñoz', 'Viniciussomostodos', 553597, 1)


INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (1,1, 'Reporte1')
select *from perfil.Reporte 

INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES ( 1, 1, 1, 'Registro 1')


INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Carlos Hurtado', 'lapuerca', 15623, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'María López', 'marialo', 98765, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 3, 'Juan Martínez', 'juanmar', 54321, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 4, 'Ana Rodríguez', 'anaro', 24680, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Luisa Gómez', 'luisago', 13579, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'Pedro Sánchez', 'pedrosa', 80246, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 3, 'Laura Jiménez', 'lauraji', 64738, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 4, 'Miguel Torres', 'migueltor', 15937, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Isabel Ortega', 'isabelor', 37491, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'Ricardo Vargas', 'ricardova', 72645, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 3, 'Sofía Medina', 'sofiame', 98364, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 4, 'Eduardo Fernández', 'eduardofe', 31578, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Patricia Ríos', 'patriciar', 48673, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'Gabriel Silva', 'gabrielsi', 92764, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 3, 'Carolina Montes', 'carolinam', 27465, 1);


INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 4, 'Andrés Castro', 'andresca', 71854, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 1, 'Gabriela Ramírez', 'gabrielara', 82439, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 2, 'Fernando Morales', 'fernandomo', 59683, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (1, 3, 'Paulina Cruz', 'paulinacru', 42190, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 4, 'Roberto Guzmán', 'robertogu', 10372, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 1, 'Valeria Ortiz', 'valeriaor', 63819, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 2, 'Javier Paredes', 'javierpa', 29178, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 3, 'Natalia Silva', 'nataliasi', 75692, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 4, 'Sebastián Rojas', 'sebastianro', 42875, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 1, 'Alejandra Núñez', 'alejandrann', 92137, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 2, 'Daniel Torres', 'danieltor', 17396, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 3, 'Carmen Morales', 'carmenmo', 59824, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 4, 'Gustavo Castro', 'gustavoca', 26417, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (2, 1, 'Marcela Gómez', 'marcelago', 75193, 1);
INSERT INTO perfil.Usuario (IdEntidad, IdRol, NombreCompleto, Usuario, Contraseña, Estado) VALUES (3, 2, 'Raúl Medina', 'raulme', 49218, 1);

INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (2, 1, 2, 'Registro 2');
INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (4, 1, 3, 'Registro 3');
INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (5, 1, 3, 'Registro 3');
INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (6, 2, 4, 'Registro 3');
INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (7, 3, 5, 'Registro 3');
INSERT INTO perfil.RegistroUsuario (IdUsuario, IdDocumento, IdReporte, NombreRegistro) VALUES (8, 4, 6, 'Registro 3');



INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (1,1, 'Reporte1')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (2,2, 'Reporte2')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (3,3, 'Reporte3')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (4,4, 'Reporte4')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (5,5, 'Reporte5')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (6,6, 'Reporte6')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (7,7, 'Reporte7')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (8,8, 'Reporte8')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (45,9, 'Reporte9')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (46,10, 'Reporte10')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (47,11, 'Reporte11')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (48,12, 'Reporte12')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (49,13, 'Reporte13')
INSERT INTO perfil.Reporte (IdDocumento, IdDocHistorial, NombreReporte) VALUES (50,14, 'Reporte6')







