# 定理証明手習い (7) やっぱりテスト風に

公理を書き換えたりすると今までの結果が全部怪しくなるのでやっぱりテストを書こう
でもフレームワークっていうほどのものじゃないからちょっとだけ自分で書くことに

`my/test`をマクロにしてるのは、`'`を取ったり付けたりするのに
それ以外に方法を思いつかなかったからです

```
(define my/test/passed 0)
(define my/test/failed 0)

(define-syntax my/test
  (syntax-rules ()
    ((_ name actual expected)
     (let ((act actual))
       (if (equal (quote expected) actual)
           (set! my/test/passed (+ my/test/passed 1))
           (begin
             (display name)
             (display " actual:")
             (display act)
             (display " expected:")
             (display (quote expected))
             (newline)
             (set! my/test/failed (+ my/test/failed 1))))))))

(define (my/test/result)
  (display "Test passed:")
  (display my/test/passed)
  (display " failed:")
  (display my/test/failed)
  (display " total:")
  (display (+ my/test/passed my/test/failed))
  (newline))
```

Schemeって`display`並べるしかないんだっけ？
(Scheme使うたびに思ってる気がする)

これでこんな風に書いて

```
(my/test
 "chapter1.example1"
 (J-Bob/step (my/prelude)
   '(car (cons 'ham '(eggs)))
   '(((1) (cons 'ham '(eggs)))
     (() (car '(ham eggs)))))
 'ham)

(my/test
 "chapter1.example2"
 (J-Bob/step (my/prelude)
   '(atom '())
   '((() (atom '()))))
 't)

(my/test
 "chapter1.example3"
 (J-Bob/step (my/prelude)
   '(atom (cons a b))
   '((() (atom/cons a b))))
 't) ; わざと間違えた

(my/test/result)
```

実行するとこんな結果

```
chapter1.example3 actual:'t expected:'nil
Test passed:2 failed:1 total:3
```

十分
新しい例が出たら最初はこんな風に追加しておいて

```
(my/test
 "chapter1.example6"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '())
 't)
```

実行

```
chapter1.example6 actual:(atom (cdr (cons (car (cons p q)) '()))) expected:'t
Test passed:5 failed:1 total:6
```

ここからひとつずつ置き換えを追加していって、テストが通ったら付録Bを見て答え合わせ
パターンできた感じ

ただしプリティプリントしてくれないので式が長くなるときは
そのまま値を出力してもらったほうがいいかもしれない
（REPLはプリティプリントしてくれる）