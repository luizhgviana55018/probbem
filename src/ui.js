// Cria um elemento com atributos e filhos. Texto entra sempre como texto.
export function el(tag, atributos = {}, ...filhos) {
  const elemento = document.createElement(tag);
  for (const [chave, valor] of Object.entries(atributos)) {
    if (valor === false || valor == null) continue;
    if (chave === "class") elemento.className = valor;
    else if (chave.startsWith("on")) elemento.addEventListener(chave.slice(2), valor);
    else elemento.setAttribute(chave, valor === true ? "" : valor);
  }
  for (const filho of filhos.flat()) {
    if (filho == null || filho === false) continue;
    elemento.append(filho instanceof Node ? filho : document.createTextNode(String(filho)));
  }
  return elemento;
}

// Mensagem anunciada por leitor de tela (role=status). tipo: "sucesso" ou "erro".
export function mensagem(texto, tipo = "sucesso") {
  const prefixo = tipo === "erro" ? "Erro: " : "Sucesso: ";
  return el("p", { class: `mensagem ${tipo}`, role: "status" }, prefixo + texto);
}

export function carregando() {
  return el("p", { class: "carregando", role: "status" }, "Carregando...");
}

export function vazio(texto) {
  return el("p", { class: "vazio" }, texto);
}

// "2026-10-28" vira "28/10/2026" sem passar por Date (evita erro de fuso).
export function formatarData(texto) {
  const [ano, mes, dia] = String(texto).split("-");
  return `${dia}/${mes}/${ano}`;
}

export function hoje() {
  const d = new Date();
  const mes = String(d.getMonth() + 1).padStart(2, "0");
  const dia = String(d.getDate()).padStart(2, "0");
  return `${d.getFullYear()}-${mes}-${dia}`;
}