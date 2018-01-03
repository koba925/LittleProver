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
それ以外に方法を思いつかなかったので

```
(define my/test/passed 0)
(define my/test/failed 0)

(define-syntax my/test
  (syntax-rules ()
    ((_ name actual expected)
     (let ((act actual))
       (if (equal (quote expected) actual)
           (set! my/test/passed (+ my/test/passed 1))
           (begin
             (display name)
             (display " actual:")
             (display act)
             (display " expected:")
             (display (quote expected))
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
(Scheme使うたびに思ってる気がする)

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
chapter1.example3 actual:'t expected:'nil
Test passed:2 failed:1 total:3
```

十分
新しい例が出たら最初はこんな風に追加しておいて

```
(my/test
 "chapter1.example6"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '())
 't)
```

実行

```
chapter1.example6 actual:(atom (cdr (cons (car (cons p q)) '()))) expected:'t
Test passed:5 failed:1 total:6
```

ここからひとつずつ置き換えを追加していって、テストが通ったら付録Bを見て答え合わせ
パターンできた感じ

# 定理証明手習い (7) ●

1章のラスト近く
こうやっていくらでも式をでっちあげられるから定理の自動証明は難しいんだ、
っていうアピールですかね？

```
(my/test
 "chapter1.example11"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (car (cons (cdr x) (car y))) '(oats)))
     ((2 2 2) (atom/cons (atom (cdr (cons a b))) (equal (cons a b) c)))
     ((2 2 2 1 1 1) (cdr/cons a b))
     ((2 2 2 1 2) (equal-swap (cons a b) c))))
 (cons y (equal (car (cons (car (cons (cdr x) (car y))) '(oats)))
                (equal (atom x)
                       (atom (cons (atom b) (equal c (cons a b))))))))
```

しかしちょっとこれはつらい

なにかもうちょっと楽ができるUIがほしい感じ
でもどうなったら楽なのかちょっとわからない
せめて途中経過の表示だけでも
あとここにマッチしようとしてるけどしなかったとか
せめてせめてエラーチェックだけでも
公理の名前が間違ってたり各ステップを囲むカッコが抜けてたりしても
何も言わないので悩むことがたびたび

と思ってj-bob.scmを見てみましたがちょっとすぐにはどこをいじっていいものか

きっと普通にやるぶんにはもうちょっと楽だと信じて進みます

あと、expectedをクォートしなくていいようにわざわざマクロ使って書いたテストですが
actualの式にクォートがついてるのにexpectedについてないというのは逆に不自然な気がして
やっぱりクォートを付けて書くことにしました
それにともなってテストは普通の関数で書けるように

```
(define (my/test name actual expected)
  (if (equal expected actual)
      (set! my/test/passed (+ my/test/passed 1))
      (begin
        (display name)
        (display "\nactual  :")
        (display actual)
        (display "\nexpected:")
        (display expected)
        (newline)
        (set! my/test/failed (+ my/test/failed 1)))))
```

# 定理証明手習い (8) 「2 もう少し、いつものゲームを」

「2 もう少し、いつものゲームを」では`if`の公理が出てきます
`if`では数ではなくて`Q`、`A`、`E`で置き換え対象を指定します

* `(if 't x y)`と`x`は等しい (`if-true`)
* `(if 'nil x y)`と`y`は等しい (`if-false`)
* `(if x y y)`と`y`は等しい (`if-same`)

3つめ公理はどうやって使うんでしょうか

```
(dethm if-same (x y)
  (equal (if x y y) y))
```

次はEqualの公理に含められていますがifとも関係あり
日本語にしてしまうと意味が取れなくなってしまうのでそのまま

```
(dethm equal-if (x y)
  (if (equal x y) (equal x y) 't))
```

`'t`ってなんだよ`'t`って、と思いましたがこれはたぶん定理は常に`'t`でないと
いけないので入れてあるってことでしょう

この`equal-if`を適用するためにDethmの公理が更新されてます
文章で読むとわかりづらいですが
`(if X (... (equal Y Y') ...) (... (equal Z Z') ...))`という公理があれば
`(if X (... Y ...) (... Z ...))`を`(if X (... Y' ...) (... Z' ...))`に
置き換えられるということ（一部手抜き）
例をあげて1ステップずつ順番にやってくれますので進めばわかります

> 次の場合、置き換えた結果であるbody(e)を使ってフォーカスの書き換えができる

は「body(e)に含まれる**帰結**を使ってフォーカスの書き換えができる」てことですね
最初ここが飲み込めませんでした

`equal-if`の公理でEqualの公理が完成します
推移律じゃなかったか
でも推移律作れそう
`and`はないからこう・・・

```
  (if (equal x y) (if (equal y z) (equal x z) 't) 't)
= (if (equal x y) (if (equal z y) (equal x z) 't) 't)
= (if (equal x y) (if (equal z y) (equal y y) 't) 't)
= (if (equal x y) (if (equal z y) 't 't) 't)
= (if (equal x y) 't 't)
= 't
```

かな？

```
> (J-Bob/step (my/prelude)
    '(if (equal x y) (if (equal y z) (equal x z) 't) 't)
    '(((A Q) (equal-swap y z))
      ((A A 1) (equal-if x y))
      ((A A 2) (equal-if z y))
      ((A A) (equal-same y))
      ((A) (if-same (equal z y) 't))
      (() (if-same (equal x y) 't))))
't
```

いけた

じゃあ`my/axioms`にこうやって公理を付け加えたら

```    
(defun my/axioms ()
     :
     :
    (dethm equal-trans (x y z)
      (if (equal x y) (if (equal y z) (equal x z) 't) 't))))
```

`(if (equal a b) (if (equal b c) a b) c)`みたいなのを
`(if (equal a b) (if (equal b c) c b) c)`のように置き換えられたりするかな？

```
> (J-Bob/step (my/prelude)
    '(if (equal a b) (if (equal b c) a b) c)
    '(((A A) (equal-trans a b c))))
(if (equal a b) (if (equal b c) c b) c)
```

できた
あてずっぽうでもけっこう動くもんだなと思って`jabberwocky`も動かしてみようと
思いましたが悪戦苦闘のあげくうまくいきませんでした
ちゃんとわかってきたらできるのかな？

なお

> `(equal 'nil 'nil)`を`'t`に置き換えるのに`equal-same`は必要でしょうか？
> そんなことはありません。`'nil`は値なので、関数`equal`の定義がそのまま使えました。

こういう場合は公理で置き換えても、単に関数適用してもどっちでもいいってことですね
疑問氷解しました

Consの公理を追加

* `x`がアトムでなければ、`x`と`(cons (car x) (cdr x))`は等しい  (`cons/car+cdr`)

Ifの公理も追加

* `x`ならば`(if x y z)`と`y`は等しい (`if-nest-A`)
* `x`でなければ`(if x y z)`と`z`は等しい (`if-nest-E`)

`it-true`や`if-false`と意味は似てますが`x`を`'t`や`'nil`に変形しなくても
置き換えられるところが違います

`if-same`なんてどう使うのかと思いましたが
`if-nest-A`や`if-nest-E`と組み合わせるとこんなことができたり

```
  (A (if B C D) (if B E F))
= (if B (A (if B C D) (if B E F)) (A (if B C D) (if B E F)))) [if-same]
= (if B (A C E) (A D F)) [if-nest-A, if-nest-E]
```

式を簡単にするのではなくて式を増やす方向で活躍する模様
奥が深い

これでCons、Ifの公理も完成
本文と付録Aと付録Bをいったりきたりしながら読まないといけないので忙しいです

# 定理証明手習い (9) 「3 名前に何が？」

関数定義が出てきます
関数はその定義で置き換えることができます（Defunの法則）
ただしここでは「再帰的でない」関数が対象になっています
再帰的な関数はどうするんでしょうか

まだ証明されていない定理を主張といいます
主張を証明するには、主張の式の置き換えを繰り返して`'t`になることを示します

# Jabberwocky

悪戦苦闘したけどダメ
しばらく進めてたらちゃんとやれるかも？

```

(defun my/axioms+jw ()
  (append (my/axioms) 
          '((dethm jabberwocky (x)
              (if (brillig x)
                  (if (slithy x)
                      (equal (mimsy x) 'borogove)
                      (equal (mome x) 'rath))
                  (if (uffish x)
                      (equal (frumious x) 'bandersnatch)
                      (equal (frabjous x) 'beamish)))))))

(defun my/prelude+jw ()
  (J-Bob/define (my/axioms+jw)
    '()))

(J-Bob/step (my/prelude+jw)
  '(if (brillig '(callooh callay))
       (if (uffish '(callooh callay))
           't
           (cons 'bandersnatch 't))
       't)
  '(((A E 1) (jabberwocky '(callooh callay)))))

(my/test
 "chapter2.exampleA"
 (J-Bob/step (my/prelude+jw)
   '(cons 'gyre
          (if (uffish '(callooh callay))
              (cons 'gimble
                    (if (brillig '(callooh callay))
                        (cons 'borogove '(outgrabe))
                        (cons 'bandersnatch '(wabe))))
              (cons (frabjous '(callooh callay)) '(vorpal))))
   '(((2 A 2 E 1) (jabberwocky '(callooh callay)))))
 '(cons 'gyre
        (if (uffish '(callooh callay))
            (cons 'gimble
                  (if (brillig '(callooh callay))
                      (cons 'borogove '(outgrabe))
                      (cons '(frumious '(callooh callay)) '(wabe))))
            (cons (frabjous '(callooh callay)) '(vorpal)))))
```

関数を追加してもダメ

```
(define (id x) x)
(define brillig id)
(define slithy id)
(define mimsy id)
(define mome id)
(define uffish id)
(define frumious id)
(define frabjous id)
```

my/axiomsに追加してもダメ

```
    ; 追加
    (dethm jabberwocky (x)
      (if (brillig x)
          (if (slithy x)
              (equal (mimsy x) 'borogove)
              (equal (mome x) 'rath))
          (if (uffish x)
              (equal (frumious x) 'bandersnatch)
              (equal (frabjous x) 'beamish))))
```

そもそも公理として認識されてない模様
当てずっぽうはここまで
