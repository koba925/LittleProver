# 定理証明手習い (21) sub

> 2つめの引数に含まれる`'?`をすべて1つめの引数の値に置き換える、`sub`という関数を考えましょう。

これはScheme手習いで言うところの「スター型」(*のついた)関数になります
`car`側も再帰するやつです

`(cons (sub x (car y)) (sub x (cdr y)))`の部分は証明だと

```
(if (< (size (car y)) (size y))
    (< (size (cdr y)) (size y))
    'nil))
```

に書き換えられてます
語彙が不足してるからこうなってますけど、普通のLispなら

```
(and (< (size (car y)) (size y))
     (< (size (cdr y)) (size y)))
```

と書くところですね
要は`(car y)`も`(cdr y)`も小さくなるよね、ってこと

何か見えてきたかも
