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

見えてきた

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

たとえばこんな公理があれば

```
(dethm size-same (x)
       (equal (< (size x) (size x)) 'nil))
```

証明できますが
いやこうか

```
(dethm compare-same (x)
       (equal (< x x) 'nil))
```

このあたり、本気でやってる人たちはどう扱ってるんでしょうか

```
> (J-Bob/prove
    (list-extend (my/prelude)
      '(dethm size-same (x)
         (equal (< (size x) (size x)) 'nil)))
    '(((defun partial (x)
         (if (partial x) 'nil 't))
       (size x)
       ((Q) (natp/size x))
       (() (if-true (if (< (size x) (size x)) 't 'nil) 'nil))
       ((Q) (size-same x))
       (() (if-false 't 'nil)))))
'nil
```

`'nil`って返されてしまうと、失敗の`'nil`と見分けがつきませんけれども
それとも、あくまでも証明は`'t`にするのがお作法なのかな
いや、そうも行かないか
定理なら`(equal A 'nil)`みたいにするだけだけど

もうひとつ、
`(if (< (size x) (size x)) 't 'nil)`までで止まったということはこの形、
やっぱりここで行き止まりってことなんですかね
何かしたら`(< (size x) (size x))`に書き換えられる、ってことはなさそう？
ただここでやめただけ、かもしれないけど

# 定理証明手習い (23) 

「5. 何回も何回も何回も考えよう」

ここでは何をやってるんだっけ
再帰する関数の全域性が証明できるようになったので
再帰する関数を使った定理を証明する、でいいのかな

0要素のリスト、1要素のリスト、2要素のリストについて
定理を証明していきます

証明にも技が出てきました
基本的には適用順に評価しなさいと言いつつも
ときには単純に内側から置き換えていくのではなくて
定理の形を想定して内側を残しておくとか
2章で出てきた、`if-same`と`if-nest-A/E`を組み合わせたIfの持ち上げとか

そしてかなり長く
１要素のリストに対する証明がこれくらい
（ちょっとだけ本文と順番が違います）

```
(J-Bob/prove (dethm.memb?/remb0)
  '(((dethm memb?/remb1 (x1)
       (equal (memb? (remb (cons x1 '()))) 'nil))
     nil
     ((1 1) (remb (cons x1 '())))
     ((1 1 Q) (atom/cons x1 '()))
     ((1 1) (if-false '()
                      (if (equal (car (cons x1 '())) '?)
                          (remb (cdr (cons x1 '())))
                          (cons (car (cons x1 '()))
                                (remb (cdr (cons x1 '())))))))
     ((1 1 Q 1) (car/cons x1 '()))
     ((1 1 A 1) (cdr/cons x1 '()))
     ((1 1 E 1) (car/cons x1 '()))
     ((1 1 E 2 1) (cdr/cons x1 '()))
     ((1) (if-same (equal x1 '?)
                   (memb? (if (equal x1 '?)
                              (remb '())
                              (cons x1 (remb '()))))))
     ((1 A 1) (if-nest-A (equal x1 '?)
                         (remb '())
                         (cons x1 (remb '()))))
     ((1 E 1) (if-nest-E (equal x1 '?)
                         (remb '())
                         (cons x1 (remb '()))))
     ((1 A) (memb?/remb0))
     ((1 E) (memb? (cons x1 (remb '()))))
     ((1 E Q) (atom/cons x1 (remb '())))
     ((1 E) (if-false 'nil
                      (if (equal (car (cons x1 (remb '()))) '?)
                          't
                          (memb? (cdr (cons x1 (remb '())))))))
     ((1 E Q 1) (car/cons x1 (remb '())))
     ((1 E) (if-nest-E (equal x1 '?) 't (memb? (cdr (cons x1 (remb '()))))))
     ((1 E 1) (cdr/cons x1 (remb '())))
     ((1 E) (memb?/remb0))
     ((1) (if-same (equal x1 '?) 'nil))
     (() (equal-same 'nil)))))
```

ぱっと見こんなのわかんね、となりそうですが
本文読みながらやっていくと意外とすんなりいきます
もうJ-Bobとの対話もずいぶん慣れてきましたし

Ifの持ち上げはこれがパターンであるのなら定理として証明してしまえばいいのでは、
と思ったのですが
・・・
J-Bobの構文では書けないかな
引数にラムダ式が書けたらいける？
