# PetBooking Business Intelligence

* Main branch: master
* Rails version: 5.0.2
* PG version: ~> 0.18

## Para que serve?

Este app tem como função alimentar o dashboard do Klipfolio utilizado
para metrificar todos os aspectos da plataforma do PetBooking.
Para tal este app se alimenta dos dados do PetBooking, seja os dados locais ou
de produção.
Nenhum tipo de escrita é feito no banco, apenas o consumo de um Database Follower.

## Instalação

Primeiramente é necessário que o database do PetBooking esteja criado e tenha dados.
É possível criar apenas o banco local sem precisar da aplicação inteira do PetBooking.
Par isso, siga os seguintes comandos (e peça a outro desenvolvedor um DUMP atual)

1 - Criando o database standalone (abra o terminal do PostgreSQL):

No Terminal do PostgreSQL:

```
CREATE DATABASE petbooking_development;
\q (para sair)
```

2 - Suba o dump de dados com o comando (terminal padrão do seu computador)

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d petbooking_development ~/caminho/do/dump
```

3 - Configure o Local Tunnel (utilizado para acessar o app em dev de fora da sua rede)

```
npm -g install localtunnel
```

## Variáveis de Ambiente

Utilizamos a gem [dotenv-rails](https://github.com/bkeepers/dotenv)
Você deve copiar e modificar os dados do arquivo `.env.example` para um arquivo `.env`

No Terminal:

```
cp .env.example .env
```

## Rodando a aplicação

Lembre-se, esta aplicação é apenas uma API que irá alimentar um dashboard,
portanto não possui qualquer tipo de interface de usuário.
Se você quiser testar a saída de dados pode executar comandos manuais de cURL
no terminal ou através de programas como o [POSTman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop)

No Terminal:

```
bin/rails server
```

Abra outra aba do Terminal e abra o [LocalTunnel](https://github.com/localtunnel/localtunnel)

```
lt --port 3000 (ou a porta atual do seu server Rails)
```

## Abrindo novos PRs

Na PetBooking trabalhamos com o envio de PRs para fechamento de tarefas no [Trello](https://trello.com/c/aPOkcSkD).
Procuramos utilizar os prefixos de GitFlow o máximo possível, então segue um exemplo:

```
git checkout -b feature/add-endpoint-for-user-metrics
git checkout -b hotfix/fix-wrong-value-for-current-users
git checkout -b bug/users-endpoint-return-unprocessable-entity
```

## Atualizando o [Trello](https://trello.com/c/aPOkcSkD)

- Após abrir o PR coloque o link no card correspondente do Trello
- Mova o Card para "Pull Request Open"
- Antes de fechar o PR leia atentamente os comentários e sugestões no PR
- Quando o PR for mergeado mova o Card para a coluna "Done" atual
