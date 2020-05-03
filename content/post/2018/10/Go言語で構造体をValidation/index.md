---
title: Go言語で構造体をValidation
slug: golang-struct-validation
date: 2018-10-15T01:00:57+09:00
thumbnailImage: images/cover/2018-10-15.jpg
categories:
  - engineering
tags:
  - golang
---

validatorを使って、Go言語の構造体をスマートにValidationしてみました。

<!--more-->

{{<cimg "2018-10-15.jpg">}}

<!--toc-->


はじめに
--------

Go言語で開発しているとstructのフィールドを検証したくなることはないでしょうか。  
例えば、ユーザからの入力を受け取るインタフェース部分などです。

functionやreceiverを使えば目的を達成することはできます。  
しかし、都度if文や定義が必要になり泥臭く感じることはないでしょうか。

本記事ではvalidatorというライブラリを使ってそれをスマートに解決します。

{{<summary "https://github.com/go-playground/validator">}}


標準のやり方
------------

以下のような構造体とルールがあるとします。

| フィールド名 |   型   |  有効値   |
| ------------ | ------ | --------- |
| ID           | 数値   | 1～99     |
| Name         | 文字列 | 9文字以内 |

ライブラリを使わずに実装すると、以下の様な実装になると思います。

```go
package main

import (
	"fmt"
	"log"
)

type Fruit struct {
	ID   int
	Name string
}

func (r *Fruit) validate() error {
	if !(0 < r.ID && r.ID <= 99) {
		return errors.New("FruitのIDは1～99でなければいけません.")
	}

	if len(r.Name) >= 10 {
		return errors.New("FruitのNameは10文字未満でなければいけません.")
	}
	return nil
}

func main() {
	orange := Fruit{
		ID:   100,
		Name: "orange-range",
	}

	if err := orange.validate(); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%v\n", orange)
}
```

この実行結果は以下のようになります。

```
2018/10/15 01:19:47 FruitのIDは1～99でなければいけません.
```


validatorを使った場合
---------------------

validatorを使うとstructフィールドのタグに条件を記載するだけでOKです。  
先ほどのコードは以下のように書くことができます。

```go
package main

import (
	"fmt"
	"log"

	"gopkg.in/go-playground/validator.v9"
)

type Fruit struct {
	ID   int    `validate:"min=1,max=99"`
	Name string `validate:"max=9"`
}

func main() {
	validate := validator.New()

	orange := Fruit{
		ID:   100,
		Name: "orange-range",
	}

	if err := validate.Struct(orange); err != nil {
		log.Fatal(err)
	}

	fmt.Printf("%v\n", orange)
}
```

この実行結果は以下のようになります。

```
2018/10/15 01:35:38 Key: 'Fruit.ID' Error:Field validation for 'ID' failed on the 'max' tag
Key: 'Fruit.Name' Error:Field validation for 'Name' failed on the 'max' tag
```

今回の例では2つの条件共に違反しているため、2つの検証エラーが出ます。

maxやminの値を具体的に教えてくれないためエラーメッセージとしては不親切ですね..。  
自由にメッセージをカスタマイズする方法があれば知りたいです。


### 使えるタグ一覧

公式ドキュメントを参照して下さい。

{{<summary "https://godoc.org/gopkg.in/go-playground/validator.v9">}}

一番使うことが多いのは`required`ですね。


### トラブルシューティング

以下はよくハマッたケースです。

#### invalid memory address or nil pointer dereference

Validateインスタンスの初期化がされていません。  
`validate := validator.New()`のように初期化していることを確認してください。

#### タグに記載したルールでvalidationできない

実行エラーや検証エラーにならないケースです。  
以下を確認してください。

* フィールド名の先頭が大文字になっていること
* タグに記載された`:`の後にスペースが無いこと

例えば以下の例はどちら`Name`がNGです。

```go
type Fruit struct {
	name string `validate:"max=9"`
}
```

```go
type Fruit struct {
	Name string `validate: "max=9"`
}
```


総括
----

validatorを使って、Go言語の構造体をスマートにValidationしてみました。

今はエラーメッセージをカスタマイズしたり、エラーの種類によって処理を変える方法が分かっていません。  
今後、可能になった(やり方が分かった)場合は追記したいと思います。
