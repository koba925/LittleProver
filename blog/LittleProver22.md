# 定理証明手習い (22) partialの証明

このまえも出てきた`partial`の証明
本に書いてあることをコードで書くとこうなります

```
> (J-Bob/prove (my/prelude)
    '(((defun partial (x)
         (if (partial x) 'nil 't))
       (size x)
       ((Q) (natp/size x))
       (() (if-true (if (< (size x) (size x)) 't 'nil) 'nil)))))
(if (< (size x) (size x)) 't 'nil)
```

ここで`(< (size x) (size x))`なはずはないから偽、となってて
意味的にはわかりますが形式的にはごにょごにょしてません？
「このやり方では全域であるとは証明できなかった」までしか言えてないのでは？
前にも行き詰まったらもとに戻ってやり直せる、みたいなこと言ってたし

ちゃんと証明できないものでしょうか
`(< (size x) (size x))`を評価して`'nil`になれば続けられるんですが
`x`が含まれてるのでダメです

たとえばこんな公理があれば証明できそうですね

```
(dethm size-same (x)
       (equal (< (size x) (size x)) 'nil))
```

いやもっと一般化できるな
こうか

```
(dethm smaller-same (x)
       (equal (< x x) 'nil))
```

実際やってみるとこう

```
> (J-Bob/prove
    (list-extend (my/prelude)
      '(dethm smaller-same (x)
         (equal (< x x) 'nil)))
    '(((defun partial (x)
         (if (partial x) 'nil 't))
       (size x)
       ((Q) (natp/size x))
       (() (if-true (if (< (size x) (size x)) 't 'nil) 'nil))
       ((Q) (smaller-same (size x)))
       (() (if-false 't 'nil)))))
'nil
```

`'nil`に変形できました
`'nil`って返されてしまうと、失敗の`'nil`と見分けがつきませんけれども
証明はあくまでも`'t`にするのがお作法なのかな
いや、そうも行かないか
定理なら`(equal A 'nil)`みたいにすれば済みますが

このあたり、ちゃんとやるならどう扱うんでしょうか

もうひとつ、
`(if (< (size x) (size x)) 't 'nil)`までで止まったということはこの形、
やっぱりここで行き止まりってことなんですかね
何かしたら`(< (size x) (size x))`に書き換えられる、ってことはなさそう？
ただここでやめたというだけでしょうか？
