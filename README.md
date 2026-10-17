# Painel Comercial TRON — publicação e sincronização

Este pacote preserva a interface do arquivo `Monitron.html` e prepara a entrada `index.html` para hospedagem estática, com login e sincronização de dados via Supabase.

## Antes de publicar

**Não use dados comerciais reais até terminar a configuração e testar o acesso.** O painel contém dados comerciais; um repositório/site público não é apropriado para informações confidenciais sem a proteção correta. GitHub Pages padrão é público, mesmo se o repositório for privado. Se o site em si precisa ser privado, confirme se sua organização dispõe de GitHub Enterprise Cloud com Pages privado; caso contrário, escolha hospedagem com proteção de acesso ou coloque autenticação confiável na frente do site.

## Arquivos

- `index.html`: painel com as telas e funcionalidades do HTML original, adaptado para exigir login e sincronizar o estado do painel.
- `config.js`: URL do projeto Supabase e chave pública do cliente; preencher antes de publicar.
- `supabase-schema.sql`: tabela e políticas de segurança do banco.
- `.nojekyll`: evita processamento desnecessário do Jekyll.

## 1. Configurar o Supabase

1. Crie um projeto em https://supabase.com/.
2. Em **SQL Editor**, execute todo o conteúdo de `supabase-schema.sql`.
3. Em **Authentication**, desative o cadastro público de novos usuários. Crie manualmente apenas as contas autorizadas em **Authentication > Users**.
4. Em **Project Settings > API** (ou seção equivalente de API Keys), copie a URL do projeto e a chave pública `anon`/`publishable`.
5. Preencha esses valores em `config.js`. A chave pública é destinada ao navegador; a segurança depende das políticas RLS. Nunca use a chave `service_role` no HTML/JavaScript.
6. Confirme que a tabela `panel_state` está com RLS habilitado e que não há política para `anon`. Teste com usuário autenticado e também sem sessão.

A sincronização é feita como um único documento JSON do painel na tabela `panel_state`. Isso preserva o formato atual do banco do app, mas não é indicado para edição simultânea por várias pessoas. Para o cenário atual (uma pessoa cadastrando e a TV lendo), é uma solução inicial simples.

## 2. Migrar os dados existentes

**Antes de trocar do arquivo local para o site publicado:** abra o `Monitron.html` original no mesmo computador/navegador e use **Exportar backup** para salvar um JSON. O armazenamento de `file://` não é compartilhado com o domínio do GitHub Pages.

Depois de configurar Supabase e publicar: entre no site, faça login, use a opção de restaurar backup no menu do painel e selecione o JSON exportado. A restauração enviará os dados ao banco online. Se ainda não houver registro remoto, o primeiro login cria um registro inicial; restaure o backup logo depois para substituir esse estado inicial. Se já houver registro remoto, ele passa a ser a fonte principal e a cópia local anterior é guardada no navegador como `tron_painel_comercial_v1_pre_cloud_migration`. Faça primeiro um teste com uma cópia do backup.

## 3. Publicar no GitHub Pages

1. Crie um repositório. Se os dados/código não devem ser públicos, não presuma que repositório privado torna o site Pages privado.
2. Envie `index.html`, `config.js`, `supabase-schema.sql`, `README.md` e `.nojekyll` para a raiz da branch `main`.
3. Em **Settings > Pages**, configure a publicação a partir da branch `main`, pasta `/ (root)`.
4. Aguarde o deploy e abra o endereço mostrado pelo GitHub.
5. Faça login no computador e confira os registros. Abra o mesmo site na TV, entre com uma conta autorizada e teste se os indicadores atualizam após um cadastro de teste.

## 4. Testes obrigatórios antes de uso real

- Usuário sem login não consegue ler nem alterar `panel_state`.
- Conta autorizada consegue entrar; conta inválida não consegue.
- Cadastro no computador aparece na TV em até cerca de 10 segundos, com ambos online.
- Exportar backup e restaurar um backup de teste funciona.
- Configurações do modo TV, logo, categorias, pedidos, contratos e estoque permanecem depois de sair e entrar.
- Teste com dados fictícios antes de importar registros reais.

## Limitações conhecidas

- A TV também precisa de conexão com a internet e uma sessão autorizada.
- A sincronização consulta o banco a cada 10 segundos enquanto a página está visível.
- O banco guarda o estado completo do painel em um único registro; é apropriado para um operador principal, não para várias edições simultâneas.
- Faça backups regulares fora do navegador.
- Não publique informações comerciais no repositório, em screenshots ou em arquivos de exemplo.
