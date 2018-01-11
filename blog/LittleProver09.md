# 定理証明手習い (9) 「2 もう少し、いつものゲームを」

やっと2章
「2 もう少し、いつものゲームを」では`if`の公理が出てきます
`if`では数ではなくて`Q`、`A`、`E`で置き換え対象を指定します

* `(if 't x y)`と`x`は等しい (`if-true`)
* `(if 'nil x y)`と`y`は等しい (`if-false`)
* `(if x y y)`と`y`は等しい (`if-same`)

3つめ公理はどうやって使うんでしょうか

```
(dethm if-same (x y) (equal (if x y y) y))
```

次はEqualの公理に含められていますがifとも関係あり
日本語にしてしまうと意味が取れなくなってしまうのでそのまま

```
(dethm equal-if (x y) (if (equal x y) (equal x y) 't))
```

`'t`ってなんだよ`'t`って、と思いましたがこれはたぶん定理は常に`'t`でないと
いけないので入れてあるってことでしょう

この`equal-if`を適用するためにDethmの法則が更新されてます
文章で読むとわかりづらいですが
`(if X (equal Y Y') ...)`という公理があれば
`(if X (... Y ...) ...)`を`(if X (... Y' ...) ...)`に、
`(if X ... (equal Z Z'))`という公理があれば
`(if X ... (... Z ...))`を`(if X ... (... Z' ...))`に
置き換えられるということ
例をあげて1ステップずつ順番にやってくれますので進めばわかります

> 次の場合、置き換えた結果であるbody(e)を使ってフォーカスの書き換えができる

は「body(e)に含まれる**帰結**を使ってフォーカスの書き換えができる」てことですね
最初ここが飲み込めませんでした

`equal-if`の公理でEqualの公理が完成します
推移律じゃなかったか
でも推移律作れそう
`and`はないからこう・・・

```
  (if (equal x y) (if (equal y z) (equal x z) 't) 't)
= (if (equal x y) (if (equal z y) (equal x z) 't) 't)
= (if (equal x y) (if (equal z y) (equal y y) 't) 't)
= (if (equal x y) (if (equal z y) 't 't) 't)
= (if (equal x y) 't 't)
= 't
```

かな？

```
> (J-Bob/step (my/prelude)
    '(if (equal x y) (if (equal y z) (equal x z) 't) 't)
    '(((A Q) (equal-swap y z))
      ((A A 1) (equal-if x y))
      ((A A 2) (equal-if z y))
      ((A A) (equal-same y))
      ((A) (if-same (equal z y) 't))
      (() (if-same (equal x y) 't))))
't
```

いけた

じゃあ`my/axioms`にこうやって公理を付け加えたら

```    
(defun my/axioms ()
     :
     :
    (dethm equal-trans (x y z)
      (if (equal x y) (if (equal y z) (equal x z) 't) 't))))
```

`(if (equal a b) (if (equal b c) a b) c)`みたいなのを
`(if (equal a b) (if (equal b c) c b) c)`のように置き換えられたりするかな？

```
> (J-Bob/step (my/prelude)
    '(if (equal a b) (if (equal b c) a b) c)
    '(((A A) (equal-trans a b c))))
(if (equal a b) (if (equal b c) c b) c)
```

できた

あてずっぽうでもけっこう動くもんだなと思って`jabberwocky`も動かしてみようと
思いましたが悪戦苦闘のあげくうまくいきませんでした
ちゃんとわかってきたらできるのかな？

なお

> `(equal 'nil 'nil)`を`'t`に置き換えるのに`equal-same`は必要でしょうか？
> そんなことはありません。`'nil`は値なので、関数`equal`の定義がそのまま使えました。

こういう場合は公理で置き換えても、単に関数適用してもどっちでもいいってことですね
疑問氷解しました

Consの公理を追加

* `x`がアトムでなければ、`x`と`(cons (car x) (cdr x))`は等しい  (`cons/car+cdr`)

Ifの公理も追加

* `x`ならば`(if x y z)`と`y`は等しい (`if-nest-A`)
* `x`でなければ`(if x y z)`と`z`は等しい (`if-nest-E`)

`it-true`や`if-false`と意味は似てますが`x`を`'t`や`'nil`に変形することなく
置き換えられます

`if-same`なんてどう使うのかと思いましたが
`if-nest-A`や`if-nest-E`と組み合わせるとこんなことができたり

```
  (A (if B C D) (if B E F))
= (if B (A (if B C D) (if B E F)) (A (if B C D) (if B E F)))) [if-same]
= (if B (A C E) (A D F)) [if-nest-A, if-nest-E]
```

式を簡単にするのではなくて式を増やす方向で活躍する模様
奥が深い

これでCons、Ifの公理も完成
本文と付録Aと付録Bをいったりきたりしながら読むのが忙しい
