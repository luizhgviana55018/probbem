import express from 'express';
import cors from 'cors';
import helmet from 'helmet'; // Incluído pois já está no seu package.json

const app = express();
const port = process.env.PORT || 3000;

// Configuração de middlewares de segurança, CORS e parser de JSON
app.use(helmet());
app.use(cors({ origin: process.env.CORS_ORIGIN || 'http://localhost:5173' }));
app.use(express.json());

// Rota GET /api/health exigida na Atividade 1
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.listen(port, () => {
  console.log(`API da ONG ProBem rodando na porta ${port}`);
});