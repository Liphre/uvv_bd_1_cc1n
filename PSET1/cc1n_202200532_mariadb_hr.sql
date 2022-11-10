-- ME CONECTANDO AO MARIADB
mysql -u root -p;
-- CRIANDO USUÁRIO 
create user 'filipebm'@'localhost' identified by '5123';
-- CRIANDO BANCO DE DADOS UVV 
create database uvv;
-- USUÁRIOS 'filipebm' RECEBE PRIVILÉGIOS PARA O BANCO DE DADOS UVV */
grant all on uvv.* to 'filipebm'@'localhost';
-- CONECTO O 'filipebm' AO MYSQL 
system mysql -u filipebm -p
-- ENTRO NO BANCO DE DADOS uvv 
use uvv

-- APLICANDO O CODIGO

CREATE TABLE regioes (
                id_regiao INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao)
);

ALTER TABLE regioes COMMENT 'Tabela regiões';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'nome das regiões';


CREATE TABLE paises (
                id_pais INT NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (id_pais)
);

ALTER TABLE paises COMMENT 'tabela com os paises das localizações';

ALTER TABLE paises MODIFY COLUMN id_pais INTEGER COMMENT 'PK de paises, serve como identificador de cada pais';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do pais';


CREATE TABLE localizacoes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep VARCHAR(12),
                id_pais INT NOT NULL,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacoes COMMENT 'Tabela que armazena endereços dos escritorios e utilidades da empresa';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'o';

ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'endereco de escritorio ou utilidade da empresa';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'ios da empresa';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'estado aonde esta localizadas as cidades';

ALTER TABLE localizacoes MODIFY COLUMN cep VARCHAR(12) COMMENT 'cep do escritorio ou utilidade da empresa';

ALTER TABLE localizacoes MODIFY COLUMN id_pais INTEGER COMMENT 'PK de paises, serve como identificador de cada pais';


CREATE TABLE cargos (
                id_cargo_ INT NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximo_ DECIMAL(8,2),
                PRIMARY KEY (id_cargo_)
);

ALTER TABLE cargos COMMENT 'Tabela composta pelos cargos exercitos dos empregados, nela tera tanto o salario minimo quanto o maximo';

ALTER TABLE cargos MODIFY COLUMN id_cargo_ INTEGER COMMENT 'PK da tabela cargo, identificador do cargo';

ALTER TABLE cargos MODIFY COLUMN cargo VARCHAR(35) COMMENT 'nome do cargo';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'menor salario que o cargo exercido pode receber';

ALTER TABLE cargos MODIFY COLUMN salario_maximo_ DECIMAL(8, 2) COMMENT 'maior salario que o cargo exercido pode receber';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(100) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario DECIMAL(8,2) NOT NULL,
                comissao DECIMAL(4,2),
                id_departamento INT NOT NULL,
                id_cargo_ INT NOT NULL,
                id_supervisor INT NOT NULL,
                sexo CHAR(1) NOT NULL,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'Tabela composta pelos empregados e suas informações requisitadas.';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'PK para a tabela empregados';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'nome do empregado';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(100) COMMENT 'nome do email antes do ''@''';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'telefone do empregado';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'data da contratação do empregado';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'salario do empregado';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT 'comissao do empregado refente ao sálario';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'PK da tabela departamento';

ALTER TABLE empregados MODIFY COLUMN id_cargo_ INTEGER COMMENT 'PK da tabela cargo, identificador do cargo';

ALTER TABLE empregados MODIFY COLUMN id_supervisor INTEGER COMMENT 'empregado que supervisiona os outros empregados';

ALTER TABLE empregados MODIFY COLUMN sexo CHAR(1) COMMENT ' NÃO SOU HOMOFOBICO.';
ALTER TABLE empregados
ADD CHECK (sexo in('M', 'm', 'F', 'f'));
ALTER TABLE empregados 
ADD CHECK (salario>=0.0);

CREATE UNIQUE INDEX empregados_idx
 ON empregados
 ( email );

CREATE TABLE departamento (
                id_departamento INT NOT NULL,
                id_supervisor INT,
                nome VARCHAR(50),
                id_localizacao INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamento COMMENT 'tabela de departamentos da empresa';

ALTER TABLE departamento MODIFY COLUMN id_departamento INTEGER COMMENT 'PK da tabela departamento';

ALTER TABLE departamento MODIFY COLUMN id_supervisor INTEGER COMMENT 'PK para a tabela empregados';

ALTER TABLE departamento MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do departamento';

ALTER TABLE departamento MODIFY COLUMN id_localizacao INTEGER COMMENT 'o';


CREATE TABLE historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INT NOT NULL,
                data_final DATE NOT NULL,
                id_cargo_ INT NOT NULL,
                id_departamento INT NOT NULL,
                PRIMARY KEY (data_inicial, id_empregado)
);

ALTER TABLE historico_cargos COMMENT 'Tabela que contem todos os dados de historicos de cargos exercidos pelos empregados';

ALTER TABLE historico_cargos MODIFY COLUMN data_inicial DATE COMMENT 'cargo exercido';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'PK para a tabela empregados';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'data final do cargo execido pelo empregado';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo_ INTEGER COMMENT 'PK da tabela cargo, identificador do cargo';

ALTER TABLE historico_cargos MODIFY COLUMN id_departamento INTEGER COMMENT 'PK da tabela departamento';


ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT localizacoes_departamento_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo_)
REFERENCES cargos (id_cargo_)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo_)
REFERENCES cargos (id_cargo_)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT empregados_departamento_fk
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamento_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamento (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamento_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES departamento (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

