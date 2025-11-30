-- Inserções compatíveis com DDL-ProgAqsDistSementeV2.sql
USE `BD-ProgAqsDistSemente`;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS; SET UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS; SET FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE; SET SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- 1) Endereco (20)
INSERT INTO Endereco (idEndereco, UF, estado, bairro, rua, cep, numero, comp) VALUES
(1,'PE','Pernambuco','Boa Vista','Rua das Flores','50000-010',123,NULL),
(2,'PE','Pernambuco','Vila Nova','Av. Central','55000-020',200,'Sala 2'),
(3,'PE','Pernambuco','Centro','Rua do Comércio','56300-030',45,NULL),
(4,'PB','Paraíba','Bessa','Av. Litorânea','58000-040',1000,NULL),
(5,'PB','Paraíba','Tambor','Rua 7','58400-050',78,NULL),
(6,'CE','Ceará','Aldeota','Av. Central','60000-060',600,NULL),
(7,'RN','Rio Grande do Norte','Ponta Negra','Rua do Sol','59000-070',12,NULL),
(8,'BA','Bahia','Barra','Av. Oceânica','40000-080',300,NULL),
(9,'SE','Sergipe','Centro','Rua 21','49000-090',21,NULL),
(10,'AL','Alagoas','Jaraguá','Av. Sete','57000-100',77,NULL),
(11,'PE','Pernambuco','Vila Rica','Rua X','53100-110',10,NULL),
(12,'PE','Pernambuco','Água Fria','Rua Y','55200-120',50,NULL),
(13,'PE','Pernambuco','Tabatinga','Rua Z','53400-130',5,NULL),
(14,'MG','Minas Gerais','Funcionários','Av. Afonso Pena','30100-140',1200,NULL),
(15,'SP','São Paulo','Vila Esperança','Rua Arte','05400-150',220,NULL),
(16,'RJ','Rio de Janeiro','Laranjeiras','Rua Lírio','22240-160',50,NULL),
(17,'ES','Espírito Santo','Boa Vista Sul','Av. das Árvores','29000-170',400,NULL),
(18,'GO','Goiás','Setor Oeste','Av. Goiás','74000-180',450,NULL),
(19,'MT','Mato Grosso','Jardim','Av. dos Rios','78000-190',100,NULL),
(20,'MS','Mato Grosso do Sul','Centro','Rua das Nações','79000-200',10,NULL);

-- 2) Usuario (20)
INSERT INTO Usuario (idUsuario, nome, senha, cpfCnpj, email, telefone, status, idEndereco) VALUES
(1,'Maria Oliveira','pwd_maria','12345678901','maria.oliveira@coopalto.com.br','81991230001','Ativo',1),
(2,'José Silva','pwd_jose','23456789002','jose.silva@prefrecife.gov.br','81991230002','Ativo',2),
(3,'João Pereira','pwd_joao','34567890103','joao.pereira@armazempetrol.com','81991230003','Ativo',3),
(4,'Fernando Souza','pwd_fernando','45678901204','fernando.souza@fornseed.com','81991230004','Ativo',4),
(5,'Ana Costa','pwd_ana','56789012305','ana.costa@coopvale.org','81991230005','Ativo',5),
(6,'Paulo Ramos','pwd_paulo','67890123406','paulo.ramos@distagro.com','81991230006','Ativo',6),
(7,'Carla Martins','pwd_carla','78901234507','carla.martins@cooperativa1.org','81991230007','Ativo',7),
(8,'Ricardo Lima','pwd_ricardo','89012345608','ricardo.lima@agro.com','81991230008','Ativo',8),
(9,'Lúcia Ferreira','pwd_lucia','90123456709','lucia.ferreira@coopnorte.com','81991230009','Ativo',9),
(10,'Marcos Andrade','pwd_marcos','01234567890','marcos.andrade@armazemsp.com','81991230010','Ativo',10),
(11,'Helena Rocha','pwd_helena','11222333411','helena.rocha@coopeste.com','81991230011','Ativo',11),
(12,'Gustavo Menezes','pwd_gustavo','22333444512','gustavo.menezes@fornseed.com','81991230012','Ativo',12),
(13,'Patrícia Gomes','pwd_patricia','33444555613','patricia.gomes@coopcentral.com','81991230013','Ativo',13),
(14,'Roberto Santos','pwd_roberto','44555666714','roberto.santos@transportes.com','81991230014','Ativo',14),
(15,'Sofia Almeida','pwd_sofia','55666777815','sofia.almeida@coopleste.org','81991230015','Ativo',15),
(16,'Eduardo Pinto','pwd_eduardo','66777888916','eduardo.pinto@logistica.com','81991230016','Ativo',16),
(17,'Mariana Silva','pwd_mariana','77888999017','mariana.silva@coopsul.org','81991230017','Ativo',17),
(18,'Diego Carvalho','pwd_diego','88999000118','diego.carvalho@distribgo.com','81991230018','Ativo',18),
(19,'Vera Nunes','pwd_vera','99000111219','vera.nunes@coopnordeste.org','81991230019','Ativo',19),
(20,'Bruno Teixeira','pwd_bruno','00111222320','bruno.teixeira@coopcentro.org','81991230020','Ativo',20);

-- 3) Fornecedor (20) -- referencia Usuario
INSERT INTO Fornecedor (idFornecedor) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);

-- 4) Especie (20)
INSERT INTO Especie (idEspecie, nome, variedade) VALUES
(1,'Milho','Híbrido A'),
(2,'Milho','Híbrido B'),
(3,'Feijão','Carioca'),
(4,'Feijão','Preto'),
(5,'Soja','RR'),
(6,'Trigo','BRS 394'),
(7,'Sorgo','S-100'),
(8,'Arroz','IAC 202'),
(9,'Amendoim','Virginia'),
(10,'Girassol','G-1'),
(11,'Feijão','Caupi'),
(12,'Milho','Safrinha'),
(13,'Feijão','Jalo'),
(14,'Soja','Comum'),
(15,'Trigo','T-2'),
(16,'Arroz','IRGA 423'),
(17,'Cevada','C-1'),
(18,'Sorgo','S-200'),
(19,'Milhete','M-1'),
(20,'Arroz','Tropical');

-- 5) Armazem (20)
INSERT INTO Armazem (idArmazem, nome, status, idEndereco) VALUES
(1,'Armazém Central - Recife','Ativo',1),
(2,'Armazém Regional - Caruaru','Ativo',2),
(3,'Depósito Petrolina','Ativo',3),
(4,'Ponto João Pessoa','Ativo',4),
(5,'Depósito Campina Grande','Ativo',5),
(6,'Centro Logístico Fortaleza','Ativo',6),
(7,'Armazém Natal','Ativo',7),
(8,'Armazém Salvador','Ativo',8),
(9,'Depósito Aracaju','Ativo',9),
(10,'Depósito Maceió','Ativo',10),
(11,'Armazém Igarassu','Ativo',11),
(12,'Armazém Garanhuns','Ativo',12),
(13,'Armazém Paulista','Ativo',13),
(14,'Depósito Belo Horizonte','Ativo',14),
(15,'Armazém São Paulo Leste','Ativo',15),
(16,'Depósito Rio Zona Sul','Ativo',16),
(17,'Armazém Vitória','Ativo',17),
(18,'Centro Logístico Goiânia','Ativo',18),
(19,'Depósito Cuiabá','Ativo',19),
(20,'Armazém Campo Grande','Ativo',20);

-- 6) Cooperativa (20)
INSERT INTO Cooperativa (idCooperativa, cnpj, razaoSocial, idEndereco) VALUES
(1,'12.345.678/0001-11','Cooperativa Alto Vale',1),
(2,'22.555.444/0001-02','Cooperativa Vale Verde',2),
(3,'33.666.777/0001-03','Coop Agro Sertão',3),
(4,'44.777.888/0001-04','Coop Regional Leste',4),
(5,'55.888.999/0001-05','Cooperativa Central',5),
(6,'66.999.000/0001-06','Coop Sul',6),
(7,'77.111.222/0001-07','Coop Norte',7),
(8,'88.222.333/0001-08','Cooperativa do Agreste',8),
(9,'99.333.444/0001-09','Cooperativa Vale do São Francisco',9),
(10,'10.444.555/0001-10','Coop Metropolitana',10),
(11,'11.555.666/0001-11','Cooperativa Litoral',11),
(12,'12.666.777/0001-12','Cooperativa Cerrado',12),
(13,'13.777.888/0001-13','Coop Planalto',13),
(14,'14.888.999/0001-14','Coop Paulista',14),
(15,'15.999.111/0001-15','Cooperativa Fluminense',15),
(16,'16.111.222/0001-16','Coop Capixaba',16),
(17,'17.222.333/0001-17','Cooperativa Goiana',17),
(18,'18.333.444/0001-18','Cooperativa Mato Grosso',18),
(19,'19.444.555/0001-19','Cooperativa Pantanal',19),
(20,'20.555.666/0001-20','Cooperativa Amazônia',20);

-- 7) OperadorArmazem (20) -- PK = Usuario.idUsuario
INSERT INTO OperadorArmazem (idOperadorArmazem) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);

-- 8) AgenteDistribuicao (20) -- PK = Usuario.idUsuario
INSERT INTO AgenteDistribuicao (idAgenteDistribuicao) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);

-- 9) Gestor (20) -- PK = Usuario.idUsuario
INSERT INTO Gestor (idGestor) VALUES
(1),(2),(3),(4),(5),(6),(7),(8),(9),(10),
(11),(12),(13),(14),(15),(16),(17),(18),(19),(20);

-- 10) Lote (20)
INSERT INTO Lote (idLote, numero, codigoQr, dataValidade, qtdInicialKg, idEspecie, idFornecedor) VALUES
(1,'L-REC-001','QR-L001','2026-03-31',5000.00,1,4),
(2,'L-REC-002','QR-L002','2026-04-30',3000.00,3,1),
(3,'L-CAR-001','QR-L003','2026-05-30',4000.00,2,2),
(4,'L-PET-001','QR-L004','2026-06-15',2500.00,5,6),
(5,'L-JPA-001','QR-L005','2026-07-20',2000.00,4,8),
(6,'L-CG-001','QR-L006','2026-08-10',6000.00,6,5),
(7,'L-FOR-001','QR-L007','2026-09-05',3500.00,7,3),
(8,'L-NAT-001','QR-L008','2026-10-12',4200.00,8,7),
(9,'L-SAL-001','QR-L009','2026-11-01',1500.00,9,9),
(10,'L-MAC-001','QR-L010','2026-12-31',8000.00,10,10),
(11,'L-TER-001','QR-L011','2027-01-31',10000.00,11,11),
(12,'L-SLM-001','QR-L012','2027-02-28',9000.00,12,12),
(13,'L-BEL-001','QR-L013','2027-03-31',7000.00,13,13),
(14,'L-BH-001','QR-L014','2027-04-30',4500.00,14,14),
(15,'L-SP-001','QR-L015','2027-05-31',11000.00,15,15),
(16,'L-RJ-001','QR-L016','2027-06-30',3000.00,16,16),
(17,'L-VIT-001','QR-L017','2027-07-31',2600.00,17,17),
(18,'L-GOI-001','QR-L018','2027-08-31',5200.00,18,18),
(19,'L-CUI-001','QR-L019','2027-09-30',4800.00,19,19),
(20,'L-CG-002','QR-L020','2027-10-31',3800.00,20,20);

-- 11) Movimentacao (20) -- apenas campos comuns (tipo/details nas tabelas especificas abaixo)
INSERT INTO Movimentacao (idMovimentacao, dataRegistro, dataEntrega, qtdKg, status, idLote, idOperadorArmazem) VALUES
(1,'2025-06-10 09:00:00', NULL, 5000.00, 'Concluído', 1, 1),
(2,'2025-06-11 10:20:00', NULL, 3000.00, 'Concluído', 2, 2),
(3,'2025-06-12 11:10:00', NULL, 4000.00, 'Concluído', 3, 3),
(4,'2025-06-13 08:30:00', NULL, 2500.00, 'Concluído', 4, 4),
(5,'2025-06-14 09:45:00', NULL, 2000.00, 'Concluído', 5, 5),
(6,'2025-06-20 14:00:00', NULL, 1200.00, 'Concluído', 1, 6),
(7,'2025-06-21 15:30:00', NULL, 800.00,  'Concluído', 2, 7),
(8,'2025-06-22 16:00:00', NULL, 600.00,  'Concluído', 3, 8),
(9,'2025-06-23 14:30:00', NULL, 500.00,  'Concluído', 4, 9),
(10,'2025-06-24 13:15:00', NULL, 700.00, 'Concluído', 5, 10),
(11,'2025-07-01 09:00:00', NULL, 6000.00, 'Concluído', 6, 11),
(12,'2025-07-02 10:00:00', NULL, 3500.00, 'Concluído', 7, 12),
(13,'2025-07-03 11:00:00', NULL, 4200.00, 'Concluído', 8, 13),
(14,'2025-07-04 12:00:00', NULL, 1500.00, 'Concluído', 9, 14),
(15,'2025-07-05 13:00:00', NULL, 8000.00, 'Concluído',10, 15),
(16,'2025-07-10 08:30:00', NULL, 1500.00, 'Concluído', 1, 16),
(17,'2025-07-11 11:00:00', NULL, 2000.00, 'Concluído', 3, 17),
(18,'2025-07-12 09:00:00', NULL, 1000.00, 'Concluído', 2, 18),
(19,'2025-07-13 08:00:00','2025-07-13 12:00:00', 300.00, 'Concluído', 1, 19),
(20,'2025-07-14 09:30:00','2025-07-14 13:00:00', 200.00, 'Concluído', 2, 20);

-- 12) Entrada (apontando idMovimentacao -> idArmazemDestino)
INSERT INTO Entrada (idMovimentacao, idArmazemDestino) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 3),
(11, 3),
(12, 4),
(13, 4),
(14, 5),
(15, 5);

-- 13) Transferencia (idMovimentacao -> origem/destino)
INSERT INTO Transferencia (idMovimentacao, idArmazemOrigem, idArmazemDestino) VALUES
(6, 1, 2),
(7, 1, 3),
(8, 2, 4),
(9, 2, 5),
(10, 3, 6),
(16,1, 4), -- ajuste: origem 1 para coerência com histórico
(17,2, 1),
(18,1, 5);

-- 14) Expedicao (idMovimentacao -> origem, cooperativa, agente)
INSERT INTO Expedicao (idMovimentacao, idArmazemOrigem, idCooperativa, idAgenteDistribuicao) VALUES
(19, 2, 1, 19),
(20, 3, 2, 20);

-- 15) Estoque (valores coerentes com as movimentações acima)
INSERT INTO Estoque (idLote, idArmazem, qtdKg, ultimaAtualizacao) VALUES
(1, 1, 2300.00, '2025-07-15 10:00:00'),
(1, 2,  900.00, '2025-07-15 10:00:00'),
(1, 4, 1500.00, '2025-07-15 10:00:00'),
(2, 1, 1200.00, '2025-07-15 10:00:00'),
(2, 3,  600.00, '2025-07-15 10:00:00'),
(2, 5, 1000.00, '2025-07-15 10:00:00'),
(3, 2, 1400.00, '2025-07-15 10:00:00'),
(3, 4,  600.00, '2025-07-15 10:00:00'),
(3, 1, 2000.00, '2025-07-15 10:00:00'),
(4, 2, 2000.00, '2025-07-15 10:00:00'),
(4, 5,  500.00, '2025-07-15 10:00:00'),
(5, 3, 1300.00, '2025-07-15 10:00:00'),
(5, 6,  700.00, '2025-07-15 10:00:00'),
(6, 3, 6000.00, '2025-07-15 10:00:00'),
(7, 4, 3500.00, '2025-07-15 10:00:00'),
(8, 4, 4200.00, '2025-07-15 10:00:00'),
(9, 5, 1500.00, '2025-07-15 10:00:00'),
(10,5, 8000.00, '2025-07-15 10:00:00'),
(11,6,10000.00,'2025-07-15 10:00:00');

-- final
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
