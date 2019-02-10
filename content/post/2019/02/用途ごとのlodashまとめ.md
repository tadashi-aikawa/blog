---
title: 用途ごとのlodashまとめ
slug: lodash-by-usecase
date: 2019-02-09T23:10:01+09:00
thumbnailImage: https://cdn.svgporn.com/logos/lodash.svg
categories:
  - engineering
tags:
  - javascript
  - typescript
  - lodash
---

Lodashの仕様を以下のようにまとめてみました。

* 日本語
* 用途ベース
* 必要最低限の情報

<!--more-->

{{<alert "danger">}}
本記事で参考にしたlodashのバージョンは 4.17.11 です。  
時間の経過と共に仕様は変わります。正しい情報が欲しい方は必ず本家のドキュメントをお読み下さい。

{{<summary "https://lodash.com/docs/4.17.11">}}
{{</alert>}}


<img src="https://cdn.svgporn.com/logos/lodash.svg"/>

<!--toc-->


読み方
------

### マークについて

見出しタイトルの先頭に付いたマークの意味は以下の通りです。

| マーク |     意味     |                   説明                    |
| ------ | ------------ | ----------------------------------------- |
| ⚠      | 前提条件あり | 前提条件を満たした上で使用できる          |
| 💀      | 破壊的       | 呼び出し前と呼び出し後でinputの値が変わる |


仮
--

### Arrayを塊に分離する `T[] -> T[][]`

3つずつに分離します。並行処理をさせる場合のグループ分けなどに。

```js
const input = [1, 2, 3, 4, 5, 6, 7]
_.chunk(input, 3)
// => [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7 ] ]
```


### Arrayからfalseになるような値を除外する `T[] -> T[]`

undefinedの除外に使うケースがあります。  
想定外に0や空文字が消えてしまうことがあるので、明示的に書いた方が堅牢だとは思います。

```js
const input = ["ai", undefined, "kawa", "", "sho", undefined]
_.compact(input)
// => [ 'ai', 'kawa', 'sho' ]
```


### Arrayに別のArrayや値を結合する `T[] -> T[]`

配列 or 単一値どちらでもいけます。

```js
const input = [1, 2]
_.concat(input, [3, 4], 5)
// => [ 1, 2, 3, 4, 5 ]
```

配列か単一値のどちらが来るか分かっていれば、Spread operatorで `[...input, [3, 4], ...5]`と書けますね。


### Array同士の差集合を求める `T[] -> T[]`

差分ではなく差集合です。順番が大事です。

#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.difference(input, [3, 4, 5, 6, 7])
// => [ 1, 2 ]
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.differenceBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
// => [ 1, 2 ]
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の引き算になるので`[1, 2]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.differenceWith(input, [[3, 4], [4, 5]], _.isEqual)
// => [ [ 1, 2 ], [ 5, 6 ] ]
```

`_differece(input, [[3, 4], [4, 5]])`の場合は`[3, 4]`が結果から除外されません。


### Array同士の積集合を求める `T[] -> T[]`

#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.intersection(input, [3, 4, 5, 6, 7])
// => [ 3, 4, 5 ]
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.intersectionBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
// => [ 3, 4 ]
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の積になるので`[3, 4]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.intersectionWith(input, [[3, 4], [4, 5]], _.isEqual)
// => [ [ 3, 4 ] ]
```

`_.intersection(input, [[3, 4], [4, 5]])`の場合は`[3, 4]`も共通部分と見なされません。


### Arrayの要素を抽出する

#### 先頭 `T[] -> T`

```js
const input = [10, 20, 30]
_.head(input)
// => 10
```

#### 末尾 `T[] -> T`

```js
const input = [10, 20, 30]
_.last(input)
// => 30
```

#### N番目 `T[] -> T`

```js
const input = [10, 20, 30, 40, 50]
_.nth(input, 3)
// => 40
```

第2引数をマイナスにすると末尾から数えてになります。

#### 範囲指定 `T[] -> T`

```js
const input = [10, 20, 30, 40, 50]
_.slice(input, 2, 4)
// => [ 30, 40 ]
```

`[10, 20, 30, 40, 50].slice(2, 4)`と一緒です。


### Arrayの要素を削除する `T[] -> T[]`

#### 先頭から削除数を指定

```js
const input = [10, 11, 12, 13, 14]
_.drop(input, 3)
// => [ 13, 14 ]
```

#### 末尾から削除数を指定

```js
const input = [10, 11, 12, 13, 14]
_.dropRight(input, 3)
// => [ 10, 11 ]
```

#### 先頭から条件を満たしている間

条件を満たさない要素が出現したら、その後に条件を満たす要素が残っていても終了します。

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.dropWhile(input, x => x < 12)
// => [ 12, 13, 12, 11, 10 ]
```

#### 末尾から条件を満たしている間

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.dropRightWhile(input, x => x < 12)
// => [ 10, 11, 12, 13, 12 ]
```

#### 最後の要素

```js
const input = [10, 11, 12, 13, 14]
_.initial(input)
// => [ 10, 11, 12, 13 ]
```


### 💀Arrayの要素を危険な方法で削除する `T[] -> T[]`

戻り値だけではなくinputごと削除します。

#### 💀一致する値

{{<warn-short>}}
可能なら、inputを変更しない `_.without` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 20, 10, 40, 50, 60, 30, 10]
_.pull(input, 10, 20)
// => [ 30, 40, 50, 60, 30 ]
```

配列を指定したい場合は`_.pullAll`を使います。

{{<warn-short>}}
可能なら、inputを変更しない `_.difference` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 20, 10, 40, 50, 60, 30, 10]
_.pullAll(input, [10, 20])
// => [ 30, 40, 50, 60, 30 ]
```

#### 💀変換後の値で判定する

10で割った商を使って判定します(= 10の位が等しいか)。

{{<warn-short>}}
可能なら、inputを変更しない `_.differenceBy` を使いましょう
{{</warn-short>}}

```js
const input = [11, 21, 31, 22, 12, 41, 51, 61, 33, 13]
_.pullAllBy(input, [10, 20], x => Math.floor(x / 10))
// => [ 31, 41, 51, 61, 33 ]
```

#### 💀判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [{x: 1}, {x: 2}, {x: 3}]
_.pullAllWith(input, [ {x: 2} ], _.isEqual)
// => [ { x: 1 }, { x: 3 } ]
```

`_.pullAll`では`{x: 2}`が同一とみなされず削除されません。

#### 💀N番目を指定する

{{<warn-short>}}
可能なら、inputを変更しない `_.at` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 40]
_.pullAt(input, [1, 3])
// => [ 20, 40 ]
```

#### 💀条件に一致する要素

{{<warn-short>}}
可能なら、inputを変更しない `_.filter`, `_.reject` を使いましょう
{{</warn-short>}}

戻り値には削除した要素が返却され、元の配列は削除後の値になります。

```js
const input = [10, 20, 30, 40]
_.remove(input, x => x > 20)
// => [ 30, 40 ]
input
// => [ 10, 20 ]
```



### 💀Arrayの要素を同じ値で埋める `T[] -> T[]`

```js
const input = Array(5)
_.fill(input, "nil")
// => [ 'nil', 'nil', 'nil', 'nil', 'nil' ]
```


### 条件に一致するindexを返却する `T[] -> number`

#### 最初のindex

```js
const input = [10, 20, 30, 20, 10, 20]
_.findIndex(input, x => x === 20)
// => 1
```

#### 最後のindex

```js
const input = [10, 20, 30, 20, 10, 20]
_.findLastIndex(input, x => x === 20)
// => 5
```

#### 値が完全一致する最初のindex

`_.findIndex`より記述が楽です。

```js
const input = [10, 20, 30, 20, 30, 20, 10]
_.indexOf(input, 30)
// => 2
```

inputが昇順にソートされている場合は`_.sortedIndexOf`を使用でき、こちらの方が高速です。

```js
const input = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40]
_.sortedIndexOf(input, 30)
// => 3
```

#### 値が完全一致する最後のindex

`_.findLastIndex`より記述が楽です。

```js
const input = [10, 20, 30, 20, 30, 20, 10]
_.lastIndexOf(input, 30)
// => 4
```

inputが昇順にソートされている場合は`_.sortedLastIndexOf`を使用でき、こちらの方が高速です。

```js
const input = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40]
_.sortedLastIndexOf(input, 30)
// => 5
```


### 多重Arrayを平坦にする

#### 1段階フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flatten(input)
// => [ 1, 2, 3, 4, [ 5, [ 6 ] ] ]
```

#### 多段階フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flattenDepth(input, 2)
// => [ 1, 2, 3, 4, 5, [ 6 ] ]
```

#### 完全フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flattenDeep(input)
// => [ 1, 2, 3, 4, 5, 6 ]
```


### 2要素ArrayとObjectを相互変換する

#### ArrayからObject `Array(2)[] -> Object`

```js
const input = [["a", 1], ["b", 2], ["c", 3]]
_.fromPairs(input)
// => { a: 1, b: 2, c: 3 }
```

#### ObjectからArray `Object -> Array(2)[]`

```js
const input = { a: 1, b: 2, c: 3 }
_.toPairs(input)
// => [ [ 'a', 1 ], [ 'b', 2 ], [ 'c', 3 ] ]
```


### Arrayを文字列で結合する `T[] -> string`

第2引数を省略した場合は`,`で結合されます。

```js
const input = ["ai", "ue", "o"]
_.join(input, '-->')
// => ai-->ue-->o
```


### 💀Arrayの順序を逆転する `T[] -> T[]`

```js
const input = [10, 20, 30, 40]
_.reverse(input)
// => [ 40, 30, 20, 10 ]
```

`[10, 20, 30, 40].reverse()`と一緒です。


### ⚠ソート順を考慮して値の挿入位置を決定する `T[] -> number`

{{<warn-short>}}
`input`は予め昇順にソートされている必要があります。
{{</warn-short>}}

#### 通常

候補が複数ある場合に最初の位置を返却します。

```js
const input = [10, 20, 30, 35, 40, 50]
_.sortedIndex(input, 35)
// => 3
```

最後の位置を返却したい場合は`_sortedLastIndex`を使います。

```js
const input = [10, 20, 30, 35, 40, 50]
_.sortedLastIndex(input, 35)
// => 4
```

#### 変換後の値で判定する

1の位に変換した上で最初の候補を返却します。

```js
const input = [21, 82, 34, 55, 46, 97]
_.sortedIndexBy(input, 15, x => x % 10)
// => 3
```

1の位に変換した上で最後の候補を返却したい場合は`_sortedLastIndexBy`を使います。

```js
const input = [21, 82, 34, 55, 46, 97]
_.sortedLastIndexBy(input, 15, x => x % 10)
// => 4
```


### Arrayから重複要素を除外する `T[] -> T[]`

#### 通常

```js
const input = [1, 2, 3, 2, 4, 5, 4]
_.uniq(input)
// => [ 1, 2, 3, 4, 5 ]
```

inputが昇順にソートされている場合は`_.sortedUniq`を使用でき、こちらの方が高速です。

```js
const input = [1, 2, 2, 2, 3, 3, 4, 5, 5, 5]
_.sortedUniq(input)
// => [ 1, 2, 3, 4, 5 ]
```

#### 変換後の値で判定する

1の位に変換した結果が重複する要素を除外します。

```js
const input = [31, 41, 52, 63, 71]
_.uniqBy(input, x => x % 10)
// => [ 31, 52, 63 ]
```

input変換後の値が昇順にソートされている場合は`_.sortedUniqBy`を使用でき、こちらの方が高速です。

```js
const input = [31, 41, 71, 52, 63]
_.sortedUniqBy(input, x => x % 10)
// => [ 31, 52, 63 ]
```



