# 定理証明手習い (43) `set?/add-atoms`の証明（続）

> 下記にオレンジ色で示したif式のQuestion部は、どちらも同じ`(set? (add-atoms (cdr a) bs))`という意味です。

知ってた

> しかし、`if-nest-A`や`if-nest-E`で単純な形にはできません。

先に言ってくれ！

> `(set? (add-atoms (cdr a) bs))`という前提が真の場合には、`set?/t`によって`'t`になります。

そうですね

> この前提が偽の場合には、`'nil`です。

これは新しいパターン
この前、何だっけかが`'nil`であることを証明しようとしてできなかったけど・・・

> だとしたら、`'nil`に等しいという新しい主張が必要ですね

```
(dethm set?/nil (xs)
  (if (set? xs)
      't
      (equal (set? xs) 'nil)))
```

ふむ、証明できるのか
でもここでは証明しないで先へ進みます

そういえば結局、こう書かないのはなんでなんだろう

```
(dethm set?/t-nil (xs)
  (if (set? xs)
      (equal (set? xs) 't)
      (equal (set? xs) 'nil)))
```

意味は変わらないと思うんだけど・・・
ひとつずつ証明したいから？
それとも意味が変わっちゃうのかな

やってみたら

```
     ((E A A A Q 1) (set?/t (add-atoms (cdr a) bs)))
     ((E A E Q 1) (set?/nil (add-atoms (cdr a) bs)))
```

の代わりに

```
     ((E A A A Q 1) (set?/t-nil (add-atoms (cdr a) bs)))
     ((E A E Q 1) (set?/t-nil (add-atoms (cdr a) bs)))
```

でも同じ結果
やっぱり分割しておきたい、ってことですかね

まあそこくらいで

> これで、まあ、終わりですね。

まあ、`set?/add-atoms`の分はね
