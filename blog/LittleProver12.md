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

全域なら`(car '())`の値はなんだろう

```
(define (car x) (if (pair? x) (s.car x) '()))
(define (cdr x) (if (pair? x) (s.cdr x) '()))
```

`'()`か
そういえばCommon Lispでは`(car '())`も`(cdr '()))`も`'()`だったっけ？
Schemeと比べてなんか変だなと思ったけど全域であることを大事にしたってことでしょうか

すぐ下にはこう書いてあります

> 意外かもしれませんが、そうなのですよ。
> それじゃあ、`(cdr 'grapefruit))`の値は何になるっていうんですか？
> 考慮するのは、コンスしたものに対する`cdr`の結果だけです。`(cdr 'grapefruit)`には何かしら値があるはずですが、それが何であるかを知る必要はなく、値があるということだけわかれば十分なのです。

フーン
理屈上、そんな引数で評価されることはないわけだから何でもいいってことかな
実用的な観点からはエラーにしてほしい気がするけど
理論上は全域じゃないと取り扱いが面倒な感じはする

ここでは、全域というのはいつでも正しい値を返すという意味じゃなくて、
ただいつでも値を返すっていう意味と理解して進みます
組み込み関数も`if`も必ず値を返すのでそれらを組み合わせただけなら
必ず値を返すはず
値を返さないっていうのは無限ループしちゃってるときくらいですかね

Defunの法則は更新されて最終バージョンに
再帰的であっても全域であれば置き換えていいことになりました

# 定理証明見習い (16) 部分関数

* 部分関数の置き換えを認めると矛盾が発生する

部分関数の例はこれ

```
(defun partial (x) (if (partial x) 'nil 't))
```

こうじゃないのはなぜか

```
(defun partial (x) (partial x))
```

いちおう値を返しそうな雰囲気はかもし出しておきたい、くらいかな
であれば、こうじゃないのはなぜか

```
(defun partial (x) (if (partial x) 't 'nil))
```

評価してみて返ってくるかどうかで部分関数かどうかを判定するっていう意味合い？
いやちょっと無理があるか

さて`partial`は部分関数なのでこういうの書いても`'t`になることはないでしょうから
証明なしで定義する必要があります

```
(J-Bob/prove (my/prelude)
  '(((defun partial (x)
       (if (partial x) 'nil 't))
     ...
```

この間は無理やり公理のリストに付け足してやりましたが
J-Bobのお作法では`list-extend`というのを使うようです
`list-extend`はそんなに特別な処理をしてるわけではなくて、
項目を追加したリストを返す関数ですが、リスト内にすでに同じ項目がある場合は
何もせず元のリストを返します なるほど
`(J-Bob/prove (my/prelude) ...)`の代わりに
`(J-Bob/prove (list-extend (my/prelude) A) ...)`としてやれば
一時的に`my/prelude`に定義Aを付け加えて証明を記述することができます

いまさら気が付きましたが`(J-Bob/define (prelude) ...)`の
`prelude`を囲んでるカッコは構文上のカッコじゃなくて
単に関数適用のカッコですね
マクロかと思ってました

で部分関数の置き換えが可能だとどんなことになっていくかやっていきます
以下の`...`に置き換えを書いていきます
付録Bだと`dethm`の行のインデントがずれてて構造が見にくくなってます
カッコの数は数えないので！

```
(J-Bob/prove
  (list-extend (my/prelude)
    '(defun partial (x)
       (if (partial x) 'nil 't)))
  '(((dethm contradiction () 'nil)
     nil
     ...)))
```

（略）ということで`partial`が適用できてしまうと`'nil`が`'t`になってしまいます

どういうカラクリかと見てみると
`(partial x)`を`(if (partial x) 'nil 't)`に置き換えたときに
真偽が反転してます
なので

```
(defun partial (x) (if (partial x) 't 'nil))
```

ではそういうことは起こりません
これも部分関数ではありますが

部分関数が全部悪いわけじゃないけど念のため全部ダメなことにする、ってことでしょうか
矛盾は引き起こさないとしても値を返さないことがあるんだからやっぱダメかな

部分関数を置き換えるのはまずいとして
じゃあ公理を使って例えば`'nil`を`(if (partial x) 'nil 'nil)`に
書き換えるのは問題ないんでしょうか
`'nil`の値は`'nil`ですが`(if (partial x) 'nil 'nil)`は値を返さないので
もうすでにこの時点でおかしくなってるはず
いや、それを言うなら`my/prelude`に`partial`を追加した時点でおかしいのか
追加できたということは全域であると宣言してるようなものだから

さらにこれは部分関数かどうか

```
(defun partial (x) (if (partial x) 't 't))
```

普通に動かしたら無限ループですが`if-same`の公理が使えれば`'t`になります
`if-same`を使ってはいけない条件というのがあるんでしょうか
単に関数定義の中では公理による置き換えは使えないというだけかな

同じ形の定理なら証明できますけどだからといって関数が全域であるとは言えなさそう

```
(J-Bob/prove
  (list-extend (my/prelude)
    '(defun partial (x)
       (if (partial x) 't 'nil)))
  '(((dethm partial-theorem (x)
       (if (partial x)
           't
           't))
     nil
     (() (if-same (partial x) 't)))))
```

せっかく矛盾を導けたので、矛盾を使って任意の命題を証明する、っていうのが
できないかと思いましたが
「帰結」がないのでDethmの法則が適用できませんね
残念

# 定理証明手習い (17) atom

```
(defun list0? (x)
  (equal x '()))

(defun list1? (x)
  (if (atom x)
      'nil
      (list0? (cdr x))))

(defun list2? (x)
  (if (atom x)
      'nil
      (list1? (cdr x))))
```

からの

```
(defun list? (x)
  (if (atom? x)
      (equal x '())
      (list? (cdr x))))
```

の書き方が慣れない
`'()`がアトムとされてるから、`x`がアトムであるか判定したあと
さらに`x`が`'()`かどうかを判断しないといけない

Schemeならこう
すっきりする

```
(define (list0? x) (null? x))

(define (list1? x)
  (if (null? x) #f (list0? (cdr x))))

(define (list2? x) 
  (if (null? x) #f (list1? (cdr x))))

(define (list? x)
  (if (null? x) #t (list? (cdr x))))
```

っていうか`null?`がないのがよくないのか

`'()`がアトムとされてたり、`null?`がなかったりするのにも
全域性のために`(car '())`を`'()`としたみたいな背景があるんだろうか

`list?`のA部の`(equal x '())`(=`list0?`)が
`list1?`や`list2?`では`'nil`に置き換えられているのは
何か一般的な書き換え規則があるんだろうか
Scheme風に書いた方では`#t`が`#になってるけれども
何かあるような気がする

# 定理証明手習い (18) 尺度

全域性を証明するために**尺度**を導入します
関数が再帰的に呼び出されるたびに尺度が減少することを示すことによって
いつかは再帰が終わることを証明します

`size`はリストを作るために必要な`cons`の数でした
以下のような公理を使って全域性を証明します

* `(size x)`は自然数である
* `(size (car x))`は`(size x)`より小さい
* `(size (cdr x))`は`(size x)`より小さい

関数の場合は「種」に尺度を入れてやるようです
すると、全域性を主張する式が返されます

```
> (J-Bob/prove (defun.list2?)
    '(((defun list? (x)
         (if (atom x)
             (equal x '())
             (list? (cdr x))))
       (size x))))
(if (natp (size x)) (if (atom x) 't (< (size (cdr x)) (size x))) 'nil)
```

どんなしくみで式を作ってるんでしょうか

* 尺度は自然数である
* `if`のQ部はそのまま
* 再帰は引数の尺度が現在の尺度よりも減っているという式に変換
* それら以外の式は`'t`に変換

みたいな感じでしょうか
例をひとつ見ただけなのでまだなんとも言えません
付録CがJ-Bob自身の解説なので、そこを読む時の楽しみにとっておきます

で、あとは主張の式を公理や関数適用で置き換えていって`'t`であることを示します
