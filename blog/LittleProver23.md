# 定理証明手習い (23) 5 何回も何回も何回も考えよう

ここでは何をやってるんですかね
再帰する関数の全域性が証明できるようになったので
再帰する関数を使った定理を証明する（ための準備）、でいいのかな

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
これだけで１章使ってますから
それにもうJ-Bobとの対話もずいぶん慣れてきましたし
パターン化してるところもありますし

