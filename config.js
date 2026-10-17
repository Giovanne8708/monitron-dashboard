/* Configuração pública do Supabase para o painel Monitron.
   A chave anon/publishable pode ficar no navegador somente com RLS corretamente configurado.
   NUNCA coloque service_role, senha ou segredo privado neste arquivo. */
window.MONITRON_CONFIG = {
  supabaseUrl: 'COLOQUE_A_URL_DO_SEU_PROJETO',
  supabaseAnonKey: 'COLOQUE_A_CHAVE_PUBLICA_ANON_OU_PUBLISHABLE'
};
