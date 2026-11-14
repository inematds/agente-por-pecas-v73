cd ~/agente-por-pecas-kit && git checkout -q aula5 && mkdir -p entrada
echo "Escreva uma frase curta de bom dia para a equipe." > entrada/001-bom-dia.txt
echo "Liste 3 frutas, uma por linha." > entrada/002-frutas.txt
python3 canal_pasta.py --uma-vez
ls entrada; cat feito/002-frutas.txt
