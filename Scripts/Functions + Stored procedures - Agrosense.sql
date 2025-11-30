delimiter $$

# Formatar datetime 
create function datetimeFormatBR(pData datetime)
returns varchar(30) deterministic
begin
    return date_format(pData, '%d/%m/%Y %H:%i:%s');
end $$

# Formatar date 
create function dateFormatBR(pData datetime)
returns varchar(30) deterministic
begin
	return substring(datetimeformatBR(pData), 1, 10);
end $$

# Calcular diferença de horas entre duas datas
create function calcularDifHoras(pDataInicial datetime, pDataFinal datetime)
returns decimal(3, 1) deterministic
begin
	return timestampdiff(hour, pDataInicial, pDataFinal);
end $$

# Função para formatar ano/mês
create function dateFormatAnoMes(pData datetime)
returns varchar(7) deterministic
begin
    return date_format(pData, '%Y/%m');
end $$

# Função para formatar quantidade
create function formatarQtd(pQtd decimal(18,2))
returns varchar(30) deterministic
begin
    if pQtd is null or pQtd = 0 then
        return '-';
    else
        return round(pQtd, 2);
    end if;
end $$

# Função para formatar percentual
create function formatarQtdPercentual(pQtd decimal(10,2))
returns varchar(30) deterministic
begin
    if pQtd is null then
        return '-';
    else
        return concat(round(pQtd,2), '%');
    end if;
end $$

# Função para calcular percentual remanescente
create function calcularDifPercentual(pValorAtual decimal(18,2), pValorInicial decimal(18,2))
returns decimal(10,2) deterministic
begin
    declare resultado decimal(10,2);
    
    if pValorInicial is null or pValorInicial <= 0 then
        set resultado = 0.00;
    else
        set resultado = round((pValorAtual / pValorInicial) * 100, 2 );
    end if;
    
    return resultado;
end $$

# Função para retornar estoque
create function getEstoque(pIdArmazem int, pIdLote int)
returns decimal(10, 2) deterministic
reads sql data
begin
	declare vEstoque decimal(10, 2);
    
	select coalesce(qtdKg, 0) into vEstoque
	from Estoque
	where idArmazem = pIdArmazem
	and idLote = pIdLote;
    
    return vEstoque;
end $$

# Função para retornar armazém
create function getNomeArmazem(pIdArmazem int)
returns varchar(100) deterministic
reads sql data
begin
	declare vArmazemNome varchar(100);
    
    select nome into vArmazemNome
	from Armazem
	where idArmazem = pIdArmazem;
    
    return vArmazemNome;
end $$

# Função para verificar se uma movimentação já existe para um dos três tipos
create function movimentacaoExists(pIdMovimentacao int)
returns int deterministic
reads sql data
begin
	declare vExists int default 0;

    select (
		exists(select * from entrada where idMovimentacao = pIdMovimentacao) or
		exists(select * from transferencia where idMovimentacao = pIdMovimentacao) or
		exists(select * from expedicao where idMovimentacao = pIdMovimentacao)
	)
	into vExists;
    
    return vExists;
end $$

# Função que retorna o status de uma movimentação
create function getMovimentacaoStatus(pIdMovimentacao int)
returns varchar(100) deterministic
reads sql data
begin
	declare vStatus varchar(100);
    
    select status into vStatus 
    from movimentacao 
    where idMovimentacao = pIdMovimentacao;
    
    return vStatus;
end $$

# Função para retornar uma mensagem formatada de estoque insuficiente
create function msgEstoqueInsuficiente(pArmazemNome varchar(100), pValorDisponivel decimal(10, 2), pValorRequisitado decimal(10, 2))
returns varchar(250) deterministic
reads sql data
begin
	declare vMsg varchar(250);
    
    select concat(
		'Quantidade insuficiente no armazem ', vArmazemNome,
		'. Disponível=', pValorDisponivel,
		' Requisitado=', pValorRequisitado
	)
	into vMsg;
    
    return vMsg;
end $$

# Procedure para subtrair estoque
create procedure spSubtrairEstoque(in pNovaQtdKg decimal(10,2), in pIdArmazem int, in pIdLote int)
modifies sql data
begin
	update Estoque
		set qtdKg = qtdKg - pNovaQtdKg, ultimaAtualizacao = now()
		where idArmazem = pIdArmazem and idLote = pIdLote;
end $$

# Procedure para inserir ou atualizar estoque
create procedure spAdicionarEstoque(in pNovaQtdKg decimal(10,2), in pIdArmazem int, in pIdLote int)
modifies sql data
begin
	insert into Estoque (idLote, idArmazem, qtdKg, ultimaAtualizacao)
	values (pIdLote, pIdArmazem, pNovaQtdKg, now())
	on duplicate key update
		qtdKg = qtdKg + pNovaQtdKg,
		ultimaAtualizacao = now();
end $$

# Procedure para adicionar uma movimentação
create procedure spAdicionarMov(in pQtdKg decimal(10, 2), 
								in pIdArmazemOrigem int,
								in pIdArmazemDestino int,
								in pIdLote int, 
								in pIdOperadorArmazem int,
                                in pIdCooperativa int)
modifies sql data
begin
	declare vIdMov int;

	insert into movimentacao(dataRegistro, qtdKg, status, idLote, idOperadorArmazem)
    values (now(), pQtdKg, "Em andamento", pIdLote, pIdOperadorArmazem);
    
    set vIdMov = last_insert_id();
    
    if pIdArmazemDestino is not null and pIdArmazemOrigem is null then
		insert into entrada 
        values(vIdMov, pIdArmazemDestino);
    
    elseif pIdArmazemOrigem is not null and pIdArmazemDestino is not null then
		insert into transferencia 
		values(vIdMov, pIdArmazemOrigem, pIdArmazemDestino);
	
    elseif pIdArmazemOrigem is not null and pIdCooperativa is not null then
		insert into expedicao
		values (vIdMov, pIdArmazemOrigem, pIdCooperativa, null);
	end if;
end $$

#Procedure para atualizar uma movimentação
create procedure spAtualizarStatusMov(in pIdMovimentacao int, 
                                      in pIdAgenteDistribuicao int,
									  in pStatus varchar(100))
modifies sql data
begin
	declare vQtdKg decimal(10, 2);
    declare vIdArmazemOrigem int;
    declare vIdArmazemDestino int;
    declare vIdLote int;
    
    if not exists(select * from movimentacao where idMovimentacao = pIdMovimentacao) then
		signal sqlstate "45000" set message_text = "Movimentação informada não existe.";
    end if;
    
    if pStatus not in ("Concluído", "Em andamento", "Cancelado") then
		signal sqlstate "45000" set message_text = "Status informado inválido.";
	end if;
    
    if pStatus = "Concluído" then
		select qtdKg, idLote into vQtdKg, vIdLote
        from movimentacao 
        where idMovimentacao = pIdMovimentacao;
        
		if exists(select * from entrada where idMovimentacao = pIdMovimentacao) then
			select idArmazemDestino into vIdArmazemDestino 
			from entrada
			where idMovimentacao = pIdMovimentacao; 
                
            if vIdArmazemDestino is not null then    
                call spAdicionarEstoque(vQtdKg, vIdArmazemDestino, vIdLote);
            end if;
    
		elseif exists(select * from transferencia where idMovimentacao = pIdMovimentacao) then
			select idArmazemOrigem, idArmazemDestino into vIdArmazemOrigem, vIdArmazemDestino
			from transferencia
			where idMovimentacao = pIdMovimentacao;
            
            if vIdArmazemOrigem is not null and vIdArmazemDestino is not null then    
				call spSubtrairEstoque(vQtdKg, vIdArmazemOrigem, vIdLote);
				call spAdicionarEstoque(vQtdKg, vIdArmazemDestino, vIdLote);
			end if;
        
        elseif exists(select * from expedicao where idMovimentacao = pIdMovimentacao) then
			if pIdAgenteDistribuicao is null then
				signal sqlstate "45000" set message_text = "Agente de distribuição deve ser informado ao concluir expedição.";
			else
				update expedicao
					set idAgenteDistribuicao = pIdAgenteDistribuicao
					where idMovimentacao = pIdMovimentacao;
			end if;
            
            select idArmazemOrigem into vIdArmazemOrigem
			from expedicao
			where idMovimentacao = pIdMovimentacao;
            
            if vIdArmazemOrigem is not null then
				call spSubtrairEstoque(vQtdKg, vIdArmazemOrigem, vIdLote);		
            end if;
		end if;
    
		update movimentacao
			set dataEntrega = now()
			where idMovimentacao = pIdMovimentacao;
        end if;    

	update movimentacao 
		set status = pStatus
		where idMovimentacao = pIdMovimentacao;
end $$




