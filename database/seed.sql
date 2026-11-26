-- ConectaDoa Pró-Bem · seed.sql (dados fictícios)
SET NAMES utf8mb4;
USE conectadoa;

INSERT INTO categoria (nome) VALUES
 ('Dinheiro'),
 ('Medicamento'),
 ('Higiene');

INSERT INTO item (id_categoria, nome, unidade, exige_receita) VALUES
 (1, 'Doação em dinheiro (Pix)', 'reais', FALSE),
 (1, 'Doação em dinheiro (Cartão)', 'reais', FALSE),
 (2, 'Dipirona 500 mg (venda livre)', 'caixa', FALSE),
 (2, 'Paracetamol 750 mg (venda livre)', 'caixa', FALSE),
 (2, 'Soro fisiológico 500 ml', 'frasco', FALSE),
 (2, 'Amoxicilina 500 mg (com restrição: médico)', 'caixa', TRUE),
 (2, 'Insulina NPH (com restrição: médico)', 'frasco', TRUE),
 (3, 'Sabonete', 'unidade', FALSE),
 (3, 'Fralda infantil', 'pacote', FALSE);

INSERT INTO profissional_responsavel (nome, tipo, registro_profissional) VALUES
 ('Dra. Helena Prado', 'FARMACEUTICO', 'CRF-SP 123456'),
 ('Dr. Marcos Tavares', 'MEDICO', 'CRM-SP 654321');

INSERT INTO doador (tipo_pessoa, anonimo, nome, documento, email, telefone) VALUES
 ('JURIDICA', FALSE, 'Mercado Bom Preço', '11.222.333/0001-81', 'contato@bompreco.exemplo.com', '(11) 3333-1000'),
 ('FISICA', FALSE, 'Ana Souza', '123.456.789-09', 'ana.souza@exemplo.com', '(11) 98888-1001'),
 ('FISICA', FALSE, 'Carlos Lima', NULL, NULL, '(11) 97777-1002'),
 ('JURIDICA', FALSE, 'Farmácia Vida Plena', '44.555.666/0001-72', 'contato@vidaplena.exemplo.com', '(11) 3333-2000'),
 ('FISICA', TRUE, NULL, NULL, NULL, NULL);

INSERT INTO doacao (id_doador, data_doacao, forma_pagamento, status_pagamento, observacao) VALUES
 (1, '2026-10-05', 'PIX', 'CONFIRMADO', 'Doação via Pix da campanha de outubro'),
 (2, '2026-10-12', 'CARTAO', 'CONFIRMADO', 'Pagamento no cartão pelo link seguro'),
 (4, '2026-10-18', NULL, 'CONFIRMADO', 'Medicamentos conferidos pela farmacêutica voluntária'),
 (5, '2026-10-20', 'BOLETO', 'PENDENTE', 'Doação anônima por boleto');

INSERT INTO doacao_item (id_doacao, id_item, quantidade, validade, numero_receita, id_profissional) VALUES
 (1, 1, 500, NULL, NULL, NULL),
 (2, 2, 150, NULL, NULL, NULL),
 (3, 3, 40, '2027-08-31', NULL, NULL),
 (3, 4, 30, '2027-06-30', NULL, NULL),
 (3, 5, 20, '2028-01-31', NULL, NULL),
 (3, 6, 10, '2027-03-31', 'REC-2026-0001', 1),
 (3, 7, 5, '2027-02-28', 'REC-2026-0002', 2),
 (4, 1, 80, NULL, NULL, NULL);
