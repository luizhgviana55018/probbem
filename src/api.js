async function requisicao(caminho, opcoes = {}) {
  let resposta;
  try {
    resposta = await fetch(`/api${caminho}`, {
      headers: { "Content-Type": "application/json" },
      ...opcoes,
    });
  } catch {
    throw new Error("Sem conexão com o servidor. Verifique se o frontend e a API estão rodando.");
  }

  if (resposta.status === 204) return null;

  let corpo = null;
  try {
    corpo = await resposta.json();
  } catch {
    corpo = null;
  }

  if (!resposta.ok) {
    throw new Error(corpo?.erro || "Algo deu errado. Tente novamente.");
  }
  return corpo;
}

export function listarDoadores() {
  return requisicao("/doadores");
}

export function cadastrarDoador(doador) {
  return requisicao("/doadores", { method: "POST", body: JSON.stringify(doador) });
}

export function editarDoador(id, doador) {
  return requisicao(`/doadores/${id}`, { method: "PUT", body: JSON.stringify(doador) });
}

export function excluirDoador(id) {
  return requisicao(`/doadores/${id}`, { method: "DELETE" });
}

export function listarItens() {
  return requisicao("/itens");
}

export function listarDoacoes() {
  return requisicao("/doacoes");
}

export function registrarDoacao(doacao) {
  return requisicao("/doacoes", { method: "POST", body: JSON.stringify(doacao) });
}