# 定理証明手習い (54)

> ひとつめは
> 公理の形に合わせるためには`(equal (natp (wt (car x))) 't)`じゃなくて
> `(natp (wt (car x))`でないとだめ
> ってこと

これには9章の後半で出てきた、`if-true`を使って都合のいい前提を作る作戦が使える

```
    :
     (if (equal (natp (wt (cdr x))) 't)
         (equal (natp (+ (+ (wt (car x)) (wt (car x)))
                         (wt (cdr x))))
                't)
         't)
    :
```

ここから

```
     ; まずは(if 't ... ...) という形を作って
     ((E A A) (if-true (equal (natp (+ (+ (wt (car x)) (wt (car x)))
                                       (wt (cdr x))))
                              't)
                       't))
     ; 'tな式で'tを置き換える
     ((E A A Q) (equal-if (natp (wt (cdr x))) 't))
```

ことで

```
    :
     (if (equal (natp (wt (cdr x))) 't)
         (if (natp (wt (cdr x)))              ; 前提ができた
             (equal (natp (+ (+ (wt (car x))
                                (wt (car x)))
                             (wt (cdr x))))
                    't)
             't)
         't)
    :
```

この作戦は使える

同様にして`(natp (wt (car x)))`の前提も作る

> もうひとつは
> 前提を`(natp (wt (car x))`、`(natp (wt (car x))`にできても公理と前提から直接言えるのは
> `(natp (+ (wt (car x)) (wt (car x)))`とか
> `(natp (+ (wt (car x)) (wt (cdr x)))`とかだけ
> ってこと

これも同じ作戦で

`(natp (+ (wt (car x)) (wt (car x)))`という前提を作る

```
     ((E A A A) (if-true (if (natp (wt (cdr x)))
                             (equal (natp (+ (+ (wt (car x))
                                                (wt (car x)))
                                             (wt (cdr x))))
                                    't)
                             't)
                         't))
     ; (natp (wt (car x))という前提を使ってさらに新しい前提を入れる
     ((E A A A Q) (natp/+ (wt (car x)) (wt (car x))))
```

するとこうなるので

```
	:
	     (if (natp (+ (wt (car x)) (wt (car x))))   ; これと
	         (if (natp (wt (cdr x)))                ; これを前提として
	             (equal (natp (+ (+ (wt (car x))    ; ここでnatp/+が使える
	                                (wt (car x)))
	                             (wt (cdr x))))
	                    't)
	             't)
	         't)
    :
```

では

```
     ((E A A A A A 1) (natp/+ (+ (wt (car x)) (wt (car x)))
                              (wt (cdr x))))
```

・・・

```
	:
                (if (natp (+ (wt (car x)) (wt (car x))))
                    (if (natp (wt (cdr x)))
                        (equal 't 't)         ; よっしゃー
                        't)
                    't)
	:
```

あとは怒涛の`if-same`で証明終了

これで気分良く

> `(natp (wt x))`を`'t`に書き換えて、外側の`if`を`if-true`で取り除け

ます


