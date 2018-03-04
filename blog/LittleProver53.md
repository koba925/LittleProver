# 定理証明手習い (53)

> `(wt x)`は常に自然数でしょうか？
> わかりませんが、できると思います。

（証明が）できる、ってことかな？
could beみたいに書いてあったのかもしれないな
それはともかくとして

> `(natp (wt x))`を`'t`に書き換えて、外側の`if`を`if-true`で取り除けば

いやーん

> 関数`wt`と`natp`についての主張はあとで証明しないとですね。

気持ち悪いので先に証明してしまおう

```
(dethm natp/wt (x)
  (equal (natp (wt x)) 't))
```

`wt`が`car`でも`cdr`でも再帰するから`star-induction`かな

```
(J-Bob/prove (defun.wt)
  '(((dethm natp/wt (x)
       (equal (natp (wt x)) 't))
     (star-induction x))))
```

証明すべき主張はこうなりました

```
(if (atom x)
  (equal (natp (wt x)) 't)
  (if (equal (natp (wt (car x))) 't)
      (if (equal (natp (wt (cdr x))) 't)
          (equal (natp (wt x)) 't)
          't)
      't))
```

おなじみの公理とやり方ではここまでしか進まない

```
(if (atom x)
    't
    (if (equal (natp (wt (car x))) 't)
        (if (equal (natp (wt (cdr x))) 't)
            (equal (natp (+ (+ (wt (car x)) (wt (car x)))
                            (wt (cdr x))))
                   't)
            't)
        't))
```

遡っていけば1の足し算しかないんだから当たり前なんだけどさてどうすれば進めるか
この公理を使うのは見え見えとして

```
(dethm natp/+ (x y)
  (if (natp x)
      (if (natp y)
          (equal (natp (+ x y)) 't)
          't)
      't))
```

`(equal (natp (wt (car x))) 't)`、`(equal (natp (wt (cdr x))) 't)`っていう前提で 
`(natp (+ (+ (wt (car x)) (wt (car x))) (wt (cdr x)))`を言う流れだけれども
見えてる壁がふたつ

ひとつめは
公理の形に合わせるためには`(equal (natp (wt (car x))) 't)`じゃなくて
`(natp (wt (car x))`でないとだめ
ってこと

これは`equal/t`みたいな定理を証明して使うのかな
まだ出てきてなかったっけ？

もうひとつは
前提を`(natp (wt (car x))`、`(natp (wt (car x))`にできても公理と前提から直接言えるのは
`(natp (+ (wt (car x)) (wt (car x)))`とか
`(natp (+ (wt (car x)) (wt (cdr x)))`とかだけ
ってこと

`(natp (+ (+ (wt (car x)) (wt (car x))) (wt (cdr x)))`を言うにはもうひと工夫要りそう

z=`(+ (wt (car x)) (wt (car x)))`として`(natp z)`だから、みたいな
ワンクッションを置くってことだろうけど、うまく書けるかな？

とりあえずやってみよう
