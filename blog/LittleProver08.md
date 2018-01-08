# 定理証明手習い (8) 増殖

1章のラスト近く
式を簡単にしていくのではなく複雑にしていっています
こうやっていくらでも式をでっちあげられるから定理の自動証明は難しいんだ、
っていうアピールですかね？

```
(my/test
 "chapter1.example11"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (car (cons (cdr x) (car y))) '(oats)))
     ((2 2 2) (atom/cons (atom (cdr (cons a b))) (equal (cons a b) c)))
     ((2 2 2 1 1 1) (cdr/cons a b))
     ((2 2 2 1 2) (equal-swap (cons a b) c))))
 (cons y (equal (car (cons (car (cons (cdr x) (car y))) '(oats)))
                (equal (atom x)
                       (atom (cons (atom b) (equal c (cons a b))))))))
```

1ステップずつ追加しながら見ていきますが少々つらい
練習にはなりました

なにかもうちょっと楽ができるUIがほしい感じ
置き換え対象をカーソルとかマウスで指定できたり
途中経過と並べて表示できたりするといいかなあ
GUIにしてくれる神が現れたりしないものか

あとここにマッチしようとしてるけどしなかったとか
せめてせめてエラーチェックだけでも
公理の名前が間違ってたり各ステップを囲むカッコが抜けてたり（よくやる）しても
何も言わないので悩むことがたびたび

j-bob.scm見てなにかちょっとできないかと思いましたが
すぐにはどこをいじっていいものか

きっと普通にやるぶんにはもうちょっと楽だと信じて進みます

あと、expectedをクォートしなくていいようにわざわざマクロ使って書いたテストですが
actualの式にクォートがついてるのにexpectedについてないというのは逆に不自然な気がして
やっぱりクォートを付けて書くことにしました
それにともなってテストは普通の関数で書けるように

```
(define (my/test name actual expected)
  (if (equal expected actual)
      (set! my/test/passed (+ my/test/passed 1))
      (begin
        (display name)
        (display "\nactual  :")
        (display actual)
        (display "\nexpected:")
        (display expected)
        (newline)
        (set! my/test/failed (+ my/test/failed 1)))))
```

