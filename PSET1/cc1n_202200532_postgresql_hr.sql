-- PELO TERMINAL LINUX ENTREI NO POSTRES
su - postgres

psql

--CRIEI USUÁRIO
create user filipebm superuser inherit createdb createrole;

-- AQUI, A SENHA PARA USUÁRIO
alter user filipebm password '5123';

-- CRIANDO BANCO DE DADOS UVV
create database uvv
with
owner = 'filipebm'
template = template0
encoding = 'UTF8'
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
allow_connections = true;

-- CONECTANDO USUÁRIO AO BANCO
\c uvv filipebm;

-- CRIANDO O SCHEMA HR
create schema hr authorization "filipebm";

/*COMANDO PARA APAGAR SCHEMA 
drop schema hr cascade;*/

-- DEFINIR O SCHEMA HR COMO PADRÃO
alter user "filipebm" set search_path to hr, "\user", public;

-- APARTIR DAQUI, O COMANDO FOI RETIRADO DO POWER ARCHITECT E INSERIDO NO SCHEMA HR

CREATE TABLE hr.regioes (
                id_regiao INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao)
);
COMMENT ON TABLE hr.regioes IS 'Tabela regiões';
COMMENT ON COLUMN hr.regioes.nome IS 'nome das regiões';


CREATE TABLE hr.paises (
                id_pais INTEGER NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT paises_pk PRIMARY KEY (id_pais)
);
COMMENT ON TABLE hr.paises IS 'tabela com os paises das localizações';
COMMENT ON COLUMN hr.paises.id_pais IS 'PK de paises, serve como identificador de cada pais';
COMMENT ON COLUMN hr.paises.nome IS 'nome do pais';


CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                uf VARCHAR(25),
                cep VARCHAR(12),
                id_pais INTEGER NOT NULL,
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacoes IS 'Tabela que armazena endereços dos escritorios e utilidades da empresa';
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'PK para a tabela, serve como identificador para a localização';
COMMENT ON COLUMN hr.localizacoes.endereco IS 'endereco de escritorio ou utilidade da empresa';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'cidade a qual estara algum escritorio da empresa ou utilitarios da empresa';
COMMENT ON COLUMN hr.localizacoes.uf IS 'estado aonde esta localizadas as cidades';
COMMENT ON COLUMN hr.localizacoes.cep IS 'cep do escritorio ou utilidade da empresa';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'PK de paises, serve como identificador de cada pais';


CREATE TABLE hr.cargos (
                id_cargo_ INTEGER NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximo_ NUMERIC(8,2),
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargo_)
);
COMMENT ON TABLE hr.cargos IS 'Tabela composta pelos cargos exercitos dos empregados, nela tera tanto o salario minimo quanto o maximo';
COMMENT ON COLUMN hr.cargos.id_cargo_ IS 'PK da tabela cargo, identificador do cargo';
COMMENT ON COLUMN hr.cargos.cargo IS 'nome do cargo';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'menor salario que o cargo exercido pode receber';
COMMENT ON COLUMN hr.cargos.salario_maximo_ IS 'maior salario que o cargo exercido pode receber';


CREATE UNIQUE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(100) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                salario NUMERIC(8,2) NOT NULL,
                comissao NUMERIC(4,2),
                id_departamento INTEGER NOT NULL,
                id_cargo_ INTEGER NOT NULL,
                id_supervisor INTEGER NOT NULL,
                sexo CHAR(1) NOT NULL,
                CONSTRAINT id_empregados PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'Tabela composta pelos empregados e suas informações requisitadas.';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'PK para a tabela empregados';
COMMENT ON COLUMN hr.empregados.nome IS 'nome do empregado';
COMMENT ON COLUMN hr.empregados.email IS 'nome do email antes do ''@''';
COMMENT ON COLUMN hr.empregados.telefone IS 'telefone do empregado';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'data da contratação do empregado';
COMMENT ON COLUMN hr.empregados.salario IS 'salario do empregado';
COMMENT ON COLUMN hr.empregados.comissao IS 'comissao do empregado refente ao sálario';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'PK da tabela departamento';
COMMENT ON COLUMN hr.empregados.id_cargo_ IS 'PK da tabela cargo, identificador do cargo';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'empregado que supervisiona os outros empregados';
COMMENT ON COLUMN hr.empregados.sexo IS 'O sexo do empregado, somente M ou F (Masculino ou Feminino), NÃO SOU HOMOFOBICO.';


CREATE UNIQUE INDEX empregados_idx
 ON hr.empregados
 ( email );

CREATE TABLE hr.departamento (
                id_departamento INTEGER NOT NULL,
                id_supervisor INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER NOT NULL,
                CONSTRAINT departamento_pk PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamento IS 'tabela de departamentos da empresa';
COMMENT ON COLUMN hr.departamento.id_departamento IS 'PK da tabela departamento';
COMMENT ON COLUMN hr.departamento.id_supervisor IS 'PK para a tabela empregados';
COMMENT ON COLUMN hr.departamento.nome IS 'nome do departamento';
COMMENT ON COLUMN hr.departamento.id_localizacao IS 'PK para a tabela, serve como identificador para a localização';


CREATE TABLE hr.historico_cargos (
                data_inicial DATE NOT NULL,
                id_empregado INTEGER NOT NULL,
                data_final DATE NOT NULL,
                id_cargo_ INTEGER NOT NULL,
                id_departamento INTEGER NOT NULL,
                CONSTRAINT historico_cargos_pk PRIMARY KEY (data_inicial, id_empregado)
);
COMMENT ON TABLE hr.historico_cargos IS 'Tabela que contem todos os dados de historicos de cargos exercidos pelos empregados';
COMMENT ON COLUMN hr.historico_cargos.data_inicial IS 'PK da tabela que mostra a data de iniciação do empregado no cargo exercido';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'PK para a tabela empregados';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'data final do cargo execido pelo empregado';
COMMENT ON COLUMN hr.historico_cargos.id_cargo_ IS 'PK da tabela cargo, identificador do cargo';
COMMENT ON COLUMN hr.historico_cargos.id_departamento IS 'PK da tabela departamento';


ALTER TABLE hr.paises ADD CONSTRAINT regioes_paises_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.localizacoes ADD CONSTRAINT paises_localizacoes_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (id_pais)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamento ADD CONSTRAINT localizacoes_departamento_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo_)
REFERENCES hr.cargos (id_cargo_)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo_)
REFERENCES hr.cargos (id_cargo_)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamento ADD CONSTRAINT empregados_departamento_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT departamento_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamento (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamento_historico_cargos_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamento (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

