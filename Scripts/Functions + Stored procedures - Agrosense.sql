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
reads sql data
begin
	return timestampdiff(hour, pDataInicial, pDataFinal);
end $$

# Função para formatar ano/mês
create function dateFormatAnoMes(pData datetime)
returns varchar(7) deterministic
reads sql data
begin
    return date_format(pData, '%Y/%m');
end $$

# Função para formatar quantidade
create function formatarQtd(pQtd decimal(18,2))
returns varchar(30) deterministic
reads sql data
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
reads sql data
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

create procedure sp



delimiter ;


