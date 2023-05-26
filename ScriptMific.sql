USE MIFIC_DATABASE

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
	UsuarioEdicion varchar (50) DEFAULT NULL, 
	FechaEdicion DATETIME DEFAULT NULL,
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


