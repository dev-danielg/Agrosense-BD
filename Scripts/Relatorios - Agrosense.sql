# Relatório 1 - Lista dos lotes com validade próxima
select
	lote.numero "Número do lote",
    lote.codigoQr "Código QR",
    especie.nome "Espécie",
    usuario.nome "Fornecedor",
    lote.dataValidade "Data de validade",
    lote.qtdInicialKg "Quantidade inicial (KG)"
    from usuario
		join fornecedor
			on usuario.idUsuario = fornecedor.idFornecedor
		join lote
			on lote.idFornecedor = fornecedor.idFornecedor
		join especie
			on lote.idEspecie = especie.idEspecie
	order by lote.dataValidade;
    
    
# Relatório 2 - Saldo de estoque por armazém e espécie
select 
	armazem.nome "Armazém",
    especie.nome "Espécie",
    sum(estoque.qtdKg) "Soma do saldo (KG)"
    from estoque
		join armazem
			on estoque.idArmazem = armazem.idArmazem
		join lote
			on estoque.idlote = lote.idlote
		join especie
			on lote.idespecie = especie.idespecie
	group by armazem.nome, especie.nome
    order by armazem.nome, especie.nome;
			
    
# Relatório 3 - Histórico de entradas do lote L-PET-001
select
	datetimeformatBR(movimentacao.dataRegistro) "Data de registro",
    movimentacao.qtdKg "Quantidade (KG)",
    armazem.nome "Armazém",
    movimentacao.status "Status",
	usuario.nome "Operador do armazém"
    from movimentacao
		join operadorarmazem
			on movimentacao.idOperadorArmazem = operadorarmazem.idOperadorArmazem
		join usuario
			on usuario.idUsuario = operadorarmazem.idOperadorArmazem
		join lote
			on movimentacao.idLote = lote.idLote
		join entrada
			on entrada.idMovimentacao = movimentacao.idMovimentacao
		join armazem
			on entrada.idArmazemDestino = armazem.idArmazem
		where lote.numero = "L-PET-001";
    
    
# Relatório 4 - Lista dos fornecedores por volume entregue
select
	usuario.nome "Fornecedor",
    usuario.cpfCnpj "CPF/CNPJ",
    coalesce(sum(lote.qtdInicialKg), "-") "Soma total (KG)"
    from usuario
		join fornecedor
			on usuario.idUsuario = fornecedor.idFornecedor
		left join lote
			on fornecedor.idFornecedor = lote.idFornecedor
	group by usuario.idUsuario
    order by sum(lote.qtdInicialKg) desc
    limit 10;


# Relatório 5 - Lista das cooperativas que mais receberam sementes
select
	cooperativa.razaoSocial "Cooperativa",
    formatarQtd(count(movimentacao.idMovimentacao)) "Quantidade de movimentações recebidas",
    coalesce(sum(movimentacao.qtdKg), "-") "Total KG recebido"
    from cooperativa
		left join expedicao
			on expedicao.idCooperativa = cooperativa.idCooperativa
		join movimentacao
			on expedicao.idMovimentacao = movimentacao.idMovimentacao
	group by cooperativa.razaoSocial
    order by coalesce(sum(movimentacao.qtdKg), "-") desc;


# Relatório 6 - Lotes com maior variação percentual entre quantidade inicial e estoque atual
select
	 lote.numero "Número do lote",
     lote.codigoQr "Código QR",
     especie.nome "Espécie",
     usuario.nome "Fornecedor",
     lote.qtdInicialKg "Quantidade inicial (KG)",
     formatarQtd(sum(estoque.qtdKg)) "Total em estoque (KG)",
     formatarQtd(sum(estoque.qtdKg) - lote.qtdInicialKg) "Variação (KG)",
     formatarQtdPercentual(round((sum(estoque.qtdKg) - lote.qtdInicialKg) / lote.qtdInicialKg * 100)) "Variação percentual"
     from lote
		left join estoque
			on estoque.idLote = lote.idLote
		join especie
			on lote.idEspecie = especie.idEspecie
		join fornecedor
			on lote.idFornecedor = fornecedor.idFornecedor
		join usuario
			on fornecedor.idFornecedor = usuario.idUsuario
	group by lote.numero
    order by round((sum(estoque.qtdKg) - lote.qtdInicialKg) / lote.qtdInicialKg * 100) desc;


# Relatório 7 - Lista de lotes expirados agrupados por armazém
select
	armazem.nome "Armazém",
    lote.numero "Lote",
    lote.codigoQr "Código QR",
    especie.nome "Espécie",
    lote.dataValidade "Data de validade",
    estoque.qtdKg "Saldo atual (KG)"
    from estoque
		join armazem
			on estoque.idArmazem = armazem.idArmazem
		join lote
			on estoque.idLote = lote.idLote
		join especie
			on lote.idEspecie = especie.idEspecie
	where lote.dataValidade < now();


# Relatório 8 - Cálculo do tempo médio entre registro e entrega nas movimentações do tipo Expedição
select
	armazem.nome "Armazém",
    count(movimentacao.idMovimentacao) "Quantidade de expedições",
    round(avg(calcularDifHoras(movimentacao.dataRegistro, movimentacao.dataEntrega)), 1) "Média de horas"
    from expedicao
		join movimentacao
			on expedicao.idMovimentacao = movimentacao.idMovimentacao
		join armazem
			on expedicao.idArmazemOrigem = armazem.idArmazem
    group by armazem.nome;


# Relatório 9 - Lista de espécies com maior rotatividade
select
	especie.nome "Espécie",
    sum(movimentacao.qtdKg) "Total movimentado (KG)",
    count(movimentacao.idMovimentacao) "Quantidade de movimentações"
    from movimentacao
		join lote
			on movimentacao.idLote = lote.idLote
		join especie
			on lote.idEspecie = especie.idEspecie
	group by especie.nome
    limit 10;
    
    
# Relatório 10 - Lista de transferências concluídas
select
	movimentacao.idMovimentacao "ID da Movimentação",
    datetimeformatBR(movimentacao.dataRegistro) "Data de Registro",
    lote.numero "Lote",
    movimentacao.qtdKg "Quantidade (KG)",
    armazemOrigem.nome "Armazém Origem",
    armazemDestino.nome "Armazém Destino",
    usuario.nome "Operador de Armazém"
    from movimentacao
		join transferencia
			on transferencia.idMovimentacao = movimentacao.idMovimentacao
		join armazem as armazemOrigem
			on transferencia.idArmazemOrigem = armazemOrigem.idArmazem
		join armazem as armazemDestino
			on transferencia.idArmazemDestino = armazemDestino.idArmazem 
		join lote
			on movimentacao.idLote = lote.idLote
		join operadorarmazem
			on movimentacao.idOperadorArmazem = operadorarmazem.idOperadorArmazem
		join usuario
			on operadorarmazem.idOperadorArmazem = usuario.idUsuario
	where movimentacao.status = "Concluído"
	order by movimentacao.dataRegistro;


# Relatório 11 - Entradas por mês e espécie
select
	dateFormatAnoMes(movimentacao.dataRegistro) "Ano/Mês",
    especie.nome "Espécie",
    sum(movimentacao.qtdKg) "Total de Entrada (KG)"
    from movimentacao
		join entrada
			on entrada.idMovimentacao = movimentacao.idMovimentacao
		join lote
			on movimentacao.idLote = lote.idLote
		join especie
			on lote.idEspecie = especie.idEspecie
	group by dateFormatAnoMes(movimentacao.dataRegistro), especie.nome
    order by dateFormatAnoMes(movimentacao.dataRegistro) desc, especie.nome;

    
# Relatório 12 - Cooperativas com mais expedições pendentes
select
	cooperativa.razaoSocial "Cooperativa",
    coalesce(count(movimentacao.idMovimentacao), "-") "Movimentações pendentes",
    coalesce(sum(movimentacao.qtdKg), "-") "Total pendente (KG)",
    coalesce(min(movimentacao.dataRegistro), "-") "Data do primeiro registro"
    from cooperativa
		left join expedicao
			on expedicao.idCooperativa = cooperativa.idCooperativa
		join movimentacao
			on expedicao.idMovimentacao = movimentacao.idMovimentacao
	where movimentacao.`status` = "Em andamento"
    group by cooperativa.razaoSocial
    order by coalesce(sum(movimentacao.qtdKg), "-") desc, coalesce(count(movimentacao.idMovimentacao), "-") desc;


# Relatório 13 - Lista dos operadores com mais movimentações nos últimos seis meses
select
	usuario.nome "Operador de Armazém",
    count(movimentacao.idMovimentacao) "Quantidade de movimentações",
    sum(movimentacao.qtdKg) "Total registrado (KG)"
    from movimentacao
		join operadorarmazem
			on movimentacao.idOperadorArmazem = operadorarmazem.idOperadorArmazem
		join usuario
			on operadorarmazem.idOperadorArmazem = usuario.idUsuario
	where movimentacao.dataRegistro >= date_sub(now(), interval 6 month)
	group by usuario.nome
    order by count(movimentacao.idMovimentacao) desc;


# Relatório 14 - Lista dos agentes de distribuição com maior quantidade de expedições concluídas
select
    usuario.nome "Agente de distribuição",
    count(movimentacao.idMovimentacao) "Quantidade de expedições",
    sum(movimentacao.qtdKg) "Total expedido (KG)"
    from movimentacao
		join expedicao
			on expedicao.idMovimentacao = movimentacao.idMovimentacao
		join agentedistribuicao
			on expedicao.idAgenteDistribuicao = agentedistribuicao.idAgenteDistribuicao
		join usuario
			on agentedistribuicao.idAgenteDistribuicao = usuario.idUsuario
	where movimentacao.dataEntrega is not null
	group by usuario.nome
    order by sum(movimentacao.qtdKg) desc;


# Relatório 15 - Consulta de validação de QR Code de lote
select
	lote.codigoQr "Código QR",
    lote.numero "Número",
    especie.nome "Espécie",
    datetimeformatBR(lote.dataValidade) "Data de validade",
    datetimeformatBR(max(movimentacao.dataRegistro)) "Data da última movimentação"
    from movimentacao
		join lote
			on movimentacao.idLote = lote.idLote
		join especie
			on lote.idLote = especie.idEspecie
	group by lote.codigoQr, lote.numero;
    
    
# Relatório 16 - Lista de lotes por fornecedor e percentual em estoque
select
	usuario.nome "Fornecedor",
    formatarQtd(count(lote.idLote)) "Quantidade de lotes fornecidos",
    formatarQtd(sum(lote.qtdInicialKg)) "Total fornecido (KG)",
    formatarQtd(sum(estoque.qtdKg)) "Total em estoque (KG)",
	calcularDifPercentual(sum(estoque.qtdKg), sum(lote.qtdInicialKg)) "Percentual em estoque"
    from fornecedor
		left join lote
			on fornecedor.idFornecedor = lote.idFornecedor
		left join estoque
			on lote.idLote = estoque.idLote
		join usuario
			on fornecedor.idFornecedor = usuario.idUsuario
	group by usuario.nome
    order by concat(round((sum(estoque.qtdKg) / sum(lote.qtdInicialKg)) * 100, 0), "%") desc;


# Relatório 17 - Estoques que sofreram atualização no período de 1 mês
select
	armazem.nome "Armazém",
    lote.numero "Número do lote",
    estoque.qtdKg "Quantidade em estoque (KG)"
    from estoque
		left join armazem
			on estoque.idArmazem = armazem.idArmazem
		left join lote
			on estoque.idLote = lote.idLote
	where estoque.ultimaAtualizacao >= date_sub(now(), interval 1 month);


# Relatório 18 - Histórico de transferências entre dois armazéns
select
	dateFormatBR(movimentacao.dataRegistro) "Data",
    lote.numero "Número do lote",
    concat(armazemOrigem.nome, " -> ", armazemDestino.nome) "Direção",
    movimentacao.qtdKg "Quantidade (KG)",
    usuario.nome "Operador de Armazém"
    from movimentacao
		join transferencia
			on transferencia.idMovimentacao = movimentacao.idMovimentacao
		join lote
			on movimentacao.idLote = lote.idLote
		join armazem as armazemOrigem
			on armazemOrigem.idArmazem = transferencia.idArmazemOrigem
		join armazem as armazemDestino
			on armazemDestino.idArmazem = transferencia.idArmazemDestino
		join operadorarmazem
			on movimentacao.idOperadorArmazem = operadorarmazem.idOperadorArmazem
		join usuario
			on operadorarmazem.idOperadorArmazem = usuario.idUsuario
	where transferencia.idArmazemOrigem = 2 and transferencia.idArmazemDestino = 4 
	or transferencia.idArmazemOrigem = 4 and transferencia.idArmazemDestino = 2
	order by movimentacao.dataRegistro desc;


# Relatório 19 - Cooperativas que estão situadas em Pernambuco
select
	cooperativa.razaoSocial "Cooperativa",
    cooperativa.cnpj "CNPJ"
    from cooperativa
		join endereco
			on cooperativa.idEndereco = endereco.idEndereco
	where endereco.UF = "PE";

    
# Relatório 20 - Lotes que já tiveram seus estoques usados
select
	lote.numero "Número do lote",
    lote.codigoQr "Código QR",
    especie.nome "Espécie",
    usuario.nome "Fornecedor",
    lote.qtdInicialKg "Quantidade inicial (KG)",
    formatarQtd(sum(estoque.qtdKg)) "Quantidade em estoque (KG)",
    formatarQtdPercentual(calcularDifPercentual(sum(estoque.qtdKg), lote.qtdInicialKg)) "Diferença percentual"
    from lote
		left join estoque
			on estoque.idLote = lote.idLote
		join especie
			on lote.idEspecie = especie.idEspecie
		join fornecedor
			on lote.idFornecedor = fornecedor.idFornecedor
		join usuario
			on fornecedor.idFornecedor = usuario.idUsuario
	group by lote.numero
    having calcularDifPercentual(sum(estoque.qtdKg), lote.qtdInicialKg) < 100;



