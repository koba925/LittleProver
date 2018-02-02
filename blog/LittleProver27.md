# 定理証明手習い (27)

こんな定理を証明します

```
(dethm ctx?/sub (x y)
  (if (ctx? x)
      (if (ctx? y)
          (equal (ctx? (sub x y)) 't)
          't)
      't))
```

そういえば

> `'t`ってなんだよ`'t`って、と思いましたがこれはたぶん定理は常に`'t`でないと
> いけないので入れてあるってことでしょう

なんて書いてましたがこれ見てるときに思い出しました

> 「AならばB」っていうのは「もしAが真ならばB」ってことだよね
> Aが偽のときについては何も言ってないね
> 何も言ってないけど実はこういうことなんだよ
> 
> もしAが真ならばB
> そうでなければ (Bが何だろうと気にしないで)真

そうか「ならば」を素直に書いてただけだったか
ちょっと見当外れだったかもしれない

さて
種としてはリストの帰納法で`list-induction`を使ったように、
スター型の機能法では`star-induction`を使います

```
(defun star-induction (x)
  (if (atom x)
      x
      (cons (star-induction (car x))
            (star-induction (cdr x)))))
```

やっぱり木を木のまま返すだけの関数
これが種になっているわけですがここからどうやって証明すべき式が出てくるのか
ちょっと見えてきません
とにかく種を与えてみます

```
(J-Bob/prove (defun.ctx?)
  '(((dethm ctx?/sub (x y)
       (if (ctx? x)
           (if (ctx? y)
               (equal (ctx? (sub x y)) 't)
               't)
           't))
     (star-induction y))))
```

どれどれ

```
(if (atom y)
  (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't)
  (if (if (ctx? x) (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't) 't)
    (if (if (ctx? x) (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't)
      (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't)
      't)
    't))
```

見るからにきっつい感じです

最初はifの持ち上げから
`(if (ctx? x) ...)`という形が何度も出てきているので、
ifの持ち上げを使ってやるとひとつにまとめることができます
分配法則を使ってるようなイメージ

ifの持ち上げ＋アルファでこれくらいに

```
(if (ctx? x)
    (if (atom y)
        (if (ctx? y) (equal (ctx? (sub x y)) 't) 't)
        (if (if (ctx? (car y))
                (equal (ctx? (sub x (car y))) 't)
                't)
            (if (if (ctx? (cdr y))
                    (equal (ctx? (sub x (cdr y))) 't)
                    't)
                (if (ctx? y) (equal (ctx? (sub x y)) 't) 't)
                't)
            't))
    't)
```

終わるんでしょうか
