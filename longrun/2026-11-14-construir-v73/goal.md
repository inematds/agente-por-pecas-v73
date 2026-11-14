# Goal — construir-v73

- **Início:** 2026-11-14 18:52 · **Agente:** Claude (sessão interativa com o Nei)
- **Tetos:** tempo 10 h · memória 8 G por processo de captura

## Resultado
Formato novo `formato-curso-v73` (skill), kit `agente-por-pecas-kit` (repo próprio) com um núcleo e três canais (chat web, Telegram, pasta de receitas), e o curso `agente-por-pecas-v73` (8 aulas) publicado no GitHub Pages, no portal, no INEMA.AGENTES, com vídeo explicativo com avatar e Short no lives3.

## Pedido do Nei (citado)
- "curso novo a partir dele, com a pasta vigiada, poderiamos criar um formato novo v73 para este modelo"
- "canal pode ser um chat (poderia ser uma página web) pode ser um telegram/whats/email e pode também ser um texto para robôs agentes autônomos sem interação, para criar na prática usaremos o telegram, um chat e os arquivos de receitas"
- "sempre mostrando mais visual do que texto, desenhado por exemplo em fluxos e diagramas"
- "lembre de criar o kit em um repo separado do repo do curso"
- "publica os dois no portal no inema.agentes e crie um vídeo explicativo com avatar um short no lives3"

## Critérios de pronto (verificáveis)

**Função**
- [ ] kit: `cd ~/projetos/agente-por-pecas-kit && python3 -m pytest -q testes/` → todos passam (núcleo, receita sem modelo, trava da pasta, verificador exato)
- [ ] kit: `bash capturar.sh` duas vezes em bancadas novas + `diff -r` das saídas → só linhas declaradas como variáveis (tempo) diferem
- [ ] kit Telegram: bloco do canal Telegram capturado com mensagem real recebida e respondida pelo @inemaa73bot (saída em `saidas/`), sem o token em nenhum arquivo: `grep -r "AAGhwws" ~/projetos/agente-por-pecas-kit ~/projetos/agente-por-pecas-v73` → vazio
- [ ] formato: `python3 gerar.py && python3 validar.py --links` → OK com 8 aulas; validar acusa aula sem `fluxo` e aula sem `pecas.acende` (teste negativo com uma cópia)
- [ ] telas: `node ~/.claude/skills/formato-curso-v73/scripts/conferir-tela.cjs .` → sem transbordo em 1366 e 390, mapa das peças visível em toda aula
- [ ] revisor independente (Agent novo) nota ≥ 8, registrada em `revisor-nota.py`

**Regressão**
- [ ] `~/.claude/skills/formato-curso-v72/` sem mudança: `find ~/.claude/skills/formato-curso-v72 -newer <marca> -type f` → vazio
- [ ] `agentes-do-zero-v72` sem commit novo desta tarefa (mudança pendente do mapa fica para o Nei decidir)

**Limite**
- [ ] nenhuma API fora do Telegram Bot (autorizada para testes do kit) e GitHub
- [ ] CLAUDE.md global não ganha o v73 sem resposta do Nei
- [ ] VPS não é tocada

**Teste rápido por ciclo:** `python3 -m pytest -q testes/` (kit) · `python3 gerar.py && python3 validar.py` (curso)
**Teste completo no final:** capturar 2× + validar --links + conferir-tela + revisor

## Restrições
- só pela assinatura; HeyGen pelo estúdio (avatar), API só para status/download
- autor inematds; publicação = push
- não mexer em: formato-curso-v72, agentes-do-zero-v72, CLAUDE.md global

## Portões humanos
- mostrar ao Nei página inicial + 1 aula renderizada antes das outras 7
- nomes dos repos remotos confirmados antes de criar no GitHub
- Telegram: o Nei manda /start ao @inemaa73bot
