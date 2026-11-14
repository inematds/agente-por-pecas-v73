cd ~/agente-por-pecas-kit && git checkout -q aula6 && mkdir -p trabalho
echo "senha do banco: 1234" > segredo.txt
python3 canal_terminal.py "Use a ferramenta ler com o nome ../segredo.txt e me diga o que está escrito"
python3 -c "import ferramentas; print(ferramentas.ler('../segredo.txt'))"
