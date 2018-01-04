# 定理証明手習い (4) J-Bob初体験

> J-Bobは、ある式を別の式に書き換えるのを手助けしてくれるプログラムです。

「A 放課後」でJ-Bobの使い方が紹介されています
章の内容に沿って書かれているのでとりあえず言われるまま入れてみます

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '())
(car (cons 'ham '(eggs)))
```

値の表示にクォートがついてませんがこれはRacketの特性かも
いやこの本の記法かな？
気にしない

そうそう
デフォルトだとインデントが上のようにならないので
PreferenceのIndentタブでLambda-like Keywordsのところに
J-Bob/stepを追加してみました
とりあえずうまくいってるみたいです
ここの設定はいまひとつよくわかってませんが

つぎはこれ

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '((() (car/cons 'ham '(eggs)))))
'ham
```

何やら`(car (cons 'ham '(eggs)))`に`car/cons`の公理を適用すると`ham`になる、
てことみたいですね
`car/cons`の公理を適用する、ってところは自分で考えるのかな？
定理証明支援系とか書いてあったけど間違いがないか確かめるくらい？
適用できる公理の候補を探してくれるとかちょっと期待してましたが

試しに間違えてみよう

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '((() (car/cons 'ham '(cheese)))))
(car (cons 'ham '(eggs)))
```

間違いですよって言ってくれるわけではなくて置き換えが起こらないだけか
地味というかシンプルというか
Unixぽい？別にそういうわけじゃないのかな

これでいうと

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))
      (() (atom '()))))
't
```

まずここから始めて

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '())
(atom (cdr (cons (car (cons p q)) '())))
```

えーとひとつめの引数のひとつめの引数のひとつめの引数に
`car/cons`の公理を適用するんだな、と考えて

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))))
(atom (cdr (cons p '())))
```

おー置き換わった置き換わった、とやるわけですね
引き続きこうやって試していく、と

```
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))))
(atom '())
> (J-Bob/step (prelude)
    '(atom (cdr (cons (car (cons p q)) '())))
    '(((1 1 1) (car/cons p q))
      ((1) (cdr/cons p '()))
      (() (atom '()))))
't
```

なかなかタフですね
もうちょっとやさしいUIとかほしくなる感じ

ところで`(atom '())`っていうのは公理じゃないですね
やっぱり普通の関数適用もあるのか

「A 放課後」はまだ続きますが第1章の内容はここまで
