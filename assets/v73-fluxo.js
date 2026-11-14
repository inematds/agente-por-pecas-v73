/* INEMA Learning v7.3 — fluxo: nós numa grade + setas desenhadas entre eles (com desvios e voltas),
   passo a passo opcional e detalhe ao clicar. Usado pela seção "fluxo" e pelo mapa das peças. */
(function () {
  "use strict";
  var NS = "http://www.w3.org/2000/svg";

  function el(nome, attrs) {
    var e = document.createElementNS(NS, nome);
    for (var k in attrs) e.setAttribute(k, attrs[k]);
    return e;
  }

  // ponto na borda do retângulo r na direção do ponto (x, y)
  function borda(r, x, y) {
    var cx = r.x + r.w / 2, cy = r.y + r.h / 2, dx = x - cx, dy = y - cy;
    if (!dx && !dy) return { x: cx, y: cy };
    var sx = dx ? (r.w / 2) / Math.abs(dx) : Infinity, sy = dy ? (r.h / 2) / Math.abs(dy) : Infinity;
    var s = Math.min(sx, sy);
    return { x: cx + dx * s, y: cy + dy * s };
  }

  function desenhar(fx) {
    var svg = fx.querySelector(".fx-setas"), grade = fx.querySelector(".fx-grade");
    var base = grade.getBoundingClientRect();
    svg.setAttribute("viewBox", "0 0 " + base.width + " " + base.height);
    svg.setAttribute("width", base.width); svg.setAttribute("height", base.height);
    while (svg.lastChild) svg.removeChild(svg.lastChild);
    var defs = el("defs", {}), id = "fxp" + Math.random().toString(36).slice(2, 8);
    var m = el("marker", { id: id, viewBox: "0 0 10 10", refX: "9", refY: "5", markerWidth: "7", markerHeight: "7", orient: "auto-start-reverse" });
    m.appendChild(el("path", { d: "M0 0 L10 5 L0 10 z", "class": "fx-ponta" }));
    defs.appendChild(m); svg.appendChild(defs);
    var ret = {};
    grade.querySelectorAll(".fx-no").forEach(function (n) {
      var r = n.getBoundingClientRect();
      ret[n.dataset.id] = { x: r.left - base.left, y: r.top - base.top, w: r.width, h: r.height };
    });
    JSON.parse(fx.dataset.ligacoes || "[]").forEach(function (l) {
      var a = ret[l.de], b = ret[l.para];
      if (!a || !b) return;
      var ac = { x: a.x + a.w / 2, y: a.y + a.h / 2 }, bc = { x: b.x + b.w / 2, y: b.y + b.h / 2 };
      var g = el("g", { "class": "fx-seta", "data-l": l.de + ">" + l.para });
      var d, meio;
      if (l.volta === "baixo" || l.volta === "cima") {   // volta entre nós da mesma linha: curva por baixo/cima
        var v = l.volta === "baixo" ? 1 : -1, vaiDir = bc.x > ac.x;
        var q1 = { x: a.x + a.w * (vaiDir ? 0.72 : 0.28), y: v > 0 ? a.y + a.h : a.y };
        var q2 = { x: b.x + b.w * (vaiDir ? 0.28 : 0.72), y: v > 0 ? b.y + b.h : b.y };
        var offy = Math.max(12, Math.min(26, (parseFloat(getComputedStyle(grade).rowGap) || 30) * 0.55));
        var cy = v > 0 ? Math.max(q1.y, q2.y) + offy : Math.min(q1.y, q2.y) - offy;
        d = "M" + q1.x + " " + q1.y + " C" + q1.x + " " + cy + " " + q2.x + " " + cy + " " + q2.x + " " + q2.y;
        meio = { x: (q1.x + q2.x) / 2, y: cy - v * offy * 0.25 };
      } else if (l.volta) {                    // volta: curva para o lado, para não cobrir a ida
        var lado = l.volta === "esq" ? -1 : 1, sobe = bc.y < ac.y;
        // sai e chega fora do meio do lado (onde as setas retas encostam) e curva até ~45% do vão entre colunas
        var p1 = { x: ac.x + lado * a.w / 2, y: a.y + a.h * (sobe ? 0.28 : 0.72) };
        var p2 = { x: bc.x + lado * b.w / 2, y: b.y + b.h * (sobe ? 0.72 : 0.28) };
        var off = Math.max(12, Math.min(30, (parseFloat(getComputedStyle(grade).columnGap) || 40) * 0.45));
        var cx = lado > 0 ? Math.max(p1.x, p2.x) + off : Math.min(p1.x, p2.x) - off;
        d = "M" + p1.x + " " + p1.y + " C" + cx + " " + p1.y + " " + cx + " " + p2.y + " " + p2.x + " " + p2.y;
        meio = { x: cx - lado * off * 0.25, y: (p1.y + p2.y) / 2 };
      } else {
        var p = borda(a, bc.x, bc.y), q = borda(b, ac.x, ac.y);
        var dx = q.x - p.x, dy = q.y - p.y, t = Math.hypot(dx, dy) || 1;
        q = { x: q.x - dx / t * 3, y: q.y - dy / t * 3 };
        d = "M" + p.x + " " + p.y + " L" + q.x + " " + q.y;
        meio = { x: (p.x + q.x) / 2, y: (p.y + q.y) / 2 };
      }
      g.appendChild(el("path", { d: d, "marker-end": "url(#" + id + ")" }));
      if (l.rot) {
        var tx = el("text", { x: meio.x, y: meio.y + 4, "text-anchor": "middle" });
        tx.textContent = l.rot;
        g.appendChild(tx);
      }
      svg.appendChild(g);
      // rótulo maior que a seta reta (celular, vão curto) cobriria os nós: some; a legenda do passo explica
      var rotulo = g.querySelector("text"), seg = g.querySelector("path").getTotalLength();
      if (rotulo && !l.volta && rotulo.getBBox().width + 6 > seg) rotulo.style.display = "none";
    });
    marcar(fx);
  }

  // acende nós e setas: do passo atual (seção fluxo) ou das peças da aula (mapa)
  function marcar(fx) {
    var p = fx._passos && fx._passos[fx._i];
    var nos = p ? p.acende : null, lig = p ? (p.ligar || []) : null;
    fx.querySelectorAll(".fx-no").forEach(function (n) {
      if (nos) { n.classList.toggle("aceso", nos.indexOf(n.dataset.id) >= 0); n.classList.toggle("apagado", nos.indexOf(n.dataset.id) < 0); }
    });
    fx.querySelectorAll(".fx-seta").forEach(function (s) {
      var par = s.dataset.l.split(">");
      var on = lig ? lig.indexOf(s.dataset.l) >= 0
        : fx.querySelector('.fx-no[data-id="' + par[0] + '"]').classList.contains("aceso") &&
          fx.querySelector('.fx-no[data-id="' + par[1] + '"]').classList.contains("aceso");
      s.classList.toggle("on", on);
    });
  }

  function iniciar(fx) {
    var det = fx.querySelector(".fx-detalhe");
    fx.querySelectorAll(".fx-no").forEach(function (n) {
      n.addEventListener("click", function () {
        fx.querySelectorAll(".fx-no").forEach(function (o) { o.setAttribute("aria-pressed", o === n ? "true" : "false"); });
        if (det) det.innerHTML = n.querySelector("template").innerHTML;
      });
    });
    var passos = fx.querySelector(".fx-passos");
    if (passos) {
      fx._passos = JSON.parse(passos.dataset.passos); fx._i = 0;
      var leg = passos.querySelector(".fx-leg"), cont = passos.querySelector(".fx-cont");
      var ant = passos.querySelector(".fx-ant"), prox = passos.querySelector(".fx-prox");
      var ir = function (i) {
        fx._i = Math.max(0, Math.min(fx._passos.length - 1, i));
        var p = fx._passos[fx._i];
        leg.innerHTML = "<b>" + p.titulo + "</b> " + p.texto;
        cont.textContent = (fx._i + 1) + " / " + fx._passos.length;
        ant.disabled = fx._i === 0; prox.disabled = fx._i === fx._passos.length - 1;
        marcar(fx);
      };
      ant.addEventListener("click", function () { ir(fx._i - 1); });
      prox.addEventListener("click", function () { ir(fx._i + 1); });
      ir(0);
    }
    desenhar(fx);
    var espera;
    window.addEventListener("resize", function () { clearTimeout(espera); espera = setTimeout(function () { desenhar(fx); }, 80); });
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(function () { desenhar(fx); });
  }

  document.querySelectorAll(".fx").forEach(iniciar);
})();
