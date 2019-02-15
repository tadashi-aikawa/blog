---
title: 逆引きlodash Array/Collection/Object編
slug: lodash-by-usecase-array-collection-object
date: 2019-02-14T21:05:05+09:00
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
本記事で参考にしたLodashのバージョンは 4.17.11 です。  
時間の経過と共に仕様は変わります。正しい情報が欲しい方は必ず本家のドキュメントをお読み下さい。

{{<summary "https://lodash.com/docs/4.17.11">}}
{{</alert>}}


<img src="https://cdn.svgporn.com/logos/lodash.svg"/>

<!--toc-->


経緯
----

私は仕事でJavaScriptやTypeScriptを使う機会が多いです。  
その際、従来の命令型の書き方ではなく、関数型の書き方を普及しています。

また、JavaScript/TypeScriptには十分な関数型のfunctionがないため、`Lodash`というライブラリを導入しています。

{{<summary "https://lodash.com/">}}

しかし、慣れるまの間は**何ができるか分からないまま英語のドキュメントを探すこと**がとても重荷になります。  
少しでも心理的抵抗や調査のコスト/ハードルを下げるために本記事を執筆しました。


前提
----

Lodashの以下Sectionに属するmethodを紹介します。

* Array
* Collection
* Object

以下のケースは紹介しません。

* ES2015より前の仕様で主に使うmethod (prototype周りの`xxxIn`)
* 各method全ての使い方 (知りたい場合は公式ドキュメントを参照)

また、厳密には事実と異なる表現をしている場合があります。  
正確な理解より、各methodの大まかな挙動を理解してほしいからです。

正確な情報が欲しい場合は公式ドキュメントを参照してください。


読み方
------

### マークについて

見出しタイトルの先頭に付いたマークの意味は以下の通りです。

| マーク |     意味     |                   説明                    |
| ------ | ------------ | ----------------------------------------- |
| ⚠      | 前提条件あり | 前提条件を満たした上で使用できる          |
| 💀      | 破壊的       | 呼び出し前と呼び出し後でinputの値が変わる |



要素の増減
----------

形式や値の変換はしないが、要素が増減する処理。


### 要素を抽出する

#### 先頭 `[] -> *`

```js
const input = [10, 20, 30]
_.head(input)
/* => 10
*/
```

#### 末尾 `[] -> *`

```js
const input = [10, 20, 30]
_.last(input)
/* => 30
*/
```

#### 先頭から指定数 `[] -> []`

```js
const input = [10, 20, 30, 40, 50]
_.take(input, 3)
/* => [ 10, 20, 30 ]
*/
```

#### 末尾から指定数 `[] -> []`

```js
const input = [10, 20, 30, 40, 50]
_.takeRight(input, 3)
/* => [ 30, 40, 50 ]
*/
```

#### 条件を満たす要素 `([]|{}) -> []`

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.filter(input, x => x < 12)
/* => [ 10, 11, 11, 10 ]
*/
```

#### 条件を満たす最初の要素 `([]|{}) -> *`

```js
const input = [10, 11, 12, 13, 14, 11, 10]
_.find(input, x => x >= 12)
/* => 12
*/
```

#### 条件を満たす最初の要素のkey `{} -> *`

```js
const input = {'warosu': 21, 'tagayasu': 31, 'monomousu': 41, 'osu': 11}
_.findKey(input, x => x > 30)
/* => tagayasu
*/
```

#### 条件を満たす最後の要素 `([]|{}) -> *`

```js
const input = [10, 11, 12, 13, 14, 11, 10]
_.findLast(input, x => x >= 12)
/* => 14
*/
```

#### 条件を満たす最後の要素のkey `{} -> *`

```js
const input = {'warosu': 21, 'tagayasu': 31, 'monomousu': 41, 'osu': 11}
_.findLastKey(input, x => x > 30)
/* => monomousu
/
```


#### 先頭から条件を満たしている間 `[] -> []`

条件を満たさない要素が出現したら、その後に条件を満たす要素が残っていても終了します。

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.takeWhile(input, x => x < 12)
/* => [ 10, 11 ]
*/
```

#### 末尾から条件を満たしている間 `[] -> []`

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.takeRightWhile(input, x => x < 12)
/* => [ 11, 10 ]
*/
```

#### N番目 `[] -> *`

```js
const input = [10, 20, 30, 40, 50]
_.nth(input, 3)
/* => 40
*/
```

第2引数をマイナスにすると末尾から数えてになります。

#### 範囲指定 `[] -> *`

```js
const input = [10, 20, 30, 40, 50]
_.slice(input, 2, 4)
/* => [ 30, 40 ]
*/
```

`[10, 20, 30, 40, 50].slice(2, 4)`と一緒です。

#### ランダムで1つ `([]|{}) -> *`

{{<warn-short>}}
ランダムなので結果は毎回変わります。
{{</warn-short>}}

```js
const input = [10, 20, 30, 40, 50]
_.sample(input)
/* => 40
*/
```

#### ランダムで指定数 `([]|{}) -> []`

{{<warn-short>}}
ランダムなので結果は毎回変わります。
{{</warn-short>}}

```js
const input = [10, 20, 30, 40, 50]
_.sampleSize(input, 3)
/* => [ 20, 40, 10 ]
*/
```

#### 指定したパスの値 `{} -> *`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.get(input, 'y.y2')
/* => YY
*/
_.get(input, 'nothing', 'default')
/* => default
*/
```

実行速度が遅いので呼び出し数が多い場合は愚直に書きましょう。

```js
input.y && input.y.y2 || 'default'
```

#### 指定した複数パスの値 `{} -> []`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.at(input, ['x', 'y.y2'])
/* => [ 'X', 'YY' ]
*/
```

#### 指定したパスのkey-value `{} -> {}`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.pick(input, ['x', 'y.y1'])
/* => { x: 'X', y: { y1: 'Y' } }
*/
```

#### 条件を満たすのkey-value `{} -> {}`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.pickBy(input, v => _.size(v) > 1)
/* => { y: { y1: 'Y', y2: 'YY' }, z: 'ZZZ' }
*/
```

yはObject型なので、`_.size`はkey-valueの数になります。


### 要素を削除する

#### 一致する値 `[] -> []`

```js
const input = [10, 20, 30, 20, 10, 40, 50, 60, 30, 10]
_.without(input, 10, 20)
/* => [ 30, 40, 50, 60, 30 ]
*/
```

#### 先頭から指定数 `[] -> []`

```js
const input = [10, 11, 12, 13, 14]
_.drop(input, 3)
/* => [ 13, 14 ]
*/
```

#### 末尾から指定数 `[] -> []`

```js
const input = [10, 11, 12, 13, 14]
_.dropRight(input, 3)
/* => [ 10, 11 ]
*/
```

#### 条件を満たす要素 `([]|{}) -> []`

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.reject(input, x => x < 12)
/* => [ 12, 13, 12 ]
*/
```

#### 先頭から条件を満たしている間 `[] -> []`

条件を満たさない要素が出現したら、その後に条件を満たす要素が残っていても終了します。

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.dropWhile(input, x => x < 12)
/* => [ 12, 13, 12, 11, 10 ]
*/
```

#### 末尾から条件を満たしている間 `[] -> []`

```js
const input = [10, 11, 12, 13, 12, 11, 10]
_.dropRightWhile(input, x => x < 12)
/* => [ 10, 11, 12, 13, 12 ]
*/
```

#### 先頭の要素 `[] -> []`

```js
const input = [10, 11, 12, 13, 14]
_.tail(input)
/* => [ 11, 12, 13, 14 ]
*/
```

#### 末尾の要素 `[] -> []`

```js
const input = [10, 11, 12, 13, 14]
_.initial(input)
/* => [ 10, 11, 12, 13 ]
*/
```

#### falseになるような値 `[] -> []`

undefinedの除外に使うケースがあります。  
想定外に0や空文字が消えてしまうことがあるので、明示的に書いた方が堅牢だとは思います。

```js
const input = ["ai", undefined, "kawa", "", "sho", undefined]
_.compact(input)
/* => [ 'ai', 'kawa', 'sho' ]
*/
```

#### 指定したパスのkey-value `{} -> {}`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.omit(input, ['x', 'y.y1'])
/* => { y: { y2: 'YY' }, z: 'ZZZ' }
*/
```

#### 条件を満たすのkey-value `{} -> {}`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.omitBy(input, v => _.size(v) > 1)
/* => { x: 'X' }
*/
```

yはObject型なので、`_.size`はkey-valueの数になります。


### 重複要素を除外する `[] -> []`

#### 通常

```js
const input = [1, 2, 3, 2, 4, 5, 4]
_.uniq(input)
/* => [ 1, 2, 3, 4, 5 ]
*/
```

inputが昇順にソートされている場合は`_.sortedUniq`を使用でき、こちらの方が高速です。

```js
const input = [1, 2, 2, 2, 3, 3, 4, 5, 5, 5]
_.sortedUniq(input)
/* => [ 1, 2, 3, 4, 5 ]
*/
```

#### 変換後の値で判定する

1の位に変換した結果が重複する要素を除外します。

```js
const input = [31, 41, 52, 63, 71]
_.uniqBy(input, x => x % 10)
/* => [ 31, 52, 63 ]
*/
```

input変換後の値が昇順にソートされている場合は`_.sortedUniqBy`を使用でき、こちらの方が高速です。

```js
const input = [31, 41, 71, 52, 63]
_.sortedUniqBy(input, x => x % 10)
/* => [ 31, 52, 63 ]
*/
```

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6], [3, 4], [2, 1]]
_.uniqWith(input, _.isEqual)
/* => [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 2, 1 ] ]
*/
```


### Arrayに別のArrayや値を結合する `[] -> []`

配列 or 単一値どちらでもいけます。

```js
const input = [1, 2]
_.concat(input, [3, 4], 5)
/* => [ 1, 2, 3, 4, 5 ]
*/
```

配列か単一値のどちらが来るか分かっていれば、Spread operatorで `[...input, [3, 4], ...5]`と書けますね。


変換
----

集まりを別の形の集まりに変換する処理です。


### 要素を変換する `[]|{} -> []`

#### 通常

```js
const input = ["one", "two", "three"]
_.map(input, x => x.toUpperCase())
/* => [ 'ONE', 'TWO', 'THREE' ]
*/
```

#### 変換関数のパスを指定

```js
const input = ["one", "two", "three"]
_.invokeMap(input, "toUpperCase")
/* => [ 'ONE', 'TWO', 'THREE' ]
*/
```

以下と同じ意味です。

```js
_.map(input, x => x.toUpperCase())
```

#### 1段階フラット化

map -> flatten の順ではなく flatten -> map の順なので注意。

```js
const input = [1, 2, 3]
_.flatMap(input, x => [x, [x + 10]])
/* => [ 1, [ 11 ], 2, [ 12 ], 3, [ 13 ] ]
*/
```

#### 多段階フラット化

map -> flatten の順ではなく flatten -> map の順なので注意。

```js
const input = [1, 2, 3]
_.flatMapDepth(input, x => [x, [x + 10, [x + 100]]], 2)
/* => [ 1, 11, [ 101 ], 2, 12, [ 102 ], 3, 13, [ 103 ] ]
*/
```

#### 完全フラット化

map -> flatten の順ではなく flatten -> map の順なので注意。

```js
const input = [1, 2, 3]
_.flatMapDeep(input, x => [x, [x + 10, [x + 100]]], 2)
/* => [ 1, 11, 101, 2, 12, 102, 3, 13, 103 ]
*/
```


### 階層を平坦にする

#### 1段階フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flatten(input)
/* => [ 1, 2, 3, 4, [ 5, [ 6 ] ] ]
*/
```

#### 多段階フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flattenDepth(input, 2)
/* => [ 1, 2, 3, 4, 5, [ 6 ] ]
*/
```

#### 完全フラット化

```js
const input = [1, [2, 3], [4, [5, [6]]]]
_.flattenDeep(input)
/* => [ 1, 2, 3, 4, 5, 6 ]
*/
```


### 要素ごとの個数を数える `([]|{}) -> {}`

#### 通常

```js
const input = [1, 2, 3, 2, 2, 1]
_.countBy(input)
/* => { '1': 2, '2': 3, '3': 1 }
*/
```

#### 変換後の値で数える

```js
const input = [10, 11, 12, 20, 30, 31]
_.countBy(input, x => x % 10)
/* => { '0': 3, '1': 2, '2': 1 }
*/
```


### key-value化する `([]|{}) -> {}`

#### key:value = 1:1

検索などの処理を高速化するためindexingするときに利用します。

```js
const input = [1, 6, 11, 16, 21, 26]
_.keyBy(input, x => x % 10)
/* => { '1': 21, '6': 26 }
*?
```

複数候補がある場合は、最も後に出現した要素が採用されます。  
ただその場合は後述する`_.groupBy`の使用を考えて下さい。

#### key:value = 1:N

```js
const input = [1, 6, 11, 16, 21, 26]
_.groupBy(input, x => x % 10)
/* => { '1': [ 1, 11, 21 ], '6': [ 6, 16, 26 ] }
*?
```


### 複数配列をグループ化する

#### 配列にグルーピング `...[] -> [][]`

```js
_.zip(['x', 'y', 'z'], [1, 2, 3], [10, 20, 30], [100, 200, 300])
/* => [ [ 'x', 1, 10, 100 ], [ 'y', 2, 20, 200 ], [ 'z', 3, 30, 300 ] ]
*/
```

{{<info "INPUTとOUTPUTの形をイメージしやすくするには...">}}
こんな風にイメージするといいかもしれません。

入力が↓のとき...
```js
_.zip(['x', 'y', 'z'], [1, 2, 3], [10, 20, 30], [100, 200, 300])
```

縦に並べて...
```
['x', 'y', 'z']
[ 1 ,  2 ,  3 ]
[ 10,  20,  30]
[100, 200, 300]
```

縦でArrayにして...
```
 ┏━┓  ┏━┓  ┏━┓
['x', 'y', 'z']
[ 1 ,  2 ,  3 ]
[ 10,  20,  30]
[100, 200, 300]
 ┗━┛  ┗━┛  ┗━┛
```

整形すると...
```
┏━               ━┓
┃  ┏━┓  ┏━┓  ┏━┓  ┃
┃  'x', 'y', 'z'  ┃
┃   1 ,  2 ,  3   ┃
┃   10,  20,  30  ┃
┃  100, 200, 300  ┃
┃  ┗━┛  ┗━┛  ┗━┛  ┃
┗━               ━┛
```

こうなる😄

```
[ [ 'x', 1, 10, 100 ], [ 'y', 2, 20, 200 ], [ 'z', 3, 30, 300 ] ]
```
{{</info>}}


#### 配列にグルーピング `[][] -> [][]`

```js
const input = [ [ 'x', 1, 10, 100 ], [ 'y', 2, 20, 200 ], [ 'z', 3, 30, 300 ] ]
_.unzip(input)
/* =>
[ [ 'x', 'y', 'z' ],
  [ 1, 2, 3 ],
  [ 10, 20, 30 ],
  [ 100, 200, 300 ] ]
*/
```

実は`_.zip(...input)`と一緒です😛  
引数が配列(`*[]`)、可変長引数(`...*`)、どちらかの違いです。

#### Objectにグルーピング `([n], [n]) -> {}`

```js
_.zip(['id', 'name', 'age'], [10, 'ichiro', 21])
/* => { id: 10, name: 'ichiro', age: 21 }
*/
```

CSVデータをObjectに変換したり、並列処理結果をマッピングするときによく使います。

{{<file "CSVデータ変換の例">}}
```js
const input = `
1,10,100
2,20,200
3,30,300
`
_(input)
    .split("\n")
    .compact()
    .map(x => _.zipObject(
      ['one', 'ten', 'hundred'],
      x.split(',')
    ))
    .value()
/* =>
 [ { one: '1', ten: '10', hundred: '100' },
   { one: '2', ten: '20', hundred: '200' },
   { one: '3', ten: '30', hundred: '300' } ]
*/
```
{{</file>}}

#### Objectにネストプロパティ有効でグルーピング `([n], [n]) -> {}`

```js
_.zipObjectDeep(
  ['id', 'name', 'detail.age',  'detail.favorites[0]', 'detail.favorites[1]'],
  [10, 'ichiro', 21, 'りんご', 'みかん']
)
/* =>
{
  id: 10,
  name: 'ichiro',
  detail: {
    age: 21,
    favorites: [ 'りんご', 'みかん' ]
  }
}
*/
```

#### グルーピングロジックを指定してグルーピング `...[] -> []`

```js
_.zipWith(
  ['x', 'y', 'z'], [1, 2, 3], [10, 20, 30], [100, 200, 300],
  (key, one, ten, hundred) => ({key, total: one + ten + hundred})
)
/* =>
[ { key: 'x', total: 111 },
  { key: 'y', total: 222 },
  { key: 'z', total: 333 } ]
*/
```

{{<info "INPUTとOUTPUTの形をイメージしやすくするには...">}}
`_.zip`と同様以下のようなイメージです。

入力が↓のとき...
```js
_.zipWith(
  ['x', 'y', 'z'], [1, 2, 3], [10, 20, 30], [100, 200, 300],
  (key, one, ten, hundred) => ({key, total: one + ten + hundred})
)
```

縦に並べて...
```
['x', 'y', 'z']
[ 1 ,  2 ,  3 ]
[ 10,  20,  30]
[100, 200, 300]
```

縦でArrayにして...
```
 ┏━┓  ┏━┓  ┏━┓
['x', 'y', 'z']
[ 1 ,  2 ,  3 ]
[ 10,  20,  30]
[100, 200, 300]
 ┗━┛  ┗━┛  ┗━┛
```

整形して...
```
┏━               ━┓
┃  ┏━┓  ┏━┓  ┏━┓  ┃
┃  'x', 'y', 'z'  ┃
┃   1 ,  2 ,  3   ┃
┃   10,  20,  30  ┃
┃  100, 200, 300  ┃
┃  ┗━┛  ┗━┛  ┗━┛  ┃
┗━               ━┛
```

縦をそれぞれの引数とみなしてロジックを実行すると...
```
┏━               ━┓
┃  ┏━┓  ┏━┓  ┏━┓  ┃
┃  'x', 'y', 'z'  ┃
┃   1 ,  2 ,  3   ┃
┃   10,  20,  30  ┃
┃  100, 200, 300  ┃
┃  ┗━┛  ┗━┛  ┗━┛  ┃
┗━  ┃    ┃    ┃  ━┛
    ┃    ┃    ┗━━━→ ({key: x, total: 3 + 30 + 300})
    ┃    ┗━━━━━━━━→ ({key: y, total: 2 + 20 + 200})
    ┗━━━━━━━━━━━━━→ ({key: x, total: 1 + 10 + 100})
```

こうなる😄

```
[ { key: 'x', total: 111 },
  { key: 'y', total: 222 },
  { key: 'z', total: 333 } ]
```
{{</info>}}

#### グルーピングロジックを指定してグルーピング `[][] -> []`

`_unzip`にロジックが加わったものです。

```js
const input = [ [ 'x', 1, 10, 100 ], [ 'y', 2, 20, 200 ], [ 'z', 3, 30, 300 ] ]
_.unzipWith(input, (x, y, z) => x + y + z)
/* => [ 'xyz', 6, 60, 600 ]
*/
```

`_.unzipWith(...input, ...)`とはロジックが入る対象に違いがあるため、結果が変わります。


### 2要素ArrayとObjectを相互変換する

#### ArrayからObject `[2][] -> {}`

```js
const input = [["a", 1], ["b", 2], ["c", 3]]
_.fromPairs(input)
/* => { a: 1, b: 2, c: 3 }
*/
```

#### ObjectからArray `{} -> [2][]`

```js
const input = { a: 1, b: 2, c: 3 }
_.toPairs(input)
/* => [ [ 'a', 1 ], [ 'b', 2 ], [ 'c', 3 ] ]
*/
```


### 塊に分離する `[] -> [][]`

3つずつに分離します。並行処理をさせる場合のグループ分けなどに。

```js
const input = [1, 2, 3, 4, 5, 6, 7]
_.chunk(input, 3)
/* => [ [ 1, 2, 3 ], [ 4, 5, 6 ], [ 7 ] ]
*/
```


### 条件を満たすものと満たさないものに分別する `([]|{}) -> [2]`

```js
const input = [1, 2, 3, 4, 5, 6, 7]
_.partition(input, x => x >= 5)
/* => [ [ 5, 6, 7 ], [ 1, 2, 3, 4 ] ]
*/
```


### keyとvalueを逆転する `{} -> {}`

#### 変換後の値は1つ

同じ値がある場合はどちらか一方が採用されます。

```js
const input = {x: 'X', y: 'YY', z: 'ZZZ', x2: 'X'}
_.invert(input)
/* => { X: 'x2', YY: 'y', ZZZ: 'z' }
*/
```

#### 変換後の値は複数

```js
const input = {x: 'X', y: 'YY', z: 'ZZZ', x2: 'X'}
_.invertBy(input)
/* => { X: [ 'x', 'x2' ], YY: [ 'y' ], ZZZ: [ 'z' ] }
*/
```

#### 値をkeyに変換するロジックの指定

変換後の値は複数(配列)です。

```js
const input = {x: 'X', y: 'YY', z: 'ZZZ', x2: 'X'}
_.invertBy(input, v => v.toLowerCase())
/* => { x: [ 'x', 'x2' ], yy: [ 'y' ], zzz: [ 'z' ] }
*/
```


### key-valueをkeyだけに変換する `{} -> []`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.keys(input)
/* => [ 'x', 'y', 'z' ]
*/
```

Nativeの`Object.keys(input)`と同じです。


### key-valueをvalueだけに変換する `{} -> []`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.values(input)
/* => [ 'X', { y1: 'Y', y2: 'YY' }, 'ZZZ' ]
*/
```

Nativeの`Object.values(input)`と同じです。


### key-valueのkeyを変換する `{} -> {}`

各keyの後に、valueを文字列にしたときの長さを付ける例です。

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.mapKeys(input, (v, k) => `${k}-${v.toString().length}`)
/* => { 'x-1': 'X', 'y-15': { y1: 'Y', y2: 'YY' }, 'z-3': 'ZZZ' }
*/
```

keyが渡るのはラムダ式の第2引数なので注意してください。


### key-valueのvalueを変換する `{} -> {}`

各valueを、文字列にしたときの長さにする例です。

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.mapValues(input, v => v.toString().length)
/* => { x: 1, y: 15, z: 3 }
*/
```


並び替え
--------

要素や構成に変更は無いが、順番が変わる処理です。

### 要素を並び替える `([]|{}) -> []`

#### 昇順 固定

```js
const input = [7, 2, 5, 3, 8]
_.sortBy(input)
/* => [ 2, 3, 5, 7, 8 ]
*/

const input = [
  {a: 1, b: 30},
  {a: 3, b: 20},
  {a: 2, b: 10},
]
_.sortBy(input, x => x.b)
/* => [
  { a: 2, b: 10 },
  { a: 3, b: 20 },
  { a: 1, b: 30 }
]
*/
```

#### 昇順/降順 指定

```js
const input = [7, 2, 5, 3, 8]
_.orderBy(input, undefined, 'desc')
/* => [ 8, 7, 5, 3, 2 ]
*/

const input = [
  {a: 1, b: 30},
  {a: 3, b: 20},
  {a: 2, b: 10},
]
_.orderBy(input, x => x.b, 'desc')
/* => [
  { a: 1, b: 30 },
  { a: 3, b: 20 },
  { a: 2, b: 10 }
]
*/
```

#### ランダム

{{<warn-short>}}
ランダムなので結果は毎回変わります。
{{</warn-short>}}


```js
const input = [1, 2, 3, 4, 5]
_.shuffle(input)
/* => [ 1, 3, 5, 4, 2 ]
*/
```


畳み込み
--------

複数の要素を単一の何かに畳み込む処理です。


### サイズを取得する `([]|{}) -> number`

```js
const input = [1, 10, 100]
_.size(input)
/* => 3
*/
```


### 任意の処理で畳み込む `([]|{}) -> *`

#### 左から畳み込む

total値と各要素を入力とした処理を指定して、最終total値を出力します。

```js
const input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
_.reduce(input, (total, x) => total + x, 0)
/* => 55
*/
```

#### 右から畳み込む

交換法則を満たさない処理の場合は右から畳み込む必要があるケースもあります。

```js
const input = ["お", "え", "う", "い", "あ"]
_.reduceRight(input, (total, x) => total + x, "")
/* => あいうえお
*/
```

#### 条件を満たしている間

`_.reduce`とは異なり、`accumulator`を直接操作します。  
代わりにiterateeの返却値はbooleanとなり、`false`を返却した時点で終了します。

```js
const input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
_.transform(input, (accumulator, x) => {
  total.push(x+10)
  return x < 5
}, [])
/* => [ 11, 12, 13, 14, 15 ]
*/
```


### 文字列で結合する `[] -> string`

第2引数を省略した場合は`,`で結合されます。

```js
const input = ["ai", "ue", "o"]
_.join(input, '-->')
/* => ai-->ue-->o
*/
```



判定
----

booleanを返す判定系の処理です。

### keyが含まれているかを確認する `{} -> boolean`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.has(input, 'y.y1')
/* => true
*/
_.has(input, 'z.z1')
/* => false
*/
```


### 要素が含まれているかを確認する `([]|{}|string) -> boolean`

```js
const input = [10, 20, 30, 40, 50]
_.includes(input, 30)
/* => true
*/
const input = [10, 20, 30, 40, 50]
_.includes(input, 77)
/* => false
*/
```


### 全てが条件を満たすかを確認する `([]|{}) -> boolean`

```js
const input = [1, 2, 3]
_.every(input, x => x < 5)
/* => true
*/
const input = [1, 2, 6]
_.every(input, x => x < 5)
/* => false
*/
```


### 少なくとも1つが条件を満たすかを確認する `([]|{}) -> boolean`

```js
const input = [1, 10, 100]
_.some(input, x => x < 5)
/* => true
*/
const input = [10, 50, 100]
_.some(input, x => x < 5)
/* => false
*/
```


index系
-------

indexに関わる処理。


### 条件に一致するindexを返却する `[] -> number`

#### 最初のindex

```js
const input = [10, 20, 30, 20, 10, 20]
_.findIndex(input, x => x === 20)
/* => 1
*/
```

#### 最後のindex

```js
const input = [10, 20, 30, 20, 10, 20]
_.findLastIndex(input, x => x === 20)
/* => 5
*/
```

#### 値が完全一致する最初のindex

`_.findIndex`より記述が楽です。

```js
const input = [10, 20, 30, 20, 30, 20, 10]
_.indexOf(input, 30)
/* => 2
*/
```

inputが昇順にソートされている場合は`_.sortedIndexOf`を使用でき、こちらの方が高速です。

```js
const input = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40]
_.sortedIndexOf(input, 30)
/* => 3
*/
```

#### 値が完全一致する最後のindex

`_.findLastIndex`より記述が楽です。

```js
const input = [10, 20, 30, 20, 30, 20, 10]
_.lastIndexOf(input, 30)
/* => 4
*/
```

inputが昇順にソートされている場合は`_.sortedLastIndexOf`を使用でき、こちらの方が高速です。

```js
const input = [10, 20, 20, 30, 30, 30, 40, 40, 40, 40]
_.sortedLastIndexOf(input, 30)
/* => 5
*/
```


### ⚠ソート順を考慮して値の挿入位置を決定する `[] -> number`

{{<warn-short>}}
`input`は予め昇順にソートされている必要があります。
{{</warn-short>}}

#### 通常

候補が複数ある場合に最初の位置を返却します。

```js
const input = [10, 20, 30, 35, 40, 50]
_.sortedIndex(input, 35)
/* => 3
*/
```

最後の位置を返却したい場合は`_sortedLastIndex`を使います。

```js
const input = [10, 20, 30, 35, 40, 50]
_.sortedLastIndex(input, 35)
/* => 4
*/
```

#### 変換後の値で判定する

1の位に変換した上で最初の候補を返却します。

```js
const input = [21, 82, 34, 55, 46, 97]
_.sortedIndexBy(input, 15, x => x % 10)
/* => 3
*/
```

1の位に変換した上で最後の候補を返却したい場合は`_sortedLastIndexBy`を使います。

```js
const input = [21, 82, 34, 55, 46, 97]
_.sortedLastIndexBy(input, 15, x => x % 10)
/* => 4
*/
```


集合演算
--------

### 和集合を求める `[] -> []`

#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.union(input, [3, 4, 5, 6, 7])
/* => [ 1, 2, 3, 4, 5, 6, 7 ]
*/
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.unionBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
/* => [ 1, 2, 3, 4 ]
*/
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の和になるので`[1, 2, 3, 4]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.unionWith(input, [[3, 4], [4, 5]], _.isEqual)
/* => [ [ 1, 2 ], [ 3, 4 ], [ 5, 6 ], [ 4, 5 ] ]
*/
```


### 差集合を求める `[] -> []`

差分ではなく差集合です。順番が大事です。

#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.difference(input, [3, 4, 5, 6, 7])
/* => [ 1, 2 ]
*/
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.differenceBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
/* => [ 1, 2 ]
*/
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の引き算になるので`[1, 2]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.differenceWith(input, [[3, 4], [4, 5]], _.isEqual)
/* => [ [ 1, 2 ], [ 5, 6 ] ]
*/
```

`_differece(input, [[3, 4], [4, 5]])`の場合は`[3, 4]`が結果から除外されません。


### 積集合を求める `[] -> []`

#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.intersection(input, [3, 4, 5, 6, 7])
/* => [ 3, 4, 5 ]
*/
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.intersectionBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
/* => [ 3, 4 ]
*/
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の積になるので`[3, 4]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.intersectionWith(input, [[3, 4], [4, 5]], _.isEqual)
/* => [ [ 3, 4 ] ]
*/
```

`_.intersection(input, [[3, 4], [4, 5]])`の場合は`[3, 4]`も共通部分と見なされません。


### 対象差集合を求める `[] -> []`

対象差集合とは、どちらか片方だけに出現する値の集合です。  

{{<info "ベン図など視覚的な理解がしたい方へ">}}
以下のサイトが分かりやすいです。

{{<summary "https://qiita.com/namitop/items/be11c007da456ea95735#%E7%99%BA%E5%B1%95">}}
{{</info>}}


#### 通常

```js
const input = [1, 2, 3, 4, 5]
_.xor(input, [3, 4, 5, 6, 7])
/* => [ 1, 2, 6, 7 ]
*/
```

#### 変換後の値で判定する

4以上は全て4と見なした場合。

```js
const input = [1, 2, 3, 4, 5]
_.xorBy(input, [3, 4, 5, 6, 7], x => x >= 4 ? 4 : x)
/* => [ 1, 2, 3, 4 ]
*/
```

`[1, 2, 3, 4, 4]`と`[3, 4, 4, 4, 4]`の対象差になるので`[1, 2]`が残ります。

#### 判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

```js
const input = [[1, 2], [3, 4], [5, 6]]
_.xorWith(input, [[3, 4], [4, 5]], _.isEqual)
/* => [ [ 1, 2 ], [ 5, 6 ], [ 4, 5 ] ]
*/
```


副作用を伴うもの
----------------

以下のfunctionは副作用を伴うため、代替案がある場合はそちらを推奨します。  
使う場合は挙動を理解した上で、本当に必要な場合のみ使用して下さい。


### 💀Arrayの要素を危険な方法で削除する `[] -> []`

戻り値だけではなくinputごと削除します。

#### 💀一致する値

{{<warn-short>}}
可能なら、inputを変更しない `_.without` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 20, 10, 40, 50, 60, 30, 10]
_.pull(input, 10, 20)
/* => [ 30, 40, 50, 60, 30 ]
*/
```

配列を指定したい場合は`_.pullAll`を使います。

{{<warn-short>}}
可能なら、inputを変更しない `_.difference` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 20, 10, 40, 50, 60, 30, 10]
_.pullAll(input, [10, 20])
/* => [ 30, 40, 50, 60, 30 ]
*/
```

#### 💀変換後の値で判定する

10で割った商を使って判定します(= 10の位が等しいか)。

{{<warn-short>}}
可能なら、inputを変更しない `_.differenceBy` を使いましょう
{{</warn-short>}}

```js
const input = [11, 21, 31, 22, 12, 41, 51, 61, 33, 13]
_.pullAllBy(input, [10, 20], x => Math.floor(x / 10))
/* => [ 31, 41, 51, 61, 33 ]
*/
```

#### 💀判定ロジックを指定する

配列の中身が全て等しければ、配列同士も等しいというロジックを指定します(`_.isEqual`)

{{<warn-short>}}
可能なら、inputを変更しない `_.differenceWith` を使いましょう
{{</warn-short>}}

```js
const input = [{x: 1}, {x: 2}, {x: 3}]
_.pullAllWith(input, [ {x: 2} ], _.isEqual)
/* => [ { x: 1 }, { x: 3 } ]
*/
```

`_.pullAll`では`{x: 2}`が同一とみなされず削除されません。

#### 💀N番目を指定する

{{<warn-short>}}
可能なら、inputを変更しない `_.at` を使いましょう
{{</warn-short>}}

```js
const input = [10, 20, 30, 40]
_.pullAt(input, [1, 3])
/* => [ 20, 40 ]
*/
```

#### 💀条件に一致する要素

{{<warn-short>}}
可能なら、inputを変更しない `_.filter`, `_.reject` を使いましょう
{{</warn-short>}}

戻り値には削除した要素が返却され、元の配列は削除後の値になります。

```js
const input = [10, 20, 30, 40]
_.remove(input, x => x > 20)
/* => [ 30, 40 ]
*/
input
/* => [ 10, 20 ]
*/
```


### 💀Arrayの要素を同じ値で埋める `[] -> []`

```js
const input = Array(5)
_.fill(input, "nil")
/* => [ 'nil', 'nil', 'nil', 'nil', 'nil' ]
*/
```


### 💀Arrayの順序を逆転する `[] -> []`

```js
const input = [10, 20, 30, 40]
_.reverse(input)
/* => [ 40, 30, 20, 10 ]
*/
```

`[10, 20, 30, 40].reverse()`と一緒です。


### 💀Objectのkey-valueを上書き/追加する `{} -> {}`

#### 💀後から指定された方で勝つ

```js
const input = {x: 'X', y: 'Y'}
_.assign(input, {x: 'XXX'}, {z: 'Z'})
/* => { x: 'XXX', y: 'Y', z: 'Z' }
*/
```

分割代入(Destructuring assignment)を使えば安全に書くこともできます。

```js
{...input, x: 'XXX', z: 'Z'}
```

#### 💀先に指定された方が勝つ

```js
const input = {x: 'X', y: 'Y'}
_.defaults(input, {x: 'XXX'}, {z: 'Z'})
/* => { x: 'X', y: 'Y', z: 'Z' }
*/
```

ネストしている要素の場合は`defaultsDeep`です。

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.defaultsDeep(input, {x: 'XXX'}, {y: {y1: 'YYY', y3: 'YYYYYYYYY'}})
/* => { x: 'X', y: { y1: 'Y', y2: 'YY', y3: 'YYYYYYYYY' }, z: 'ZZZ' }
*/
```

`defaults`だと`y.y3`が追加されません。

#### 💀上書きする/しないロジック指定

文字数が多い方で上書きするロジックの場合です。

```js
const input = {x: 'X', y: 'YY', z: 'ZZZ'}
_.assignWith(
  input, {x: 'XXX', y: 'YY'}, {z: 'Z'},
  (obj, src) => obj.length > src.length ? obj : src
)
/* => { x: 'XXX', y: 'YY', z: 'ZZZ' }
*/
```


### 💀Objectのkey-valueをマージする `{} -> {}`

#### 💀通常

各valueがArrayまたはObjectであるとき、内容をマージします。

```js
const input = {x: {x1: 'X'}, y: 'Y'}
_.merge(input, {x: {x2: 'XX'}, y: 'YY'})
/* => { x: { x1: 'X', x2: 'XX' }, y: 'YY' }
*/
```

`_.assign`の場合、結果は以下になり挙動の違いを確認できます。

```js
{ x: { x2: 'XX' }, y: 'YY' }
```

#### 💀マージロジックを指定

マージする2つの値をJSON文字列にして結合するロジックに変更した例です。

```js
const mergeAsJsonString = (obj, src) => JSON.stringify(obj) + JSON.stringify(src)

const input = {x: {x1: 'X'}, y: 'Y'}
_.mergeWith(input, {x: {x2: 'XX'}, y: 'YY'}, mergeAsJsonString)
/* => { x: '{"x1":"X"}{"x2":"XX"}', y: '"Y""YY"' }
*/
```


### 💀指定したパスに値を設定する `{} => {}`

#### 💀通常

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.set(input, 'x.y2', 'YYYYYYYYYY')
/* => { x: { y2: 'YYYYYYYYYY' }, y: { y1: 'Y', y2: 'YY' }, z: 'ZZZ' }
*/
```

#### 💀設定ロジックを指定

指定パスの値が存在する場合、その値から更新後の値を設定するロジックを指定できます。

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.update(input, 'y.y2', x => _.repeat(x, 5))
/* => { x: 'X', y: { y1: 'Y', y2: 'YYYYYYYYYY' }, z: 'ZZZ' }
*/
```

#### 💀数字をkeyとして扱う

`a[0]`や`a.0`と指定したとき、`0`をkeyとして扱います。

```js
const input = {x: 'X', z: 'ZZZ'}
_.setWith(input, 'y.0', 'YYY', Object)
/* => { x: 'X', z: 'ZZZ', y: { '0': 'YYY' } }
*/
```

`_.set`の場合は以下のようになります。

```js
_.set(input, 'y.0', 'YYY')
/* => { x: 'X', z: 'ZZZ', y: [ 'YYY' ] }
*/
```

設定ロジックを指定する場合は`_.updateWith`を使います。

```js
const input = {x: 'X', z: 'ZZZ'}
_.updateWith(input, 'y.0', x => "dummy", Object)
/* => { x: 'X', z: 'ZZZ', y: { '0': 'dummy' } }
*/
```


### 💀指定したパスの値を削除する `{} => {}`

`_.unset`の返却値はプロパティが削除されたかどうかのbooleanです。

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'YY'}, z: 'ZZZ'}
_.unset(input, 'y.y2')
/* => true
*/
input
/* => { x: 'X', y: { y1: 'Y' }, z: 'ZZZ' }
```


その他
------


### 各要素に処理を行う `([]|{}) -> ([]|{})`

#### 先頭から

```js
const input = [1, 2, 3]
_.forEach(input, x => console.log(x*2))
/* =>
2
4
6
[ 1, 2, 3 ]
*/
```

Nativeの`Array.forEach`で事足りる場合がほとんどです。

#### 末尾から

```js
const input = [1, 2, 3]
_.forEachRight(input, x => console.log(x*2))
/* =>
6
4
2
[ 1, 2, 3 ]
*/
```


### 指定したパスのmethodを実行する `{} => *`

```js
const input = {x: 'X', y: {y1: 'Y', y2: 'Y-Y'}, z: 'ZZZ'}
_.invoke(input, 'y.y2.split', '-')
/* => [ 'Y', 'Y' ]
*/
```

`input.y.y2.split('-')`と同じです。


総括
----

Lodashの以下Sectionに属するmethodを用途別に紹介しました。

* Array
* Collection
* Object

続きを書くことがあれば、次はFunction版を執筆したいと思っています。
