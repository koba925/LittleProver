# 定理証明手習い (24) If持ち上げを定理に・・・

Ifの持ち上げを何回か書いてると面倒になってきます
これがパターンであるのなら定理として証明してしまえばいいのでは、
と思ったのですがそもそもパターンがJ-Bobで表現できるのかなあ
書けるとしたらこんな感じなんでしょうか

```
(J-Bob/prove (defun.remb)
  '(((dethm if-lifting (original-focus Q A E)
       (equal (original-focus (if Q A E))
              (if Q (original-focus A) (original-focus E))))
     nil
     ...)))
```

でも`(original-focus A)`っていうような書き方は受け付けてくれないようです
これが通れば

```
(J-Bob/prove (dethm.if-lifting)
  '(((dethm lift-test (x1)
       (equal (memb? (if (equal x1 '?)
                         (remb '())
                         (cons x1 (remb '()))))
              'nil))
     nil
     ((1) (if-lifting memb? 
                      (equal x1 '?)
                      (remb '())
                      (cons x1 (remb '())))))))
```

で

```
(equal (memb? (if (equal x1 '?)
                  (remb '())
                  (cons x1 (remb '()))))
       'nil)
```

を

```
(equal (if (equal x1 '?)
           (memb? (remb '()))
           (memb? (cons x1 (remb '()))))
       'nil)
```

に置き換えることができそうなんですけど
証明的にやっちゃダメって話ではないような気がするので、J-Bobの表現力の問題？
そもそもJ-Bobの使い方がわかってないのかもしれないけど
でもここで出てこないということはそういうことなんだろうなあ
