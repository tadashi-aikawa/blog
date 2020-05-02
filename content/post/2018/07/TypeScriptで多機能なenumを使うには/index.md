---
title: "TypeScriptで多機能なenumを使うには"
slug: typescript-multifunctional-enum
date: 2018-07-23T02:37:14+09:00
thumbnailImage: images/cover/2018-07-23.jpg
categories:
  - engineering
tags:
  - typescript
  - enum
---

TypeScriptでJavaのように高機能なenumを作ってみました。

<!--more-->

{{<cimg "2018-07-23.jpg">}}

<!--toc-->


はじめに
-------

TypeScriptにもenumは存在します。  
しかしTypeScriptのenumには以下のような機能が存在しません。

* 列挙子一覧の取得
* フィールドやメソッドの定義

`module`構文と組み合わればstaticメソッドに限り定義できますが、直感的ではなくインスタンスにはメソッドを定義できません。  
これらを解消する方法として、enum likeなclassを作成することにしました。

{{<alert "info">}}
冒頭で`高機能なenum`と書きましたが正確にはenumではありません。
{{</alert>}}


enum likeなclass
----------------

以下は5つの色からなるenum likeなColorクラスです。

```typescript
class Color {
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
```

列挙子はstatic変数として静的に初期化しています。  
その際に使われるconstructorはprivateであるため、宣言していない列挙子が追加されることはありません。

列挙子一覧の取得をするために用意した`_values`にはconstructorの中で要素を追加します。  
列挙子が宣言される度に自動で追加されるため、管理が二重になることもありません。

`_values`やconstructor, `values()`は親クラスを作って抽象化したかったのですが、`自分自身のクラス型`を表現することができなかったので諦めました。

{{<alert "info">}}
staticでなければthis型を使えると思います。
{{</alert>}}



使い方
------

列挙子の指定はenumと同様です。

```typescript
console.log(Color.BLUE)
// -> Color { name: 'blue', japanese: '青' }
```

`japanese`から作成する場合は`Color.fromJapanese`を使用します。

```typescript
console.log(Color.fromJapanese("緑"))
// -> Color { name: 'green', japanese: '緑' }
```

プロパティには普通にアクセスできます。

```typescript
console.log(Color.WHITE.name)
// -> white
console.log(Color.WHITE.japanese)
// -> 白
```

列挙子一覧を取得する場合は`Color.values()`を呼び出します。

```typescript
console.log(Color.values())
// [ Color { name: 'red', japanese: '赤' },
//   Color { name: 'blue', japanese: '青' },
//   Color { name: 'green', japanese: '緑' },
//   Color { name: 'white', japanese: '白' },
//   Color { name: 'black', japanese: '黒' } ]
```

他にもインスタンスメソッドやgetプロパティ、関数型プロパティを使うことで多彩な表現が可能になります。


メモ化によるパフォーマンス向上
------------------------------

列挙子の数や呼び出し回数が増えると`fromXXX`のパフォーマンスが気になることがあるかもしれません。  
その場合はメモ化(Memoize)などを使って回避することも考える必要があります。

以下のようにメモ化することで再計算を不要にすることができます。

```typescript
import {memoize} from 'lodash'

class Color {

  // 中略......

  static _fromJapanese = memoize((value: string): Color | undefined => {
    return Color._values.find(x => x.japanese === value)
  })

  static fromJapanese(value: string): Color | undefined {
    return this._fromJapanese(value)
  }
}
```


総括
----

TypeScriptでJavaのenumのようなことを実現する方法について紹介しました。

同様の機能がTypeScriptに標準として組み込まれる日がいつか来ることを祈っております。

