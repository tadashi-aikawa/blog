---
title: IDEAのプラグインを作ってみた
slug: create-intellij-idea-plugin
date: 2020-04-09T21:35:15+09:00
draft: true
thumbnailImage: null
categories:
  - engineering
tags:
  - idea
---

IntelliJ IDEAのプラグインを作ってみました。

<!--more-->

<!--toc-->


はじめに
--------

公式

https://pleiades.io/intellij/sdk/docs/intro/welcome.html

プラグインはここ

https://pleiades.io/intellij/sdk/docs/basics/basics.html


プラグインの種類
----------------

https://pleiades.io/intellij/sdk/docs/basics/types_of_plugins.html

Markdownのテーブルフォーマットはどの種類かは分からない。

`カスタム言語サポート`: Markdownのフォーマットという意味ではこれか?
`ユーザーインターフェースのアドオン`: UIではないから違うかもだけど...


入門
----

https://pleiades.io/intellij/sdk/docs/basics/getting_started.html

Gradleを使った方がいい。

### Gradleでプロジェクトを作る

https://pleiades.io/intellij/sdk/docs/tutorials/build_system/prerequisites.html

ウィザードから

![](.index_images/bd3d80b9.png)

![](.index_images/30308e3a.png)

{{<warn "Gradleが表示されない">}}
Gradle Extensionのプラグインが有効になっているかを確認してください。
{{</warn>}}

プロジェクトが読み込まれたら15分くらい準備が終わるのを待つ (なにしてる?)

Gradleのタスクが表示されるようになったら`intellij/runIde`を実行。

![](.index_images/40c95fed.png)

`plugin.xml`に色々書いておくと、起動したインスタンスのPlugin画面で認識される。

![](.index_images/e9e9a1df.png)

### Actionを作ってみる

https://pleiades.io/intellij/sdk/docs/tutorials/action_system.html

{{<error "Stringにjava.lang.Stringを求められる">}}
jdkが対応しているバージョンか確認してください。jdk11は少なくとも未対応..8は対応してました。
{{</error>}}

`src\main\resources\META-INF\plugin.xml` の `<actions>`を以下のように設定。

```xml
<actions>
    <action id="net.mamansoft.markowl.action.markdown.FormatTableAction"
            class="net.mamansoft.markowl.action.markdown.FormatTableAction" text="Format Markdown Table"
            description="Format markdown table">
        <keyboard-shortcut keymap="$default" first-keystroke="alt SEMICOLON"/>
    </action>
</actions>
```

`src\main\kotlin\net\mamansoft\markowl\action\markdown\FormatTableAction.kt` を作成。

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

Gradleで`runIde`を実行すると開発用のIntelliJ IDEAインスタンスが立ち上がる。  
追加した`Format Markdown Table`があるので実行するとダイアログが表示される。

本当はMarkdownのテーブルフォーマットをしたいけど、まずはここまで。


エディタに関するアクションを作る
----------------------------

https://pleiades.io/intellij/sdk/docs/tutorials/editor_basics.html

### テキストを扱う

https://pleiades.io/intellij/sdk/docs/tutorials/editor_basics/working_with_text.html

`update(e: AnActionEvent)`を実装して、選択範囲が指定されているときのみ処理を実行する。

### 選択範囲を置換する

`actionPerformed(e: AnActionEvent)`を実装する。

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

### 選択範囲のテーブルを整形する

フォーマットする処理を追加しました。  
SJISとUnicodeではワイド文字も考慮しています。

```kotlin
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

fun inverse(rows: List<List<String>>): List<List<String>> {
    val columns = MutableList<MutableList<String>>(rows[0].size) { mutableListOf<String>() }
    for (row in rows) {
        for ((colIndex, cell) in row.withIndex()) {
            columns[colIndex].add(cell)
        }
    }
    return columns
}

fun formatTable(tableStr: String): String {
    val rows = tableStr.split("\n")
        .map { it.trim('|').split('|').map { v -> v.trim() } }
    val columns = inverse(rows)
    val columnWidths = columns.map { it.map(::width).max() ?: 0 }

    return rows.mapIndexed { rowIndex, row ->
        when (rowIndex) {
            1 -> row.mapIndexed { i, _ -> "-".repeat(columnWidths[i]) }
            else -> row.mapIndexed { i, value -> "%-${columnWidths[i].minus(countWideWord(value))}s".format(value) }
        }
    }.joinToString("\n") { row -> "| ${row.joinToString(" | ")} |" }
}
```

この`formatTable`を実行します。

```kotlin
class FormatTableAction : AnAction() {
    override fun update(e: AnActionEvent) {
        val project = e.project
        val editor = e.getData(CommonDataKeys.EDITOR)
        e.presentation.isEnabledAndVisible = (project != null && editor != null && editor.selectionModel.hasSelection())
    }

    override fun actionPerformed(e: AnActionEvent) {
        val editor = e.getRequiredData(CommonDataKeys.EDITOR)
        val project = e.getRequiredData(CommonDataKeys.PROJECT)

        // キャレットから選択範囲のstart/endを取得
        val primaryCaret = editor.caretModel.primaryCaret
        val start = primaryCaret.selectionStart
        val end = primaryCaret.selectionEnd

        // 選択範囲の文字列を取得して整形
        val formattedTable = formatTable(editor.document.getText(TextRange(start, end)))

        // 安全な書き込みを実現するため、WriteCommandAction.runWriteを使う
        WriteCommandAction.runWriteCommandAction(project) { editor.document.replaceString(start, end, formattedTable) }

        // 選択範囲の解除
        primaryCaret.removeSelection()
    }
}
```

バージョン管理する
------------------

JetBrainsが提供している最近のプラグインを参考にします。

https://github.com/AlexPl292/IdeaVim-EasyMotion


プラグインをインストールする
----------------------------

https://pleiades.io/intellij/sdk/docs/tutorials/build_system/deployment.html

### バージョンと変更内容の記載

`build.gradle`の以下を変更します。

| 項目                                   | 意味       |
| -------------------------------------- | ---------- |
| `version`                              | バージョン |
| `patchPluginXml.changeNotes`           | 変更点     |

```
group 'net.mamansoft'
version '0.1'
//
//.. 中略
//
patchPluginXml {
    changeNotes """
      <ul>
        <li>v0.1 (2020-04-12): First release</li>
      </ul>
    """
}
```

### ディストリビューションの作成

配布可能な形でビルドします。

`gradle buildPlugin`を実行します。  
`build/distributions`配下に成果物ができていればOK。

```
├─build
│  ├─distributions
│  │  └─markowl-0.1.zip
│  │
```

### インストール

作成したディストリビューションをインストールします。  
以下からローカルファイル経由のインストールが可能です。

![](.index_images/ce2698f9.png)


プラグインを配布する
--------------------

せっかく作ったので配布してみましょう。

### JetBrains Plugins Repositoryのアカウントを作成

右上の`Sign in`で遷移した画面から作成します。  
既に持っている場合はそのままLog inします。

https://plugins.jetbrains.com/

### プラグインをアップロードする

先ほど`Sign in`となっていた、今は名前が表示されている箇所をクリックして`Upload plugin`を選択します。

必要な項目を記入し、先ほど作成したディストリビューションファイルをアップロードしましょう。

![](.index_images/e4331a97.png)

提示されたURLを確認します。

https://plugins.jetbrains.com/plugin/14116-markowl/

> Thank you! The plugin has been submitted for moderation. The request will be processed within two business days.

どうやら監査されるみたいですね..。  
説明を適当にしてしまったので、アップロードしなくては。。

承認されるまでは検索

### 各ファイルの設定がどこに反映されるか

設定ファイルも多く、プラグイン情報もIDE内とMarket placeに分散しており分かりづらいです。  
1枚のスライドにまとめてみました。

![](.index_images/ef3b023a.png)

`patchPluginXml`には注意してください。  
記載するのは最新リリースに対する内容だけです。

過去の履歴はVersion Historyページから閲覧できます。

![](.index_images/2454c583.png)

枠線のない部分はWebの`Edit plugin`から設定します。


トラブルシューティング
----------------------

### なぜかビルド時にこのエラーが。。

```
2020-04-12 19:24:59,303 [  30128]  ERROR - tellij.openapi.util.ObjectTree - Already shutdown 
java.util.concurrent.RejectedExecutionException: Already shutdown
	at com.intellij.util.concurrency.BoundedTaskExecutor.execute(BoundedTaskExecutor.java:133)
```
