# 定理証明手習い (32) 8 これがルールです

まず`member?`と`set?`の定義が出てきますがこれは下準備
いままでどおりにやるだけです

`(if (natp (size ys)) ...)`は定理にしておきますね
こうかな

```
(defun dethm.if/natp/size ()
  (J-Bob/define (dethm.ctx?/sub)
    '(((dethm if/natp/size (x a b)
         (equal (if (natp (size x)) a b) a))
       nil
       ((1 Q) (natp/size x))
       ((1) (if-true a b))
       (() (equal-same a))))))
```

ところで`-`と`/`の使い分けがいまひとつピンときてないので名前は変かもしれません
これで

```
(J-Bob/prove (dethm.if/natp/size)
  '(((defun member? (x ys)
       (if (atom ys)
           'nil
           (if (equal x (car ys))
               't
               (member? x (cdr ys)))))
     (size ys)
     (() (if/natp/size ys
                       (if (atom ys)
                           't
                           (if (equal x (car ys))
                               't
                               (< (size (cdr ys)) (size ys))))
                       'nil)))))
```

うんできてますできてます
なんと2行が1行に!

ほかには何かパターン出てこないかなあ

