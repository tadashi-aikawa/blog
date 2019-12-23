---
title: TypeScriptのモデル生成速度比較
slug: typescript-model-created-comparison
date: 2019-03-17T10:53:03+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/o07zvkk895j6p8y/alarm-clock-art-background-1037993.jpg
categories:
  - engineering
tags:
  - typescript
---

TypeScriptでモデルを生成する方法の速度を比較してみました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/o07zvkk895j6p8y/alarm-clock-art-background-103799"/>

<!--toc-->


はじめに
--------

開発を進めていく上でモデルの生成は欠かせない作業です。  
例えばユーザであれば以下のようなモデルを作る事になるでしょう。

```ts
interface User {
    id: number
    name: string
}
```

ソースコードの可読性を考えると、interfaceではなくgetterを持つことができるclassを使うかもしれません。  
その場合にconstructorの定義や値オブジェクトのparseを省略するためリフレクションを使うかもしれません。

可読性を上げることは大切ですが、大抵の場合にトレードオフとしてパフォーマンスが犠牲になります。  
本稿では、それぞれのモデル生成がどの程度の速度で行われるかを比較します。


モデルと測定方法
----------------

### モデル

以下のモデル`User`を使います。

```yaml
User:
    id: number
    name: string
    color: Color
    like?: User
```

UserとColorの定義はテストケースによって異なります。  

### 測定方法

1. モデルの生成を100万回行い、その合計値を1回あたりの結果とする
2. 1を10回行い、各回の結果と10回の平均値を出す

### 測定コード

以下の`measure`関数を使って測定します。

{{<file "performance.ts">}}

```ts
const pref = require('perf_hooks').performance;

/**
 * 100万回処理を実施した合計値を指定回数測定する
 * @param times 試行回数
 * @param f 処理
 */
export function measure<T>(times: number, f: (i: number) => T) {
    let results = []

    for (let i = 0; i < times; i++) {
        const startTime = pref.now();
        for (let i = 0; i < 1000000; i++) {
            const tmp = f(i)
        }
        const endTime = pref.now();
        console.log(`100万回: ${Math.round(endTime - startTime)}ミリ秒`);
        results.push(endTime - startTime)
    }

    console.log(`平均: ${Math.round(results.reduce((x, y) => x + y) / results.length)}ミリ秒`)
}
```

{{</file>}}

Node.jsを使うため、`require('perf_hooks').performance`です。  
ブラウザのように`window.performance`は使えません。


### 測定ケース

少しずつ動作を変えた測定ケースを計測していきます。

各セクションにおけるケースの変更点は、1つ前のセクションにおけるケースからの差分です。  
つまり、段々遅くなっていくはずです。


Objectをそのまま使うケース
--------------------------

何も変換せず、そのままObjectとして使うケースです。

### ソースコード

{{<file "models.ts">}}

```ts
type Color = "赤" | "青" | "緑" | "白" | "黒"

export interface User {
    id: number
    name: string
    color: Color
    like?: User
}
```

{{</file>}}

{{<file "main.ts">}}

```ts
import { measure } from "./performance";

const directTest = (i: number) => ({
    id: i,
    name: "ichiro",
    color: "黒",
    like: {
        id: i + 1,
        name: "jiro",
        color: "青"
    }
})

measure(5, directTest)
```

{{</file>}}

### 結果

ほぼ一瞬ですね。

```
100万回: 9ミリ秒
100万回: 9ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 2ミリ秒
平均: 2ミリ秒
```


Constructorを使うケース
-----------------------

Constructorを使ってインスタンス生成するケースです。

### ソースコード

{{<file "models.ts">}}

```ts
type Color = "赤" | "青" | "緑" | "白" | "黒"

export class User {
  constructor(
    public id: number,
    public name: string,
    public color: Color,
    public like?: User
  ) {}
}
```

{{</file>}}

{{<file "main.ts">}}

```ts
import { measure } from "./performance";
import {  User } from "./models";

const directTest = (i: number) => new User(
    i,
    "ichiro",
    "黒",
    new User(
        i + 1,
        "jiro",
        "青"
    )
)

measure(10, directTest)
```

{{</file>}}


### 結果

意外にもinterfaceを使うより速かったです..。  
インスタンス生成のコストがどうなっているのか気になりますね。

```
100万回: 4ミリ秒
100万回: 7ミリ秒
100万回: 0ミリ秒
100万回: 0ミリ秒
100万回: 1ミリ秒
100万回: 0ミリ秒
100万回: 0ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
100万回: 1ミリ秒
平均: 2ミリ秒
```


拡張enumを使うケース
--------------------

ColorをJavaのようなEnumに変換するケースです。  
Colorのソースコード量は増えますが、使う側のコード量は減ります。


### ソースコード

{{<file "models.ts">}}

```ts
export class Color {
    private static readonly _values: Color[] = []

    static readonly RED = new Color("red", "赤")
    static readonly BLUE = new Color("blue", "青")
    static readonly GREEN = new Color("green", "緑")
    static readonly WHITE = new Color("white", "白")
    static readonly BLACK = new Color("black", "黒")

    private constructor(
        readonly name: string,
        readonly japanese: string,
    ) {
        Color._values.push(this)
    }

    static fromJapanese(value: string): Color | undefined {
        return Color._values.find(x => x.japanese === value)
    }

    static values(): Color[] {
        return Color._values
    }
}


export class User {
    constructor(id: number, name: string, color: Color, like?: User) {
    }
}

```

{{</file>}}

{{<file "main.ts">}}

```ts
import { measure } from "./performance";
import { User, Color } from "./models";

const directTest = (i: number) => new User(
    i,
    "ichiro",
    Color.fromJapanese("黒"),
    new User(
        i + 1,
        "jiro",
        Color.fromJapanese("青")
    )
)

measure(10, directTest)
```

{{</file>}}


### 結果

拡張enumは少し遅くなります。

```
100万回: 29ミリ秒
100万回: 32ミリ秒
100万回: 22ミリ秒
100万回: 20ミリ秒
100万回: 19ミリ秒
100万回: 23ミリ秒
100万回: 21ミリ秒
100万回: 21ミリ秒
100万回: 21ミリ秒
100万回: 26ミリ秒
平均: 23ミリ秒
```


Partial Constructorを使うケース
-------------------------------

ConstructorにPartialを使ったケースです。


### ソースコード

{{<file "models.ts">}}

```ts
export class Color {
    private static readonly _values: Color[] = []

    static readonly RED = new Color("red", "赤")
    static readonly BLUE = new Color("blue", "青")
    static readonly GREEN = new Color("green", "緑")
    static readonly WHITE = new Color("white", "白")
    static readonly BLACK = new Color("black", "黒")

    private constructor(
        readonly name: string,
        readonly japanese: string,
    ) {
        Color._values.push(this)
    }

    static fromJapanese(value: string): Color | undefined {
        return Color._values.find(x => x.japanese === value)
    }

    static values(): Color[] {
        return Color._values
    }
}


export class User {
    id: number
    name: string
    color: Color
    like?: User

    constructor(init: Partial<User>) {
        Object.assign(this, init)
    }
}
```

{{</file>}}

{{<file "main.ts">}}

```ts
import { measure } from "./performance";
import { User, Color } from "./models";

const directTest = (i: number) => new User({
    id: i,
    name: "ichiro",
    color: Color.fromJapanese("黒"),
    like: new User({
        id: i + 1,
        name: "jiro",
        color: Color.fromJapanese("青")
    })
})

measure(10, directTest)
```

{{</file>}}


### 結果

150ミリ秒ほど遅くなりました。  
実際にはPartialではなく`Object.assign`が性能劣化の原因になっています。

```
100万回: 182ミリ秒
100万回: 178ミリ秒
100万回: 173ミリ秒
100万回: 162ミリ秒
100万回: 164ミリ秒
100万回: 171ミリ秒
100万回: 169ミリ秒
100万回: 181ミリ秒
100万回: 168ミリ秒
100万回: 171ミリ秒
平均: 172ミリ秒
```


Static fuctory methodを使うケース
---------------------------------

ConstructorにObjectを放りこむIFに違和感があるため、専用のインスタンス生成methodを作成するケースです。


### ソースコード

{{<file "models.ts">}}

```ts
export class Color {
    private static readonly _values: Color[] = []

    static readonly RED = new Color("red", "赤")
    static readonly BLUE = new Color("blue", "青")
    static readonly GREEN = new Color("green", "緑")
    static readonly WHITE = new Color("white", "白")
    static readonly BLACK = new Color("black", "黒")

    private constructor(
        readonly name: string,
        readonly japanese: string,
    ) {
        Color._values.push(this)
    }

    static fromJapanese(value: string): Color | undefined {
        return Color._values.find(x => x.japanese === value)
    }

    static values(): Color[] {
        return Color._values
    }
}


export class User {
    id: number
    name: string
    color: Color
    like?: User

    private constructor(init: Partial<User>) {
        Object.assign(this, init)
    }

    static fromObj(init: Partial<User>): User {
        return new this(init)
    }
}
```

{{</file>}}

{{<file "main.ts">}}

```ts
import { measure } from "./performance";
import { User, Color } from "./models";

const directTest = (i: number) => User.fromObj({
    id: i,
    name: "ichiro",
    color: Color.fromJapanese("黒"),
    like: User.fromObj({
        id: i + 1,
        name: "jiro",
        color: Color.fromJapanese("青")
    })
})

measure(10, directTest)
```

{{</file>}}


### 結果

速度に影響は無さそうです。

```
100万回: 180ミリ秒
100万回: 183ミリ秒
100万回: 164ミリ秒
100万回: 178ミリ秒
100万回: 163ミリ秒
100万回: 165ミリ秒
100万回: 172ミリ秒
100万回: 165ミリ秒
100万回: 205ミリ秒
100万回: 167ミリ秒
平均: 174ミリ秒
```


class-transformerを使うケース
-----------------------------

最後はclass-transformerを使うケースです。

class-transformerについては前回ブログでも紹介していますのでそちらをご覧下さい。

{{<summary "https://blog.mamansoft.net/2019/03/10/battle-with-boundary-typescript/#%E6%94%B9%E5%96%84%E6%A1%88">}}


### ソースコード

Userモデルの記載だけ見ると、Objectをそのまま使うケースの次にシンプルで読みやすいです。

{{<file "models.ts">}}

```ts
import {  Transform, Type } from "class-transformer"

export class Color {
    private static readonly _values: Color[] = []

    static readonly RED = new Color("red", "赤")
    static readonly BLUE = new Color("blue", "青")
    static readonly GREEN = new Color("green", "緑")
    static readonly WHITE = new Color("white", "白")
    static readonly BLACK = new Color("black", "黒")

    private constructor(
        readonly name: string,
        readonly japanese: string,
    ) {
        Color._values.push(this)
    }

    static fromJapanese(value: string): Color | undefined {
        return Color._values.find(x => x.japanese === value)
    }

    static values(): Color[] {
        return Color._values
    }
}


export class User {
    id: number
    name: string
    @Transform(Color.fromJapanese)
    color: Color
    @Type(() => User)
    like?: User
}
```

{{</file>}}

{{<file "main.ts">}}

```ts
import { plainToClass } from "class-transformer"
import "reflect-metadata";
import { measure } from "./performance";
import { User, Color } from "./models";

const directTest = (i: number) => plainToClass(User, {
    id: i,
    name: "ichiro",
    color: "黒",
    like: {
        id: i + 1,
        name: "jiro",
        color: "青"
    }
})

measure(10, directTest)
```

{{</file>}}


### 結果

10秒弱と大きく性能劣化します。

```
100万回: 9694ミリ秒
100万回: 8157ミリ秒
100万回: 8896ミリ秒
100万回: 8842ミリ秒
100万回: 8954ミリ秒
100万回: 8812ミリ秒
100万回: 8931ミリ秒
100万回: 8835ミリ秒
100万回: 8831ミリ秒
100万回: 8834ミリ秒
平均: 8879ミリ秒
```


結果と考察
----------

### 結果

測定結果の概要をまとめてみました。(ある程度値を丸めています)

|            ケース             | 100万回の速度(秒) | 1万回の速度(秒) |
| ----------------------------- | ----------------- | --------------- |
| Objectをそのまま              | 0.002             | 0.00002         |
| Constructorでインスタンス生成 | 0.002             | 0.00002         |
| 拡張enum                      | 0.02              | 0.0002          |
| Partial Constructor           | 0.2               | 0.002           |
| Static fuctory method         | 0.2               | 0.002           |
| class-transformer             | 10                | 0.1             |

参考までに、配列にpushする速度は概算で以下のようになります。

|   ケース   | 100万回の速度(秒) | 1万回の速度(秒) |
| ---------- | ----------------- | --------------- |
| 配列にpush | 0.3               | 0.003           |

### 考察

以上の結果から考えたことです。

* Classのインスタンス生成コストは無視してよい
* 拡張Enumの生成コストは無視してよい
    * ほぼ全てのケースで可読性向上によるメリットが大きい
    * 拡張Enum未使用時は、呼び出し側の実行時間が増えるため総合的な時間は劣化しないケースが多い
* `Object.assign`は100万回レベルになると生成コストは無視できない
* `class-transformer`は1万回レベルから生成コストを気にした方がよい

{{<alert "warning">}}
これらは処理速度についての考察であり、メモリ使用量については考慮していません。
{{</alert>}}

ユースケースによって以下のように使い分けていきたいと思いました。

|       ユースケース       | 想定される回数 | class | 拡張enum | Partial Constructor | class-transformer |
| ------------------------ | -------------- | ----- | -------- | ------------------- | ----------------- |
| 設定やユーザ入力のパース | 100回未満      | o     | o        | o                   | o                 |
| 小さいデータのパース     | 1万回未満      | o     | o        | o                   | o                 |
| 普通のデータのパース     | 100万回未満    | o     | o        | o                   | x                 |
| 大きなデータのパース     | 1000万回未満   | o     | o        | x                   | x                 |


総括
----

TypeScriptでモデルを生成する方法の速度を比較しました。

『常にこれが正解』というものは存在しません。  
今回のユースケースにどの程度のパフォーマンスが必要なのかを見極め、その中で極力メンテナンスしやすいコードを書いていきたいですね😄
