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

# 定理証明手習い (7) やっぱりテスト風に

公理を書き換えたりすると今までの結果が全部怪しくなるのでやっぱりテストを書こう
でもフレームワークっていうほどのものじゃないからちょっとだけ自分で書くことに

`my/test`をマクロにしてるのは、`'`を取ったり付けたりするのに
それ以外に方法を思いつかなかったから

```
(define my/test/passed 0)
(define my/test/failed 0)

(define-syntax my/test
  (syntax-rules ()
    ((_ name expected actual)
     (let ((exp expected))
       (if (equal exp (quote actual))
           (set! my/test/passed (+ my/test/passed 1))
           (begin
             (display name)
             (display " expected:")
             (display exp)
             (display " actual:")
             (display (quote actual))
             (newline)
             (set! my/test/failed (+ my/test/failed 1))))))))

(define (my/test/result)
  (display "Test passed:")
  (display my/test/passed)
  (display " failed:")
  (display my/test/failed)
  (display " total:")
  (display (+ my/test/passed my/test/failed))
  (newline))
```

Schemeって`display`並べるしかないんだっけ？
(Schemeで何か書くたびに思ってる気がする)

これでこんな風に書いて

```
(my/test
 "chapter1.example1"
 (J-Bob/step (my/prelude)
   '(car (cons 'ham '(eggs)))
   '(((1) (cons 'ham '(eggs)))
     (() (car '(ham eggs)))))
 'ham)

(my/test
 "chapter1.example2"
 (J-Bob/step (my/prelude)
   '(atom '())
   '((() (atom '()))))
 't)

(my/test
 "chapter1.example3"
 (J-Bob/step (my/prelude)
   '(atom (cons a b))
   '((() (atom/cons a b))))
 't) ; わざと間違えた

(my/test/result)
```

実行するとこんな結果

```
chapter1.example3 expected:'nil actual:'t
Test passed:2 failed:1 total:3
```

十分