var urlParams = new URLSearchParams(window.location.search);{
  if (urlParams.has('erro') && urlParams.get('erro') === 'usuario_existente') {
        alert('Este email já está cadastrado.');
    }else if(urlParams.has('ack') && urlParams.get('ack') === 'cadastro_concluido')
        alert('Cadastro concluído com sucesso!');
    };