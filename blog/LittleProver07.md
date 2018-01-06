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

# 定理証明手習い (9) J-Bob/prove

「3 名前に何が？」では関数定義と証明が出てきます

関数はその定義で置き換えることができます（Defunの法則）
Dethmの法則と似てるところもありますがここでは「再帰的でない」関数が対象です
定理はそもそも再帰できないという約束でした
再帰的な関数はどうするんでしょうか

そして証明
まだ証明されていない定理を主張といいます
主張を証明するには、主張の式の置き換えを繰り返して`'t`になることを示します

証明は`J-Bob/prove`の中で行います
証明で使う関数は`J-Bob/prove`の中で定義しないと使えない模様
トップレベルで定義した関数を`J-Bob/prove`の中から呼ぶことはできないようです
トップレベルで定義したからと言って二重定義のエラーになったりはしないので
作った関数をちょっとREPLで動かしてみたいみたいなときは
両方に定義を書くことになるのかな

```
(J-Bob/prove (my/prelude)
  '(((defun pair (x y)
       (cons x (cons y '())))
     nil)))
```

`nil`は「種」だそうですが詳細な説明は後で出てくるようです

```
(J-Bob/prove (<公理・定義済みの関数／定理>)
  '((<関数・定理の定義>
     <種>
     <証明>)
     ...))
```

となります
証明は`J-Bob/step`と同様に書いて、`'t`になるまで変形します

上の例では証明はありませんが実行すると`'t`になります
なぜかというと

> 与えられている`defun`が再帰的ではないので、全域性が自明であるために
> 証明案件は`'t`であり、それが成功するから

だそうですがちょっとちんぷんかんぷんです
定理は`'t`になることを証明する、関数は全域であることを証明する、ってことでしょうか
きっともうちょっと進めばわかるようになるんではないかと

# 定理証明手習い (10) J-Bob/define

証明できた関数や定理は`J-Bob/define`を使って他の証明で使いまわせるようにできます

`J-Bob/define`の書き方は`J-Bob/prove`とほとんど同じ感じ

```
(J-Bob/define (<公理・定義済みの関数／定理>)
  '((<関数・定理の定義>
     <種>
     <証明>)
     ...))
```

実例

```
> (J-Bob/define (my/prelude)
    '(((defun pair (x y)
         (cons x (cons y '())))
       nil)))
((dethm atom/cons (x y) (equal (atom (cons x y)) 'nil))
  :
 (dethm if-nest-e (x y z) (if x 't (equal (if x y z) z)))
 (defun pair (x y) (cons x (cons y '()))))
```

値は公理や関数・定理のリストになってます
証明済みかどうかのチェックして、リストの末尾に定義をくっつける、ということを
やってるようですね

で、`J-Bob/define`が返してきたリストに名前をつけてやることにより使いまわします

```
(defun defun.pair () ; 名前をつける
  (J-Bob/define (my/prelude)
    '(((defun pair (x y)
         (cons x (cons y '())))
       nil))))

(defun defun.first-of ()
  (J-Bob/define (defun.pair) ; ここで使いまわしてる
    '(((defun first-of (x)
         (car x))
       nil))))
```

付録Bで１章２章の例をわざわざ関数の形で書いてたのは
こういう書き方にあわせたのかも？

付録Aではいくつかの関数や定理をまとめて定義してますが
付録Bでは関数や定理をひとつずつ定義していきます
この違いはなんなんでしょうか
分けておけば必要な部分だけ使える、ていっても分けて使う場面は出てくるんでしょうか

# 定理証明手習い (10) J-Bob/defineのテスト

J-Bob/defineで定義を使いまわせるようにしましたがテストはどうするかな
こうかな

```
(my/test
 "defun.pair"
 (defun.pair)
 (append (my/prelude)
         (list '(defun pair (x y)
                  (cons x (cons y '()))))))
```

でもこれだと証明が長いときは見づらそう
証明が間違ってると追加されないようだから、追加されたたことだけ確認すればいいか
内部構造に依存してるのは嫌だけどすっきりはする

```
(define (last l)
  (cond ((null? (cdr l)) (car l))
        (else (last (cdr l)))))

(define (last-name l)
  (cadr (last l)))

(my/test
 "defun.pair"
 (last-name (defun.pair))
'pair)
```

このパターンはたくさん出てきそう
でこんな感じに書ければいいんだよなーと思ったんですが

```
(define (right-of str c)
  (list->string (cdr (memq c (string->list str)))))

(define (name-part sym)
  (string->symbol (right-of (symbol->string sym) #\.)))

(define-syntax my/test/define
  (syntax-rules ()
    ((_ name)
     (my/test
      (symbol->string name)
      (last-name (name))
      (name-part name)))))
```

`defun.pair`はシンボルじゃなくて関数なのでうまくいきません
関数とシンボルは違うのか わかってなかった
関数の名前をシンボルか文字列で取得できればいいんだけど・・・

ということで最初からシンボルで渡して、強引に`eval`してやってます
`eval`を使うほどのことではないような何か忘れてるような
教えてえらい人

```
(define-syntax my/test/define
  (syntax-rules ()
    ((_ name)
     (my/test
      (symbol->string name)
      (last-name ((eval name (interaction-environment))))
      (name-part name)))))
```

まあ一応使えることは使えるので進みます

# 定理証明手習い (10) Jabberwockyリベンジ

関数や定理を定義する書き方がわかったので、これで`jabberwocky`も
まっとうに定義できるようになったはず
（`jabberwocky`は再帰的な関数じゃないから）

まずは`jabberwocky`を定義
関数は、`jabberwocky`がちゃんと定理になるよう定義

```
(defun dethm.jabberwocky ()
  (J-Bob/define (my/prelude)
    '(((defun brillig (x) 't)
       nil)
      ((defun slithy (x) 't)
       nil)
      ((defun uffish (x) 't)
       nil)
      ((defun mimsy (x) 'borogove)
       nil)
      ((defun mome (x) 'rath)
       nil)
      ((defun frumious (x) 'bandersnatch)
       nil)
      ((defun frabjous (x) 'beamish)
       nil)
      ((dethm jabberwocky (x)
         (if (brillig x)
             (if (slithy x)
                 (equal (mimsy x) 'borogove)
                 (equal (mome x) 'rath))
             (if (uffish x)
                 (equal (frumious x) 'bandersnatch)
                 (equal (frabjous x) 'beamish))))
       nil
       ((Q) (brillig x))
       (() (if-true
            (if (slithy x)
                (equal (mimsy x) 'borogove)
                (equal (mome x) 'rath))
            (if (uffish x)
                (equal (frumious x) 'bandersnatch)
                (equal (frabjous x) 'beamish))))
       ((Q) (slithy x))
       (() (if-true
            (equal (mimsy x) 'borogove)
            (equal (mome x) 'rath)))
       ((1) (mimsy x))
       (() (equal-same 'borogove))))))
```

では実行 ※結果のインデントは手で修正

```
> (J-Bob/step (dethm.jabberwocky)
    '(cons 'gyre
           (if (uffish '(callooh callay))
               (cons 'gimble
                     (if (brillig '(callooh callay))
                         (cons 'borogove '(outgrabe))
                         (cons 'bandersnatch '(wabe))))
               (cons (frabjous '(callooh callay)) '(vorpal))))
    '(((2 A 2 E 1) (jabberwocky '(callooh callay)))))
(cons 'gyre
      (if (uffish '(callooh callay))
          (cons 'gimble
                (if (brillig '(callooh callay)) 
                    (cons 'borogove '(outgrabe)) 
                    (cons (frumious '(callooh callay)) '(wabe))))
          (cons (frabjous '(callooh callay)) '(vorpal))))
```

できた

