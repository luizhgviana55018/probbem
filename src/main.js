import "./style.css";
import { telaDoadores } from "./pages/doadores.js";
import { telaRegistrar, telaDoacoes } from "./pages/doacoes.js";

const rotas = {
  "#/doadores": telaDoadores,
  "#/registrar": telaRegistrar,
  "#/doacoes": telaDoacoes,
};

const app = document.querySelector("#app");

async function navegar() {
  const rota = rotas[location.hash] ? location.hash : "#/doadores";
  for (const link of document.querySelectorAll("nav a")) {
    if (link.getAttribute("href") === rota) link.setAttribute("aria-current", "page");
    else link.removeAttribute("aria-current");
  }
  await rotas[rota](app);
}

window.addEventListener("hashchange", navegar);
await navegar();