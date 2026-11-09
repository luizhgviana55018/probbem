import test from 'node:test';
import assert from 'node:assert/strict';
import { createApp } from './app.js';

async function withServer(fn) {
  const server = createApp({ save: async () => {} }).listen(0);
  const base = `http://localhost:${server.address().port}`;
  try { await fn(base); } finally { server.close(); }
}

const post = (base, body) =>
  fetch(`${base}/api/voluntarios`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });

test('GET /api/health retorna ok', () =>
  withServer(async (base) => {
    const res = await fetch(`${base}/api/health`);
    assert.equal(res.status, 200);
    assert.equal((await res.json()).status, 'ok');
  }));

test('POST /api/voluntarios rejeita dados inválidos', () =>
  withServer(async (base) => {
    const res = await post(base, { nome: '', email: 'x' });
    assert.equal(res.status, 400);
  }));

test('POST /api/voluntarios aceita dados válidos', () =>
  withServer(async (base) => {
    const res = await post(base, { nome: 'Ana', email: 'ana@exemplo.com' });
    assert.equal(res.status, 201);
  }));
