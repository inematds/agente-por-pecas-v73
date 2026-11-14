#!/usr/bin/env bash
# capturar.sh — roda cada bloco de captura/blocos/*.sh numa bancada nova e grava a saída em captura/saidas/<bloco>.txt.
#
#   bash captura/capturar.sh            # todos os blocos que têm captura
#   bash captura/capturar.sh a8a-exato  # só os citados
#
# Bancada = um ~/agente-por-pecas-kit novo a cada bloco (clonado de novo; o a1a é o próprio clone), apagado no fim.
# O HOME fica o real: com outro HOME o Codex tenta renovar o login e falha ("refresh token was revoked").
# KIT_LOCAL=<pasta> faz o `git clone https://github.com/inematds/agente-por-pecas-kit` vir dessa pasta
# (antes do push); sem ela, clona do GitHub de verdade.
# a4b (Telegram): grava o .env da bancada com o token do bot de teste (TELEGRAM_BOT_A73_TOKEN do ~/projetos/wifi/.env)
# e a saída troca o token e o número do chat por <token> e <seu chat>.
set -uo pipefail
C=$(cd "$(dirname "$0")" && pwd)
REPO=https://github.com/inematds/agente-por-pecas-kit
SEM_CAPTURA="a2b-local a3a-chat a4a-telegram"          # local sem aprovação de modelo; servidor que não termina; só grava .env
alvos=("$@"); [ ${#alvos[@]} -eq 0 ] && alvos=($(cd "$C/blocos" && ls *.sh | sed 's/\.sh$//'))
git_env=(); [ -n "${KIT_LOCAL:-}" ] && git_env=(GIT_CONFIG_COUNT=1 "GIT_CONFIG_KEY_0=url.$KIT_LOCAL.insteadOf" "GIT_CONFIG_VALUE_0=$REPO")
for b in "${alvos[@]}"; do
  case " $SEM_CAPTURA " in *" $b "*) echo "$b: sem captura (declarado)"; continue;; esac
  T=$HOME/agente-por-pecas-kit; rm -rf "$T"
  [ "$b" = a1a-baixar ] || env "${git_env[@]}" git clone -q "$REPO" "$T"
  segredo=""
  if [ "$b" = a4b-telegram-ouvir ]; then
    segredo=$(grep '^TELEGRAM_BOT_A73_TOKEN=' ~/projetos/wifi/.env | cut -d= -f2)
    echo "TELEGRAM_TOKEN=$segredo" > "$T/.env"
  fi
  ( cd /tmp && env "${git_env[@]}" timeout "${CAPTURA_TIMEOUT:-600}" bash "$C/blocos/$b.sh" ) 2>&1 \
    | sed "s#$HOME#~#g; s#127\.0\.0\.1:[0-9]\{2,5\}#127.0.0.1:<porta>#g; s#chat [0-9]\{5,\}#chat <seu chat>#g${segredo:+; s#$segredo#<token>#g}" \
    > "$C/saidas/$b.txt"
  echo "$b: $(wc -l < "$C/saidas/$b.txt") linhas"
  rm -rf "$T"
done
