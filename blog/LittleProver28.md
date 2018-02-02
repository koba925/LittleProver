# 定理証明手習い (28) 補助定理

> `(ctx? x)`という前提が真の場合、その`if`のAnswer部にある`(ctx? x)`を`'t`に置き換えられるでしょうか？

む
これは以前行きづまった
`(if (equal x '()) 't 'nil)`を`(equal x '())`に変形する
にちょっと似てる？

> 置き換えてよいのではないでしょうか。真である前提はすべて`'t`に置き換えられるべきだと思うのですが、そうではないんですか？

ぱっと見そう思うよねー

> `if`は全域関数だから、そうとも限らないのです。Question部が`'t`や`'nil`以外の値になることもありえるでしょう。

そうそこ

> 「`(ctx? x)`が真なら、`(ctx? x)`は`'t`に等しい」という新しい主張を作りましょう。

ほうほう
そういう手があるか
テキストでは証明が後回しになってますがここで証明してしまおうかな

試しにテキスト見ずにできるかどうかやってみよう
これは`ctx?`がスター型だから`star-induction`でいいんだろうな

ところでリスト型の再帰関数とスター型の再帰関数の両方を使ってる
定理はどうしたらいいんでしょうね
いやその前にリスト型の再帰関数をふたつ使ってる関数でも
`list-induction`でいいのか、って話もあるな

でもここは話を戻して

```
(if (atom x)
  (if (ctx? x) (equal (ctx? x) 't) 't)
  (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (ctx? x) (equal (ctx? x) 't) 't)
      't)
    't))
```

からスタート

まず手頃そうな`(atom x)`な場合をとっかかりにしてみますか
そのままではどうしようもないので、まずはA部の`(ctx? x)`を開いてみよう

```
(if (atom x)
  (if (if (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x))))
    (equal (if (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))) 't)
    't)
  :
```

`(atom x)`で`if-nest`が使える

```
(if (atom x)
  (if (equal x '?) (equal (equal x '?) 't) 't)
  :
```

`(A A 1 1)`の`x`を`?`に書き換えてやる

```
(if (atom x)
  (if (equal x '?) (equal (equal '? '?) 't) 't)
  :
```

あとは単純に

```
(if (atom x)
  't
  (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (ctx? x) (equal (ctx? x) 't) 't)
      't)
    't))
```

よしよし半分（？）終わった
いい感じ
このままいけるかな？

> 洞察：帰納法のための前提には手をつけるな

スター型の前提は`car`に関する前提と`cdr`に関する前提の両方がありますね
`(if (ctx? x) (equal (ctx? x) 't) 't)`をうまく変形して
`car`や`cdr`の形を導き出せればいいんだな

まずは`(E A A)`の`(ctx? x)`を開いてと

```
(if (atom x)
  't
  (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (if (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x))))
        (equal (if (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))) 't)
  :
```

また`(atom x)`で`if-nest`が使える

```
(if (atom x)
  't
  (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (if (ctx? (car x)) 't (ctx? (cdr x)))
        (equal (if (ctx? (car x)) 't (ctx? (cdr x))) 't)
        't)
      't)
    't))
```

さてどうしよう
`(if (ctx? (car x)) ...)`が入れ子になってるように見えるけど
`if`のQ部に入ってるからこれで`if-nest`は無理だよな

`(E A A)`で`(if (ctx? (car x))`を持ち上げてやろう

```
(if (atom x)
  't
  (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (ctx? (car x))
        (if 't (equal 't 't) 't)
        (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
      't)
    't))
```

お、これは
`(if 't (equal 't 't) 't)`は`'t`だし
`(if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))`は前提とそっくり
いや、そっくりだけどどうしたらいいんだ？
`if-nest`が使える形じゃないし・・・

これは前提が`if`になってて使いにくいんだよな
ここは前提に手を付ける
手を付ける気になればA部全体で`(if (ctx? (car x)) ...)`の持ち上げができる
そうすると`(if (equal (ctx? (car x)) 't) ...)`って形になるから
使いやすい前提になるはず

持ち上げて

```
(if (atom x)
  't
  (if (ctx? (car x))
    (if (equal (ctx? (car x)) 't)
      (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't) 't 't)
      't)
    (if 't
      (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
        (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
        't)
      't)))
```

整理

```
(if (atom x)
  't
  (if (ctx? (car x))
    't
    (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
      't)))
```

`(ctx? (cdr x))`でも持ち上げ

```
(if (atom x)
  't
  (if (ctx? (car x))
    't
    (if (ctx? (cdr x))
      (if (equal (ctx? (cdr x)) 't) (equal (ctx? (cdr x)) 't) 't)
      (if 't 't 't))))
```

`equal-if`で`(ctx? (cdr x))`を`'t`に置き換え

```
(if (atom x)
  't
  (if (ctx? (car x))
    't
    (if (ctx? (cdr x)) 
      (if (equal (ctx? (cdr x)) 't) (equal 't 't) 't) 
      (if 't 't 't))))
```

できたー

if持ち上げ大活躍
