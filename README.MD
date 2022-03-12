Bookstack - Docker Environment
====================

**Observação**

Configurações foram feitas no projeto [BookStack](https://github.com/BookStackApp/BookStack) original para suportar Esbuild.

**Execução**

1. Use ```docker-compose up``` na raiz do projeto.
2. Acesse o container bookstackphp e execute a migração do banco pelo ```php artisan migrate --no-interaction --force``` caso não tenha um banco pré configurado.
3. Acesse localhost:9876 da sua maquina host.

## Dependências

 * Docker
 * docker-compose

