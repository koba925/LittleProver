# 定理証明手習い (18) atom

対話的定理証明器という言葉を見かけました
j-bobに1行足しては結果を見てまた1行足す、ってやってるのを思い出して
ああこれは対話してたんだ、と思うなど

さて

```
(defun list0? (x)
  (equal x '()))

(defun list1? (x)
  (if (atom x) 'nil (list0? (cdr x))))

(defun list2? (x)
  (if (atom x) 'nil (list1? (cdr x))))
```

からの

```
(defun list? (x)
  (if (atom? x) (equal x '()) (list? (cdr x))))
```

ですが、この書き方が慣れません
`'()`がアトムとされてるので、`x`がアトムであるか判定したあと
さらに`x`が`'()`かどうかを判断しないといけないですよね

Schemeならこう
こっちのほうがすっきりしてませんか

```
(define (list0? x) (null? x))

(define (list1? x)
  (if (null? x) #f (list0? (cdr x))))

(define (list2? x) 
  (if (null? x) #f (list1? (cdr x))))

(define (list? x)
  (if (null? x) #t (list? (cdr x))))
```

っていうか`null?`がないのがよくないのか

`'()`がアトムとされてたり、`null?`がなかったりするのにも
`(car '())`を`'()`としたのは全域性のため、みたいに何か背景があるんでしょうか

