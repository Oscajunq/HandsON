CREATE TABLE tabela_externa  
    ("LITERAL" VARCHAR2(4000)) 
    organization external 
    ( type oracle_loader 
      default directory mportes_dir 
      access parameters 
      ( RECORDS DELIMITED BY newline 
        fields terminated by ';' 
        missing field values are null 
        ( literal) ) 
        location ('TAB_ISSRSUPP.TXT') 
        ) REJECT LIMIT UNLIMITED 
        
        
        
O uso de tabelas externas está disponível a partir da versão 9i release 1 do Oracle, os dados não residem no banco
 de dados e sim em arquivos flat. A grande vantagem é o tratamento destes arquivos como tabelas normais do Oracle.
  Não é permitido alteração, porém as tabelas externas nos permite a habilidade de manipulação em queries ad-hoc, 
  isto quer dizer: ordernar, somar, máximo, mínimo, média, etc.

Set up:

No exemplo a seguir, eu usei o diretório /tmp e o arquivo emp.txt para ser o source da tabela. 
Então primeiro devemos criar o diretório no Oracle e logo a seguir, veremos como se parece o conteúdo do arquivo
 /tmp/emp.txt


ops$mportes@FCCUAT9I> create or replace directory mportes_dir as '/tmp/';
Directory created.
ops$mportes@FCCUAT9I>
ops$mportes@FCCUAT9I> !cat /tmp/emp.txt7369;
SMITH;CLERK;7902;17/DEC/80;800;;207499;ALLEN;SALESMAN;7698;20/FEB/81;1600;300;307521;WARD;SALESMAN;
7698;22/FEB/81;1250;500;307566;JONES;MANAGER;7839;02/APR/81;2975;
;207654;MARTIN;SALESMAN;7698;28/SEP/81;1250;1400;307698
;BLAKE;MANAGER;7839;01/MAY/81;2850;;307782;CLARK;MANAGER;7839;09/JUN/81;2450;
;107788;SCOTT;ANALYST;7566;19/APR/87;3000;;207839;KING;PRESIDENT;;17/NOV/81;5000;
;107844;TURNER;SALESMAN;7698;08/SEP/81;1500;0;307876;ADAMS;CLERK;7788;23/MAY/87;1100;
;207900;JAMES;CLERK;7698;03/DEC/81;950;;307902;FORD;ANALYST;7566;03/DEC/81;3000;;207934;MILLER;CLERK
;7782;23/JAN/82;1300;;10

Agora a criação da tabela, aqui o principal é, basicamente, ter cuidado com o separador, 
no nosso exemplo o ";", e o formato da data "dd/mon/rr". Aqui voce encontra a documentação
 referente as declarações de cláusulas das external tables. É necessário usuário e senha,
  mas é só registro, não paga nada e o site é o oficial da Oracle.

ops$mportes@FCCUAT9I> CREATE TABLE emp_ext  
2    (    "EMPNO" NUMBER(7),  
3         "ENAME" VARCHAR2(10),  
4         "JOB" VARCHAR2(9),  
5         "MGR" NUMBER(7),  
6           "HIREDATE" DATE,  
7         "SAL" NUMBER(7,2),  
8         "COMM" NUMBER(7,2),  
9                "DEPTNO" NUMBER(2) 
10   ) 
11   organization external 
12               ( type oracle_loader 
13      default directory mportes_dir 
14      access parameters 
15                 ( RECORDS DELIMITED BY newline 
16         fields terminated by ';' 
17                  missing field values are null 
18                     ( empno, ename, job, mgr, hiredate date 'dd/mon/yy', sal, comm, deptno ) ) 
19                         location ('emp.txt') 
20     ) 
21    REJECT LIMIT UNLIMITED
 22  /Table created.

Agora o resultado, como se parecem os dados desta tabela externa.

ops$mportes@FCCUAT9I> select * from emp_ext;    

    EMPNO ENAME      JOB                 MGR HIREDATE                      SAL          COMM        DEPTNO
    ------------- ---------- --------- ------------- ------------------- ------------- ------------- -------------
             7369 SMITH      CLERK              7902 17/12/2080 00:00:00           800                          20         
             7499 ALLEN      SALESMAN           7698 20/02/2081 00:00:00          1600           300            30         
             7521 WARD       SALESMAN           7698 22/02/2081 00:00:00          1250           500            30         
             7566 JONES      MANAGER            7839 02/04/2081 00:00:00          2975                          20         
             7654 MARTIN     SALESMAN           7698 28/09/2081 00:00:00          1250          1400            30         
             7698 BLAKE      MANAGER            7839 01/05/2081 00:00:00          2850                          30         
             7782 CLARK      MANAGER            7839 09/06/2081 00:00:00          2450                          10         
             7788 SCOTT      ANALYST            7566 19/04/2087 00:00:00          3000                          20         
             7839 KING       PRESIDENT               17/11/2081 00:00:00          5000                          10         
             7844 TURNER     SALESMAN           7698 08/09/2081 00:00:00          1500             0            30        
             7876 ADAMS      CLERK              7788 23/05/2087 00:00:00          1100                          20         
             7900 JAMES      CLERK              7698 03/12/2081 00:00:00           950                          30         
             7902 FORD       ANALYST            7566 03/12/2081 00:00:00          3000                          20         
             7934 MILLER     CLERK              7782 23/01/2082 00:00:00          1300                          
             1014 rows selected.

Os próximos passos serão simulações. Primeiro eu me livro do arquivo source, fingindo uma perda, então, 
embora a entrada da tabela ainda exista logicamente, o Oracle dá erro de execução, isso é perfeitamente normal e 
prova que os dados pertencem ao arquivo e não aos datafiles do Oracle. Depois, voltamos o arquivo apenas com uma 
linha e mais uma vez, como o arquivo só tem uma linha o resultado será o conteúdo do arquivo.

ops$mportes@FCCUAT9I> !mv /tmp/emp.txt /tmp/deletado.txt
ops$mportes@FCCUAT9I> select * from emp_ext;
select * from emp_ext*ERROR at line 1:ORA-29913: error in executing ODCIEXTTABLEOPEN 
calloutORA-29400: data cartridge errorKUP-04040: file emp.txt in MPORTES_DIR not foundORA-06512:
 at "SYS.ORACLE_LOADER", line 14ORA-06512: at line 1
 
 
ops$mportes@FCCUAT9I> !tail -1 /tmp/deletado.txt > /tmp/emp.txt
 
ops$mportes@FCCUAT9I> select * from emp_ext;    
     EMPNO ENAME      JOB                 MGR HIREDATE                      SAL          COMM        DEPTNO
     ------------- ---------- --------- ------------- ------------------- ------------- ------------- -------------         
     7934 MILLER     CLERK              7782 23/01/2082 00:00:00          1300                          101 
     row selected.
     
     ops$mportes@FCCUAT9I> !cat /tmp/deletado.txt > /tmp/emp.txt

Com o comando acima, recuperamos o arquivo original, conforme pudemos seguir no exemplo,
para livrar-me do arquivo emp.txt eu o renomeei para deletado.txt - assim deletado.txt era meu backup. 
Uma vez que emp.txt tem os dados corretos, agora vamos "ETLzar" a coisa criando uma tabela dos dados vindos do arquivo.

ops$mportes@FCCUAT9I> create table emp_nobanco as select * from emp_ext;
Table created.ops$mportes@FCCUAT9I> select * from emp_nobanco;        
EMPNO ENAME      JOB                 MGR HIREDATE                      SAL          COMM        DEPTNO
------------- ---------- --------- ------------- ------------------- ------------- ------------- -------------         
7369 SMITH      CLERK              7902 17/12/2080 00:00:00           800                          20         
7499 ALLEN      SALESMAN           7698 20/02/2081 00:00:00          1600           300            30         
7521 WARD       SALESMAN           7698 22/02/2081 00:00:00          1250           500            30         
7566 JONES      MANAGER            7839 02/04/2081 00:00:00          2975                          20         
7654 MARTIN     SALESMAN           7698 28/09/2081 00:00:00          1250          1400            30         
7698 BLAKE      MANAGER            7839 01/05/2081 00:00:00          2850                          30         
7782 CLARK      MANAGER            7839 09/06/2081 00:00:00          2450                          10         
7788 SCOTT      ANALYST            7566 19/04/2087 00:00:00          3000                          20         
7839 KING       PRESIDENT               17/11/2081 00:00:00          5000                          10         
7844 TURNER     SALESMAN           7698 08/09/2081 00:00:00          1500             0            30         
7876 ADAMS      CLERK              7788 23/05/2087 00:00:00          1100                          20         
7900 JAMES      CLERK              7698 03/12/2081 00:00:00           950                          30         
7902 FORD       ANALYST            7566 03/12/2081 00:00:00          3000                          20         
7934 MILLER     CLERK              7782 23/01/2082 00:00:00          1300                          
1014 rows selected.

Todo exemplo acima, foi a maneira mais simples de demonstrar o poder das tabelas externas. 
Outras possibilidades são possíveis, tudo depende das regras de negócio e seu sistema. 
O uso recomendável para External Tables é load (carga) ou merge (uso de novos registros para atualizar os já existentes),
 não substitua tabelas normais por external tables, seria um erro grave.
  Faça leitura dos manuais, referências no metalink e tenha certeza de entender o uso praticando.
   Tenha em consideração que, num import, haverá um erro/alerta, porque tabelas externas não são importadas.
   
