# Agente por peças (curso INEMA, formato v7.3)

Curso aberto e gratuito do INEMA.CLUB: um agente de IA montado peça por peça (canal, caixa, cérebro, receitas, ferramentas, memória, regras e verificador), com o Codex da assinatura como cérebro e quatro canais: terminal, chat web, Telegram e pasta.

- Curso: https://inematds.github.io/agente-por-pecas-v73/
- Kit (repo próprio, uma tag por aula): https://github.com/inematds/agente-por-pecas-kit
- Formato: skill `formato-curso-v73` (mapa das peças em toda aula, seção `fluxo` com desvios, teto de texto)

## O processo, do início ao fim

1. 🧠 Planejar as peças e as aulas com o Nei (mapa: canal → caixa → receita/cérebro → ferramentas → verificador → resultado).
2. 🧠 Montar o kit em `~/projetos/agente-por-pecas-kit`, uma tag por aula, e rodar os testes: `python3 -m pytest -q testes/`.
3. 🧠 Escrever cada bloco que o aluno cola em `captura/blocos/<aula><letra>-<nome>.sh`.
4. ⚙️ Capturar as saídas reais: `bash captura/capturar.sh` (clona o kit do GitHub; `KIT_LOCAL=<pasta>` antes do push). O bloco do Telegram usa o bot de teste (token em `~/projetos/wifi/.env`, trocado por `<token>` na saída).
5. 🧠 Escrever as aulas em `conteudo/pt/aulas/*.json` com marcadores `@@bloco:x@@`, `@@saida:x@@`, `@@arquivo:aulaN:caminho@@` (guardar uma cópia com marcadores fora do repo).
6. ⚙️ Resolver os marcadores: `python3 ~/.claude/skills/formato-curso-v73/scripts/resolver-kit.py .` (confere bloco × captura e arquivo × kit pela tag).
7. ⚙️ Imagens pelo Codex image_gen (assinatura): `bash longrun/2026-11-14-construir-v73/imagens.sh`.
8. ⚙️ Gerar e validar: `python3 gerar.py && python3 validar.py --links`.
9. ⚙️ Conferir as telas: `node ~/.claude/skills/formato-curso-v73/scripts/conferir-tela.cjs .` (1366 e 390 px).
10. 🤖 Revisor independente (Agent novo), nota em `~/projetos/wifi/scripts/revisor-nota.py`.
11. 🧠 Publicar: commit + push (GitHub Pages, raiz da main), depois portal (skill `atualiza-portal`), tópico no INEMA.AGENTES, vídeo com avatar e Short no lives3.
