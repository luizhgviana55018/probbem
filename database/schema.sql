-- ProBem · schema.sql
-- Recria o banco do zero. Apaga os dados existentes.
SET NAMES utf8mb4;
DROP DATABASE IF EXISTS probem;
CREATE DATABASE probem CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE probem;

CREATE TABLE doador (
  id_doador INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  email VARCHAR(100) UNIQUE,
  telefone VARCHAR(20),
  documento VARCHAR(18),
  endereco VARCHAR(255),
  data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE voluntario (
  id_voluntario INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  funcao VARCHAR(80) NOT NULL,
  setor VARCHAR(80),
  crm VARCHAR(20),
  eh_medico BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE doacao (
  id_doacao INT AUTO_INCREMENT PRIMARY KEY,
  id_doador INT NOT NULL,
  tipo ENUM('dinheiro','medicamento') NOT NULL,
  data_doacao DATE NOT NULL,
  observacao VARCHAR(255),
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_doador) REFERENCES doador (id_doador)
);

CREATE TABLE doacao_dinheiro (
  id_doacao INT PRIMARY KEY,
  forma ENUM('pix','boleto') NOT NULL,
  valor DECIMAL(10,2) NOT NULL CHECK (valor > 0),
  status ENUM('pendente','confirmado') NOT NULL,
  confirmacao_email VARCHAR(255),
  FOREIGN KEY (id_doacao) REFERENCES doacao (id_doacao) ON DELETE CASCADE
);

CREATE TABLE medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(150) NOT NULL,
  exige_receita BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE doacao_medicamento (
  id_doacao INT NOT NULL,
  id_medicamento INT NOT NULL,
  quantidade INT NOT NULL CHECK (quantidade > 0),
  validade DATE NOT NULL,
  status_avaliacao ENUM('nao_exige','pendente','aprovada','recusada') NOT NULL DEFAULT 'nao_exige',
  id_medico INT,
  PRIMARY KEY (id_doacao, id_medicamento),
  FOREIGN KEY (id_doacao) REFERENCES doacao (id_doacao) ON DELETE CASCADE,
  FOREIGN KEY (id_medicamento) REFERENCES medicamento (id_medicamento),
  FOREIGN KEY (id_medico) REFERENCES voluntario (id_voluntario)
);