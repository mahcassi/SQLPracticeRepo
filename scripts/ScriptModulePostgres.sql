/*FUNÇOES DE AGREGACAO*/

/*Query simples*/

select * from funcionarios;
select * from departamentos;
/* Contando o numero de ocorrencias */

select count(*) from funcionarios;
select count(*) from departamentos;
select count(*) from localizacao;

/* Agrupando por sexo com group by */

select count(*) from funcionarios
group by sexo;

/* colocando o nome da coluna */

select sexo, count(*) as "Quantidade" from funcionarios
group by sexo;


/* mostrando o numero de funcionarios em cada departamento */

select departamento, count(*)
from funcionarios
group by departamento;


/* Exibindo o maximo de salarios - 149929 */

select max(salario) as "SALARIO MAXIMO" from funcionarios;

/* Exibindo o minimo de salarios - 40138 */

select min(salario) as "SALARIO MENOR" from funcionarios;

/* Exibindo o máximo e o mínimo juntos */

select min(salario) as "SALARIO MINIMO", max(salario) as "SALARIO MAXIMO"
from funcionarios;

/* Exibindo o máximo e o mínimo de cada departamento */

select departamento, min(salario), max(salario)
from funcionarios
group by departamento;

/* Exibindo o máximo e o mínimo por sexo */

select sexo, min(salario), max(salario)
from funcionarios
group by sexo;


/* Estatisticas */

/* Mostrando quantidade limitada de linhas */
SELECT * FROM FUNCIONARIOS 
LIMIT 10;

/* Qual gasto total de salario pago pela empresa?*/
SELECT SUM(SALARIO) FROM FUNCIONARIOS;

/* Qual o montante total que cada departamento recebe? */
SELECT DEPARTAMENTO, SUM(SALARIO)
FROM FUNCIONARIOS
GROUP BY DEPARTAMENTO;


/* POR DEPARTAMENTO, QUAL O TOTAL E A MEDIA PAGA PARA FUNCIONARIOS? */
SELECT SUM(SALARIO), AVG(SALARIO) FROM FUNCIONARIOS;

SELECT DEPARTAMENTO, SUM(SALARIO), AVG(SALARIO) FROM FUNCIONARIOS 
GROUP BY DEPARTAMENTO;

/* ORDENANDO */
SELECT DEPARTAMENTO, SUM(SALARIO), AVG(SALARIO) FROM FUNCIONARIOS 
GROUP BY DEPARTAMENTO
ORDER BY 3;

SELECT DEPARTAMENTO, SUM(SALARIO), AVG(SALARIO) FROM FUNCIONARIOS 
GROUP BY DEPARTAMENTO
ORDER BY 3 ASC;

SELECT DEPARTAMENTO, SUM(SALARIO), AVG(SALARIO) FROM FUNCIONARIOS 
GROUP BY DEPARTAMENTO
ORDER BY 3 DESC;