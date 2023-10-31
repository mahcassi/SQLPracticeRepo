/* O servidor de maquinas gerou um arquivo de log CSV. 
Vamos importá-lo e analisa-lo dentro do nosso banco*/

/* Importando CSV */
CREATE TABLE MAQUINAS(
	MAQUINA VARCHAR(20),
	DIA INT,
	QTD NUMERIC(10,2)
);

COPY MAQUINAS
FROM 'C:\Curso SQL\LogMaquinas.csv'
DELIMITER ','
CSV HEADER;

SELECT * FROM MAQUINAS;

/* qual a media de cada maquina */

SELECT MAQUINA, AVG(QTD) AS MEDIA_QTD 
FROM MAQUINAS GROUP BY MAQUINA
ORDER BY 2 DESC;

/* arrendondando */
ROUND(COLUNA, 2)

SELECT MAQUINA, ROUND(AVG(QTD), 2) AS MEDIA_QTD 
FROM MAQUINAS GROUP BY MAQUINA
ORDER BY 2 DESC;


/* QUAL A MODA DAS QUANTIDADES*/
SELECT MAQUINA, QTD, COUNT(*) AS MODA
FROM MAQUINAS 
GROUP BY MAQUINA, QTD
ORDER BY 3 DESC;

/* A MODA DAS QUANTIDADES DE CADA MAQUINA */
SELECT MAQUINA, QTD, COUNT(*) FROM MAQUINAS
WHERE MAQUINA = 'Maquina 01'
GROUP BY MAQUINA, QTD
ORDER BY 3 DESC
LIMIT 1;
