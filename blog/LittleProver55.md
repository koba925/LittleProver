# 定理証明手習い (55) common-addendsのキャンセル

> `common-addends-<`の公理を使うことで、`<`の引数にある2つの`(wt (cdr x))`をキャンセルできると思います。

```
     (if (atom x)
         't
         (if (atom (car x))
             (< (wt (cdr x))
                (+ (+ (wt (car x)) (wt (car x)))
                   (wt (cdr x))))
             (< (wt (rotate x)) (wt x))))
```

これを

```
    (dethm common-addends-< (x y z)
      (equal (< (+ x z) (+ y z)) (< x y)))
```

と見比べて0を足すことを思いつけばいいわけだな！
ちょっと自信なし

足し算するためには`(wt (cdr x))`が自然数であると言わなければいけないけれども
`if-true`で都合のいい前提を導入する技はマスター済み
そして目的を果たすや否や導入したばかりの前提を消去するという極悪非道ぶりも発揮
