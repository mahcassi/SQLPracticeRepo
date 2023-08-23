USE EMPRESA
GO

INSERT INTO ENDERECO VALUES('FLAMENGO', 'RJ', 1)
INSERT INTO ENDERECO VALUES('MORUMBI', 'SP', 2)
INSERT INTO ENDERECO VALUES('CENTRO', 'SP', 3)
INSERT INTO ENDERECO VALUES('Pampulha', 'MG', 4)
INSERT INTO ENDERECO VALUES('CENTRO', 'RJ', 5)
INSERT INTO ENDERECO VALUES('LIBERDADE', 'SP', 6)
INSERT INTO ENDERECO VALUES('PAULISTA', 'SP', 7)
GO


CREATE TABLE TELEFONE (
	IDTELEFONE INT PRIMARY KEY IDENTITY,
	TIPO CHAR(3) NOT NULL,
	NUMERO VARCHAR(10) NOT NULL,
	ID_ALUNO INT,
	CHECK(TIPO IN('RES', 'COM', 'CEL'))
)
GO

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_ALUNO
FOREIGN KEY(ID_ALUNO) REFERENCES ALUNO(IDALUNO)
GO


INSERT INTO TELEFONE VALUES('CEL', '9656456487', 1)
INSERT INTO TELEFONE VALUES('COM', '54564645', 2)
INSERT INTO TELEFONE VALUES('RES', '1487987878', 3)
INSERT INTO TELEFONE VALUES('CEL', '9685985656', 5)
INSERT INTO TELEFONE VALUES('CEL', '369898987', 6)


SELECT * FROM ALUNO
LEFT JOIN TELEFONE ON TELEFONE.ID_ALUNO = ALUNO.IDALUNO

/* Pegar a data atual */
SELECT GETDATE()
GO

/*	Clasula ambigua (quando fa�o um join e tenho colunos iguals em mais de uma tabela) */
SELECT A.NOME, T.TIPO, T.NUMERO, E.BAIRRO, E.UF
FROM ALUNO A LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO

/* IFNULL */
SELECT  A.NOME, 
		ISNULL(T.TIPO, 'SEM') AS TIPO, 
		ISNULL(T.NUMERO, 'NUMERO') AS TELEFONE, 
		E.BAIRRO, 
		E.UF
FROM ALUNO A LEFT JOIN TELEFONE T
ON A.IDALUNO = T.ID_ALUNO
INNER JOIN ENDERECO E
ON A.IDALUNO = E.ID_ALUNO
GO




/* trabalhando com datas */

/* DATEDIFF - CALCULA A DIFEREN�A ENTRE 2 DATAS */
SELECT NOME, GETDATE()  AS DATA_ATUAL FROM ALUNO

SELECT NOME, DATEDIFF(DAY, NASCIMENTO, GETDATE()) AS IDADE
FROM ALUNO
GO


/* Retorno em inteiro + oper matematica */

SELECT NOME, (DATEDIFF(DAY, NASCIMENTO, GETDATE())/365) AS IDADE
FROM ALUNO
GO

SELECT NOME, (DATEDIFF(MONTH, NASCIMENTO, GETDATE())/12) AS IDADE
FROM ALUNO
GO

SELECT NOME, (DATEDIFF(YEAR, NASCIMENTO, GETDATE())) AS IDADE
FROM ALUNO
GO


/* datename - TRAZ O NOME DA PARTE DA DATA EM QUEST�O */
SELECT NOME, DATENAME(MONTH, NASCIMENTO)
FROM ALUNO
GO


/* DATEPART - MESMA COISA Q O DATENAME MAS RETORNA UM INT*/

SELECT NOME, DATEPART(MONTH, NASCIMENTO)
FROM ALUNO
GO

/* DFATEADD - Retorna uma data somando outra data */
/* LEGAL PARA CALCULAR PERIODOS DE CONTAS A VENCER */

SELECT DATEADD(DAY, 365, GETDATE())



/* CHARINDEX - RETORNA UM INTEIRO */
/* CONTAGEM DEFAULT - INICIA EM 01*/

/* PRIMEIRO PARAMENTRO - O QUE ESTOU PROCURANDO */
/* SEGUNDO PARAMENTRO - ONDE ESTOU PROCURANDO */
/* TERCEIRO PARAMENTRO - A PARTIR DE */
SELECT NOME, CHARINDEX('A', NOME) AS INDICE
FROM ALUNO
GO


/* BULK INSERT - IMPORTACAO DE ARQUIVOS */

CREATE TABLE LANCAMENTO_CONTABIL(
	CONTA INT,
	VALOR INT,
	DEB_CRED CHAR(1)
 )
 GO

 BULK INSERT LANCAMENTO_CONTABIL 
 FROM 'C:\DOCS-SQL\CONTAS.txt'
 WITH 
 (
	FIRSTROW = 2,
	DATAFILETYPE = 'char',
	FIELDTERMINATOR = '\t',
	ROWTERMINATOR = '\n'
 )

 select * from LANCAMENTO_CONTABIL

 USE EMPRESA

 /* trazer numero da conta, saldo devedor ou credor */
 SELECT CONTA, VALOR,
 CHARINDEX('D', DEB_CRED) AS DEBITO,
 CHARINDEX('C', DEB_CRED) AS CREDITO,
CHARINDEX('C', DEB_CRED) * 2 - 1 AS MULTIPLICADOR
 FROM LANCAMENTO_CONTABIL
 GO

 SELECT CONTA, 
 SUM(VALOR * (CHARINDEX('C', DEB_CRED) * 2 - 1)) AS SALDO
 FROM LANCAMENTO_CONTABIL
 GROUP BY CONTA



 /* TRIGGERS */

 CREATE TABLE PRODUTOS(
	IDPRODUTO INT IDENTITY PRIMARY KEY,
	NOME VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECO NUMERIC(10, 2) NOT NULL
 )
 GO


 CREATE TABLE HISTORICO(
	IDOPERACAO INT PRIMARY KEY IDENTITY,
	PRODUTO VARCHAR(50) NOT NULL,
	CATEGORIA VARCHAR(30) NOT NULL,
	PRECOANTIGO NUMERIC(10, 2) NOT NULL,
	PRECONOVO NUMERIC(10, 2) NOT NULL,
	DATA_ALTERACAO DATETIME,
	USUARIO VARCHAR(30),
	MENSAGEM VARCHAR(100)
)
 GO

INSERT INTO PRODUTOS VALUES('Livro Oracle', 'Livros', 98.00)
INSERT INTO PRODUTOS VALUES('Livro: "Clean Code"', 'Livros', 79.90)
INSERT INTO PRODUTOS VALUES('Curso Online: "Python for Beginners"', 'Cursos', 129.00)
INSERT INTO PRODUTOS VALUES('Notebook HP EliteBook', 'Eletr�nicos', 3899.00)
INSERT INTO PRODUTOS VALUES('Teclado Mec�nico RGB', 'Acess�rios de Computador', 149.99)
INSERT INTO PRODUTOS VALUES('Mouse Gamer com Sensor �ptico', 'Acess�rios de Computador', 79.90)
INSERT INTO PRODUTOS VALUES('Kit Raspberry Pi 4', 'Placas e Componentes', 249.50)
GO

SELECT * FROM PRODUTOS;
SELECT * FROM HISTORICO;


/* VERIFICANDO O USUARIO DO BANCO */
SELECT SUSER_NAME() 
GO

/* TRIGGER DE DADOS - DATA MANIPULATION LANGUAGE */
CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE
AS 
	DECLARE @IDPRODUTO INT
	DECLARE @PRODUTO VARCHAR(50)
	DECLARE @CATEGORIA VARCHAR(30)
	DECLARE @PRECO NUMERIC (10, 2)
	DECLARE @PRECONOVO NUMERIC (10, 2)
	DECLARE @DATA_ALTERACAO DATETIME 
	DECLARE @USUARIO VARCHAR(30)
	DECLARE @ACAO VARCHAR(100)

	SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED 
	SELECT @PRODUTO = NOME FROM INSERTED
	SELECT @CATEGORIA = CATEGORIA FROM INSERTED
	SELECT @PRECO = PRECO FROM DELETED
	SELECT @PRECONOVO = PRECO FROM INSERTED

	SET @DATA_ALTERACAO = GETDATE()
	SET @USUARIO = SUSER_NAME()
	SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

	INSERT INTO HISTORICO
	(PRODUTO, CATEGORIA, PRECOANTIGO, PRECONOVO, DATA_ALTERACAO, USUARIO, MENSAGEM)
	VALUES(@PRODUTO, @CATEGORIA, @PRECO, @PRECONOVO, @DATA_ALTERACAO, @USUARIO, @ACAO)

	PRINT 'TRIGGER EXECUTADA COM SUCESSO'
GO


/* EXECUTANDO UPDATE */

UPDATE PRODUTOS SET PRECO = 100.00
WHERE IDPRODUTO = 1
GO

SELECT * FROM PRODUTOS
SELECT * FROM HISTORICO
GO


/* PROGRAMNDO TRIGGER EM UMA COLUNA*/

DROP TRIGGER TRG_ATUALIZA_PRECO

CREATE TRIGGER TRG_ATUALIZA_PRECO
ON DBO.PRODUTOS
FOR UPDATE AS
IF UPDATE(PRECO)
BEGIN
	DECLARE @IDPRODUTO INT
	DECLARE @PRODUTO VARCHAR(50)
	DECLARE @CATEGORIA VARCHAR(30)
	DECLARE @PRECO NUMERIC (10, 2)
	DECLARE @PRECONOVO NUMERIC (10, 2)
	DECLARE @DATA_ALTERACAO DATETIME 
	DECLARE @USUARIO VARCHAR(30)
	DECLARE @ACAO VARCHAR(100)

	SELECT @IDPRODUTO = IDPRODUTO FROM INSERTED 
	SELECT @PRODUTO = NOME FROM INSERTED
	SELECT @CATEGORIA = CATEGORIA FROM INSERTED
	SELECT @PRECO = PRECO FROM DELETED
	SELECT @PRECONOVO = PRECO FROM INSERTED

	SET @DATA_ALTERACAO = GETDATE()
	SET @USUARIO = SUSER_NAME()
	SET @ACAO = 'VALOR INSERIDO PELA TRIGGER TRG_ATUALIZA_PRECO'

	INSERT INTO HISTORICO
	(PRODUTO, CATEGORIA, PRECOANTIGO, PRECONOVO, DATA_ALTERACAO, USUARIO, MENSAGEM)
	VALUES(@PRODUTO, @CATEGORIA, @PRECO, @PRECONOVO, @DATA_ALTERACAO, @USUARIO, @ACAO)

	PRINT 'TRIGGER EXECUTADA COM SUCESSO'
END
GO

UPDATE PRODUTOS SET PRECO = 300
WHERE IDPRODUTO = 2
GO

SELECT * FROM HISTORICO

UPDATE PRODUTOS SET NOME = 'LIVRO JAVA'
WHERE IDPRODUTO = 1
GO

SELECT * FROM HISTORICO
SELECT * FROM PRODUTOS

/* ATRIBUINDO SELECTS A VARIAVEIS - ANONIMO */

USE Empresa

CREATE TABLE RESULTADO (
	IDRESULTADO INT PRIMARY KEY IDENTITY,
	RESULTADO INT
)
GO


DECLARE 
	@RESULTADO INT
	SET @RESULTADO = (SELECT 50 + 50)
	INSERT INTO RESULTADO VALUES(@RESULTADO)
	PRINT 'VALOR INSERIDO NA TABELA ' + CAST(@RESULTADO AS VARCHAR)
	GO


SELECT * FROM RESULTADO

/* TRIGGER UPDATE */

CREATE TABLE EMPREGADO(
	IDEMP INT PRIMARY KEY,
	NOME VARCHAR(30),
	SALARIO MONEY,
	IDGERENTE INT
)
GO

ALTER TABLE EMPREGADO ADD CONSTRAINT FK_GERENTE
FOREIGN KEY(IDGERENTE) REFERENCES EMPREGADO(IDEMP)
GO

INSERT INTO EMPREGADO VALUES(1, 'CLARA', 5000.00, NULL)
INSERT INTO EMPREGADO VALUES(2, 'MARIA', 4000.00, 1)
INSERT INTO EMPREGADO VALUES(3, 'JOAO', 4000.00, 1)
GO

CREATE TABLE HIST_SALARIO(
	IDEMPREGADO INT,
	ANTIGO_SAL MONEY,
	NOVO_SAL MONEY,
	DATA_ALTERACAO DATETIME
)
GO

CREATE TRIGGER TG_SALARIO
ON DBO.EMPREGADO
FOR UPDATE AS
IF UPDATE(SALARIO)
BEGIN
	INSERT INTO HIST_SALARIO
	(IDEMPREGADO, ANTIGO_SAL, NOVO_SAL, DATA_ALTERACAO)
	SELECT D.IDEMP, D.SALARIO, I.SALARIO, GETDATE()
	FROM deleted D, inserted I
	WHERE D.IDEMP = I.IDEMP
END
GO

UPDATE EMPREGADO SET SALARIO = SALARIO * 1.1
GO

SELECT * FROM EMPREGADO
GO

SELECT * FROM HIST_SALARIO
GO

ALTER TABLE HIST_SALARIO
ADD NOME_FUNCIONARIO VARCHAR(100)

ALTER TRIGGER TG_SALARIO
ON DBO.EMPREGADO
FOR UPDATE AS
IF UPDATE(SALARIO)
BEGIN
	INSERT INTO HIST_SALARIO
	(IDEMPREGADO, ANTIGO_SAL, NOVO_SAL, DATA_ALTERACAO, NOME_FUNCIONARIO)
	SELECT D.IDEMP, D.SALARIO, I.SALARIO, GETDATE(), I.NOME
	FROM deleted D, inserted I
	WHERE D.IDEMP = I.IDEMP 
END
GO

UPDATE EMPREGADO SET SALARIO = SALARIO * 1.2
GO


/* PROCEDURES */

CREATE TABLE PESSOA(
	IDPESSOA INT PRIMARY KEY IDENTITY,
	NOME VARCHAR(30) NOT NULL,
	SEXO CHAR(1) NOT NULL CHECK(SEXO IN('M', 'F')),
	NASCIMENTO DATE NOT NULL
)
GO

CREATE TABLE TELEFONE(
	IDTELEFONE INT NOT NULL IDENTITY,
	TIPO CHAR(3) NOT NULL CHECK(TIPO IN('CEL', 'COM')),
	NUMERO CHAR(10) NOT NULL,
	ID_PESSOA INT
)
GO

ALTER TABLE TELEFONE ADD CONSTRAINT FK_TELEFONE_PESSOA
FOREIGN KEY(ID_PESSOA) REFERENCES PESSOA(IDPESSOA)
GO


INSERT INTO PESSOA VALUES('ANTONIO', 'M', '1981-02-13')
INSERT INTO PESSOA VALUES('ANDRESSA', 'F', '1989-03-16')
INSERT INTO PESSOA VALUES('PAULO', 'M', '2000-05-20')

SELECT @@IDENTITY -- GUARDA O ULTIMO IDENTITY INSERIDO NA SESSAO


INSERT INTO TELEFONE VALUES('CEL', '454564', 1)
INSERT INTO TELEFONE VALUES('COM', '4454564', 1)
INSERT INTO TELEFONE VALUES('CEL', '9898989', 1)
INSERT INTO TELEFONE VALUES('CEL', '74854564', 2)
INSERT INTO TELEFONE VALUES('COM', '65893221', 2)
INSERT INTO TELEFONE VALUES('CEL', '54564564', 3)
INSERT INTO TELEFONE VALUES('COM', '9898989', 3)
GO

/* CRIANDO PROC EST�TICA */
CREATE PROC SOMA 
AS	
	SELECT 10 + 10 AS SOMA
GO

EXEC SOMA

/* proc din�mica */
CREATE PROC TESTE @NUM1 INT, @NUM2 INT
AS 
	SELECT @NUM1 + @NUM2 AS RESULTADO
GO

/* executando proc*/
EXEC TESTE 11, 11
GO


/* apagando proc */
DROP PROC TESTE

/* procedures em tabelas */
 SELECT NOME, NUMERO
 FROM PESSOA
 INNER JOIN TELEFONE
 ON IDPESSOA = ID_PESSOA
 WHERE TIPO = 'CEL'
 GO


 /* TRAZER OS TELEFONES DE ACORDO COM O TIPO PASSADO */
 CREATE PROC TELEFONES @TIPO CHAR(3)
 AS 
	 SELECT NOME, NUMERO, TIPO
	 FROM PESSOA 
	 INNER JOIN TELEFONE 
	 ON IDPESSOA = ID_PESSOA
	 WHERE TIPO = @TIPO
GO

EXEC TELEFONES 'CEL'

DROP PROC TELEFONES


/* PARAMETROS DE OUTPUT */

SELECT TIPO, COUNT(*) AS QUANTIDADE
FROM TELEFONE 
GROUP BY TIPO
GO

/* PROC COM PARAMETRO DE ENTRADA E SAIDA */
CREATE PROC GETTIPO @TIPO CHAR(3), @CONTADOR INT OUTPUT
AS
	SELECT @CONTADOR = COUNT(*)
	FROM TELEFONE
	WHERE TIPO = @TIPO
GO

/* EXECU��O */
/* Criando variavel para receber o valor output da minha proc */

DECLARE @SAIDA INT
EXEC GETTIPO @TIPO = 'CEL', @CONTADOR = @SAIDA OUTPUT
SELECT @SAIDA
GO

DECLARE @SAIDA INT
EXEC GETTIPO 'CEL', @SAIDA OUTPUT
SELECT @SAIDA
GO

/* PROC DE CADASTRO */

CREATE PROC CADASTRO @NOME VARCHAR(30), @SEXO CHAR(1), @NASCIMENTO DATE,
@TIPO CHAR(3), @NUMERO VARCHAR(10)
AS
	DECLARE @FK INT

	INSERT INTO PESSOA VALUES(@NOME, @SEXO, @NASCIMENTO) -- GERAR UM ID
	SET @FK = (SELECT IDPESSOA FROM PESSOA WHERE IDPESSOA = @@IDENTITY)

	INSERT INTO TELEFONE VALUES(@TIPO, @NUMERO, @FK)
GO

CADASTRO 'JORGE', 'M', '1981-01-01', 'CEL', '4564564564'
GO

SELECT PESSOA.*, TELEFONE.*
FROM PESSOA
INNER JOIN TELEFONE
ON IDPESSOA = ID_PESSOA
GO


/* TSQL */

/* BLOCO DE EXECU��O */
BEGIN
	PRINT 'PRIMEIRO BLOCO'
END
GO

/* BLOCOS DE ATRIBUICAO DE VARIAVEIS*/

DECLARE
	@CONTADOR INT
BEGIN 
	SET @CONTADOR = 5
	PRINT @CONTADOR
END
GO

/* NO SQLSERVER CADA COLUNA, VARIAVEL LOCAL, EXPRESSAO E PARAMETRO TEM UM TIPO */

DECLARE
	@V_NUMERO NUMERIC(10,2) = 100.52,
	@V_DATA DATETIME = '20230207'
BEGIN
	PRINT 'VALOR NUMERICO: ' + CAST(@V_NUMERO AS VARCHAR)
	PRINT 'VALOR NUMERICO: ' + CONVERT(VARCHAR, @V_NUMERO) --USADO mais para trabalhar com data
	PRINT 'VALOR DE DATA: ' + CAST(@V_DATA AS VARCHAR)
	PRINT 'VALOR DE DATA: ' + CONVERT(VARCHAR, @V_DATA, 105)
END
GO

--------------

CREATE TABLE CARROS(
	CARRO VARCHAR(20),
	FABRICANTE VARCHAR(30)
)
GO

INSERT INTO CARROS (CARRO, FABRICANTE)
VALUES
    ('KA', 'FORD'),
    ('GOL', 'VW'),
    ('COROLLA', 'TOYOTA'),
    ('CIVIC', 'HONDA'),
    ('ONIX', 'CHEVROLET');
GO

INSERT INTO CARROS VALUES('FIESTA', 'FORD')
INSERT INTO CARROS VALUES('MUSTANG', 'FORD')
INSERT INTO CARROS VALUES('CIVIC', 'HONDA')
INSERT INTO CARROS VALUES('ACCORD', 'HONDA')
INSERT INTO CARROS VALUES('COROLLA', 'TOYOTA')
INSERT INTO CARROS VALUES('CAMRY', 'TOYOTA')
INSERT INTO CARROS VALUES('JETTA', 'VOLKSWAGEN')
INSERT INTO CARROS VALUES('GOLF', 'VOLKSWAGEN')
INSERT INTO CARROS VALUES('3 SERIES', 'BMW')
INSERT INTO CARROS VALUES('C-CLASS', 'MERCEDES-BENZ')
GO

SELECT * FROM CARROS

/* atribuindo resultados de querys � vari�veis */

DECLARE 
	@V_CONT_FORD INT,
	@V_CONT_HONDA INT
BEGIN
	--METODO 1 - O SELECT PRECISA RETORNAR UMA SIMPLES COLUNA
	-- E UM SO RESULTADO

	SET @V_CONT_FORD = (SELECT COUNT(*) FROM CARROS WHERE FABRICANTE = 'FORD')
	PRINT 'QUANTIDADE FORD: ' + CAST(@V_CONT_FORD AS VARCHAR)

	--METODO 2
	SELECT @V_CONT_HONDA = COUNT(*) FROM CARROS WHERE FABRICANTE = 'HONDA'
	PRINT 'QUANTIDADE HONDA: ' + CONVERT(VARCHAR, @V_CONT_HONDA)

END
GO