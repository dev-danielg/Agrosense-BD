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
  `tipo` ENUM("Gestor", "OperadorArmazem", "AgenteDistribuicao", "Agricultor") NOT NULL,
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
  INDEX `fk_Lote_Usuario1_idx` (`idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Lote_Especie`
    FOREIGN KEY (`idEspecie`)
    REFERENCES `BD-ProgAqsDistSemente`.`Especie` (`idEspecie`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Lote_Usuario1`
    FOREIGN KEY (`idFornecedor`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `BD-ProgAqsDistSemente`.`Solicitacao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `BD-ProgAqsDistSemente`.`Solicitacao` (
  `idSolicitacao` INT NOT NULL AUTO_INCREMENT,
  `dataSolicitacao` DATETIME NOT NULL,
  `status` ENUM("Pendente", "Concluído", "Rejeitado") NOT NULL,
  `idAgricultor` INT NOT NULL,
  `idGestorIPA` INT NULL,
  `motivoRejeicao` VARCHAR(300) NULL,
  INDEX `fk_Solicitacao_Usuario1_idx` (`idGestorIPA` ASC) VISIBLE,
  PRIMARY KEY (`idSolicitacao`),
  INDEX `fk_Solicitacao_Usuario2_idx` (`idAgricultor` ASC) VISIBLE,
  CONSTRAINT `fk_Solicitacao_Usuario1`
    FOREIGN KEY (`idGestorIPA`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Solicitacao_Usuario2`
    FOREIGN KEY (`idAgricultor`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
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
  `idSolicitacao` INT NOT NULL,
  `idArmazemOrigem` INT NULL,
  `idArmazemDestino` INT NULL,
  `idAgenteDistribuicao` INT NULL,
  PRIMARY KEY (`idMovimentacao`),
  INDEX `fk_Movimentacao_Lote1_idx` (`idLote` ASC) VISIBLE,
  INDEX `fk_Movimentacao_Usuario1_idx` (`idOperadorArmazem` ASC) VISIBLE,
  INDEX `fk_Movimentacao_Armazem1_idx` (`idArmazemOrigem` ASC) VISIBLE,
  INDEX `fk_Movimentacao_Armazem2_idx` (`idArmazemDestino` ASC) VISIBLE,
  INDEX `fk_Movimentacao_Usuario2_idx` (`idAgenteDistribuicao` ASC) VISIBLE,
  INDEX `fk_Movimentacao_Solicitacao1_idx` (`idSolicitacao` ASC) VISIBLE,
  CONSTRAINT `fk_Movimentacao_Lote1`
    FOREIGN KEY (`idLote`)
    REFERENCES `BD-ProgAqsDistSemente`.`Lote` (`idLote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_Usuario1`
    FOREIGN KEY (`idOperadorArmazem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_Armazem1`
    FOREIGN KEY (`idArmazemOrigem`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_Armazem2`
    FOREIGN KEY (`idArmazemDestino`)
    REFERENCES `BD-ProgAqsDistSemente`.`Armazem` (`idArmazem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_Usuario2`
    FOREIGN KEY (`idAgenteDistribuicao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Movimentacao_Solicitacao1`
    FOREIGN KEY (`idSolicitacao`)
    REFERENCES `BD-ProgAqsDistSemente`.`Solicitacao` (`idSolicitacao`)
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
  `idGestorCooperativa` INT NOT NULL,
  `idEndereco` INT NOT NULL,
  PRIMARY KEY (`idCooperativa`),
  INDEX `fk_Cooperativa_Endereco1_idx` (`idEndereco` ASC) VISIBLE,
  UNIQUE INDEX `idEndereco_UNIQUE` (`idEndereco` ASC) VISIBLE,
  INDEX `fk_Cooperativa_Usuario1_idx` (`idGestorCooperativa` ASC) VISIBLE,
  CONSTRAINT `fk_Cooperativa_Endereco1`
    FOREIGN KEY (`idEndereco`)
    REFERENCES `BD-ProgAqsDistSemente`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cooperativa_Usuario1`
    FOREIGN KEY (`idGestorCooperativa`)
    REFERENCES `BD-ProgAqsDistSemente`.`Usuario` (`idUsuario`)
    ON DELETE NO ACTION
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


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
