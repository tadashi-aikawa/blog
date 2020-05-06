---
title: Expressでjsdocと同期したAPI仕様書の作り方
slug: create-api-specification-with-express
date: 2019-06-18T21:43:07+09:00
thumbnailImage: images/cover/2019-06-18.jpg
categories:
  - engineering
tags:
  - open-api
  - swagger
  - express
  - nodejs
  - javascript
---

[Express]で作成したAPIの仕様書を[Swagger UI]を使って作りました。

<!--more-->

{{<cimg "2019-06-18.jpg">}}

<!--toc-->


はじめに
--------

仕事で[Express]を使ったAPIの開発をしています。  
しかし、そのシステムはレガシーであるためAPI仕様書が存在しません。

Markdownやyamlを使って仕様書を作る方法はありますが、時間と共にソースコードと乖離する恐れがあります。  
そこでソースコードのjsdocから、API仕様書を作成する仕組みを整えました。

本記事では仕組み作成の部分にフォーカスを絞って紹介します。  
[Open API]の書き方や、実用的なAPIパターンの紹介はしません。

### 使用したpackageのバージョン

|      pacakge       | バージョン | インストール先 |
| ------------------ | ---------- | -------------- |
| node               | v10.13.0   | global         |
| npm                | 6.7.0      | global         |
| express            | 4.17.1     | local          |
| swagger-jsdoc      | 3.2.9      | local          |
| swagger-ui-express | 4.0.6      | local          |


APIの作成
---------

まずは[Express]を使った簡単なAPIを作ります。

### 準備

プロジェクトディレクトリを作成し、その中で[Express]をインストールします。

```
$ npm init -y
$ npm i express
```

### コードの作成

`main.js`を作成して以下のコードを書きます。

```javascript
var express = require('express')
var app = express()

app.get('/hello', (req, res) => res.json({
  message: `Hello ${req.query.name}!`,
  yourName: req.query.name,
}))

app.listen(3000, () => console.log("Listen on port 3000."))
```

起動します。

```
$ node main.js
```

`http://localhost:3000/hello?name=John`とリクエストすれば、以下のような結果を返します。

```json
{"message":"Hello John!","yourName":"John"}
```

ここから作成したAPIのドキュメントを作成していきます。


依存packageのインストール
-------------------------

### swagger-ui-express

[Swagger UI]のドキュメントを[Express]から配信できるようにするpackageです。

```
$ npm i -D swagger-ui-express
```

これだけでは`swagger.json`を自分で作成する必要があります。  
今回はソースコード(jsdoc)からAPI仕様書を作成したいので、別のpackageもインストールする必要があります。


### swagger-jsdoc

jsdocから[Swagger UI]で使用可能なjsonを作成できるpackageです。

```
$ npm i -D swagger-jsdoc
```


完成コードと解説
----------------

### 完成コード

{{<file "main.js">}}
```javascript
const express = require('express')
const app = express()
const swaggerUi = require('swagger-ui-express')
const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  swaggerDefinition: {
    info: {
      title: 'MAMANのAPI',
      version: '1.0.0'
    },
  },
  apis: ['./main.js'],
};
app.use('/spec', swaggerUi.serve, swaggerUi.setup(swaggerJSDoc(options)))

/**
 * @swagger
 * /hello:
 *   get:
 *     description: こんにちはと挨拶してくれます
 *     produces:
 *       - application/json
 *     parameters:
 *       - name: name
 *         description: アナタの名前
 *         in: query
 *         required: true
 *         type: string
 *     responses:
 *       200:
 *         description: nameにJohnを指定した場合、挨拶を返す
 *         examples:
 *           result:
 *              message: Hello Jon!
 *              yourName: John
 */
app.get('/hello', (req, res) => res.json({
  message: `Hello ${req.query.name}!`,
  yourName: req.query.name,
}))

app.listen(3000, () => console.log("Listen on port 3000."))

```
{{</file>}}

起動コマンドは変わりません。

```
$ node main.js
```

`http://localhost:3000/spec`にアクセスすると仕様書が表示されます。


### swagger関連の仕組み部分

仕組みの部分は以下のコードです。

```javascript
const swaggerUi = require('swagger-ui-express')
const swaggerJSDoc = require('swagger-jsdoc');

const options = {
  swaggerDefinition: {
    info: {
      title: 'MAMANのAPI',
      version: '1.0.0'
    },
  },
  apis: ['./main.js'],
};
app.use('/spec', swaggerUi.serve, swaggerUi.setup(swaggerJSDoc(options)))
```

`/spec`のエンドポイントに対して、`swaggerUi.serve`というhandlerを渡します。  
次の引数にjsdocから変換された設定が渡ります。

`options`は仕様書の情報です。  
`apis`にはAPI(jsdoc)が記載されたファイルのパターン(`**/*.js`など)を指定します。

今回は同じファイル内にAPIが存在するため、自身である`./main.js`を指定しました。


### API(jsdoc)部分

API仕様が記載されたjsdocの部分です。

```javascript
/**
 * @swagger
 * /hello:
 *   get:
 *     description: こんにちはと挨拶してくれます
 *     produces:
 *       - application/json
 *     parameters:
 *       - name: name
 *         description: アナタの名前
 *         in: query
 *         required: true
 *         type: string
 *     responses:
 *       200:
 *         description: nameにJohnを指定した場合、挨拶を返す
 *         examples:
 *           result:
 *              message: Hello Jon!
 *              yourName: John
 */
app.get('/hello', (req, res) => res.json({
  message: `Hello ${req.query.name}!`,
  yourName: req.query.name,
}))
```

記載内容..[Open API]の仕様は以下を参照してください。

{{<summary "https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md">}}



総括
----

[Express]で作成したAPIの仕様書を[Swagger UI]を使って作りました。

[Swagger UI]の元となる情報は[swagger-ui-express]と[swagger-jsdoc]を使ってjsdocから自動生成しています。  
それゆえ、別途yamlファイルを管理したり、仕様書(静的ファイル)を配信する方法を考える必要がありません。

APIのエントリポイントが書かれたコードの上に記載することで、仕様と実装の乖離しないスマートな開発ができるのではないでしょうか。

[Express]: http://expressjs.com/
[Swagger UI]: https://swagger.io/tools/swagger-ui/
[Open API]: https://github.com/OAI/OpenAPI-Specification
[swagger-ui-express]: https://github.com/scottie1984/swagger-ui-express
[swagger-jsdoc]: https://github.com/Surnet/swagger-jsdoc
