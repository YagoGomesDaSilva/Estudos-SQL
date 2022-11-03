CREATE DATABASE alura;

DROP TABLE aluno,curso,categoria ,aluno_curso

CREATE TABLE aluno(
	id SERIAL PRIMARY KEY,
	primeiro_nome VARCHAR(255) NOT NULL,
	ultimo_nome VARCHAR(255) NOT NULL,
	data_nascimento VARCHAR(255)NOT NULL
);

CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE curso(
	id SERIAL PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	--categoria_id INTEGER NOT NULL REFERENCES categoria(id)
	categoria_id INTEGER,FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE aluno_curso(
	aluno_id INTEGER NOT NULL REFERENCES aluno(id),
	curso_id INTEGER NOT NULL REFERENCES curso(id),
	PRIMARY KEY (aluno_id,curso_id)
);
-- quase a mesma coisa de ...
CREATE TABLE aluno_curso(
	aluno_id INTEGER,FOREIGN KEY (aluno_id) REFERENCES aluno(id),
	curso_id INTEGER,FOREIGN KEY (curso_id) REFERENCES curso(id),
	PRIMARY KEY (aluno_id,curso_id)
);
/*
(Basicamente a chave estrangeira do código anterior cria uma restrição, 
informando que sempre que um valor for inserido em "aluno_curso",
o dado em aluno_id precisa ser um número inteiro não- nulo e precisa referenciar o que já existe na tabela "aluno" no campo "id".
Dessa forma, quando inserimos um aluno_id , ele precisa existir no campo "id" da tabela "aluno".
ou seja,uma chave estrangeira sempre faz a referência entre o campo de uma tabela com um campo de outra tabela.
sempre que criamos uma chave estrangeira, precisamos referenciá-la a um campo que tem a restrição de ser único.)
*/

--Preparando dados

INSERT INTO aluno (primeiro_nome, ultimo_nome, data_nascimento) VALUES (
    'Vinicius', 'Dias', '1997-10-15'
), (
    'Patrícia', 'Freitas', '1996-10-25'
), (
    'Diogo', 'Oliveira', '1994-08-27'
), (
    'Maria', 'Rosa', '1985-01-01'
);
	
INSERT INTO categoria (nome) VALUES ('Front-End'), ('Programação'), ('Banco de dados'), ('Data Science');

INSERT INTO curso (nome, categoria_id) VALUES
    ('HTML',1),
    ('CSS',1),
    ('JS',1),
    ('PHP',2),
    ('Java',2),
    ('C++',2),
    ('PostgreSQL',3),
    ('MySQL',3),
    ('Oracle',3),
    ('SQL Server',3),
    ('SQLite',3),
    ('Pandas',4),
    ('Machine Learning',4),
    ('Power BI',4);
	
INSERT INTO aluno_curso VALUES (1,4), (1,11), (2,1), (2,2), (3,4), (3,3),(4,4),(4,6),(4,5);

SELECT * FROM aluno
SELECT * FROM curso 
SELECT * FROM aluno_curso 
SELECT * FROM categoria 

--gerando um relatório

SELECT * 
	FROM aluno
	JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
	JOIN curso ON curso.id = aluno_curso.curso_id;

/*
assim tbm funciona
SELECT * 
	FROM aluno
	JOIN aluno_curso ON aluno.id = aluno_curso.aluno_id
	JOIN curso ON curso.id = aluno_curso.curso_id;
SELECT * 
	FROM aluno_curso
	JOIN aluno ON aluno.id =aluno_curso.aluno_id
	JOIN curso ON curso.id =aluno_curso.curso_id;


--entregar o nome do aluno e quantos cursos ele está fazendo

(Precisamos que o COUNT() contabilize a quantidade de cursos que esse aluno está matriculado)

SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) AS numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY aluno.primeiro_nome, aluno.ultimo_nome;

ou

SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) AS numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY 1,2; --utilizando apenas a posição das colunas

-- ordenando

SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(curso.id) AS numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
    JOIN curso ON curso.id = aluno_curso.curso_id
GROUP BY 1,2
ORDER BY numero_cursos DESC;
*/

(Portanto a junção da tabela "curso”, através da linha JOIN curso ON curso.id = aluno_curso.curso_id não é necessária.
 Podemos buscar essas informações em aluno_curso.curso_id , que passaremos para os parâmetros do COUNT() .)
 
--NOMERO DE CURSOS EM QUE CADA ALUNOS ESTA MATRICULADO
SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1,2
ORDER BY numero_cursos DESC;

--se eu quisesse o aluno matriclado em mais cursos

SELECT aluno.primeiro_nome,
       aluno.ultimo_nome,
       COUNT(aluno_curso.curso_id) numero_cursos
    FROM aluno
    JOIN aluno_curso ON aluno_curso.aluno_id = aluno.id
GROUP BY 1,2
ORDER BY numero_cursos DESC
	LIMIT 1;
	
--relatório dos cursos, ou do curso, mais requisitado, ou seja, aqueles que têm mais alunos matriculados

SELECT * 
	FROM curso
	JOIN aluno_curso ON aluno_curso.curso_id = curso.id
	
SELECT curso.nome,
       COUNT(aluno_curso.aluno_id) AS numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC;

SELECT curso.nome,
       COUNT(aluno_curso.aluno_id) AS numero_alunos
    FROM curso
    JOIN aluno_curso ON aluno_curso.curso_id = curso.id
GROUP BY 1
ORDER BY numero_alunos DESC
LIMIT 1;

-- ==============sub-consultas==============

SELECT * FROM curso;
SELECT * FROM categoria;

--Buscaremos agora os cursos que sejam da categoria "Front-End" ou a categoria "Programação"
SELECT * FROM curso WHERE categoria_id = 1 OR categoria_id = 2 
--Mesma coisa de ...
SELECT * FROM curso WHERE categoria_id IN (1,2);
/*
Com a cláusula IN() , conseguimos passar vários parâmetros, que serão comparados com o campo que determinamos,
que no caso é a "categoria_id", e se essa categoria for igual a qualquer um dos parâmetros dessa lista, significa que o resultado será retornado.
Portanto, ao executarmos SELECT * FROM curso WHERE categoria_id IN (1,2); , teremos o mesmo resultado.
*/
												

--queremos buscar todos os cursos dentro de categorias que não possuem espaço

SELECT * FROM curso;
SELECT * FROM categoria;

SELECT id FROM categoria WHERE nome NOT LIKE ('% %');

SELECT * FROM curso WHERE categoria_id IN (
    SELECT id FROM categoria WHERE nome NOT LIKE ('% %')
);

SELECT * FROM curso WHERE categoria_id IN (
    SELECT id FROM categoria WHERE nome LIKE ('% de %')
);


--sud-consultas com tabelas

--tabela que relaciona o a categoria com a quantidade de cursos referente a essa categoria
SELECT categoria.nome AS categoria,
        COUNT(curso.id) as numero_cursos
    FROM categoria
    JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria;

/*
queremos buscar a categoria e o número de cursos de "algum lugar" que tenha as categorias e quantos cursos elas têm.
Nesse lugar, queremos utilizar um filtro onde o número de cursos precisa ser maior que três.

SELECT categoria,
       numero_cursos
    FROM algum_lugar
  WHERE numero_cursos > 3;
  
  Isso significa que, no FROM, podemos colocar uma subquery que será utilizada como uma tabela
 */
 
 SELECT categoria,
       numero_cursos
    FROM (
            SELECT categoria.nome AS categoria,
                COUNT(curso.id) AS numero_cursos
            FROM categoria
            JOIN curso ON curso.categoria_id = categoria.id
        GROUP BY categoria
    ) AS categoria_cursos
  WHERE numero_cursos > 3;
  
/*
é possível utilizar uma query em um filtro, ou seja, no WHERE , ou no FROM() . Geralmente, quando se utiliza uma subquery no FROM,
é possível simplificar a busca modificando a subquery em questão, porém em alguns casos raros, que só conheceremos quando nos depararmos com eles,
pode ser necessário utilizar esse artefato, que já conhecemos e conseguiremos utilizar.
*/

--MESMO RESULTADO
SELECT categoria.nome AS categoria,
		COUNT(curso.id) AS numero_cursos
	FROM categoria
	JOIN curso ON curso.categoria_id = categoria.id
GROUP BY categoria
HAVING COUNT(curso.id) > 3;


-- ==============FUNÇÕES==============

--------------------manipulação de strings
/*
SELECT (primeiro_nome juntar com ultimo_nome) AS nome_completo FROM aluno;
No Postgres, temos o operador || para realizarmos uma concatenação ou seja, uma junção dos campos
*/

SELECT (primeiro_nome || ultimo_nome) AS nome_completo FROM aluno;
SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo FROM aluno;


--FUNÇÃO CONCAT
-- evitar o NULL na saida
SELECT CONCAT('Vinicius', ' ', NULL);
SELECT CONCAT('Vinicius', NULL, 'Dias')
SELECT CONCAT('Vinicius', ' ', 'Dias')

SELECT CONCAT(primeiro_nome , ' ' , ultimo_nome) AS nome_completo FROM aluno;

--FUNÇÃO  UPPER
--transforma tudo em maiúsculo

SELECT UPPER(CONCAT(primeiro_nome , ' ' , ultimo_nome)) AS nome_completo FROM aluno;

--FUNÇÃO TRIM
--remove todos os espaços do início e do fim

SELECT CONCAT(' ',primeiro_nome , ' ' , ultimo_nome,' ') AS nome_completo FROM aluno;

SELECT TRIM(CONCAT(' ',primeiro_nome , ' ' , ultimo_nome,' ')) AS nome_completo FROM aluno;

--USANDO TUDO

SELECT TRIM(UPPER(CONCAT(' ',primeiro_nome , ' ' , ultimo_nome,' '))) AS nome_completo FROM aluno;

------------ FUNÇÕES DE DATA

-- FUNÇÃO NOW
--NOW() retorna várias informações, sendo elas: data, hora e timezone

SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, NOW(), data_nascimento FROM aluno;

SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo, NOW()::DATE, data_nascimento FROM aluno;
--operador ()::) Esse é um operador que indica conversão e, após ele, precisamos informar o tipo de dado que queremos

/*

DEVERIA FUNCIONAR

SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo,
    (NOW()::DATE - data_nascimento)/365 AS idade
  FROM aluno;

SELECT (primeiro_nome || ' ' || ultimo_nome) AS nome_completo,
   AGE(data_nascimento) AS idade
  FROM aluno;
  
  SELECT (primeiro_nome || ultimo_nome) AS nome_completo,
    EXTRACT(YEAR FROM AGE(data_nascimento)) AS idade
  FROM aluno;
  
*/

----- CONVERSÕES DE TIPO
/*
a função TO_CHAR() recebe timestamp, intervalo, double precision, qualquer número ou texto, portanto,
várias possibilidades de parâmetros para, no final, devolver um texto formatado.
*/


SELECT TO_CHAR(NOW(), 'DD/MM/YYYY');


