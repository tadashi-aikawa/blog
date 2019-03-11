---
title: TypeScriptで境界と戦う
slug: battle-with-boundary-typescript
date: 2019-03-10T20:24:31+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/shtz8i41arhndam/quentin-lagache-77362-unsplash.jpg
categories:
  - engineering
tags:
  - typescript
---

TypeScriptで境界に立ち向かう方法を整理してみました。  
本編はその導入部になります。機会があれば続編があるかも..

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/shtz8i41arhndam/quentin-lagache-77362-unsplash.jpg"/>

<!--toc-->


はじめに
--------

開発をしていると境界と向き合う機会が多いのではないでしょうか。  
代表的な境界には以下のようなものがあります。

* 設定ファイルの入出力
* Web APIのインタフェース
* DBにアクセスするDaoとテーブル定義
* ビジネスロジックとそれ以外

最近だとDDDが再び注目されている気がします。  
私もDDD本をちゃんと読んだことが無かったので以下を読み始めました。

<a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F13138730%2F&m=http%3A%2F%2Fm.rakuten.co.jp%2Fbook%2Fi%2F17331704%2F&link_type=pict&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0Iiwic2l6ZSI6IjMwMHgzMDAiLCJuYW0iOjEsIm5hbXAiOiJyaWdodCIsImNvbSI6MSwiY29tcCI6ImRvd24iLCJwcmljZSI6MSwiYm9yIjoxLCJjb2wiOjEsImJidG4iOjF9" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=17331704&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F1610%2F9784798131610.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F1610%2F9784798131610.jpg%3F_ex%3D300x300&s=300x300&t=pict" border="0" style="margin:2px" alt="" title=""></a>

本記事ではDDDについて語るつもりはありません。  
DDDでも取り上げられている境界について、TypeScriptを使って今までどのように実装してきたかをまとめています。


### 想定する読者

TypeScriptを使って普通に開発できる読者を想定しています。  
TypeScriptで実装したことがない方に向けての補足はありませんが、それでも問題なければご覧下さい。


お題のケース
------------

人というモデル複数から構成された`humans.json`を読みこみ、全員のフルネーム+年齢を表示するケースを考えます。

{{<file "humans.json">}}
```ts
[
    {
        "id": 1,
        "name": "ichiro",
        "myoji": "sato",
        "gender": "man",
        "birthday": "1991-01-01"
    },
    {
        "id": 2,
        "name": "jiro",
        "myoji": "tanaka",
        "gender": "man",
        "birthday": "1992-02-02"
    },
    {
        "id": 3,
        "name": "saki",
        "myoji": "suzuki",
        "gender": "woman",
        "birthday": "1993-03-03"
    }
]
```
{{</file>}}

フルネームと年齢の定義は以下です。

|            |                 定義                 | 具体例(ichiroの場合) |
| ---------- | ------------------------------------ | -------------------- |
| フルネーム | 名前と名字をハイフンで連結した文字列 | ichiro-sato          |
| 年齢       | 2019年3月11日時点の年                | 28                   |


ベースとなる実装
----------------

まずはベースの実装を紹介します。

### 準備

適当なディレクトリを作成し、npmプロジェクトとしてください。

```
$ npm init -y
```

続いて、TypeScriptの開発に必要なpackageをインストールします。

```
$ npm i typescript ts-node @types/node dayjs
```

今回は日付を扱うので`dayjs`もインストールしました。

{{<summary "https://github.com/iamkun/dayjs">}}

最後にTypeScriptプロジェクトとして初期化します。

```
$ npx tsc --init --target es2015
```

### 実装

`humans.json`と同じ階層に`main.js`を作成して実装します。

{{<file "main.js">}}
```ts
import dayjs from 'dayjs';
import fs from 'fs';


enum Gender {
    MAN = "man",
    WOMAN = "woman",
}

interface Human {
    id: number
    gender: Gender
    name: string
    myoji: string
    birthday: string
}

const loadHumans = (): Human[] =>
    JSON.parse(fs.readFileSync(`${__dirname}/humans.json`).toString())

console.log(
    loadHumans()
        .map(x => `${x.name}-${x.myoji}: ${dayjs().diff(dayjs(x.birthday), 'year')}歳`)
        .join('\n')
)
```
{{</file>}}

実行すると以下のようになります。

```
$ npx ts-node main.ts
ichiro-sato: 28歳
jiro-tanaka: 27歳
saki-suzuki: 26歳
```


ベース実装の問題
----------------

JavaScriptのコードに比べれば堅牢でシンプルだと思いますが、このコードにはいくつか問題があります。

1. InputデータのIFがイケていない
2. Inputデータが使いにくい
3. Inputデータが間違っていることがある

それぞれの問題は実装でカバーすることもできます。  
ただ、今回紹介する方法の方がシンプルに書けて改修もしやすいと思います。

次のセクションで1つずつ紹介していきます。


InputデータのIFがイケてない
---------------------------

jsonのIFが悪いとまでは言いませんが、良いとは言えません。

```ts
interface Human {
    id: number
    gender: Gender
    name: string
    myoji: string
    birthday: string
}
```

具体的には以下の点が気になります。

* `name`と`myoji`ではなく、`firstName`と`lastName`にしたい
* `birthday`はstring型ではなくDate型にしたい

特に`birthday`は登場するたびに `${dayjs().diff(dayjs(x.birthday), 'year')}` とするのは非常に冗長でしょう。


### 改善案

typestack/class-transformerを使うと、変換結果を変数に詰め直さずIFを変更できます。

{{<summary "https://github.com/typestack/class-transformer">}}

npmでインストールします。

```
$ npm i class-transformer reflect-metadata
```

reflect-metadataはデコレータを使うために必要です。
`tsconfig.json`も変更する必要があります。

* `experimentalDecorators`を`true`にする
* `strictPropertyInitialization`を`false`にする

{{<why "experimentalDecorators を true にする理由">}}
デコレータは試験的な機能であるため、使用する事を明示的に示さなければいけないためです。
{{</why>}}

{{<why "strictPropertyInitialization を false にする理由">}}
class-transformerを利用する場合、constructorを使いません。

一方、contructorが無いClassでプロパティの型をOptionalにするとエラーになります。  
それを抑制するための設定変更です。
{{</why>}}

{{<error "プロパティ 'id' に初期化子がなく、コンストラクターで明確に割り当てられていません。">}}
`strictPropertyInitialization`を`false`にしているか確認しましょう。
{{</error>}}


### 実装

`plainToClass(クラス, json文字列)`でjson文字列をクラスにparseできます。  
第2引数はObjectでもOKです。

{{<file "main.ts">}}
```ts
import { Expose, plainToClass, Transform } from "class-transformer";
import dayjs, { Dayjs } from 'dayjs';
import fs from 'fs';
import "reflect-metadata";

enum Gender {
    MAN = "man",
    WOMAN = "woman",
}

class Human {
    id: number
    gender: Gender

    @Expose({ name: "name" })
    firstName: string

    @Expose({ name: "myoji" })
    lastName: string

    @Transform(value => dayjs(value), { toClassOnly: true })
    birthday: Dayjs
}

const loadHumans = (): Human[] =>
    plainToClass(Human, JSON.parse(fs.readFileSync(`${__dirname}/humans.json`).toString()))

console.log(
    loadHumans()
        .map(x => `${x.firstName}-${x.lastName}: ${dayjs().diff(x.birthday, 'year')}歳`)
        .join('\n')
)
```
{{</file>}}

`humans.json`から読み込まれるプロパティ名を`@Expose`アノテーションの`name`プロパティに指定すると、Humanクラスのプロパティと一致しなくても変換されます。

`@Transform`で変換関数を指定すると、読み込まれるプロパティを変換することもできます。  
この例では、dayjsのコンストラクタを通してDayjs型に変換しています。

これらの対応により、`loadHumans()`後の変換ロジックは以下のように変化しました。

```diff
-       .map(x => `${x.name}-${x.myoji}: ${dayjs().diff(dayjs(x.birthday), 'year')}歳`)
+       .map(x => `${x.firstName}-${x.lastName}: ${dayjs().diff(x.birthday, 'year')}歳`)
 
```

1行も文字数だけを見るとそこまで変わらないかもしれません..  
ただ、本当にひどいIFに遭遇したときは便利ですよ。

**プロパティ内部で完結する関係なら、Exposeアノテーションが使えます**



Inputデータが使いにくい
-----------------------

フルネームを出すのに`${x.firstName}-${x.lastName}`...  
年齢の計算に`dayjs().diff(x.birthday, 'year')`...

モデルの外側でこのような計算をできればしたくないと思います。  
とはいえ..utilクラスを作ってそれを呼び出すのも大袈裟と感じたことはないでしょうか。

### 改善案

getterを適切に設けることで、ロジックをモデルに隠蔽できます。  
フルネームは`.fullName`、年齢は`.age`でアクセスできるようにしてみましょう。


### 実装

getterを追加した実装です。

{{<file "main.ts">}}
```ts
import { Expose, plainToClass, Transform } from "class-transformer";
import dayjs, { Dayjs } from 'dayjs';
import fs from 'fs';
import "reflect-metadata";

enum Gender {
    MAN = "man",
    WOMAN = "woman",
}

class Human {
    id: number
    gender: Gender

    @Expose({ name: "name" })
    firstName: string

    @Expose({ name: "myoji" })
    lastName: string

    @Transform(value => dayjs(value), { toClassOnly: true })
    birthday: Dayjs

    get fullName(): string {
        return `${this.firstName}-${this.lastName}`
    }

    get age(): number {
        return dayjs().diff(this.birthday, 'year')
    }
}

const loadHumans = (): Human[] =>
    plainToClass(Human, JSON.parse(fs.readFileSync(`${__dirname}/humans.json`).toString()))


console.log(
    loadHumans()
        .map(x => `${x.fullName}: ${x.age}歳`)
        .join('\n')
)
```
{{</file>}}

この対応で`loadHumans()`後の変換ロジックは以下のように変化しました。

```diff
-       .map(x => `${x.firstName}-${x.lastName}: ${dayjs().diff(x.birthday, 'year')}歳`)
+       .map(x => `${x.fullName}: ${x.age}歳`)
 
```

とてもシンプルで、ビジネスロジック(要件)が簡潔に記載されていますね。素晴らしい😄

**モデル内部で完結する関係なら、getterが使えます**


Inputデータが間違っていることがある
-----------------------------------

最後は *Input間違っている問題* です。

冒頭で境界の例としてあげた以下について、期待したものが必ず来るとは言えませんよね。

* 設定ファイルの入出力
* Web APIのインタフェース

受け取った後にValidation関数へ突っ込む方法はあります...が辛いですよね..  
本筋ではないValidationロジックのせいで見通しが悪くなることも多々あります。

今回の例では以下のようなケースを想定します。

* `gender`にotoko (man, woman以外の値が入る)
* idが文字列 (数値型ではない)
* myojiが空 (必須項目に値が入っていない)

{{<file "humans.json">}}
```json
[
    {
        "id": 1,
        "name": "ichiro",
        "myoji": "sato",
        "gender": "man",
        "birthday": "1991-01-01"
    },
    {
        "id": 2,
        "name": "jiro",
        "gender": "otoko",
        "birthday": "1992-02-02"
    },
    {
        "id": "saki",
        "name": "saki",
        "myoji": "suzuki",
        "gender": "lady",
        "birthday": "1993-03-03"
    }
]
```
{{</file>}}


Validation関数を実装していないので、このまま実行すると **何事もなく動きます**。

```
$ npx ts-node main.ts
ichiro-sato: 28歳
jiro-undefined: 27歳
saki-suzuki: 26歳
```

なんか`undefined`という名字の方がいますね..🙏


### 改善案

typestack/class-validatorkを使うと、アノテーションを付けるだけでプロパティがルールに従っているかを判定してくれます。

{{<summary "https://github.com/typestack/class-validatork">}}

npmでインストールします。

```
$ npm i class-validator class-transformer-validator
```

先に紹介したtypestack/class-transformerと一緒に使うため、class-transformer-validatorもあわせてインストールします。


### 実装

各プロパティにアノテーションを追加しています。  
Validation失敗時に例外が送出されるため、例外処理も追加しました。

{{<file "main.ts">}}
```ts
import { Expose, Transform } from "class-transformer";
import { transformAndValidate } from "class-transformer-validator";
import { IsDefined, IsEnum, IsNumber } from 'class-validator';
import dayjs, { Dayjs } from 'dayjs';
import fs from 'fs';
import "reflect-metadata";


enum Gender {
    MAN = "man",
    WOMAN = "woman",
}

class Human {
    @IsNumber()
    id: number

    @IsEnum(Gender)
    gender: Gender

    @Expose({ name: "name" })
    firstName: string

    @Expose({ name: "myoji" })
    @IsDefined()
    lastName: string

    @Transform(value => dayjs(value), { toClassOnly: true })
    birthday: Dayjs

    get fullName(): string {
        return `${this.firstName}-${this.lastName}`
    }

    get age(): number {
        return dayjs().diff(this.birthday, 'year')
    }
}

const loadHumans = async (): Promise<Human[]> =>
    await transformAndValidate(Human, fs.readFileSync(`${__dirname}/humans.json`).toString())
        .then(humans => humans as Human[])


async function main() {
    try {
        const ret = (await loadHumans())
            .map(x => `${x.fullName}: ${x.age}歳`)
            .join('\n')
        console.log(ret)
    } catch (e) {
        console.error(JSON.stringify(e, null, 4))
    }
}

main()
```
{{</file>}}

`plainToClass`ではなく`transformAndValidate`を使っていることに注意してください。  
Validationに失敗した場合は以下のObjectがエラーとして渡されます。

{{<file "実行結果">}}
```json
[
    [],
    [
        {
            "target": {
                "id": 2,
                "firstName": "jiro",
                "gender": "otoko",
                "birthday": "1992-02-01T15:00:00.000Z"
            },
            "value": "otoko",
            "property": "gender",
            "children": [],
            "constraints": {
                "isEnum": "gender must be a valid enum value"
            }
        },
        {
            "target": {
                "id": 2,
                "firstName": "jiro",
                "gender": "otoko",
                "birthday": "1992-02-01T15:00:00.000Z"
            },
            "property": "lastName",
            "children": [],
            "constraints": {
                "isDefined": "lastName should not be null or undefined"
            }
        }
    ],
    [
        {
            "target": {
                "id": "saki",
                "firstName": "saki",
                "lastName": "suzuki",
                "gender": "lady",
                "birthday": "1993-03-02T15:00:00.000Z"
            },
            "value": "saki",
            "property": "id",
            "children": [],
            "constraints": {
                "isNumber": "id must be a number"
            }
        },
        {
            "target": {
                "id": "saki",
                "firstName": "saki",
                "lastName": "suzuki",
                "gender": "lady",
                "birthday": "1993-03-02T15:00:00.000Z"
            },
            "value": "lady",
            "property": "gender",
            "children": [],
            "constraints": {
                "isEnum": "gender must be a valid enum value"
            }
        }
    ]
]
```
{{</file>}}

使用できるアノテーションは https://github.com/typestack/class-validator にまとめられています。  
今回使用したアノテーションは以下3つです。

| アノテーション |                 意味                 |
| -------------- | ------------------------------------ |
| `@IsEnum`      | 指定されたEnum値になりうるか         |
| `@IsNumber`    | 数値であるか (数の文字列はNG)        |
| `@IsDefined`   | 値が存在するか (null, undefined以外) |

コード量はまた増えてしまいましたが、if文を1つも書くことなく堅牢なValidationが可能になりました。

**プロパティで完結する関係なら、Validationのアノテーションが使えます**


総括
----

TypeScriptで境界と向き合い、堅牢で可読性の高い実装をする方法を紹介しました。

今回紹介したpackageはどちらもVersion1.0未満であり、更新も頻繁にされていません。  
それでも動作は安定しており、改修に強いコードが書けるので使うメリットは大きいと考えています。
