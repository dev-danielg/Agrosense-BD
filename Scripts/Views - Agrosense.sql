create or replace view v_rel_01_lotes_validade_proxima as
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


create or replace view v_rel_02_saldo_estoque_armazem_especie as
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


create or replace view v_rel_03_historico_entradas_lote_l_pet_001 as
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


create or replace view v_rel_04_fornecedores_por_volume as
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


create or replace view v_rel_05_cooperativas_que_mais_receberam as
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


create or replace view v_rel_06_lotes_maior_variacao_percentual as
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


create or replace view v_rel_07_lotes_expirados_por_armazem as
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


create or replace view v_rel_08_tempo_medio_expedicoes as
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


create or replace view v_rel_09_especies_maior_rotatividade as
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


create or replace view v_rel_10_transferencias_concluidas as
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


create or replace view v_rel_11_entradas_mes_especie as
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


create or replace view v_rel_12_cooperativas_pendentes as
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


create or replace view v_rel_13_operadores_movimentacoes_6meses as
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


create or replace view v_rel_14_agentes_expedicoes_concluidas as
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


create or replace view v_rel_15_validacao_qrcode as
select
    lote.codigoQr "Código QR",
    lote.numero "Número",
    especie.nome "Espécie",
    datetimeformatBR(lote.dataValidade) "Data de validade",
    coalesce(datetimeformatBR(max(movimentacao.dataRegistro)), "-") "Data da última movimentação"
    from lote
        left join movimentacao
            on movimentacao.idLote = lote.idLote
        join especie
            on lote.idLote = especie.idEspecie
    group by lote.codigoQr, lote.numero;


create or replace view v_rel_16_lotes_por_fornecedor_percentual as
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


create or replace view v_rel_17_estoques_atualizados_1mes as
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


create or replace view v_rel_18_transferencias_entre_dois_armazens as
select
    dateFormatBR(movimentacao.dataRegistro) "Data",
    lote.numero "Número do lote",
    concat(armazemOrigem.nome, " -> ", armazemDestino.nome) "Direção",
    movimentacao.qtdKg "Quantidade (KG)",
    usuario.nome "Operador de Armazém"
    from lote
        left join movimentacao
            on movimentacao.idLote = lote.idLote
        join transferencia
            on transferencia.idMovimentacao = movimentacao.idMovimentacao
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


create or replace view v_rel_19_cooperativas_de_pernambuco as
select
    cooperativa.razaoSocial "Cooperativa",
    cooperativa.cnpj "CNPJ"
    from cooperativa
        join endereco
            on cooperativa.idEndereco = endereco.idEndereco
    where endereco.UF = "PE";


create or replace view v_rel_20_lotes_com_estoque_usado as
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
