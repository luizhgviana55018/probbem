-- ConectaDoa Pro Bem · schema.sql
-- Recria o banco do zero. Atenção: apaga os dados que já existirem.
SET NAMES utf8mb4;
DROP DATABASE IF EXISTS conectadoa;
CREATE DATABASE conectadoa CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE conectadoa;

-- Quem doa: pessoa física (CPF), jurídica (CNPJ) ou doador anônimo.
-- LGPD: doador anônimo não tem nome, documento nem contato gravados.
CREATE TABLE doador (
 id_doador INT AUTO_INCREMENT PRIMARY KEY,
 tipo_pessoa ENUM('FISICA', 'JURIDICA') NOT NULL,
 anonimo BOOLEAN NOT NULL DEFAULT FALSE,
 nome VARCHAR(150),
 documento VARCHAR(18) UNIQUE,
 email VARCHAR(100) UNIQUE,
 telefone VARCHAR(20),
 data_cadastro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 CHECK (anonimo = TRUE OR (nome IS NOT NULL AND nome <> '')),
 CHECK (anonimo = FALSE OR (nome IS NULL AND documento IS NULL AND email IS NULL AND telefone IS NULL))
);

-- Categorias do que a ONG recebe: Dinheiro, Medicamento, Higiene.
CREATE TABLE categoria (
 id_categoria INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(60) NOT NULL UNIQUE
);

-- Catálogo de itens. Medicamento pode ser de venda livre ou controlado.
CREATE TABLE item (
 id_item INT AUTO_INCREMENT PRIMARY KEY,
 id_categoria INT NOT NULL,
 nome VARCHAR(150) NOT NULL,
 unidade VARCHAR(20) NOT NULL DEFAULT 'unidade',
 exige_receita BOOLEAN NOT NULL DEFAULT FALSE,
 FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

-- Médico ou farmacêutico que libera os medicamentos controlados.
CREATE TABLE profissional_responsavel (
 id_profissional INT AUTO_INCREMENT PRIMARY KEY,
 nome VARCHAR(150) NOT NULL,
 tipo ENUM('MEDICO', 'FARMACEUTICO') NOT NULL,
 registro_profissional VARCHAR(30) NOT NULL UNIQUE,
 ativo BOOLEAN NOT NULL DEFAULT TRUE
);

-- Cada doação pertence a um doador.
-- Em doação em dinheiro, preencha forma_pagamento (cartão ou boleto/Pix).
CREATE TABLE doacao (
 id_doacao INT AUTO_INCREMENT PRIMARY KEY,
 id_doador INT NOT NULL,
 data_doacao DATE NOT NULL,
 forma_pagamento ENUM('CARTAO', 'BOLETO', 'PIX'),
 status_pagamento ENUM('PENDENTE', 'CONFIRMADO', 'CANCELADO') NOT NULL DEFAULT 'CONFIRMADO',
 observacao VARCHAR(255),
 criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
 FOREIGN KEY (id_doador) REFERENCES doador (id_doador)
);

-- Tabela associativa N:N entre doação e item.
-- Para dinheiro, a quantidade guarda o valor em reais.
-- Item que exige receita precisa do profissional responsável e da validade.
CREATE TABLE doacao_item (
 id_doacao INT NOT NULL,
 id_item INT NOT NULL,
 quantidade INT NOT NULL CHECK (quantidade > 0),
 validade DATE,
 numero_receita VARCHAR(40),
 id_profissional INT,
 PRIMARY KEY (id_doacao, id_item),
 FOREIGN KEY (id_doacao) REFERENCES doacao (id_doacao) ON DELETE CASCADE,
 FOREIGN KEY (id_item) REFERENCES item (id_item),
 FOREIGN KEY (id_profissional) REFERENCES profissional_responsavel (id_profissional)
);
