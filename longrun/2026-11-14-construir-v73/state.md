# State — construir-v73 (14/11/2026)

## Feito
- Kit `~/projetos/agente-por-pecas-kit` (local, sem remoto): tags aula1–aula8, 7 testes em `testes/` passam (cérebro falso).
  Peças = arquivos: canal_terminal/web/telegram/pasta, caixa.py, cerebro.py, receitas.py + receitas/, ferramentas.py, regras.md, memoria.json, verificador.py.
- Blocos do curso em `captura/blocos/*.sh` (17), ainda sem `capturar.sh` e sem saídas.
- Achados reais (llama3.2): modelo "recusa" o segredo mas a ferramenta já leu (regra tem de estar no código); aviso do verificador com o esperado fez o modelo inventar "Acme" (corrigido: aviso genérico); juiz sem evidência reprova tudo (corrigido: juiz lê o que as ferramentas devolveram); juiz llama3.2 reprova resposta certa; juiz llama3.1:8b aprova resposta em PT a pedido "em inglês" → exemplo concreto vence.

## Parado em
- REGRA nova do CLAUDE.md global (14/11): modelo local só com aprovação do Nei. Usei llama3.2 e llama3.1:8b via HTTP do Ollama nos testes antes de ver a regra; descarreguei os dois (`ollama stop`). Pedir aprovação: llama3.2 (agente, ~4,3 GB GPU) e llama3.1:8b (juiz, ~7,2 GB GPU), só para as capturas do kit, com `ollama stop` depois.
- Telegram: nenhuma mensagem do Nei ao @inemaa73bot ainda.
- Nomes dos remotos (agente-por-pecas-v73 / agente-por-pecas-kit) não confirmados.

## Próximo
1. capturar.sh do curso (clone fresco por bloco, HOME de bancada, insteadOf para o repo local até o push).
2. skill formato-curso-v73 (mapa de peças + seção fluxo + validador) e 1 aula para o Nei ver.

## Atualização 14/11 (noite)
- Nei: cérebro = Codex da assinatura (gpt-6-luna); Ollama vira módulo à parte (cerebro_local.py, CEREBRO=local), sem captura (modelo local não aprovado).
- Kit no GitHub: inematds/agente-por-pecas-kit (main + tags aula1–aula8). Captura do GitHub real = idêntica à local.
- Capturas reais em captura/saidas (Codex): Telegram respondeu /start e "oi" do Nei.
- Skill ~/.claude/skills/formato-curso-v73 (motor 7.16.23): seção fluxo (grade + setas, voltas dir/esq/baixo/cima, passos), mapa das peças no topo da aula e na inicial, validar com fluxo obrigatório, pecas e teto de 1400 palavras; resolver-kit lê o kit pela tag (git show).
- Amostra para o Nei: página inicial + aula 6 (receitas-ferramentas). Aulas com marcadores guardadas em scratchpad/aulas-marcadores.
- Próximo: ouvir o Nei sobre a amostra → escrever aulas 1–5, 7, 8 → imagens (Codex image_gen) → portão → revisor → push → portal/Telegram/vídeo.
