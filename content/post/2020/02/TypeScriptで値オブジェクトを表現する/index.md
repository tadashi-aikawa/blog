---
title: TypeScriptで値オブジェクトを表現する
slug: express-value-object-by-typescript
date: 2020-02-19T13:13:26+09:00
thumbnailImage: https://dl.dropboxusercontent.com/s/k2sxyfkoh9ifuv1/girl-2931287_1280.jpg
categories:
  - engineering
tags:
  - typescript
  - ddd
---

TypeScriptでDDDの値オブジェクトを表現する方法を模索してみました。

<!--more-->

<img src="https://dl.dropboxusercontent.com/s/k2sxyfkoh9ifuv1/girl-2931287_1280.jpg"/>

<!--toc-->


DDDについて
-----------

### DDDとは

DDDとはドメイン駆動設計(Domain-driven design)の略です。

{{<summary "https://ja.wikipedia.org/wiki/%E3%83%89%E3%83%A1%E3%82%A4%E3%83%B3%E9%A7%86%E5%8B%95%E8%A8%AD%E8%A8%88">}}

以下はWikipediaから引用した定義です。

> ソフトウェアの設計手法であり、「複雑なドメインの設計は、モデルベースで行うべき」であり、また「大半のソフトウェアプロジェクトでは、システムを実装するための特定の技術ではなく、ドメインそのものとドメインのロジックに焦点を置くべき」であるとする

難しいことのように思えますが、誤解を恐れずに言うと  
**コードを見るだけでビジネスロジックが分かるようにプロダクトを作ろう**  
という設計思想です。

### DDDに関する書籍

この3ヶ月間、私は3つのプロダクトでDDDを試しました。  
この記事では触れませんが、ほとんどのケースでDDDは素晴らしい価値を提供してくれました。

そんなDDDを始めるきっかけとなった2つの本を紹介します。

#### エリック・エヴァンスのドメイン駆動設計

一番有名と思われるエリック・エヴァンスの本です。  
通称エヴァンス本と呼ばれています。

ページ数も多く、お値段もビッグです😏

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:624px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:300px"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11146351%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=14501360&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F1963%2F9784798121963.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F1963%2F9784798121963.jpg%3F_ex%3D300x300&s=300x300&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a></td><td style="vertical-align:top;width:308px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11146351%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  >エリック・エヴァンスのドメイン駆動設計 ソフトウェア開発の実践 （IT　architects’　archive） [ エリック・エヴァンス ]</a><br><span >価格：5720円（税込、送料無料)</span> <span style="color:#BBB">(2020/2/17時点)</span></p><div style="margin:15px;"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11146351%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:5px"></a><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F11146351%2F%3Fscid%3Daf_pc_bbtn&m=%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><div style="float:right;width:50%;height:32px;background-color:#bf0000;color:#fff !important;font-size:14px;font-weight:500;line-height:32px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td><tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

内容は素晴らしいです.. しかし、難しすぎます😓

以下のすべてを満たさない方は躓く可能性が高いです。  
1つも条件を満たさない方へは読むこと自体をオススメしません..。

* オブジェクト指向を理解している
* 本の中で例に出されているドメインの知識がある
* 設計をしたことがある
* 同じシステムを1年以上開発し続けたことがある


#### ドメイン駆動設計入門

私の周りではボトムアップDDD本と呼ばれています。  
エヴァンス本に挫折した方のために現れた救世主だと私は思っています😄

<table border="0" cellpadding="0" cellspacing="0"><tr><td><div style="border:1px solid #95a5a6;border-radius:.75rem;background-color:#FFFFFF;width:624px;margin:0px;padding:5px;text-align:center;overflow:hidden;"><table><tr><td style="width:300px"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16167672%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://hbb.afl.rakuten.co.jp/hgb/0bb611af.8b747228.0bb611b0.b536e084/?me_id=1213310&item_id=19881333&m=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F0727%2F9784798150727.jpg%3F_ex%3D80x80&pc=https%3A%2F%2Fthumbnail.image.rakuten.co.jp%2F%400_mall%2Fbook%2Fcabinet%2F0727%2F9784798150727.jpg%3F_ex%3D300x300&s=300x300&t=picttext" border="0" style="margin:2px" alt="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]" title="[商品価格に関しましては、リンクが作成された時点と現時点で情報が変更されている場合がございます。]"></a></td><td style="vertical-align:top;width:308px;"><p style="font-size:12px;line-height:1.4em;text-align:left;margin:0px;padding:2px 6px;word-wrap:break-word"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16167672%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  >ドメイン駆動設計入門 ボトムアップでわかる！ドメイン駆動設計の基本 [ 成瀬 允宣 ]</a><br><span >価格：3520円（税込、送料無料)</span> <span style="color:#BBB">(2020/2/17時点)</span></p><div style="margin:15px;"><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16167672%2F&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ%3D%3D" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><img src="https://static.affiliate.rakuten.co.jp/makelink/rl.svg" style="float:left;max-height:27px;width:auto;margin-top:5px"></a><a href="https://hb.afl.rakuten.co.jp/hgc/0bb611af.8b747228.0bb611b0.b536e084/?pc=https%3A%2F%2Fitem.rakuten.co.jp%2Fbook%2F16167672%2F%3Fscid%3Daf_pc_bbtn&m=%3Fscid%3Daf_pc_bbtn&link_type=picttext&ut=eyJwYWdlIjoiaXRlbSIsInR5cGUiOiJwaWN0dGV4dCIsInNpemUiOiIzMDB4MzAwIiwibmFtIjoxLCJuYW1wIjoicmlnaHQiLCJjb20iOjEsImNvbXAiOiJkb3duIiwicHJpY2UiOjEsImJvciI6MSwiY29sIjoxLCJiYnRuIjoxLCJwcm9kIjowfQ==" target="_blank" rel="nofollow noopener noreferrer" style="word-wrap:break-word;"  ><div style="float:right;width:50%;height:32px;background-color:#bf0000;color:#fff !important;font-size:14px;font-weight:500;line-height:32px;margin-left:1px;padding: 0 12px;border-radius:16px;cursor:pointer;text-align:center;">楽天で購入</div></a></div></td><tr></table></div><br><p style="color:#000000;font-size:12px;line-height:1.4em;margin:5px;word-wrap:break-word"></p></td></tr></table>

本書が発売されたのは数日前であり、まだ読み切っていません。  
ただ、著者nrsさんが運営されているサイトにはお世話になりました。

{{<summary "https://nrslib.com/bottomup-ddd/">}}

上記サイトやスライドがなければ、チームメンバへDDDを広めることはできなかったと思います。


値オブジェクトとは
------------------

値オブジェクトはDDDに登場する用語です。  
以下の性質を持つものが値オブジェクトである、と私は理解しています。

* Immutable (不変)
* 全ての要素が等しい場合のみ等しい
* 不完全なオブジェクトが存在できない

{{<warn "値オブジェクトの定義について">}}
私にとって理解しやすい表現であり、DDDで厳密に定義されたものとは異なる可能性があります。
{{</warn>}}

値オブジェクトの詳細については割愛します。  
nrsさんの以下がオススメですので、理解を深めたい方は是非読んでみてください😄

{{<summary "https://nrslib.com/bottomup-ddd/#outline__3_1">}}


AbstractValueObjectクラスの実装
-------------------------------

クラスを使って、実際に値オブジェクトを実装してみます。  
TypeScriptのバージョンは3.7.5です。

まずは全てのベースとなる`AbstractValueObject`クラスを作成します。

```ts
import { shallowEqual } from 'shallow-equal-object';

export abstract class AbstractValueObject<T> {
  protected readonly _value: T;

  protected constructor(_value: T) {
    this._value = Object.freeze(_value);
  }

  equals(vo?: AbstractValueObject<T>): boolean {
    if (vo == null) {
      return false;
    }
    return shallowEqual(this._value, vo._value);
  }
}
```

この抽象クラスは値オブジェクトがもつ2つの性質を実現しています。

### Immutableの実現

唯一のプロパティ`_value`を`Object.freeze`することで変更不可能にしています。

```ts
  protected readonly _value: T;

  protected constructor(_value: T) {
    this._value = Object.freeze(_value);
  }
```

{{<alert warning>}}
`Object.freeze`はネストしたプロパティには効果がありません。  
完全に変更不可能にしたい場合は、Primitiveでない直下のプロパティを値オブジェクトにする必要があります。
{{</alert>}}

### 全ての要素が等しい場合のみ等しくする

値オブジェクトの等価判定でよく使う処理です。  
直下のプロパティ同士が完全に等価である場合のみ`true`を返します。

```ts
  equals(vo?: AbstractValueObject<T>): boolean {
    if (vo == null) {
      return false;
    }
    return shallowEqual(this._value, vo._value);
  }
```

`shallowEqual`は以下のpackageを利用しています。

{{<summary "https://github.com/azu/shallow-equal-object">}}

{{<why "_valueやコンストラクタがprotectedなのはなぜ?">}}

```ts
  protected readonly _value: T;

  protected constructor(_value: T) {
    this._value = Object.freeze(_value);
  }
```

値のアクセスはgetterを、インスタンス生成にはStatic factory methodを利用してもらうためです。  
ここでは詳しく触れませんが、オブジェクト指向のカプセル化によるメリットを得るためです。
{{</why>}}


ValueObjectクラスの実装
-----------------------

`AbstractValueObject`クラスを継承して、もう少し具体的な`ValueObject`クラスを作ります。

```ts
interface ValueObjectProps {
  [index: string]: any;
}

export abstract class ValueObject<T extends ValueObjectProps> extends AbstractValueObject<T> {}
```

`T`は値オブジェクトがもつ`[index: string]: any`型を継承したプロパティです。  
以下のようにクラスを作成します。

```ts
interface UserProps {
  id: number;
  name: string;
}

class User extends ValueObject<UserProps> {
  static create(props: UserProps): User {
    return new User(props);
  }

  get name(): string {
    return this._value.name;
  }
}
```

使用例です。

```ts
const ichiro = User.create({ id: 1, name: 'hoge' });
const ichiro2 = User.create({ id: 1, name: 'hoge' });

console.log(ichiro.name); // hoge
console.log(ichiro == ichiro2); // false
console.log(ichiro === ichiro2); // false
console.log(ichiro.equals(ichiro2)); // true
```

### createの引数がpropsである理由

2つ理由があります。

* 実装ミスのリスクが減る
* 仕様の変更に強い

#### 実装ミスのリスクが減る

`User.create(id: string, firstName: string, lastName?: string)`という前提で話をします。  
TypeScriptは名前付き引数に未対応のため、以下のようには書けません。

```ts
User.create(id="100", firstName="Taro", lastName="Suzuki")
```

それゆえ、以下のような実装ミスをしても気付きにくいという問題があります。

```ts
User.create("100", "Suzuki", "Taro")
User.create("Taro", "Suzuki", "100")
```

Propsによる型付きの指定は、このリスクを最小限にできます。

```ts
User.create({
  id: "100",
  firstName: "Taro",
  lastName: "Suzuki",
})
```

#### 仕様の変更に強い

`User.create`に新しく必須パラメータが追加されることを想像してみてください

```ts
User.create(id: string, firstName: string, lastName?: string, required: string)
```

TypeScriptでこの書き方は不正です。  
Optionalな引数`lastName?: string`のあとに、Requiredな引数`required: string`を指定することはできません。  
その場合、引数の順序を変更する必要があります。

```ts
User.create(id: string, required: string, firstName: string, lastName?: string)
```

でも待って下さい!!  
このコードは修正ミスのリスクを格段に引き上げます。

なぜなら、以下の様な既存コードがエラーなしに通ってしまうからです。

```ts
User.create("100", "Taro", "Suzuki")
```

Props指定の場合、引数の順序は関係ないのでこの問題は起きません。

```ts
User.create({
  id: "100",
  lastName: "Suzuki",
  firstName: "Taro",
})
```

しかも、`UserProps`型に`required`プロパティを追加されると、上記はエラーになります。  
それに気付いて、以下のように修正できるわけです😄

```ts
User.create({
  id: "100",
  lastName: "Suzuki",
  firstName: "Taro",
  required: "ok",
})
```

### 不完全なオブジェクトが存在できないようにする

不完全であるかの判定は、実装する値オブジェクトクラスによって決まります。  
そのため、抽象クラスではなく具象クラスでcreateするときにValidationします。

```ts
  static create(props: UserProps): User {
    if (!(props.id > 0)) {
      throw new Error('idは1以上を指定してください');
    }
    if (!(props.name.length > 0)) {
      throw new Error('nameは1文字以上指定してください');
    }
    return new User(props);
  }
```

createで値オブジェクトを作成するときに、不正な条件下ではErrorが送出されます。

```ts
const ichiro = User.create({ id: 1, name: '' }); // Error: nameは1文字以上指定してください
const ichiro2 = User.create({ id: -1, name: 'hoge' }); // Error: idは1以上を指定してください
const ichiro3 = User.create({ id: 2, name: 'jiro' }); // ok
```

システムを停止するのか、catchしてエラーを表示するのかは状況によります。


PrimitiveValueObjectクラスの実装
--------------------------------

primitiveな値を値オブジェクトとして扱いたい場合のため`PrimitiveValueObject`を作ります。

```ts
export abstract class PrimitiveValueObject<T> extends AbstractValueObject<T> {
  get value(): T {
    return this._value;
  }
}
```

生成時のValidationが主な目的なので、getterで値を取り出す共通実装をしておきます。  
必要があればgetterを追加すればOKです。

`PrimitiveValueObject`を使って、`User`クラスの`id`と`name`を値オブジェクトにした実装が以下です。

```ts
class UserId extends PrimitiveValueObject<number> {
  static create(value: number): UserId {
    if (!(value > 0)) {
      throw new Error('idは1以上を指定してください');
    }
    return new UserId(value);
  }
}

class UserName extends PrimitiveValueObject<string> {
  static create(value: string): UserName {
    if (!(value.length > 0)) {
      throw new Error('nameは1文字以上指定してください');
    }
    return new UserName(value);
  }
}

interface UserProps {
  id: UserId;
  name: UserName;
}

class User extends ValueObject<UserProps> {
  static create(props: UserProps): User {
    return new User(props);
  }

  get name(): string {
    return this._value.name.value;
  }
}

const ichiro = User.create({ id: UserId.create(2), name: UserName.create('jiro') });
console.log(ichiro.name); // jiro
```

コード量は増えてしまいましたが、インタフェースは`User.create`の引数が値オブジェクトに変わっただけです。  
Validationの役割も的確なスコープに留まっています。


createの引数とプロパティの型を分ける
--------------------------------

先のコードでは`User.create`のインタフェース(引数)が少し変わっていました。  
実はこれを全く変えずに実装を変更する方法があります。

`User.create`の引数を`UserProps`ではなく、新たに作った`UserArgs`で分離してしまうのです。

```ts
interface UserProps {
  id: UserId;
  name: UserName;
}

interface UserArgs {
  id: number;
  name: string;
}

class User extends ValueObject<UserProps> {
  static create(args: UserArgs): User {
    return new User({
      id: UserId.create(args.id),
      name: UserName.create(args.name),
    });
  }

  get name(): string {
    return this._value.name.value;
  }
}

const ichiro = User.create({ id: 2, name: 'jiro' });
console.log(ichiro.name); // jiro
```

`User.create`のコード量と引き替えに、生成ロジックと内部状態の分離がされました。  
使う側からすると、個々の値オブジェクトを作成する手間が省けるのは嬉しいですね😄


総括
----

TypeScriptでDDDの値オブジェクトを表現する方法を模索した結果、以下3つのクラスを定義して使うことにしました。

* `AbstractValueObject`
* `ValueObject`
* `PrimitiveValueObject`

システムが小さいうちは、回りくどく面倒に感じるかもしれません。  
しかし、ある程度の規模になってくると値オブジェクトが厳格に定義されているメリットを感じられることでしょう😄

`getter`が不要であれば、公称型と生成関数を使ったアプローチもオススメです。  
公式でも利用されている手法なので、小規模プロダクトならアリだと思います👍

{{<summary "https://basarat.gitbook.io/typescript/main-1/nominaltyping">}}

最後に、本記事で紹介したクラスの2020-02-19現在におけるコードへのリンクを貼っておきます。

{{<summary "https://github.com/tadashi-aikawa/togowl-next/blob/b77355040928d8241b31ff8c9ed3ac49f87e9955/utils/vo.ts">}}

### 参考

{{<summary "https://khalilstemmler.com/articles/typescript-value-object/">}}
