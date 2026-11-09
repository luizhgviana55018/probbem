import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { appendFile, mkdir } from 'node:fs/promises';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const dataFile = join(dirname(fileURLToPath(import.meta.url)), 'data', 'voluntarios.jsonl');
const emailOk = (v) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);

async function salvar(registro) {
  await mkdir(dirname(dataFile), { recursive: true });
  await appendFile(dataFile, JSON.stringify(registro) + '\n');
}

export function createApp({ corsOrigin = 'http://localhost:5173', save = salvar } = {}) {
  const app = express();
  app.use(helmet());
  app.use(cors({ origin: corsOrigin }));
  app.use(express.json({ limit: '10kb' }));

  app.get('/api/health', (req, res) => {
    res.json({
      status: 'ok',
      message: 'API da ONG ProBem funcionando',
      timestamp: new Date().toISOString(),
    });
  });

  app.post('/api/voluntarios', async (req, res) => {
    const nome = String(req.body?.nome ?? '').trim();
    const email = String(req.body?.email ?? '').trim();
    const mensagem = String(req.body?.mensagem ?? '').trim().slice(0, 500);

    const erros = {};
    if (nome.length < 2) erros.nome = 'Informe seu nome.';
    if (!emailOk(email)) erros.email = 'Informe um e-mail válido.';
    if (Object.keys(erros).length) return res.status(400).json({ erros });

    try {
      await save({ nome, email, mensagem, criadoEm: new Date().toISOString() });
      res.status(201).json({ message: 'Cadastro recebido. Entraremos em contato!' });
    } catch {
      res.status(500).json({ message: 'Não foi possível salvar agora. Tente novamente.' });
    }
  });

  return app;
}
