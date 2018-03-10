# 定理証明手習い (60) 

進んでみたらわかることを期待して進む

`J-Bob/prove`に`(align x)`を種として与えてやると証明すべき式が出力されます

```
(if (atom x)
    (equal (align (align x)) (align x))
    (if (atom (car x))
        (if (equal (align (align (cdr x)))
                   (align (cdr x)))
            (equal (align (align x)) (align x))
            't)
        (if (equal (align (align (rotate x)))
                   (align (rotate x)))
            (equal (align (align x)) (align x))
            't)))
```

が
Defun帰納法にしたがって自分で作ってみます
主張はこれ

```
(dethm align/align (x)
  (equal (align (align x)) (align x)))
```

まずはなんとなく考えてみると

`x`が`atom`なときは`(equal (align (align x)) (align x))`が成り立つ
そうでないときは
`(equal (align (align (car x))) (align (car x)))`
`(equal (align (align (cdr x))) (align (cdr x)))`
が成り立てば
`(equal (align (align x)) (align x))`が成り立つ

くらいかなあ
あ、でもこれでいいなら`star-induction`でいいわけか
そうじゃないからここで取り上げてるんだろうな

まじめに作る

主張 *c* は`(equal (align (align x)) (align x))`
関数は
*namef* が `align`
*x1* が `x`
*bodyf* が

```
(if (atom x)
    x
    (if (atom (car x))
        (cons (car x) (align (cdr x)))
        (align (rotate x))))
```

*y1* も *c* でつかってるのが `x` だから `x` でいいのかな
そうすると *bodyi* は *bodyf* と同じ

全体を見ると`(if Q A E)`の形

まず *A* から *ca* を作ります
*A* は`x`で、`(if Q A E)`の形ではないので
「 *E* の帰納法のための前提は *c* を含意する」を適用します
ここではE=A=`x`
`x`には再帰的な関数適用がひとつもないので
「前提が0個の場合、含意は *e0* によって表す。」から
*ca* は単に `(equal (align (align x)) (align x))`

次に *E* から *ce* を作ります
*E* は 

```
(if (atom (car x))
    (cons (car x) (align (cdr x)))
    (align (rotate x)))
```

なので再帰的に

まず *A* から *ca* を作ります
*A* は`(cons (car x) (align (cdr x)))`で、`(if Q A E)`の形ではないので
「 *E* の帰納法のための前提は *c* を含意する」を適用します
ここでは`(align (cdr x))`という再帰的な関数適用があるので、
*c* に出てくる `x` を `(cdr x)`で置き換えて、
帰納法のための前提は`(equal (align (align (cdr x))) (align (cdr x)))`となり
*ca*は

```
(if (equal (align (align (cdr x))) (align (cdr x)))
    (equal (align (align x)) (align x))
    't)
```

となります

次に *E* から *ce* を作ります
*E* は `(align (rotate x))` で、`rotate`が出てくるのが気になりますが
*c* に出てくる `x` を `(rotate x)`で置き換えて、
帰納法のための前提は`(equal (align (align (rotate x))) (align (rotate x)))`となり
*ce*は

```
(if (equal (align (align (rotate x))) (align (rotate x)))
    (equal (align (align x)) (align x))
    't)
```

以上から *cae* は

```
(if (atom (car x))
    (if (equal (align (align (cdr x))) (align (cdr x)))
        (equal (align (align x)) (align x))
        't)
    (if (equal (align (align (rotate x))) (align (rotate x)))
        (equal (align (align x)) (align x))
        't)) 
```

となります
*Q* は `(atom (car x))` で再帰的な関数適用はないので
帰納法の前提が *cae* を含意する、は単に *cae* となります

再帰からひとつ戻ると今作ったのが *ce* で *Q* は `(atom x)`なので
*cae* は

```
(if (atom x)
    (equal (align (align x)) (align x))
    (if (atom (car x))
        (if (equal (align (align (cdr x))) (align (cdr x)))
            (equal (align (align x)) (align x))
            't)
        (if (equal (align (align (rotate x))) (align (rotate x)))
            (equal (align (align x)) (align x))
            't)))
```

となります
*Q* は `(atom (car x))` で再帰的な関数適用はないので
帰納法の前提が *cae* を含意する、は単に *cae* となります

あってるようです
`align`の定義と証明すべき式を見比べてやって腑に落ちてきた感じ
すらすらできるようになるにはあと2、3回・・・
