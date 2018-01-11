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
