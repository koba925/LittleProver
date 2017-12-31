# 定理証明手習い (3) 「1.いつものゲームに新しいルールを」

> 『Scheme手習い』を読んだことは？
> `'nil`

`#t`ですよ！

* ある式に等しい式は無数にあるが、値はひとつしかない
* 変数の値が決まってなくても式の値が決まることがある
* 注目する部分を「フォーカス」、その外側を「文脈」と呼ぶ

フォーカスを、それに等しい式で置き換えていくことにより値を求める、というのを
練習していきます

Little Schemerではこんな感じで考えてましたが

```
  (length '(a b))
= (add1 (length '(b)))
= (add1 (add1 (length '())))
= (add1 (add1 0))
= (add1 1)
= 2
```

Little Proverではこんな感じ

```
  (equal 'flapjack (atom (cons a b)))
= (equal 'flapjack 'nil)
= 'nil
```

何が違うかというと
Little Schemerでは仮引数に値を入れることからスタート
Little Proverでは仮引数に値を入れないでスタート
してるってことですかね

だから仮引数の値にかかわらず等しくなるような式で置き換えなければならない、と

* 真(`'t`)であると想定した基本的な仮定を公理という
* 常に真となる式を定理という
* 定理には証明が必要

さっきの式変形も実は公理に基づいていて使った公理は以下のように書きます

```
(dethm atom/cons (x y)
  (equal (atom (cons x y)) 'nil))
```

この公理で`(atom (cons a b))`を`'nil`に書き換えてるわけですね
書き換えていいよ、っていうのがDethmの法則

`(equal 'nil 'nil)`を`'t`にするのは単に関数適用？
引数が確定してれば公理じゃなくて普通に関数として評価すればいいのかな？
違うな
これも公理でした

```
(dethm equal-same(x)
  (equal (equal x x) 't))
```

なお、この`equal`は`(atom (cons x y))`を`'nil`が等しいことを言っているので
`(atom (cons x y))`を`'nil`に書き換えるだけでなく
`'nil`を`(atom (cons x y))`に書き換えるのに使うこともできます
わかりませんが意外な使いみちがあるかもしれません
これも公理

> J-Bobは、ある式を別の式に書き換えるのを手助けしてくれるプログラムです。

以下次号

# 定理証明手習い (4) ●

> J-Bobは、ある式を別の式に書き換えるのを手助けしてくれるプログラムです。

「A 放課後」でJ-Bobの使い方が紹介されています
章の内容に沿って書かれているのでとりあえず言われるまま入れてみます

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '())
(car (cons 'ham '(eggs)))
```

値の表示にクォートがついてませんがこれはRacketの特性かも
いやこの本の記法かな？
気にしない

そうそう
デフォルトだとインデントが上のようにならないので
PreferenceのIndentタブでLambda-like Keywordsのところに
J-Bob/stepを追加してみました
とりあえずうまくいってるみたいです
ここの設定はいまひとつよくわかってませんが

つぎはこれ

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '((() (car/cons 'ham '(eggs)))))
'ham
```

何やら`(car (cons 'ham '(eggs)))`に`car/cons`の公理を適用すると`ham`になる、
てことみたいですね
`car/cons`の公理を適用する、ってところは自分で考えるのかな？
定理証明支援系とか書いてあったけど間違いがないか確かめるくらい？
適用できる公理の候補を探してくれるとかちょっと期待してましたが

試しに間違えてみよう

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '((() (car/cons 'ham '(cheese)))))
(car (cons 'ham '(eggs)))
```

間違いですよって言ってくれるわけではなくて置き換えが起こらないだけか
地味というかシンプルというか
Unixぽい？別にそういうわけじゃないのかな

これでいうと

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))
      (() (atom '()))))
't
```

まずここから始めて

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '())
(atom (cdr (cons (car (cons p q)) '())))
```

えーとひとつめの引数のひとつめの引数のひとつめの引数に
`car/cons`の公理を適用するんだな、と考えて

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))))
(atom (cdr (cons p '())))
```

おー置き換わった置き換わった、とやるわけですね
引き続きこうやって試していく、と

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))))
(atom '())
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))
      (() (atom '()))))
't
```

なかなかタフですね
もうちょっとやさしいUIとかほしくなる感じ

ところで`(atom '())`っていうのは公理じゃないですね
やっぱり普通の関数適用もあるのか

「A 放課後」はまだ続きますが第1章の内容はここまで

# 定理証明手習い (5) ●

さらに「B デザートには証明を」には出てきた式が全部J-Bobで書いてあります
こんな感じ

```
(defun chapter1.example1 ()
  (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))
      (() (car '(ham eggs))))))
```

関数として定義されてるので実行してやらないと何も起こりません

```
> (chapter1.example1)
'ham
```

うむ
これだけだと暗算が必要
慣れるまでは順を追ってやってみるのがいいかなあ

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '())
(car (cons 'ham '(eggs)))
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))))
(car '(ham eggs))
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))
      (() (car '(ham eggs)))))
'ham
```

いちいち関数を実行してやるのも面倒だし
コピペも簡単だからコメントでいいや

```
; chapter1.example1
(J-Bob/step (prelude)
  '(car (cons 'ham '(eggs)))
  '(((1) (cons 'ham '(eggs)))
    (() (car '(ham eggs))))))
```

Racketだったらrackunitで書くという手もあったかな
r5rs用のユニットテストフレームワークもあるだろうけど探して覚えるのも面倒だし

ずらずら書いていってみよう

# 定理証明手習い (6) 公理も自分で

ところで

> `prelude`は、J-Bobの公理および最初に用意されている関数の集まりです。

公理も自分で書いてみたい
最初に公理が必要になるのはこれ

```
; chapter1.example3
(J-Bob/step (prelude)
  '(atom (cons a b))
  '((() (atom/cons a b))))
```

j-bob.scmをチラ見して、からっぽのpreludeを作ってみる

```
(defun my/axioms ()
  '())

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))
```

この`my/prelude`を使って実行してみる

```
> (J-Bob/step (my/prelude)
    '(atom (cons a b))
    '((() (atom/cons a b))))
(atom (cons a b))
```

書き換えは起こらない
ていうか`atom/cons`なんてねーよ、っていうエラーになるかと思ったけどそこはハズレ

ここで`my/axioms`を書き換え

```
(defun my/axioms ()
  '((dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))))
```

実行

```
> (J-Bob/step (my/prelude)
    '(atom (cons a b))
    '((() (atom/cons a b))))
'nil
```

できた

(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

; Consの公理（最初のバージョン）

(defun my/axioms ()
  '((dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))))

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))

; chapter1.example1
(J-Bob/step (my/prelude)
  '(car (cons 'ham '(eggs)))
  '(((1) (cons 'ham '(eggs)))
    (() (car '(ham eggs)))))
; -> 'ham

; chapter1.example2
(J-Bob/step (my/prelude)
  '(atom '())
  '((() (atom '()))))
; -> 't

; chapter1.example3
(J-Bob/step (my/prelude)
  '(atom (cons a b))
  '((() (atom/cons a b))))
; -> 'nil
