# 定理証明手習い (56)
> `(+ (wt (car x)) (wt (car x)))`は正の数ですか？
> `(wt (car x))`が正なら、正ですね。

そういう当たり前のことがね

> 次のような主張`positive/wt`を作れば、そのフォーカスをうまい前提に書き換えられますね。
> 
> ```
> (dethm positive/wt (x)
>   (equal (< '0 (wt x)) 't))
> ```

そうですね

> もちろん、`positive/wt`は証明が必要です。

はいそうですね

証明の骨組みは`natp/wt`と同じ
さらっと

```
(J-Bob/prove (dethm.natp/wt)
  '(((dethm positive/wt (x)
       (equal (< '0 (wt x)) 't))
     (star-induction x)

     ; (if (atom x)
     ;     (equal (< '0 (wt x)) 't)
     ;     (if (equal (< '0 (wt (car x))) 't)
     ;         (if (equal (< '0 (wt (cdr x))) 't)
     ;             (equal (< '0 (wt x)) 't)
     ;             't)
     ;         't))

     ;; A部

     ((A 1 2) (wt x))
     ((A 1 2) (if-nest-A (atom x)
                         '1
                         (+ (+ (wt (car x)) (wt (car x)))
                            (wt (cdr x)))))
     ((A 1) (< '0 '1))
     ((A) (equal 't 't))

     ; (if (atom x)
     ;     't
     ;     (if (equal (< '0 (wt (car x))) 't)
     ;         (if (equal (< '0 (wt (cdr x))) 't)
     ;             (equal (< '0 (wt x)) 't)
     ;             't)
     ;         't))

     ;; E部

     ; 前提の内側のwtから展開

     ((E A A 1 2) (wt x))
     ((E A A 1 2) (if-nest-E (atom x)
                             '1
                             (+ (+ (wt (car x)) (wt (car x)))
                                (wt (cdr x)))))

     ; (if (atom x)
     ;     't
     ;     (if (equal (< '0 (wt (car x))) 't)
     ;         (if (equal (< '0 (wt (cdr x))) 't)
     ;             (equal (< '0
     ;                       (+ (+ (wt (car x)) (wt (car x)))
     ;                          (wt (cdr x))))
     ;                    't)
     ;             't)
     ;         't))

     ; (< '0 (wt (car x)))の前提を作る
     ((E A A) (if-true (equal (< '0
                                 (+ (+ (wt (car x))
                                       (wt (car x)))
                                    (wt (cdr x))))
                              't)
                       't))
     ((E A A Q) (equal-if (< '0 (wt (car x))) 't))

     ; (< '0 (+ (wt (car x)) (wt (car x))))の前提を作る
     ((E A A A) (if-true (equal (< '0
                                   (+ (+ (wt (car x))
                                         (wt (car x)))
                                      (wt (cdr x))))
                                't)
                         't))
     ((E A A A Q) (positives-+ (wt (car x)) (wt (car x))))

     ; (< '0 (wt (cdr x)))の前提を作る
     ((E A A A A) (if-true (equal (< '0
                                   (+ (+ (wt (car x))
                                         (wt (car x)))
                                      (wt (cdr x))))
                                't)
                         't))
     ((E A A A A Q) (equal-if (< '0 (wt (cdr x))) 't))

     ; (if (atom x)
     ;     't
     ;     (if (equal (< '0 (wt (car x))) 't)
     ;         (if (equal (< '0 (wt (cdr x))) 't)
     ;             (if (< '0 (wt (car x)))
     ;                 (if (< '0 (+ (wt (car x)) (wt (car x))))
     ;                     (if (< '0 (wt (cdr x)))
     ;                         (equal (< '0 (+ (+ (wt (car x))
     ;                                            (wt (car x)))
     ;                                         (wt (cdr x))))
     ;                                't)
     ;                         't)
     ;                     't)
     ;                 't)
     ;             't)
     ;         't))

     ; 本丸
     ((E A A A A A 1) (positives-+ (+ (wt (car x))
                                      (wt (car x)))
                                   (wt (cdr x))))

     ; (if (atom x)
     ;     't
     ;     (if (equal (< '0 (wt (car x))) 't)
     ;         (if (equal (< '0 (wt (cdr x))) 't)
     ;             (if (< '0 (wt (car x)))
     ;                 (if (< '0 (+ (wt (car x)) (wt (car x))))
     ;                     (if (< '0 (wt (cdr x)))
     ;                         (equal 't 't)
     ;                         't)
     ;                     't)
     ;                 't)
     ;             't)
     ;         't))

     ; 整理
     ((E A A A A A) (equal 't 't))
     ((E A A A A) (if-same (< '0 (wt (cdr x))) 't))
     ((E A A A) (if-same (< '0 (+ (wt (car x)) (wt (car x)))) 't))
     ((E A A) (if-same (< '0 (wt (car x))) 't))
     ((E A) (if-same (equal (< '0 (wt (cdr x))) 't) 't))
     ((E) (if-same (equal (< '0 (wt (car x))) 't) 't))
     (() (if-same (atom x) 't)))))
```
