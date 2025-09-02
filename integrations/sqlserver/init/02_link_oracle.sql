-- Reference: linking SQL Server to Oracle (requires provider)
EXEC master.dbo.sp_addlinkedserver
  @server = N'ORCL_XE',
  @srvproduct=N'Oracle',
  @provider=N'OraOLEDB.Oracle',
  @datasrc=N'//oracle:1521/XEPDB1';

EXEC master.dbo.sp_addlinkedsrvlogin
  @rmtsrvname = N'ORCL_XE',
  @useself = 'False',
  @rmtuser = N'ADMISSIONS',
  @rmtpassword = 'AdmissionsP@ssw0rd';
GO
