# 定理証明手習い (14) 証明ゴルフ？

この証明がもうちょっと短くできますねと書いてあります

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1 1) (pair a '?))
     ((1) (in-pair? (cons a (cons '? '()))))
     ((1 Q 1) (first-of (cons a (cons '? '())))) ; ここと
     ((1 Q 1) (car/cons a (cons '? '()))) ; ここが不要
     ((1 E 1) (second-of (cons a (cons '? '()))))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal a '?) 't))
     (() (equal-same 't)))))
```

不要な行を削除
式の形が変わるので、下から２行目も変更しました

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1 1) (pair a '?))
     ((1) (in-pair? (cons a (cons '? '()))))
     ((1 E 1) (second-of (cons a (cons '? '()))))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal (first-of (cons a (cons '? '()))) '?) 't))
     (() (equal-same 't)))))
```

その下から２行目、微妙に長い気がします
ここは`cons`に展開されてなくてもいいところ
`pair`の評価をあとに回せば`first-of`の方は展開しなくて済みます

```
(J-Bob/prove (dethm.in-first-of-pair)
  '(((dethm in-second-of-pair (a)
       (equal (in-pair? (pair a '?)) 't))
     nil
     ((1) (in-pair? (pair a '?)))
     ((1 E 1) (second-of (pair a '?)))
     ((1 E 1 1 1) (pair a '?))
     ((1 E 1 1) (cdr/cons  a (cons '? '())))
     ((1 E 1) (car/cons '? '()))
     ((1 E) (equal-same '?))
     ((1) (if-same (equal (first-of (pair a '?)) '?) 't))
     (() (equal-same 't)))))
```

この方がちょっと気持ちいいかな
これって、関数の評価順を自由に変えてるってことになるわけか

> 洞察：無関係な式は飛ばそう

なるほど

あと`(equal-same '?)`を`(equal '? '?)`に変更すればさらに２文字・・・
これはあんまり意味がないからやめておこう
公理で言えるときは公理で言っておくほうがスジがいいのかな

