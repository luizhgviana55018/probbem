# ONG ProBem

Site e API da ONG ProBem, uma organização **fictícia** criada para fins de estudo: front-end em Vite (Vanilla JS) e API Express.

## Requisitos

- Node.js 20.6 ou superior
- Opcional: [Vite+](https://viteplus.dev) (`vp`). Os comandos abaixo funcionam com `npm`; com Vite+, troque `npm run` por `vp run`.

## Como rodar

```bash
git clone https://github.com/SEU-USUARIO/probem.git
cd probem
npm install
cp .env.example .env
npm run dev        # sobe API (porta 3000) e site (porta 5173)
```

Abra http://localhost:5173.

## Scripts

| Comando | O que faz |
| --- | --- |
| `npm run dev` | API e front-end juntos |
| `npm run api` / `npm run web` | Cada um separado |
| `npm test` | Testes da API |
| `npm run build` | Gera o site em `dist/` |
| `npm start` | Roda só a API (produção) |

## Variáveis de ambiente

| Variável | Padrão | Uso |
| --- | --- | --- |
| `PORT` | `3000` | Porta da API |
| `CORS_ORIGIN` | `http://localhost:5173` | Endereço do site autorizado a chamar a API |

## Rotas da API

- `GET /api/health`: status da API.
- `POST /api/voluntarios`: recebe `{ nome, email, mensagem? }` e salva em `server/data/voluntarios.jsonl`. Retorna `400` com `erros` por campo se algo for inválido.

## Estrutura

```
server/app.js       rotas e configuração da API
server/index.js     inicia o servidor
server/app.test.js  testes
src/main.js         status da API e formulário
src/style.css       estilos
index.html          página do site
vite.config.js      proxy /api -> API
```

## Antes de publicar

- A ONG, os projetos, o horário e a chave Pix (`00.000.000/0001-00`) são fictícios. Se virar uma ONG real, troque tudo em `index.html`.
- Os cadastros ficam em arquivo local. Em hospedagem gratuita esse arquivo pode ser apagado; para uso real, use um banco de dados.
- Hospedagem sugerida: site em GitHub Pages ou Netlify (`npm run build`) e API em Render ou Railway (`npm start`, defina `CORS_ORIGIN` com o endereço do site).

## Publicar no GitHub

```bash
git init && git add . && git commit -m "feat: cria site e API da ONG ProBem"
git branch -M main
gh repo create probem --public --source=. --push
```

## Mensagens de commit sugeridas

- `feat: cria projeto ProBem com Vite (Vanilla, JavaScript)`
- `feat: adiciona API Express com /api/health e /api/voluntarios`
- `feat: página inicial da ONG com formulário de voluntários`
- `test: adiciona testes da API`
- `ci: adiciona workflow de testes e build`
- `docs: README com instruções`