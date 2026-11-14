cd ~/agente-por-pecas-kit && git checkout -q aula8 && mkdir -p trabalho entrada
echo "Reunião com o fornecedor na sexta às 15h. Levar o contrato." > trabalho/notas.txt
printf 'Leia notas.txt e diga só o horário da reunião.\nesperado: 15h\n' > entrada/hora.txt
printf 'Leia notas.txt e diga o valor do contrato.\nesperado: R$\n' > entrada/valor.txt
python3 canal_pasta.py --uma-vez | grep -E "canal|verificador|resultado|pasta\]"
cat feito/hora.txt feito/valor.txt
