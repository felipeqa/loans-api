<h1>Arquitetura do projeto</h1>

API em rails com autenticação usando JWT para treinamento de automação.
-------------------------

Esse projeto tem como objetivo disponibilizar uma API para automação de teste com autenticação, criando desafios para quem utilizar.

Essa API também está disponível em produção, vou disponibilizar a collection do Postman ao final do post.


<h3>1. O que precisamos?</h3>

* Docker: [Docker info](https://www.docker.com/)

* Postman: [Postman info](https://www.getpostman.com/)


<h3>2. Vamos começar? </h3>

Se vc tem o docker instalado e também o postman é bem simples inicializar a aplicação, eu criei o dockerfile e o script que faz isso para nós.


<h3>3. Vamos fazer o clone do projeto </h3>

Primeiro passo a ser feito é clonar o projeto para a nossa máquina:

```bash
git clone https://github.com/felipeqa/loans-api.git
```

Eu por exemplo clonei dentro de um diretório chamado rails

![Passo 1](readme_images/Picture1.jpg?raw=true)

Obs: Se vc não tiver o git instalado, vc pode baixar o zip e descompactar em algum diretório.

* [Link Download](https://github.com/felipeqa/loans-api/archive/master.zip)

<h3>4. Agora vamos até a raiz do projeto </h3>

```bash
cd loans-api
```
![Passo 2](readme_images/Picture2.jpg?raw=true)


<h3>5. Execução do script</h3>

Agora que estamos na raiz do projeto, vamos executar o script:

```bash
sh scripts/setup
```

Isso deve demorar um pouco pois é preciso baixar algumas dependências

![Passo 3](readme_images/Picture3.jpg?raw=true)

![Passo 4](readme_images/Picture4.jpg?raw=true)

Quando exibir "Successfully tagged loan-api/rails:latest" é por que a API está de pé.

Obs: Se vc não conseguir executar o script, vc pode executar diretamente os camandos no seu terminal:

```bash
docker build -t loan-api/rails .
docker run -p 3000:3000 loan-api/rails
```

Para verificar, vc só precisa acessar essa [url](http://localhost:3000/)

O projeto sobe na url http://localhost:3000

![Passo 5](readme_images/Picture5.jpg?raw=true)


<h3>6. Importando as collections no Postman</h3>


* Collection para o ambiente local:

https://www.getpostman.com/collections/fd3039c516e6e537264a


* Collection para o ambiente de produção:

https://www.getpostman.com/collections/2c862f1f7f5b501ad915


Para importar a collection é bem simples, clica em Import:

![Passo 6](readme_images/Picture6.jpg?raw=true)

Clicar em "Import From Link" e colar a url acima:

![Passo 7](readme_images/Picture7.jpg?raw=true)

Agora que importamos as collections, vou explicar como utilizar cada verbo da api.


<h3>7. Detalhando cada endpoint</h3>

Se saber todas as rotas da api:

```bash
rake routes
```

![Passo 8](readme_images/Picture8.jpg?raw=true)


* Server URL:

Local: http://localhost:3000

Produção: https://loans-api-felipe-qa.herokuapp.com


Endpoints:
-------------------------

* *GET* / ou root  **(Não necessita autenticação)**

Esse endpoint é apenas para verificar se a API está respondendo

* *GET* /auth **(Necessita autenticação)**

Esse endpoint é apenas para saber se o token é valido e retorna o usuário e o email

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

|HTTP: Status   |
|---|
|200|
|401|

* *POST* /user_token **(Necessita de um usuário cadastrado)**

Esse endpoint é responsável de obter um token dado um usuário e senha

Body:

```json
{
	"auth":{
		"email": "admin@admin.com",
		"password": "password"
	}
}
```

Response:

```json
{
    "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE1NDEwOTA3NTQsInN1YiI6Mn0.dZ7HV37hhZFuTeUVp5ZsZEdRpw06gukbUkorXkvAEvs"
}
```

|HTTP: Status   |
|---|
|200|
|401|
|404|

* *GET* /users **(Necessita autenticação)**

Esse endpoint lista todos os usuários cadastrados na aplicação

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

|HTTP: Status   |
|---|
|200|
|401|

* *GET* /users/current **(Necessita autenticação)**

Esse endpoint lista  as informações do usuário atual com base no token

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

|HTTP: Status   |
|---|
|200|
|401|

* *POST* /users/create **(Necessita autenticação)**

Esse endpoint é responsável por criar um usuários

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
"Content-Type": "application/json"
```

*Usuário padrão:*

```json
{
	"user":{
		"email": "test{{$timestamp}}@teste.com",
		"password": "password",
		"username": "teste{{$timestamp}}"
	}
 }
```

*Usuário admin adicionar a* ***role:"admin"*** *:*

```json
{
	"user":{
		"email": "test{{$timestamp}}@teste.com",
		"password": "password",
		"username": "teste{{$timestamp}}",
        "role": "admin"
	}
 }
```

|HTTP: Status   |
|---|
|200|
|401|
|204|   |

Obs: 204 se vc tentar cadastrar o mesmo email ou username, eu não tratei o http code e também não coloquei uma mensagem apropriada.

* *PUT* /user/:id **(Necessita autenticação)**

Esse endpoint é responsável por fazer a atualização de um usuário e senha com base no seu id

**REGRA**:

1* Usuário comum só pode alterar a ele mesmo, ou seja, o token só atualiza o usuário com o seu respectivo id.
2* Usuário com a rule admin pode alterar qualquer usuário.

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
"Content-Type": "application/json"
```

Body:

```json
{
	"user":{
		"email": "test{{$timestamp}}@teste.com",
		"password": "password",
		"username": "teste{{$timestamp}}"
	}
 }
```

* *DELETE* /user/:id **(Necessita autenticação)**

Esse endpoint é responsável por fazer deletar um usuário com base no seu id

**REGRA**:

1* Usuário comum só pode deleter a ele mesmo, ou seja, o token só deleta o usuário com o seu respectivo id.
2* Usuário com a rule admin pode deletar qualquer usuário.

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

* *GET*  /api/v1/loans **(Necessita autenticação)**

Esse endpoint é responsável por listar todos os empréstimos existentes de todos os cliente

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

* *POST*  /api/v1/loans **(Necessita autenticação)**

Esse endpoint é responsável por cadastrar os empréstimos de cada cliente

OBS: O próprio endpoint calcula a parcela para o cliente, ou seja, dado um valo e quantidade parcela o endpoint retorna o valor da parcela (calculo sem juros hoje)

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
"Content-Type": "application/json"
```

Body:

```json
{
  "name": "felipe",
  "cpf": "33333333333",
  "total_loans": 100,
  "quantity_quotas": 10
 }
```

* *GET*  /api/v1/loans/:id **(Necessita autenticação)**

Esse endpoint recuperar um empréstimo dado o seu id

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

* *DEL*  /api/v1/loans/:id **(Necessita autenticação)**

Esse endpoint deleta um empréstimo dado o seu id

**REGRA**: Somente o admin pode remover um empréstimo

Usar o header:

```json
"Authorization": "Bearer ${token_jwt_gerado}"
```

Então galera é isso!

Essa é apenas a primeira parte do post!

Vou criar um novo projeto mostranto como eu faria estes testes, esse aqui é apenas o desafio para vc que quer fazer testes em api ou contrato.

O intuíto é fornecer essa api como interface para testes, se vc quiser um ambiente mais reservado, faça o clone do projeto e suba a aplicação com o docker, se vc quer apenas fazer algumas brincadeira e talz use a de produção mesmo.

Agora escolha seu framework favorita e mão-na-massa.

Até o próximo!!!!!

Contato
-------
Estou aberto a sugestões, elogios, críticas ou qualquer outro tipo de comentário.

*	E-mail: felipe_rodriguesx@hotmail.com.br
*	Linkedin: <https://www.linkedin.com/in/luis-felipe-rodrigues-de-oliveira-2b056b5a/>

Licença
-------
Esse código é livre para ser usado dentro dos termos da licença MIT license.
