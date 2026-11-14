-- ProBem · seed.sql
SET NAMES utf8mb4;
USE probem;

INSERT INTO voluntario (nome, funcao, setor, crm, eh_medico) VALUES
 ('Helena Duarte Campos', 'Diretora-presidente', 'Diretoria', NULL, FALSE),
 ('Roberto Aguiar Nunes', 'Chefe de operações', 'Logística', NULL, FALSE),
 ('Dra. Marina Teles Rocha', 'Médica voluntária', 'Saúde', 'CRM-SP 000000', TRUE),
 ('Dr. Paulo Henrique Lima', 'Médico voluntário', 'Saúde', 'CRM-SP 111111', TRUE),
 ('Sônia Maria Barbosa', 'Conselheira', 'Representante da comunidade', NULL, FALSE),
 ('Pe. Antônio Ferraz', 'Conselheiro', 'Representante religioso', NULL, FALSE),
 ('Cláudia Ribeiro Matos', 'Conselheira', 'Representante do comércio local', NULL, FALSE),
 ('Prof. Marcos Vieira', 'Conselheiro', 'Representante da educação', NULL, FALSE);

INSERT INTO medicamento (nome, exige_receita) VALUES
 ('Dipirona 500 mg', FALSE),
 ('Paracetamol 750 mg', FALSE),
 ('Amoxicilina 500 mg', TRUE),
 ('Losartana 50 mg', TRUE),
 ('Soro fisiológico 500 ml', FALSE);

INSERT INTO doador (nome, email, telefone, documento, endereco) VALUES
 ('Ana Souza', 'ana.souza@exemplo.com', '(11) 98888-1001', '000.000.000-00', 'Rua das Flores, 100, São Paulo'),
 ('Mercado Bom Preço', 'contato@bompreco.exemplo.com', '(11) 3333-1000', '00.000.000/0001-00', 'Av. Central, 500, São Paulo'),
 ('Carlos Lima', NULL, '(11) 97777-1002', '111.111.111-11', NULL);

INSERT INTO doacao (id_doador, tipo, data_doacao, observacao) VALUES
 (1, 'dinheiro', '2026-11-03', 'Doação por Pix'),
 (2, 'dinheiro', '2026-11-05', 'Doação por boleto'),
 (3, 'medicamento', '2026-11-08', NULL);

INSERT INTO doacao_dinheiro (id_doacao, forma, valor, status, confirmacao_email) VALUES
 (1, 'pix', 150.00, 'confirmado', 'Confirmação enviada para ana.souza@exemplo.com (simulada)'),
 (2, 'boleto', 500.00, 'pendente', NULL);

INSERT INTO doacao_medicamento (id_doacao, id_medicamento, quantidade, validade, status_avaliacao, id_medico) VALUES
 (3, 1, 20, '2027-06-30', 'nao_exige', NULL),
 (3, 3, 10, '2027-03-31', 'pendente', NULL);