delimiter $$

# Trigger para verificar status em movimentação
create trigger before_movimentacao_update
before update on movimentacao
for each row
begin
	if new.status = "Concluído" and new.dataEntrega is null then
		signal sqlstate "45000" set message_text = "Movimentações concluídas devem ter data de entrega.";
	end if;
    
    if old.status = "Cancelado" then
		signal sqlstate "45000" set message_text = "Movimentações canceladas não podem ser mais alteradas.";
	
    elseif old.status = "Concluído" then
		signal sqlstate "45000" set message_text = "Movimentações concluídas não podem ser mais alteradas.";
	end if;
end $$

# Trigger para verificar se já existe um tipo atribuído à Entrada
create trigger before_entrada_insert
before insert on entrada
for each row
begin
	declare vMovimentacaoExistente int;
    set vMovimentacaoExistente = movimentacaoExists(new.idMovimentacao);
    
    if vMovimentacaoExistente then
		signal sqlstate "45000" set message_text = "Movimentação já possui Entrada como tipo registrado.";
    end if;
end $$

# Trigger para verificar se já existe um tipo atribuído à Transferência
create trigger before_transferencia_insert
before insert on transferencia
for each row
begin
	declare vMovimentacaoExistente int;
    set vMovimentacaoExistente = movimentacaoExists(new.idMovimentacao);
    
    if vMovimentacaoExistente then
		signal sqlstate "45000" set message_text = "Movimentação já possui Transferência como tipo registrado.";
    end if;
end $$

# Trigger para verificar se já existe um tipo atribuído à Expedição
create trigger before_expedicao_insert
before insert on expedicao
for each row
begin
	declare vMovimentacaoExistente int;
    set vMovimentacaoExistente = movimentacaoExists(new.idMovimentacao);
    
    if vMovimentacaoExistente then
		signal sqlstate "45000" set message_text = "Movimentação já possui Expedição como tipo registrado.";
    end if;
end $$

# Trigger para inserir data de entrega após insert caso Agente de distribuição seja informado
create trigger after_expedicao_insert
after insert on expedicao
for each row
begin
	update movimentacao
		set dataEntrega = now()
		where idMovimentacao = new.idMovimentacao and dataEntrega is null;
end $$


# Trigger para verificar status em Entrada
create trigger before_entrada_update
before update on entrada
for each row
begin
	declare vMovStatus varchar(100);
    set vMovStatus = getMovimentacaoStatus(new.idMovimentacao);
    
	if vMovStatus = "Cancelado" then
		signal sqlstate "45000" set message_text = "Entradas canceladas não podem ser mais alteradas.";
    
    elseif vMovStatus = "Concluído" then
		signal sqlstate "45000" set message_text = "Entradas concluídas não podem ser mais alteradas.";
	end if;
end $$


# Trigger para verificar status em Transferência
create trigger before_transferencia_update
before update on transferencia
for each row
begin
	declare vMovStatus varchar(100);
    set vMovStatus = getMovimentacaoStatus(new.idMovimentacao);
    
	if vMovStatus = "Cancelado" then
		signal sqlstate "45000" set message_text = "Transferências canceladas não podem ser mais alteradas.";
    
    elseif vMovStatus = "Concluído" then
		signal sqlstate "45000" set message_text = "Transferências concluídas não podem ser mais alteradas.";
	end if;
end $$

# Trigger para verificar status em Expedição
create trigger before_expedicao_update
before update on expedicao
for each row
begin
	declare vMovStatus varchar(100);
    set vMovStatus = getMovimentacaoStatus(new.idMovimentacao);
    
    if new.idAgenteDistribuicao is null then
		signal sqlstate "45000" set message_text = "Agente de distribuição deve ser informado ao concluir expedição.";
	end if;
    
	if vMovStatus = "Cancelado" then
		signal sqlstate "45000" set message_text = "Expedições canceladas não podem ser mais alteradas.";
    
    elseif vMovStatus = "Concluído" then
		signal sqlstate "45000" set message_text = "Expedições concluídas não podem ser mais alteradas.";
	end if;
end $$

# Trigger para inserir data de entrega após update caso Agente de distribuição seja informado
create trigger after_expedicao_update
after update on expedicao
for each row
begin
	update movimentacao
		set dataEntrega = now()
		where idMovimentacao = new.idMovimentacao and dataEntrega is null;
end $$

# Trigger para verificar se validade do lote passada é válida após insert
create trigger before_lote_insert
before insert on lote
for each row
begin
	if new.dataValidade <= now() then
		signal sqlstate "45000" set message_text = "Lote não pode ter data de validade passada.";
	end if;
end $$

# Trigger para inserir código QR
create trigger after_lote_insert
after insert on lote
for each row
begin
	if new.codigoQr is null or trim(new.codigoQr) = "" then
		set new.codigoQr = concat(new.numero, "-", replace(dateFormatBR(new.dataValidade), "/", ""));
	end if;
end $$

# Trigger para verificar se validade do lote passada é válida e impedir alterações com mov existente ativo
create trigger before_lote_update
after update on lote
for each row
begin
	declare vMovimentacaoExistente int default 0;

	if new.dataValidade <= now() then
		signal sqlstate "45000" set message_text = "Lote não pode ter data de validade passada.";
	end if;
    
    select (
		exists(select * from movimentacao where movimentacao.idLote = lote.idLote and status != "Cancelado")
	)
	into vMovimentacaoExistente;
    
	if vMovimentacaoExistente then
		if new.qtdInicialKg != old.qtdInicialKg then
			signal sqlstate "45000" set message_text = "Quantidade inicial (KG) não pode ser alterada com registro de movimentação ativo.";
		end if;
		
        if new.numero != old.numero then
			signal sqlstate "45000" set message_text = "Número do lote não pode ser mudado com registro de movimentação ativo.";
		end if;
	end if;
end $$


	
delimiter ;
		
    
		
