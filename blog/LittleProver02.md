# 定理証明手習い (2) J-Bobを動かす

> 「自分で動かしながら楽しみたい」という読者のために、J-Bobという簡素な定理証明支援系を
> 用意してあります。

必須じゃないという書き方ですね
でもせっかくですから動かしてみたい

まずはThe Little Proverのページ http://the-little-prover.org にアクセスしてみます
J-Bobは GitHub https://github.com/the-little-prover/j-bob からダウンロードできます
SchemeやRacketでも動くって書いてありますね
よかったよかった
Racketで動かすにはDracuraっていうパッケージがいるのかな
でもSchemeで動くならそれでよさそうな気もするけど

J-Bobのページを見てみると、Scheme版をRacketで動かす方法と
Dracuraを使ってRacketで動かす方法とが書いてあります
どっちでやってみるかな

まずはDracura http://dracula-lang.github.io から見てみよう
DracuraはACL2のためのプログラミング環境です、か
なるほど
DrRacketとACLをくっつけてぐちゃっとするとDraculaになりそうだな
uが足りないか
DrRacketは入ってるから、まずACL2を動かさないと
なかなか大変だな

ACL2 http://www.cs.utexas.edu/users/moore/acl2/ からたどっていくと
Mac OS Xにはpre-built binary distributionがあるらしい
さらにACL2 SedanっていうバイナリやドキュメントやEclipseベースの開発環境が
全部入りのがあるって書いてあるな
別にRacketにこだわらなきゃこれ入れとけば済むのかな
でも今ネット環境がなくてiPhoneのテザリングでJDKとEclipse落とすのはちょっとつらい

・・・
考えるのに疲れてScheme版の方を試すことに

以下、LittleProverフォルダを使うことにします

1. GitHubからj-bobをダウンロード
1. schemeフォルダをj-bobという名前でLittleProverフォルダに保存
1. DrRacketのLanguageメニューからChoose Languageを選択
1. Other Languages、R5RSを選択
1. Show Detailsを選択してDisallow redefinition of initial bindingsのチェックを外す
1. FileメニューのNewで新規ファイルを作成し、test.scmという名前でLittleProverフォルダに保存

で以下のコードを入力してやればいけそう

```
(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")
```

意味はわかりませんがちょっと先回りしてテスト

```
> (defun chapter1.example1 ()
  (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))
      (() (car '(ham eggs))))))
> (chapter1.example1)
'ham
```

どうやら使えるようになったみたいです
今はACL2を使いたいってわけではないのでこれでいいかな