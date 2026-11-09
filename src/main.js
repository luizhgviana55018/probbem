// Atualiza o ano de copyright no rodapé dinamicamente
const anoSpan = document.getElementById('ano');
if (anoSpan) {
  anoSpan.textContent = new Date().getFullYear();
}

// Verifica o status da API e atualiza o rodapé com data e hora
async function checarStatusAPI() {
  const statusElement = document.getElementById('status');
  
  if (!statusElement) return;

  try {
    const resposta = await fetch('/api/health');
    const dados = await resposta.json();

    if (resposta.ok && dados.status === 'ok') {
      // Pega a data e hora do navegador do usuário e formata no padrão brasileiro
      const dataHoraAtual = new Date().toLocaleString('pt-BR');
      
      // Atualiza o texto para cumprir a exigência do PDF da atividade
      statusElement.textContent = `Status da API: ok - ${dataHoraAtual}`;
      statusElement.dataset.estado = 'ok';
    } else {
      statusElement.textContent = 'Status da API: erro na resposta';
      statusElement.dataset.estado = 'erro';
    }
  } catch (erro) {
    console.error('Erro ao conectar com a API:', erro);
    statusElement.textContent = 'Status da API: fora do ar';
    statusElement.dataset.estado = 'erro';
  }
}

// Executa a função assim que o script é carregado
checarStatusAPI();