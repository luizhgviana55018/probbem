import { listarDoadores, cadastrarDoador, editarDoador, excluirDoador } from "../api.js";
import { el, mensagem, carregando, vazio } from "../ui.js";

export async function telaDoadores(app) {
  let editandoId = null;

  const aviso = el("div", { "aria-live": "polite" });
  const lista = el("div", { class: "lista" });

  const campoNome = el("input", { id: "nome", name: "nome", type: "text", required: true, maxlength: 150, autocomplete: "name" });
  const campoEmail = el("input", { id: "email", name: "email", type: "email", maxlength: 100, autocomplete: "email" });
  const campoTelefone = el("input", { id: "telefone", name: "telefone", type: "tel", maxlength: 20, autocomplete: "tel" });
  const botaoSalvar = el("button", { type: "submit" }, "Salvar doador");
  const botaoCancelar = el("button", { type: "button", class: "secundario", hidden: true }, "Cancelar edição");
  const titulo = el("h2", {}, "Novo doador");

  const form = el(
    "form",
    { class: "cartao" },
    titulo,
    el("label", {}, "Nome", campoNome),
    el("label", {}, "E-mail (opcional)", campoEmail),
    el("label", {}, "Telefone / WhatsApp (opcional)", campoTelefone),
    el("div", { class: "acoes" }, botaoSalvar, botaoCancelar),
  );

  function sairDaEdicao() {
    editandoId = null;
    form.reset();
    titulo.textContent = "Novo doador";
    botaoCancelar.hidden = true;
  }

  async function carregarLista() {
    lista.replaceChildren(carregando());
    try {
      const doadores = await listarDoadores();
      if (doadores.length === 0) {
        lista.replaceChildren(vazio("Nenhum doador cadastrado ainda."));
        return;
      }
      lista.replaceChildren(...doadores.map(cartaoDoador));
    } catch (erro) {
      lista.replaceChildren(mensagem(erro.message, "erro"));
    }
  }

  function cartaoDoador(d) {
    return el(
      "article",
      { class: "cartao" },
      el("h3", {}, d.nome),
      el("p", {}, d.email ?? "sem e-mail"),
      el("p", {}, d.telefone ?? "sem telefone"),
      el(
        "div",
        { class: "acoes" },
        el("button", {
          type: "button",
          onclick: () => {
            editandoId = d.id_doador;
            titulo.textContent = `Editando ${d.nome}`;
            campoNome.value = d.nome;
            campoEmail.value = d.email ?? "";
            campoTelefone.value = d.telefone ?? "";
            botaoCancelar.hidden = false;
            campoNome.focus();
          },
        }, "Editar"),
        el("button", {
          type: "button",
          class: "perigo",
          onclick: async () => {
            if (!confirm(`Excluir ${d.nome}? Essa ação não pode ser desfeita.`)) return;
            try {
              await excluirDoador(d.id_doador);
              aviso.replaceChildren(mensagem(`${d.nome} foi excluído.`));
              if (editandoId === d.id_doador) sairDaEdicao();
              await carregarLista();
            } catch (erro) {
              aviso.replaceChildren(mensagem(erro.message, "erro"));
            }
          },
        }, "Excluir"),
      ),
    );
  }

  form.addEventListener("submit", async (evento) => {
    evento.preventDefault();
    const dados = Object.fromEntries(new FormData(form));
    botaoSalvar.disabled = true;
    try {
      if (editandoId) {
        await editarDoador(editandoId, dados);
        aviso.replaceChildren(mensagem(`${dados.nome} foi atualizado.`));
      } else {
        await cadastrarDoador(dados);
        aviso.replaceChildren(mensagem(`${dados.nome} foi cadastrado.`));
      }
      sairDaEdicao();
      await carregarLista();
    } catch (erro) {
      aviso.replaceChildren(mensagem(erro.message, "erro"));
    } finally {
      botaoSalvar.disabled = false;
    }
  });

  botaoCancelar.addEventListener("click", sairDaEdicao);

  app.replaceChildren(
    el("div", { class: "duas-colunas" }, form, el("section", {}, el("h2", {}, "Doadores cadastrados"), aviso, lista)),
  );
  await carregarLista();
}