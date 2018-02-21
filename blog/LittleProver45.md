# 定理証明手習い (45) set?/t

> `set?/t`とか`set?/nil`を証明しないといけませんかね。

そうですよ！

> 178ページです。

そんだけ

自力でやってみるかな
できるとわかってるだけでも足しになる
新しい技も覚えたし（使うかどうかわからないけど

えーとこういうのは`list-induction`でやるんだっけ？

```
> (J-Bob/prove (defun.atoms)
    '(((dethm set?/t (xs)
         (if (set? xs)
             (equal (set? xs) 't)
             't))
       (list-induction xs))))
(if (atom xs)
  (if (set? xs) (equal (set? xs) 't) 't)
  (if (if (set? (cdr xs))
          (equal (set? (cdr xs)) 't)
          't)
      (if (set? xs)
          (equal (set? xs) 't)
          't)
      't))
```

A部は`set?`を開いて淡々と変形していけば`'t`
E部は帰納法の前提はそのままにして`(if (set? xs) ...)`からやっていく
`set?`を開いて
`(if (member? (car xs) (cdr xs)) ... `で持ち上げて
`(if (set? (cdr xs))`で持ち上げるくらいでこっちは証明完了

今まで出てきた技でできそうなことからやっていくだけですんなり終わり
意外なところは特になし

