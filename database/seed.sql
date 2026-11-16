-- ConectaDoa Pro Bem · seed.sql (dados fictícios)
SET NAMES utf8mb4;
USE conectadoa;

INSERT INTO categoria (nome) VALUES
  ('Dinheiro'),
  ('Medicamento'),
  ('Higiene');

INSERT INTO item (id_categoria, nome, unidade) VALUES
  (1, 'Doação em dinheiro (Pix)', 'reais'),
  (1, 'Doação em dinheiro (Cartão)', 'reais'),
  (2, 'Dipirona 500 mg (venda livre)', 'caixa'),
  (2, 'Paracetamol 750 mg (venda livre)', 'caixa'),
  (2, 'Soro fisiológico 500 ml', 'frasco'),
  (2, 'Amoxicilina 500 mg (com restrição: médico)', 'caixa'),
  (2, 'Insulina NPH (com restrição: médico)', 'frasco'),
  (3, 'Sabonete', 'unidade'),
  (3, 'Fralda infantil', 'pacote');

INSERT INTO doador (nome, email, telefone) VALUES
  ('Mercado Bom Preço', 'contato@bompreco.exemplo.com', '(11) 3333-1000'),
  ('Ana Souza', 'ana.souza@exemplo.com', '(11) 98888-1001'),
  ('Carlos Lima', NULL, '(11) 97777-1002'),
  ('Farmácia Vida Plena', 'contato@vidaplena.exemplo.com', '(11) 3333-2000');

INSERT INTO doacao (id_doador, data_doacao, observacao) VALUES
  (1, '2026-10-05', 'Doação via Pix da campanha de outubro'),
  (2, '2026-10-12', 'Pagamento no cartão pelo link seguro'),
  (4, '2026-10-18', 'Medicamentos conferidos pela farmacêutica voluntária');

INSERT INTO doacao_item (id_doacao, id_item, quantidade) VALUES
  (1, 1, 500),
  (2, 2, 150),
  (3, 3, 40),
  (3, 4, 30),
  (3, 5, 20),
  (3, 6, 10);