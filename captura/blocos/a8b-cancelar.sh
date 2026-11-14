cd ~/agente-por-pecas-kit && git checkout -q aula8 && mkdir -p trabalho
echo "Reunião com o fornecedor na sexta às 15h. Levar o contrato." > trabalho/notas.txt
python3 canal_terminal.py "Leia notas.txt e diga o nome do fornecedor" --esperado "Acme"
