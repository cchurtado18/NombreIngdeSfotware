create database MificPrueba
use [MificPrueba]

CREATE TABLE [UserLog]
(
	[idUsuario] varchar(50) NULL,
	[name] varchar(50) NULL,
	[rol] varchar(50) NULL,
	[entityName] varchar(50) NULL,
	[loginDateTime] DateTime  NOT NULL DEFAULT current_timestamp,
	[LogOutDateTime] Datetime2  NOT NULL DEFAULT current_timestamp,
	[docId] int not NULL,
	[docName] varchar(50) NULL,
	[machineId] int not NULL,
	[reportId] int not NULL,
	)

	insert into Userlog (idUsuario,name, rol, entityName,loginDateTime,LogOutDateTime,docId,docName,machineId,reportId)
	values (1, 'carlos' , 3, 'uamv' , '11:54 am' , '12:31 pm' , 1 , 'pesca' , 12 , 2)

	