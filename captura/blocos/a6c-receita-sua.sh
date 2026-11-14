cd ~/agente-por-pecas-kit && git checkout -q aula6
printf 'quando: anote a tarefa *\nfaça: acrescentar tarefas.txt *\nresponda: Tarefa anotada: *\n' > receitas/anotar-tarefa.txt
python3 canal_terminal.py "anote a tarefa pagar a luz"
cat trabalho/tarefas.txt
