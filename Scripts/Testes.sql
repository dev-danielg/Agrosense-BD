
# Adicionando e atualizando entrada
call spAdicionarMov(700, null, 1, 1, 1, null);
call spAtualizarStatusMov(21, null, "Concluído");

# Adicionando e atualizando transferência
call spAdicionarMov(700, 1, 2, 1, 2, null);
call spAtualizarStatusMov(22, null, "Concluído");

# Adicionando e atualizando expedição
call spAdicionarMov(700, 1, null, 1, 1, 1);
call spAtualizarStatusMov(23, 1, "Concluído");

select * from movimentacao;
select * from entrada;
select * from transferencia;
select * from Estoque;