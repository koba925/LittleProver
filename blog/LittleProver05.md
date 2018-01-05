# 定理証明手習い (5) 「B デザートには証明を」

さらに「B デザートには証明を」には出てきた式が全部J-Bobで書いてあります
なので本編と付録Aと付録Bをいったりきたりすることになります
なのでしおりが３本ほしかったりするわけです

J-Bobでの記述はこんな感じ

```
(defun chapter1.example1 ()
  (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))
      (() (car '(ham eggs))))))
```

関数として定義されてるので実行してやらないと何も起こりません
どうしてこういう書き方になってるんでしょうか

```
> (chapter1.example1)
'ham
```

うむ
これだけだと何がなんだかわからない
慣れるまでは順を追ってやってみるのがいいかなあ
こうやって

```
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '())
(car (cons 'ham '(eggs)))
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))))
(car '(ham eggs))
> (J-Bob/step (prelude)
    '(car (cons 'ham '(eggs)))
    '(((1) (cons 'ham '(eggs)))
      (() (car '(ham eggs)))))
'ham
```

で付録Bを見て答え合わせする

いちいち関数を実行してやるのも面倒だし
コピペも簡単だからコメントでいいや

```
; chapter1.example1
(J-Bob/step (prelude)
  '(car (cons 'ham '(eggs)))
  '(((1) (cons 'ham '(eggs)))
    (() (car '(ham eggs))))))
```

Racketだったらrackunitで書くという手もあったんだけど
r5rs用のユニットテストフレームワークもあるだろうけど探して覚えるのも面倒だし

ずらずら書いていってみよう
