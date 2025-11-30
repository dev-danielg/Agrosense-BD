-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema BD-ProgAqsDistSemente
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema BD-ProgAqsDistSemente
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `BD-ProgAqsDistSemente` DEFAULT CHARACTER SET utf8 ;
USE `BD-ProgAqsDistSemente` ;

-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Endereco` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `UF` CHAR(2) NOT NULL,
  `estado` VARCHAR(100) NOT NULL,
  `bairro` VARCHAR(100) NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `cep` VARCHAR(9) NOT NULL,
  `numero` INT UNSIGNED NOT NULL,
  `comp` VARCHAR(150) NULL,
  PRIMARY KEY (`idEndereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Armazem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Armazem` (
  `idArmazem` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(100) NOT NULL,
  `status` ENUM("Ativo", "Inativo") NOT NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idArmazem`),
  INDEX `fk_Armazem_Endereco1_idx` (`idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_Armazem_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `BD-ProgAqsDistSemente`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Especie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Especie` (
  `idEspecie` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(50) NOT NULL,
  `variedade` VARCHAR(50) NULL,
  PRIMARY KEY (`idEspecie`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(150) NOT NULL,
  `senha` VARCHAR(100) NOT NULL,
  `cpfCnpj` VARCHAR(20) NOT NULL,
  `email` VARCHAR(100) NULL,
  `telefone` VARCHAR(15) NULL,
  `status` ENUM("Ativo", "Rejeitado", "Pendente") NOT NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `fk_Usuario_Endereco1_idx` (`idEndereco` ASC) VISIBLE,
  UNIQUE INDEX `idEndereco_UNIQUE` (`idEndereco` ASC) VISIBLE,
  UNIQUE INDEX `cpfCnpj_UNIQUE` (`cpfCnpj` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `BD-ProgAqsDistSemente`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Fornecedor` (
  `idFornecedor` INT NOT NULL,
  PRIMARY KEY (`idFornecedor`),
  CONSTRAINT `fk_Fornecedor_Usuario1`
    FOREIGN KEY (`idFornecedor`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Lote`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Lote` (
  `idLote` INT NOT NULL AUTO_INCREMENT,
  `numero` VARCHAR(100) NOT NULL,
  `codigoQr` VARCHAR(100) NOT NULL,
  `dataValidade` DATE NOT NULL,
  `qtdInicialKg` DECIMAL(10,2) UNSIGNED NOT NULL,
  `idEspecie` INT NOT NULL,
  `idFornecedor` INT NOT NULL,
  PRIMARY KEY (`idLote`),
  INDEX `fk_Lote_Especie_idx` (`idEspecie` ASC) VISIBLE,
  UNIQUE INDEX `numero_UNIQUE` (`numero` ASC) VISIBLE,
  INDEX `fk_Lote_Fornecedor1_idx` (`idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Lote_Especie`
    FOREIGN KEY (`idEspecie`)
    REFERENCES `BD-ProgAqsDistSemente`.`Especie` (`idEspecie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lote_Fornecedor1`
    FOREIGN KEY (`idFornecedor`)
    REFERENCES `BD-ProgAqsDistSemente`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`OperadorArmazem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`OperadorArmazem` (
  `idOperadorArmazem` INT NOT NULL,
  PRIMARY KEY (`idOperadorArmazem`),
  INDEX `fk_OperadorDeArmazem_Usuario1_idx` (`idOperadorArmazem` ASC) VISIBLE,
  CONSTRAINT `fk_OperadorDeArmazem_Usuario1`
    FOREIGN KEY (`idOperadorArmazem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Movimentacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Movimentacao` (
  `idMovimentacao` INT NOT NULL AUTO_INCREMENT,
  `dataRegistro` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dataEntrega` DATETIME NULL,
  `qtdKg` DECIMAL(10,2) UNSIGNED NOT NULL,
  `status` ENUM("Em análise", "Em andamento", "Concluído", "Cancelado") NOT NULL,
  `idLote` INT NOT NULL,
  `idOperadorArmazem` INT NOT NULL,
  PRIMARY KEY (`idMovimentacao`),
  INDEX `fk_Movimentacao_Lote1_idx` (`idLote` ASC) VISIBLE,
  INDEX `fk_Movimentacao_OperadorDeArmz1_idx` (`idOperadorArmazem` ASC) VISIBLE,
  CONSTRAINT `fk_Movimentacao_Lote1`
    FOREIGN KEY (`idLote`)
    REFERENCES `BD-ProgAqsDistSemente`.`Lote` (`idLote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_OperadorDeArmz1`
    FOREIGN KEY (`idOperadorArmazem`)
    REFERENCES `BD-ProgAqsDistSemente`.`OperadorArmazem` (`idOperadorArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Cooperativa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Cooperativa` (
  `idCooperativa` INT NOT NULL AUTO_INCREMENT,
  `cnpj` VARCHAR(20) NOT NULL,
  `razaoSocial` VARCHAR(100) NOT NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idCooperativa`),
  INDEX `fk_Cooperativa_Endereco1_idx` (`idEndereco` ASC) VISIBLE,
  UNIQUE INDEX `idEndereco_UNIQUE` (`idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_Cooperativa_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `BD-ProgAqsDistSemente`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`AgenteDistribuicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`AgenteDistribuicao` (
  `idAgenteDistribuicao` INT NOT NULL,
  PRIMARY KEY (`idAgenteDistribuicao`),
  CONSTRAINT `fk_AgenteDeDist_Usuario1`
    FOREIGN KEY (`idAgenteDistribuicao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Gestor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Gestor` (
  `idGestor` INT NOT NULL,
  PRIMARY KEY (`idGestor`),
  CONSTRAINT `fk_Gestor_Usuario1`
    FOREIGN KEY (`idGestor`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Estoque` (
  `idLote` INT NOT NULL,
  `idArmazem` INT NOT NULL,
  `qtdKg` DECIMAL(10,2) UNSIGNED NOT NULL,
  `ultimaAtualizacao` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idLote`, `idArmazem`),
  INDEX `fk_Lote_has_Armazem_Armazem1_idx` (`idArmazem` ASC) VISIBLE,
  INDEX `fk_Lote_has_Armazem_Lote1_idx` (`idLote` ASC) VISIBLE,
  CONSTRAINT `fk_Lote_has_Armazem_Lote1`
    FOREIGN KEY (`idLote`)
    REFERENCES `BD-ProgAqsDistSemente`.`Lote` (`idLote`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lote_has_Armazem_Armazem1`
    FOREIGN KEY (`idArmazem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Transferencia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Transferencia` (
  `idMovimentacao` INT NOT NULL,
  `idArmazemOrigem` INT NOT NULL,
  `idArmazemDestino` INT NOT NULL,
  PRIMARY KEY (`idMovimentacao`),
  INDEX `fk_Transferência_Armazem1_idx` (`idArmazemOrigem` ASC) VISIBLE,
  INDEX `fk_Transferência_Armazem2_idx` (`idArmazemDestino` ASC) VISIBLE,
  CONSTRAINT `fk_table1_Movimentacao1`
    FOREIGN KEY (`idMovimentacao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Movimentacao` (`idMovimentacao`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transferência_Armazem1`
    FOREIGN KEY (`idArmazemOrigem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Transferência_Armazem2`
    FOREIGN KEY (`idArmazemDestino`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Entrada`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Entrada` (
  `idMovimentacao` INT NOT NULL,
  `idArmazemDestino` INT NOT NULL,
  PRIMARY KEY (`idMovimentacao`),
  INDEX `fk_Entrada_Armazem1_idx` (`idArmazemDestino` ASC) VISIBLE,
  CONSTRAINT `fk_Entrada_Movimentacao1`
    FOREIGN KEY (`idMovimentacao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Movimentacao` (`idMovimentacao`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Entrada_Armazem1`
    FOREIGN KEY (`idArmazemDestino`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Expedicao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Expedicao` (
  `idMovimentacao` INT NOT NULL,
  `idArmazemOrigem` INT NOT NULL,
  `idCooperativa` INT NOT NULL,
  `idAgenteDistribuicao` INT NULL,
  PRIMARY KEY (`idMovimentacao`),
  INDEX `fk_Expedicao_Armazem1_idx` (`idArmazemOrigem` ASC) VISIBLE,
  INDEX `fk_Expedicao_AgenteDistribuicao1_idx` (`idAgenteDistribuicao` ASC) VISIBLE,
  INDEX `fk_Expedicao_Cooperativa1_idx` (`idCooperativa` ASC) VISIBLE,
  CONSTRAINT `fk_Expedicao_Movimentacao1`
    FOREIGN KEY (`idMovimentacao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Movimentacao` (`idMovimentacao`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Expedicao_Armazem1`
    FOREIGN KEY (`idArmazemOrigem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Expedicao_AgenteDistribuicao1`
    FOREIGN KEY (`idAgenteDistribuicao`)
    REFERENCES `BD-ProgAqsDistSemente`.`AgenteDistribuicao` (`idAgenteDistribuicao`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Expedicao_Cooperativa1`
    FOREIGN KEY (`idCooperativa`)
    REFERENCES `BD-ProgAqsDistSemente`.`Cooperativa` (`idCooperativa`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
