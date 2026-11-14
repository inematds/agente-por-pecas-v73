#!/usr/bin/env bash
# Gera as imagens do curso agente-por-pecas-v73 pelo Codex image_gen (assinatura), uma por vez.
# Uso: imagens.sh [nome ...]   (sem argumento = todas que ainda não existem)
# Modelo: wifi/longrun/2026-10-19-iacultivada-v72/imagens.sh. Capa no padrão V15 (DESIGN.md), com a capa do Terminal como referência.
set -u
export PATH="$HOME/.npm-global/bin:$PATH"
CURSO=~/projetos/agente-por-pecas-v73
TMP=/tmp/claude-1000/-home-nmaldaner-projetos-agentes-do-zero-v72/2a0c0e9c-910e-43ae-8cf9-805dd4dce6d4/scratchpad/agente-por-pecas-v73-img
REF=~/projetos/do-chat-ao-agente-terminal-v72/assets/img/capa.jpg
mkdir -p "$TMP" "$CURSO/assets/img/hero"
BASE="Fotografia editorial cinematográfica, luz NEUTRA (sem tom amarelado nem alaranjado), cores naturais, alta nitidez, composição horizontal com espaço livre. SEM nenhum texto, letra, logotipo ou número na imagem; telas de celular e computador desfocadas, sem texto legível. Se aparecer robô: humanoide industrial estilo Tesla Optimus, acabamento fosco, com visor preto na frente da cabeça; nunca robô fofo ou cartoon. Pessoas adultas, mãos naturais, sem destaque em mãos."
declare -A P
P[capa]="Capa de curso no MESMO estilo da imagem anexada (siga a composição, a luz e a tipografia dela): foto calma e escura, luz neutra; à direita, poucos objetos sobre uma bancada escura: algumas peças de metal de um mecanismo desmontado (engrenagem, placa de circuito, uma pequena caixa aberta) organizadas lado a lado; espaço vazio à esquerda. No terço esquerdo, desenhado dentro da arte: uma linha pequena em caixa alta cinza 'CURSO · 8 AULAS'; o título em serifa branca, grande, em duas linhas: 'Agente' e 'por peças'; abaixo, uma linha de apoio em sem serifa cinza clara: 'Canal, caixa, cérebro e verificador'; embaixo, 'INEMA.CLUB' em branco com o ponto em amarelo. Sem letra grande amarela, sem brilho, sem neon. Exatamente esses textos, sem erro de grafia; nenhum outro texto."
P[inicio]="Bancada de oficina moderna e organizada; peças de um mecanismo dispostas em fileira, da esquerda para a direita, prontas para montar: uma caixa de metal aberta, uma placa de circuito, um pequeno motor, cabos; ao fundo, desfocado, um robô humanoide industrial estilo Tesla Optimus com visor preto, parcialmente montado."
P[objetivo]="Peças de um mecanismo organizadas sobre uma mesa clara, vistas de cima (flat lay): engrenagens, uma placa de circuito, uma pequena caixa de metal, parafusos em grupos, um caderno aberto com folhas em branco ao lado."
P[caixa-cerebro]="Uma caixa de metal aberta sobre uma bancada, com fios bem organizados ligados a uma pequena luz suave; ao lado, uma placa de circuito; ambiente técnico calmo."
P[chat]="Notebook aberto numa mesa de madeira iluminada pela janela, a tela mostra uma janela de conversa com balões, DESFOCADA e sem texto legível; xícara ao lado."
P[telegram]="Celular sobre uma mesa de madeira, tela com uma conversa aberta DESFOCADA e sem texto legível, luz de fim de tarde neutra entrando pela janela; chaves e um caderno ao lado."
P[pasta]="Bandejas de papel de entrada e saída sobre uma mesa organizada de escritório; na bandeja de entrada algumas folhas, na de saída folhas grampeadas; sem texto legível nas folhas."
P[receitas-ferramentas]="Caderno de receitas aberto com folhas em branco ao lado de uma caixa de ferramentas organizada e aberta, sobre uma bancada clara de madeira."
P[memoria-regras]="Cofre pequeno de metal ao lado de um caderno de anotações aberto com folhas em branco, sobre uma mesa clara; uma caneta sobre o caderno."
P[verificador]="Lupa sobre uma folha com marcas de conferência (só tiques, sem palavras), ao lado de uma xícara de café, sobre uma mesa clara de escritório."
ordem=(capa inicio objetivo caixa-cerebro chat telegram pasta receitas-ferramentas memoria-regras verificador)
[ $# -gt 0 ] && ordem=("$@")
for n in "${ordem[@]}"; do
  if [ "$n" = capa ]; then dest="$CURSO/assets/img/capa.jpg"; W=1400; H=788; anexo=(-i "$REF")
  elif [ "$n" = inicio ]; then dest="$CURSO/assets/img/hero/inicio.jpg"; W=1536; H=1024; anexo=()
  else dest="$CURSO/assets/img/hero/$n.jpg"; W=1536; H=1024; anexo=(); fi
  [ -s "$dest" ] && [ $# -eq 0 ] && { echo "pula $n"; continue; }
  d="$TMP/$n"; rm -rf "$d"; mkdir -p "$d"
  for t in 1 2 3; do
    (cd "$d" && printf '%s\n' "Use a ferramenta image_gen para gerar UMA imagem em formato paisagem: ${P[$n]} ${BASE} Salve o arquivo final como arte.png nesta pasta e responda só OK." \
      | timeout 900 codex exec --skip-git-repo-check --dangerously-bypass-approvals-and-sandbox "${anexo[@]}" -o resposta.txt - >log.txt 2>&1)
    f=$(ls -t "$d"/*.png 2>/dev/null | head -1)
    [ -z "$f" ] && f=$(find ~/.codex/generated_images -newer "$d/log.txt" -name '*.png' 2>/dev/null | head -1)
    if [ -n "$f" ]; then
      python3 - "$f" "$dest" "$W" "$H" <<'EOF'
import sys
from PIL import Image
src, dst, W, H = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])
im = Image.open(src).convert("RGB")
r = max(W / im.width, H / im.height)
im = im.resize((round(im.width * r), round(im.height * r)), Image.LANCZOS)
l, t = (im.width - W) // 2, (im.height - H) // 2
im.crop((l, t, l + W, t + H)).save(dst, quality=88)
EOF
      echo "OK $n (tentativa $t)"; break
    fi
    echo "falhou $n tentativa $t"
  done
done
echo "FIM imagens"
