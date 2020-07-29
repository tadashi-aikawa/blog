---
title: IntelliJ IDEAのプラグインを作ってみた
slug: create-intellij-idea-plugin
date: 2020-04-22T15:30:42+09:00
thumbnailImage: https://cdn.svgporn.com/logos/intellij-idea.svg
categories:
  - engineering
tags:
  - idea
---

IntelliJ IDEAのプラグインをKotlinで作ってみました。  

<!--more-->

{{<cimg "https://cdn.svgporn.com/logos/intellij-idea.svg">}}

<!--toc-->


はじめに
--------

### どんなプラグインを作ったのか?

Markdownの機能を拡張するプラグインです。

{{<himg "resources/2020-04-22_15h50_04.gif">}}

執筆時点では以下機能を提供しています。

* テーブルのフォーマット/補完
* 見出し下線の補完

#### JetBrainsのプラグインページ

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

#### リポジトリ

{{<summary "https://github.com/tadashi-aikawa/markowl">}}


### なぜ作ったのか?

2つ理由があります。

#### 必要な機能を搭載した既存プラグインがなかった

今年に入って、Markdown編集に使う主なエディタをVS CodeからIntelliJ IDEAに移行しました。  
移行した理由は以下です。

* VS Codeは動作がもっさりしている
  * Vimアドオンを使用した場合
* 頭の切り替えが面倒
  * 開発物のREADMEを書くときはIntelliJ IDEAを使うので

しかし、IntelliJ IDEAとプラグインでは必要なMarkdown編集機能が不足していました。  
VS Codeを使っていたときはアドオンを利用したり、自作アドオンで解決してきたのに。

#### Kotlinで開発がしたかった

前からKotlinが気になっていましたが、本当に必要なケースに巡り会いませんでした。  
大抵の課題はPython、TypeScript、Golangで解決してしまいます。

しかし、IntelliJ IDEAのプラグインはJava/Kotlinで作る必要があります。  
Javaは使いたくないし、Markdown編集機能を拡張したかったので願ってもないタイミングです。

### ドキュメント

公式ドキュメントを参考にしました。

{{<summary "https://pleiades.io/intellij/sdk/docs/intro/welcome.html">}}

プラグインのクイックスタートガイドは以下です。

{{<summary "https://pleiades.io/intellij/sdk/docs/basics/basics.html">}}

基本的にJavaを使った手順が紹介されていますが、本記事の内容はそれをKotlinに変換しています。

### 環境

| 項目                       | バージョン                              |
| -------------------------- | --------------------------------------- |
| OS                         | Windows 10 Pro 1909                     |
| IntelliJ IDEA              | 2020.1                                  |
| JDK                        | jdk1.8.0_211                            |
| Kotlin                     | 1.3.71-release-431 (JRE 1.8.0_242-b08)  |
| Kotlinプラグイン           | 1.3.72-release-IJ2020.1-1               |
| Gradle                     | 5.2.1                                   |
| Gradleプラグイン           | bundled 201.6668.121                    |
| Gradle Extensionプラグイン | bundled 201.6668.121                    |
| Plugin DevKitプラグイン    | bundled 201.6668.121                    |


プラグインプロジェクトをつくる
------------------------------

[入門セクション]を参考にプラグインプロジェクトを作成してみましょう。  
推奨されているGradleを使います。

[入門セクション]: https://pleiades.io/intellij/sdk/docs/basics/getting_started.html

{{<summary "https://pleiades.io/intellij/sdk/docs/tutorials/build_system/prerequisites.html">}}

ウィザードからプロジェクトを作成します。

{{<himg "resources/bd3d80b9.png">}}

{{<himg "resources/30308e3a.png">}}

{{<warn "Gradleが表示されない">}}
Gradle Extensionのプラグインが有効になっているかを確認してください。
{{</warn>}}

プロジェクト作成後、初回は準備に時間がかかります。  
本記事執筆時は15分くらい待ちました。


プラグインを起動する
--------------------

プロジェクト作成が完了し、Gradleのタスクが表示されたら`intellij/runIde`を実行します。

{{<himg "resources/40c95fed.png">}}

開発用のIDEAインスタンスが立ち上がればOKです。  
起動したインスタンスのPlugin画面にて、プラグインが認識されていることを確認しましょう。

{{<himg "resources/e9e9a1df.png">}}

表示されるプラグイン情報は`plugin.xml`の内容が反映されています。  
どこに何の情報が表示されるかあとで紹介します。


Actionを作ってみる
------------------

プラグインにはまだなんの機能も実装されていません。  
ウォーミングアップとして、ダイアログを表示する機能を追加してみましょう。

{{<summary "https://pleiades.io/intellij/sdk/docs/tutorials/action_system.html">}}

### Actionの登録

`src\main\resources\META-INF\plugin.xml`の`<actions>`に`<action>..</action>`を追加します。  

```xml
<actions>
    <action id="net.mamansoft.markowl.action.markdown.FormatTableAction"
            class="net.mamansoft.markowl.action.markdown.FormatTableAction" text="Format Markdown Table"
            description="Format markdown table">
        <keyboard-shortcut keymap="$default" first-keystroke="alt SEMICOLON"/>
    </action>
</actions>
```

これが意味する重要なポイントは2つです。

* アクション名は`Format Markdown Table`
* デフォルトショートカットキーは`Alt + ;`

{{<why "ダイアログを表示するのにFormat Markdown Table??">}}
最終的にはテーブルフォーマット機能を実装したいので、そのような名前にしています。
{{</why>}}

### Actionの処理を実装

`src\main\kotlin\net\mamansoft\markowl\action\markdown\FormatTableAction.kt` を作成して以下のように実装します。

```kotlin
package net.mamansoft.markowl.action.markdown

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.ui.Messages


class FormatTableAction : AnAction() {
    override fun actionPerformed(e: AnActionEvent) {
        Messages.showMessageDialog(
            "テスト本文",
            "テストタイトル",
            null
        )
    }
}
```

公式ドキュメントのコードをKotlinで書き直し、少しカスタマイズしただけです。

### Actionの実行

Gradleの`runIdes`で開発用インスタンスを立ち上げましょう。  
`Find Action`の一覧に`Format Markdown Table`があれば、登録されています。

実行するとテスト用のダイアログが表示されるはずです:smile:

{{<error "Stringにjava.lang.Stringを求められる">}}
jdkが対応しているバージョンか確認してください。jdk11は少なくとも未対応..8は対応してました。
{{</error>}}


エディタに関するアクションを作る
----------------------------

最終的にはテキストを整形したいので、エディタに関するアクションを使います。  
公式サイトを参考に実装してみましょう。

{{<summary "https://pleiades.io/intellij/sdk/docs/tutorials/editor_basics.html">}}

### 選択範囲が指定されているときのみ実行可能にする

`update(e: AnActionEvent)`を実装して、選択範囲が指定されているときのみ処理を実行できるようにします。  
公式を参考にKotlinへ置き換えてみてください。

{{<summary "https://pleiades.io/intellij/sdk/docs/tutorials/editor_basics/working_with_text.html">}}

### 選択範囲を置換する

`actionPerformed(e: AnActionEvent)`を実装して、実際の処理を書いていきます。

```kotlin
override fun actionPerformed(e: AnActionEvent) {
    val editor = e.getRequiredData(CommonDataKeys.EDITOR)
    val project = e.getRequiredData(CommonDataKeys.PROJECT)

    // キャレットから選択範囲のstart/endを取得
    val primaryCaret = editor.caretModel.primaryCaret
    val start = primaryCaret.selectionStart
    val end = primaryCaret.selectionEnd

    // 選択範囲の文字列を置換
    // 安全な書き込みを実現するため、WriteCommandAction.runWriteを使う
    WriteCommandAction.runWriteCommandAction(project) { editor.document.replaceString(start, end, "置換した後の文字列") }

    // 選択範囲の解除
    primaryCaret.removeSelection()
}
```

開発用インスタンスを立ち上げ、テキストを選択した状態でアクションを実行してみてください。  
選択された箇所が`置換した後の文字列`という文字列に置き換わるはずです:wink:


テーブルを整形する
------------------

本節はMarkowlに関するコア実装です。
今までは基本的なプラグインの実装方法を紹介しましたが、本節では執筆時点での最新コードを紹介します。

{{<alert "success">}}
プラグインの作り方のみに興味ある方はこのセクションを飛ばして下さい。
{{</alert>}}


### FormatTableAction.kt

Actionのエントリポイントです。  
小規模のプロジェクトなので、特化したビジネスロジックも同じファイルに記載しています。

{{<file ".../action/markdown/FormatTableAction.kt">}}

```kotlin
package net.mamansoft.markowl.action.markdown

import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.CommonDataKeys
import com.intellij.openapi.util.TextRange
import net.mamansoft.markowl.domain.OwlDocument
import net.mamansoft.markowl.util.countWideWord
import net.mamansoft.markowl.util.fillEmpty
import net.mamansoft.markowl.util.inverse
import net.mamansoft.markowl.util.width

fun formatTable(tableStr: String): String {
    val rows = tableStr.split("\n")
        .map { it.trim('|').split('|').map { v -> v.trim() } }
    val maxColumnNums = rows.map { it.size }.max() ?: 0
    val columns = inverse(rows)
    val columnWidths = columns.map { it.map(::width).max()?.coerceAtLeast(3) ?: 3 }

    return rows.mapIndexed { rowIndex, row ->
        row.fillEmpty(maxColumnNums).mapIndexed { i, value ->
          when (rowIndex) {
            1 -> "-".repeat(columnWidths[i])
            else -> "%-${columnWidths[i].minus(countWideWord(value))}s".format(value)
          }
        }
    }.joinToString("\n") { row -> "| ${row.joinToString(" | ")} |" }
}

fun getRangeAsTable(doc: OwlDocument): TextRange {
    val startTableLine = (doc.currentLine downTo 0)
        .find { doc.getTextByLine(it).isEmpty() }?.plus(1) ?: 0
    val endTableLine = (doc.currentLine..doc.lastLine)
        .find { doc.getTextByLine(it).isEmpty() }?.minus(1) ?: doc.lastLine

    return TextRange(doc.getLineStartOffset(startTableLine), doc.getLineEndOffset(endTableLine))
}

class FormatTableAction : AnAction() {
    override fun update(e: AnActionEvent) {
        e.presentation.isEnabledAndVisible = e.project != null && e.getData(CommonDataKeys.EDITOR) != null
    }

    override fun actionPerformed(e: AnActionEvent) {
        val doc = OwlDocument(e)

        val tableRange = getRangeAsTable(doc)
        doc.safeReplace(tableRange, formatTable(doc.getTextByRange(tableRange)))
    }
}
```

{{</file>}}

現在のカーソル位置からフォーマットするテーブル範囲を自動判別するようにしています。  
`getRangeAsTable`の部分です。

### OwlDocument.kt

`document`や`editor`の操作をWrapするため、`OwlDocument`というクラスを作りました。  
`com.intellij.util.DocumentUtil`も便利ですが、それだけでは足りないと感じたので。

{{<file ".../domain/OwlDocument">}}

```kotlin
package net.mamansoft.markowl.domain

import com.intellij.openapi.actionSystem.AnActionEvent
import com.intellij.openapi.actionSystem.CommonDataKeys
import com.intellij.openapi.command.WriteCommandAction
import com.intellij.openapi.editor.Caret
import com.intellij.openapi.editor.Document
import com.intellij.openapi.editor.Editor
import com.intellij.openapi.project.Project
import com.intellij.openapi.util.TextRange
import com.intellij.util.DocumentUtil


class OwlDocument constructor(e: AnActionEvent) {
    private val project: Project = e.getRequiredData(CommonDataKeys.PROJECT)
    private val editor: Editor = e.getRequiredData(CommonDataKeys.EDITOR)
    private val document: Document = editor.document

    val currentCaret: Caret
        get() = this.editor.caretModel.currentCaret
    val lastLine: Int
        get() = this.document.lineCount - 1
    val lastLineOffset: Int
        get() = DocumentUtil.getLineTextRange(this.document, this.lastLine).endOffset
    val currentLine: Int
        get() = this.currentCaret.selectionEndPosition.line
    val isLastLine: Boolean
        get() = this.currentLine == this.lastLine
    val currentLineText: String
        get() = getTextByLine(this.currentLine)
    val currentLineEndOffset: Int
        get() = DocumentUtil.getLineEndOffset(this.currentCaret.selectionEnd, this.editor.document)
    val nextLineOffset: Int
        get() = this.currentLineEndOffset.plus(1)
    val nextLineRange: TextRange
        get() =  DocumentUtil.getLineTextRange(this.document, this.currentLine + 1)
    val nextLineText: String?
        get() = if (this.isLastLine) null else this.getTextByRange(this.nextLineRange)


    fun getTextByRange(range: TextRange): String = this.document.getText(range)
    fun getTextByLine(line: Int): String = this.document.getText(DocumentUtil.getLineTextRange(this.document, line))
    fun getLineStartOffset(line: Int): Int = this.document.getLineStartOffset(line)
    fun getLineEndOffset(line: Int): Int = this.document.getLineEndOffset(line)

    fun safeReplace(range: TextRange, text: String) {
        WriteCommandAction.runWriteCommandAction(this.project) {
            this.editor.document.replaceString(range.startOffset, range.endOffset, text)
        }
    }

    fun safeReplaceToNextLine(text: String) = this.safeReplace(nextLineRange, text)

    fun safeInsertToNextLine(text: String) {
        WriteCommandAction.runWriteCommandAction(this.project) {
            this.editor.document.insertString(currentLineEndOffset, "\n${text}")
        }
    }

    fun moveEOF() {
        this.currentCaret.moveToOffset(this.lastLineOffset)
    }
}
```

{{</file>}}

### StringUtil.kt

Markowlでは全角文字と半角文字の幅を考慮してフォーマットすることに拘っています。  
その計算を`StringUtil.kt`で行っています。

{{<file "StringUtil.kt">}}

```kotlin
package net.mamansoft.markowl.util

// Shift_JIS: 0x0 ～ 0x80, 0xa0 , 0xa1 ～ 0xdf , 0xfd ～ 0xff
// Unicode : 0x0 ～ 0x80, 0xf8f0, 0xff61 ～ 0xff9f, 0xf8f1 ～ 0xf8f3
fun width(codePoint: Int): Int = when (codePoint) {
    0xf8f0 -> 1
    in 0x0..0x81 -> 1
    in 0xff61..0xffa0 -> 1
    in 0xf8f1..0xf8f4 -> 1
    else -> 2
}

fun width(ch: Char): Int = width(ch.toInt())
fun width(str: String): Int = str.sumBy(::width)
fun countWideWord(str: String): Int = str.count { width(it) == 2 }
```

{{</file>}}


バージョン管理する
------------------

JetBrainsの従業員が提供している最近のプラグインを参考にしました。

{{<summary "https://github.com/AlexPl292/IdeaVim-EasyMotion">}}

管理対象に加えたのは以下です。

```
gradle
  wrapper
    gradle-wrapper.jar
    gradle-wrapper.properties
src
  << 配下すべて >>
build.gradle
gradle.properties
gradlew
gradlew.bat
settings.gradle
```


互換性を定義する
----------------

デフォルトの設定では`build.gradle`に記載された`intellij.version`以外のプラットフォームで動作しません。  
以下の記述をした場合 `2020.1.*`バージョン以外ではインストールできなくなります。

```
intellij {
    version '2020.1'
}
```

これを解決するため2つの設定が必要です。

### 対応バージョンのアップデートオプションを無効にする

`build.gradle`の`updateSinceUntilBuild`オプションに`false`を指定します。

```diff
  intellij {
      version '2020.1'
+     updateSinceUntilBuild false
  }
```

デフォルトは`true`となっており、雑に言うと`intellij.version`のバージョンが採用されます。  
これがバージョン`2020.2`以降や`2020.1`より前のIDEAでインストールできない理由です。

`updateSinceUntilBuild`が`true`の場合の正確な仕様はドキュメントをご覧ください。

{{<summary "https://github.com/JetBrains/gradle-intellij-plugin/blob/master/README.md#building-properties">}}

### 対応バージョンの下限を設定する

`plugin.xml`で`idea-version`を指定します。

```xml
  <idea-version since-build="191"/>
```

上記は **`2019.1`以上のプラットフォームであれば対応する** という設定です。  
`since-build`に指定できるプラットフォームバージョンの関連はドキュメントをご覧ください。

{{<summary "https://jetbrains.org/intellij/sdk/docs/basics/getting_started/build_number_ranges.html">}}



プラグインをインストールする
----------------------------

開発用インスタンスではなく、普段使っているIntelliJ IDEAにインストールしてみます。

{{<summary "https://pleiades.io/intellij/sdk/docs/tutorials/build_system/deployment.html">}}

### バージョンと変更内容の記載

インストールの前にバージョンと変更点(Change Notes)を記載しましょう。  
`build.gradle`の以下を変更します。

| 項目                                   | 意味       |
| -------------------------------------- | ---------- |
| version                                | バージョン |
| patchPluginXml.changeNotes             | 変更点     |

以下は0.4.1リリース時に記載した`build.gradle`の内容です。

```
group 'net.mamansoft'
version '0.4.1'
//
//.. 中略
//
patchPluginXml {
    changeNotes """
      <ul>
        <li>[bug] DrawH1/2LineAction is not working in last line</li>
      </ul>
    """
}
```

### ディストリビューションの作成

配布可能な形でビルドします。

gradleの`buildPlugin`コマンドを実行します。  
成功すると`build/distributions`配下にバージョン付きのzipファイルが成果物としてできます。

```
├─build
│  ├─distributions
│  │  └─markowl-0.1.zip
│  │
```

### インストール

作成したディストリビューションをインストールします。  
以下からローカルファイル経由のインストールが可能です。

{{<himg "resources/ce2698f9.png">}}


プラグインを配布する
--------------------

せっかく作ったので配布してみましょう。

### JetBrains Plugins Repositoryのアカウントを作成

右上の`Sign in`で遷移した画面から作成します。  
既に持っている場合はそのままLog inします。

{{<summary "https://plugins.jetbrains.com/">}}

### プラグインをアップロードする

右上の名前が表示されている箇所をクリックして`Upload plugin`を選択します。

必要な項目を記入し、先ほど作成したzipをアップロードしましょう。

{{<himg "resources/e4331a97.png">}}

提示されたURLを確認します。

https://plugins.jetbrains.com/plugin/14116-markowl/

> Thank you! The plugin has been submitted for moderation. The request will be processed within two business days.

JetBrainsの承認が下りてから公開されます。

### 各ファイルの設定がどこに反映されるか

設定ファイルも多く、プラグイン情報もIDE内とMarket placeに分散しています。
整理するため、1枚のスライドにまとめてみました。

{{<himg "resources/ef3b023a.png">}}

枠線のない部分はWebの`Edit plugin`から設定します。

{{<warn "patchPluginXmlには注意してください">}}
記載するのは最新リリースに対する内容だけです。

過去の履歴はVersion Historyページから閲覧できます。

{{<himg "resources/2454c583.png">}}
{{</warn>}}


気になっていること
------------------

プラグインのディストリビューションファイル(zipファイル)を作成すると、必ず以下のエラーが表示されます。。  
成果物に問題ないため無視していますが気になりますね..:sweat:

```
2020-04-12 19:24:59,303 [  30128]  ERROR - tellij.openapi.util.ObjectTree - Already shutdown 
java.util.concurrent.RejectedExecutionException: Already shutdown
	at com.intellij.util.concurrency.BoundedTaskExecutor.execute(BoundedTaskExecutor.java:133)
```


総括
----

IntelliJ IDEAで快適なMarkdownライフを送るため、Kotlinでプラグインを作成してみました。

知らないと抵抗を感じますが、一度理解してしまえばかなり楽になると思います。  
Kotlin未経験者がいきなりチャレンジしても実用的なモノが作れました:+1:

Markowlは今後も新機能を搭載していく予定です。  
GitHubやTwitter、Reviewなどでフィードバックお待ちしております:pray:

{{<summary "https://plugins.jetbrains.com/plugin/14116-markowl">}}

{{<summary "https://github.com/tadashi-aikawa/markowl">}}

