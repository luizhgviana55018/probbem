import { listarDoadores, listarItens, listarDoacoes, registrarDoacao } from "../api.js";
import { el, mensagem, carregando, vazio, formatarData, hoje } from "../ui.js";

export async function telaRegistrar(app) {
  app.replaceChildren(el("h2", {}, "Registrar doação"), carregando());

  let doadores;
  let itens;
  try {
    [doadores, itens] = await Promise.all([listarDoadores(), listarItens()]);
  } catch (erro) {
    app.replaceChildren(el("h2", {}, "Registrar doação"), mensagem(erro.message, "erro"));
    return;
  }

  if (doadores.length === 0) {
    app.replaceChildren(
      el("h2", {}, "Registrar doação"),
      vazio("Cadastre um doador antes de registrar uma doação."),
      el("a", { href: "#/doadores" }, "Ir para Doadores"),
    );
    return;
  }

  const aviso = el("div", { "aria-live": "polite" });
  const avisoMedicamento = el("p", { class: "alerta", hidden: true, role: "status" },
    "Atenção: medicamentos com restrição de uso só são liberados mediante avaliação do médico voluntário responsável (Dr. André Luiz Carvalho).");

  const selectDoador = el("select", { name: "id_doador", required: true },
    el("option", { value: "" }, "Selecione..."),
    doadores.map((d) => el("option", { value: d.id_doador }, d.nome)),
  );
  const campoData = el("input", { type: "date", name: "data_doacao", required: true, value: hoje() });
  const campoObs = el("input", { type: "text", name: "observacao", maxlength: 255 });
  const linhasItens = el("div", { class: "itens" });
  const botaoSalvar = el("button", { type: "submit" }, "Registrar doação");

  function conferirMedicamento() {
    const selecionados = [...linhasItens.querySelectorAll("select")].map((s) => s.selectedOptions[0]?.dataset.categoria);
    avisoMedicamento.hidden = !selecionados.includes("Medicamento");
  }

  function novaLinhaItem() {
    const selectItem = el("select", { required: true, onchange: conferirMedicamento },
      el("option", { value: "" }, "Item..."),
      itens.map((i) => el("option", { value: i.id_item, "data-categoria": i.categoria }, `${i.nome} (${i.unidade})`)),
    );
    const campoQtd = el("input", { type: "number", min: 1, step: 1, required: true, value: 1, "aria-label": "Quantidade" });
    const remover = el("button", {
      type: "button",
      class: "secundario",
      onclick: () => {
        if (linhasItens.children.length > 1) {
          linha.remove();
          conferirMedicamento();
        }
      },
    }, "Remover");
    const linha = el("div", { class: "linha-item" }, selectItem, campoQtd, remover);
    return linha;
  }

  linhasItens.append(novaLinhaItem());

  const form = el(
    "form",
    { class: "cartao" },
    el("label", {}, "Doador", selectDoador),
    el("label", {}, "Data da doação", campoData),
    el("label", {}, "Observação (opcional)", campoObs),
    el("fieldset", {}, el("legend", {}, "Itens da doação"), linhasItens,
      el("button", { type: "button", class: "secundario", onclick: () => linhasItens.append(novaLinhaItem()) }, "Adicionar item")),
    avisoMedicamento,
    el("div", { class: "acoes" }, botaoSalvar),
  );

  form.addEventListener("submit", async (evento) => {
    evento.preventDefault();
    const itensEnviados = [...linhasItens.querySelectorAll(".linha-item")].map((linha) => ({
      id_item: Number(linha.querySelector("select").value),
      quantidade: Number(linha.querySelector("input").value),
    }));
    const doacao = {
      id_doador: Number(selectDoador.value),
      data_doacao: campoData.value,
      observacao: campoObs.value || null,
      itens: itensEnviados,
    };
    botaoSalvar.disabled = true;
    try {
      await registrarDoacao(doacao);
      location.hash = "#/doacoes";
    } catch (erro) {
      aviso.replaceChildren(mensagem(erro.message, "erro"));
    } finally {
      botaoSalvar.disabled = false;
    }
  });

  app.replaceChildren(el("h2", {}, "Registrar doação"), aviso, form);
}

export async function telaDoacoes(app) {
  app.replaceChildren(el("h2", {}, "Doações registradas"), carregando());
  try {
    const doacoes = await listarDoacoes();
    if (doacoes.length === 0) {
      app.replaceChildren(el("h2", {}, "Doações registradas"), vazio("Nenhuma doação registrada ainda."));
      return;
    }
    app.replaceChildren(
      el("h2", {}, "Doações registradas"),
      el("div", { class: "lista" }, doacoes.map(cartaoDoacao)),
    );
  } catch (erro) {
    app.replaceChildren(el("h2", {}, "Doações registradas"), mensagem(erro.message, "erro"));
  }
}

function cartaoDoacao(d) {
  return el(
    "article",
    { class: "cartao" },
    el("header", { class: "topo-cartao" },
      el("h3", {}, d.doador.nome),
      el("time", { datetime: d.data_doacao }, formatarData(d.data_doacao))),
    d.observacao ? el("p", {}, d.observacao) : null,
    el("ul", {}, d.itens.map((i) => el("li", {}, `${i.quantidade} × ${i.nome} (${i.unidade})`))),
  );
}