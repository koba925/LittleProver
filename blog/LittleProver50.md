# 定理証明手習い (50) 反例じゃなくて証明

っていう話はここまで変形しないと言えないもの？

```
(if (atom x)
  't
  (if (atom (car x))
    't
    (< (size (cons (car (car x)) (cons (cdr (car x)) (cdr x))))
       (size (cons (cons (car (car x)) (cdr (car x))) (cdr x))))))
```

反例なら上に上げた主張の時点でもう言えてたと思うけど
逆にここまで来たら

```
(size (cons (car (car x)) (cons (cdr (car x)) (cdr x))))
```

と

```
(size (cons (cons (car (car x)) (cdr (car x))) (cdr x))))))
```

が等しい、くらい言えないものか
うんさっぱり見当がつきません
ていうか公理が足りなさそうだ
こんなのがあればできるかな（あと足し算）

```
(dethm size/cons (a b)
  (equal (size (cons a b)) (+ (+ (size a) (size b)) '1)))
```

それともこうかな？

```
(dethm size/cons (a)
  (equal (size a) (+ (+ (size (car a)) (size (cdr a))) '1)))
```

これは`atom`じゃないっていう前提がいるかな
いや、なくても意外と成り立つか
でも上の方でやろう

ちょっとやってみる

```
(J-Bob/prove (dethm.set?/atoms)
  '(((dethm size/cons (a b)
       (equal (size (cons a b)) (+ (+ (size a) (size b)) '1)))
     nil)
    ((dethm rotate/size (x)
       (equal (size (cons (car (car x)) (cons (cdr (car x)) (cdr x))))
              (size (cons (cons (car (car x)) (cdr (car x))) (cdr x)))))
     nil
     ((1) (size/cons (car (car x)) (cons (cdr (car x)) (cdr x))))
     ((1 1 2) (size/cons (cdr (car x)) (cdr x)))
     ((2) (size/cons (cons (car (car x)) (cdr (car x))) (cdr x)))
     ((2 1 1) (size/cons (car (car x)) (cdr (car x))))
     )))
```

これでここまできた

```
(equal
  (+ (+ (size (car (car x))) (+ (+ (size (cdr (car x))) (size (cdr x))) '1)) '1)
  (+ (+ (+ (+ (size (car (car x))) (size (cdr (car x)))) '1) (size (cdr x))) '1))
```

あとは交換則と結合則でできそうだ
`(size (car (car x)))`をA、`(size (cdr (car x)))`をB、`(size (cdr x))`をCと
書いてみると

```
  (+ (+ A (+ (+ B C) 1)) 1)
= (+ (+ A (+ B (+ C 1))) 1)
= (+ (+ A (+ B (+ 1 C))) 1)
= (+ (+ A (+ (+ B 1) C)) 1)
= (+ (+ (+ A (+ B 1)) C) 1)
= (+ (+ (+ (+ A B) 1) C) 1)
```

いけそう
やってみる

```
     ((1 1 2) (associate-+ (size (cdr (car x))) (size (cdr x)) '1))
     ((1 1 2 2) (commute-+ (size (cdr x)) '1))
     ((1 1 2) (associate-+ (size (cdr (car x))) '1 (size (cdr x))))
     ((1 1) (associate-+ (size (car (car x)))
                         (+ (size (cdr (car x))) '1)
                         (size (cdr x))))
     ((1 1 1) (associate-+ (size (car (car x)))
                         (size (cdr (car x)))
                         '1))
```

これで

```
(equal
 (+ (+ (+ (+ (size (car (car x))) (size (cdr (car x)))) '1) (size (cdr x))) '1)
 (+ (+ (+ (+ (size (car (car x))) (size (cdr (car x)))) '1) (size (cdr x))) '1))
```

よし
さらに

```
     (() (equal-same (+ (+ (+ (+ (size (car (car x)))
                                 (size (cdr (car x))))
                              '1)
                           (size (cdr x)))
                        '1)))
```

これで完了・・・

```
(equal (size (cons a b)) (+ (+ (size a) (size b)) '1))
```

おっとそうか
`'t`にはならないな

これは証明無理だよね？