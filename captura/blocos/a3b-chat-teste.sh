cd ~/agente-por-pecas-kit && git checkout -q aula3 && rm -f web.url
python3 canal_web.py > chat.log 2>&1 & CHAT=$!
until [ -s web.url ]; do sleep 0.3; done
python3 -c "import json,urllib.request; u=open('web.url').read(); r=urllib.request.urlopen(urllib.request.Request(u, json.dumps({'texto':'Diga oi em 3 palavras'}).encode())); print(json.loads(r.read()))"
kill $CHAT; cat chat.log
