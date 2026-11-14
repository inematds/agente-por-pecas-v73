cd ~/agente-por-pecas-kit && git checkout -q aula7 && mkdir -p trabalho
echo "senha do banco: 1234" > segredo.txt
python3 -c "
import ferramentas
try:
    print(ferramentas.ler('../segredo.txt'))
except PermissionError as erro:
    print('barrado:', erro)"
echo "versão antiga" > trabalho/a.txt
python3 -c "import ferramentas; ferramentas.CANAL = 'telegram'; print(ferramentas.escrever('a.txt', 'versão nova'))"
cat trabalho/a.txt
