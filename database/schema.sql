data_inicio DATE NOT NULL,
  data_fim DATE NULL,
  status ENUM('PLANEJADA','ATIVA','ENCERRADA','CANCELADA')
    NOT NULL DEFAULT 'PLANEJADA',
  CONSTRAINT pk_arrecadacao PRIMARY KEY (id_arrecadacao),
  CONSTRAINT chk_arrecadacao_periodo
    CHECK (data_fim IS NULL OR data_fim >= data_inicio)
) ENGINE=InnoDB;

-- Contribuicoes em dinheiro, por exemplo via PIX ou cartao de credito.
CREATE TABLE contribuicao (
  id_contribuicao INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_doador INT UNSIGNED NOT NULL,
  id_arrecadacao INT UNSIGNED NULL,
  valor DECIMAL(10,2) NOT NULL,
  forma_pagamento ENUM('PIX','CARTAO_CREDITO','DINHEIRO','TRANSFERENCIA')
    NOT NULL,
  status ENUM('PENDENTE','AUTORIZADA','RECEBIDA','RECUSADA','CANCELADA')
    NOT NULL DEFAULT 'PENDENTE',
  data_contribuicao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  codigo_referencia VARCHAR(100) NULL,
  observacao VARCHAR(255) NULL,
  CONSTRAINT pk_contribuicao PRIMARY KEY (id_contribuicao),
  CONSTRAINT chk_contribuicao_valor CHECK (valor > 0),
  CONSTRAINT uq_contribuicao_referencia UNIQUE (codigo_referencia),
  INDEX idx_contribuicao_doador (id_doador),
  INDEX idx_contribuicao_arrecadacao (id_arrecadacao),
  CONSTRAINT fk_contribuicao_doador
    FOREIGN KEY (id_doador) REFERENCES doador (id_doador)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_contribuicao_arrecadacao
    FOREIGN KEY (id_arrecadacao) REFERENCES arrecadacao (id_arrecadacao)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- Categorias de itens recebidos: medicamentos, alimentos, higiene etc.
CREATE TABLE categoria (
  id_categoria INT UNSIGNED NOT NULL AUTO_INCREMENT,
  nome VARCHAR(60) NOT NULL,
  CONSTRAINT pk_categoria PRIMARY KEY (id_categoria),
  CONSTRAINT uq_categoria_nome UNIQUE (nome)
) ENGINE=InnoDB;

-- Catalogo de itens que podem ser recebidos pela ONG.
CREATE TABLE item (
  id_item INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_categoria INT UNSIGNED NOT NULL,
  nome VARCHAR(150) NOT NULL,
  unidade VARCHAR(20) NOT NULL DEFAULT 'unidade',
  CONSTRAINT pk_item PRIMARY KEY (id_item),
  INDEX idx_item_categoria (id_categoria),
  CONSTRAINT fk_item_categoria
    FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Dados complementares quando o item catalogado for um medicamento.
CREATE TABLE medicamento (
  id_item INT UNSIGNED NOT NULL,
  principio_ativo VARCHAR(150) NULL,
  apresentacao VARCHAR(100) NULL,
  exige_receita BOOLEAN NOT NULL DEFAULT FALSE,
  CONSTRAINT pk_medicamento PRIMARY KEY (id_item),
  CONSTRAINT fk_medicamento_item
    FOREIGN KEY (id_item) REFERENCES item (id_item)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

-- Doacoes de bens/itens entregues a ONG.
CREATE TABLE doacao (
  id_doacao INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_doador INT UNSIGNED NOT NULL,
  id_arrecadacao INT UNSIGNED NULL,
  data_doacao DATE NOT NULL,
  status ENUM('PENDENTE','AUTORIZADA','RECEBIDA','RECUSADA','CANCELADA')
    NOT NULL DEFAULT 'PENDENTE',
  observacao VARCHAR(255) NULL,
  criado_em TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_doacao PRIMARY KEY (id_doacao),
  INDEX idx_doacao_doador (id_doador),
  INDEX idx_doacao_arrecadacao (id_arrecadacao),
  INDEX idx_doacao_data (data_doacao),
  CONSTRAINT fk_doacao_doador
    FOREIGN KEY (id_doador) REFERENCES doador (id_doador)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_doacao_arrecadacao
    FOREIGN KEY (id_arrecadacao) REFERENCES arrecadacao (id_arrecadacao)
    ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

-- Itens e quantidades de cada doacao (relacionamento N:N).
CREATE TABLE doacao_item (
  id_doacao INT UNSIGNED NOT NULL,
  id_item INT UNSIGNED NOT NULL,
  quantidade INT UNSIGNED NOT NULL,
  lote VARCHAR(80) NULL,
  data_validade DATE NULL,
  CONSTRAINT pk_doacao_item PRIMARY KEY (id_doacao, id_item),
  INDEX idx_doacao_item_item (id_item),
  CONSTRAINT chk_doacao_item_quantidade CHECK (quantidade > 0),
  CONSTRAINT chk_doacao_item_validade
    CHECK (data_validade IS NULL OR data_validade >= '2000-01-01'),
  CONSTRAINT fk_doacao_item_doacao
    FOREIGN KEY (id_doacao) REFERENCES doacao (id_doacao)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_doacao_item_item
    FOREIGN KEY (id_item) REFERENCES item (id_item)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Observacao:
-- 'AUTORIZADA' indica aprovacao/confirmacao do registro.
-- 'RECEBIDA' indica que o valor ou item foi efetivamente recebido pela ONG.
-- Em medicamentos, lote e data_validade podem ser informados em doacao_item.
-- Este schema registra os dados; nao processa pagamentos reais nem valida receitas.

-- Fim do schema da ONG ProBem.
