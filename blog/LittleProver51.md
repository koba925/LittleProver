# 定理証明手習い (51) wt

というわけで新しい尺度

```
(defun wt (x)
       (if (atom x)
           '1
           (+ (+ (wt (car x)) (wt (car x)))
              (wt (cdr x)))))
```

Scheme手習いでやったやつと同じです
そのときはこうでした

```
(define weight*
  (lambda (pora)
    (cond ((atom? pora) 1)
          (else (o+ (o* (weight* (first para)) 2) 
                    (weight* (second para)))))))
```

かけ算がないので足し算になってるのと
Scheme手習いではドット対じゃなくて２要素のリストで表現してるのが違うくらいですね

まず`wt`自体の全域性を証明しますが、全域性の主張は

> 自分で構成してもらってもよかったんですけどね。

ルールの細かいとこは忘れた
でも雰囲気で作れるからいいんだ

再帰してないところは終わるから't
再帰してるところは引数が小さくなってる
ifのときはQ部とE部/A部みんな考える
くらいでしょ

はい

```
(if (atom x) 
    't 
    (if (< (size (car x)) (size x))
        (< (size (cdr x)) (size x))
        'nil))
```

証明は何も難しいところなし