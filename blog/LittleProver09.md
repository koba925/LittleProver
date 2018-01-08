# 定理証明手習い (9) 「2 もう少し、いつものゲームを」

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

`it-true`や`if-false`と意味は似てますが`x`を`'t`や`'nil`に変形することなく
置き換えられます

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
本文と付録Aと付録Bをいったりきたりしながら読むのが忙しい

# 定理証明手習い (10) J-Bob/prove

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

# 定理証明手習い (11) J-Bob/define

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

# 定理証明手習い (12) J-Bob/defineのテスト

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

# 定理証明手習い (13) Jabberwockyリベンジ

> これって本当に定理なんですか？
> たぶん定理ですね。

関数や定理を定義する書き方がわかったので、これで`jabberwocky`も
まっとうに定義できるようになったはず
（`jabberwocky`は再帰的な関数じゃないから）

> `brillig`、`slithy`、`mimsy`、`mome`、`uffish`、`frumious`、`frabjous`が何を意味しているかによりますが。

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

# 定理証明手習い (14) 証明ゴルフ？

この証明がもうちょっと短くできますねと書いてあります

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1 1) (pair a '?))
     ((1) (in-pair? (cons a (cons '? '()))))
     ((1 Q 1) (first-of (cons a (cons '? '())))) ; ここと
     ((1 Q 1) (car/cons a (cons '? '()))) ; ここが不要
     ((1 E 1) (second-of (cons a (cons '? '()))))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal a '?) 't))
     (() (equal-same 't)))))
```

不要な行を削除
式の形が変わるので、下から２行目も変更しました

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1 1) (pair a '?))
     ((1) (in-pair? (cons a (cons '? '()))))
     ((1 E 1) (second-of (cons a (cons '? '()))))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal (first-of (cons a (cons '? '()))) '?) 't))
     (() (equal-same 't)))))
```

その下から２行目、微妙に長い気がします
ここは`cons`に展開されてなくてもいいところ
`pair`の評価をあとに回せば`first-of`の方は展開しなくて済みます

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1) (in-pair? (pair a '?)))
     ((1 E 1) (second-of (pair a '?)))
     ((1 E 1 1 1) (pair a '?))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal (first-of (pair a '?)) '?) 't))
     (() (equal-same 't)))))
```

この方がちょっと気持ちいいかな
これって、関数の評価順を自由に変えてるってことになるわけか

> 洞察：無関係な式は飛ばそう

なるほど

あと`(equal-same '?)`を`(equal '? '?)`に変更すればさらに２文字・・・
これはあんまり意味がないからやめておこう
公理で言えるときは公理で言っておくほうがスジがいいのかな

# 定理証明手習い (15) 型？

「4. これが完全なる朝食」のはじめに

> 関数`list0?`を定義してください。
> 
> ```
> (defun list0? (x)
>   (if (equal x 'oatmeal)
>       'nil
>       (if (equal x '())
>           't
>           (if (equal x '(toast))
>               'nil
>               'nil)))
> ```
> 
> はいはい、やり直しましょうね。
> 
> ```
> (defun list0? (x)
>   (equal x '()))
> ```

ってくだりがあるんですが、これはただのジョークでしょうか
公理を使えば書き換えられるんでしょうか
やってみます

```
  (if (equal x 'oatmeal) 'nil (if (equal x '()) 't (if (equal x '(toast)) 'nil 'nil)))
= (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil))
```

`(if (equal x '()) 't 'nil)`はどう見ても`(equal x '())`なんですが
どうやって変形していいかわかりません
別方面から進めてみます

```
= (if (equal x '())
    (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil))
    (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil)))
= (if (equal x '()) 
    (if (equal x 'oatmeal) 'nil 't) 
    (if (equal x 'oatmeal) 'nil 'nil))
= (if (equal x '()) 
    (if (equal x 'oatmeal) 'nil 't) 
    'nil)
= (if (equal x '()) 
    (if (equal '() 'oatmeal) 'nil 't) 'nil)
= (if (equal x '()) (if 'nil 'nil 't) 'nil)
= (if (equal x '()) 't 'nil)
```

結局残りました

公理とにらめっこしてみましたが簡単にする方向には進みそうにないので
いったん式を増やすんでしょうか

妄想ではこんな風に終わりそうな気がするんですが何かが足りないような

```
= (if (equal x '()) 't 'nil)
= ...
= ...
= (if (equal x '()) (equal x '()) (equal x '()))
= (equal x '())
```

逆算すると`equal-if`でもうちょっといける？

```
= (if (equal x '()) 't 'nil)
= ...
= ...
= (if (equal x '()) (equal '() '()) (equal x '()))
= (if (equal x '()) (equal x '()) (equal x '()))
= (equal x '())
```

`(equal '() '())`は公理でも関数適用でも`'t`に書き換えられるけど
`'t`を`(equal '() '())`に書き換えるっていうのは可能なんでしょうか
今知ってる範囲のJ-Bobでは書きようがない気がします

それにそっちがんばってもElse部がなあ

変形できないのかなあと思っても悪魔の証明みたいな感じですが
考えてみると`(if (equal x '()) 't 'nil)`と`(equal x '())`が
同じであるというためには`(equal x '())`が`'t`と`'nil`しか返さないという
約束が必要ですね
それがなければここで終わり？

そもそもJ-Bobでは`'t`と`'nil`以外の値はどう扱われてるんでしょうか

```
(define (if/nil Q A E)
  (if (equal? Q 'nil) (E) (A)))
(define-syntax if
  (syntax-rules ()
    ((_ Q A E)
     (if/nil Q (lambda () A) (lambda () E)))))
```

`'nil`以外は`'t`扱いのようです

じゃあ`(equal x '())`が`'t`と`'nil`しか返さないっていう公理があれば
`(if (equal x '()) 't 'nil)`を`(equal x '())`に変形できるかな？
・・・
`'t`か`'nil`である＆`'t`ではない、から`'nil`であることが言える？
うーんわからない

そもそも「`'t`と`'nil`しか返さない」ってどうやって書くんだ
それは公理じゃないのか？
型？
型かもしれないな

# 定理証明手習い (16) 全域

* **全域**とは、どんな値を渡しても関数が値を持つということ

この間`pair`は全域、って話が出てました

> 組み込み関数は、すべて全域です。
> そうだったんですか！

そうだったんですか！

Scheme手習いでは

> `l`の`car`は何ですか。
> ここで
> `l`は`'()`です。
> 答えはありません。

って掟になってたけどこれは全域じゃないってことだよな
素のRacket(r5rsにしても)でやるとエラーになります

全域なら`(car 'nil)`の値はなんだろう

```
(define (car x) (if (pair? x) (s.car x) '()))
(define (cdr x) (if (pair? x) (s.cdr x) '()))
```

`'()`か
そういえばCommon Lispでは`(car 'nil)`も`(cdr 'nil)`も`'nil`だったっけ？
Schemeと比べてなんか変だなと思ったけど全域であることを大事にしたってことでしょうか

ってすぐ下見たら書いてありました

> 意外かもしれませんが、そうなのですよ。
> それじゃあ、`(cdr 'grapefruit))`の値は何になるっていうんですか？
> 考慮するのは、コンスしたものに対する`cdr`の結果だけです。`(cdr 'grapefruit)`には何かしら値があるはずですが、それが何であるかを知る必要はなく、値があるということだけわかれば十分なのです。

フーン
理屈上、そんな引数で評価されることはないわけだから何でもいいってことか
実用的な観点からはエラーにしてほしい気がするけど

ここでは、全域というのはいつでも正しい値を返すという意味じゃなくて、
ただいつでも値を返すっていう意味と理解して進みます
組み込み関数も`if`も必ず値を返すのでそれらを組み合わせただけなら
必ず値を返すはず
値を返さないっていうのは無限ループしちゃってるときくらいですかね