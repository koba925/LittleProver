# 定理証明手習い (29) もうちょっとなんとか

前回の記事書いてみて思ったのは
`((A A 1 1) (equal-if x '?))`とかを並べて書いてあるコードを見るより
途中経過の式を並べたものを見るほうがわかりやすいなってこと
本には書いてあるんですけどね
J-Bobの証明でも途中経過がもっと自由自在に見られると楽そう
行ったり来たりできるデバッガみたいな感じで
GUIがいいかもね
ていうか途中経過の式の方を並べて証明にするってのはできないかな？
・・・
ちょっと変かな
両方書いたら煩雑だし

まあそれはともかく
証明も長くなってきてそろそろこれは人間には読めなくなってきてるのでは
ソフトウェア工学的にはこれは分割しなきゃなんじゃないの

ってことで`ctx?/t`が出てきたところで

> 洞察：機能法の補助定理を作るべし

てなってます

が
前回自分でやってみた補助定理の証明がこれですよ
遠回りがあるかもしれないけど

```
(J-Bob/prove (defun.ctx?)
  '(((dethm ctx?/t (x)
       (if (ctx? x)
           (equal (ctx? x) 't)
           't))
     (star-induction x)
     ((A Q) (ctx? x))
     ((A A 1) (ctx? x))
     ((A Q) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((A A 1) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((A A 1 1) (equal-if x '?))
     ((A A 1) (equal '? '?))
     ((A A) (equal 't 't))
     ((A) (if-same (equal x '?) 't))
     ((E A A Q) (ctx? x))
     ((E A A A 1) (ctx? x))
     ((E A A Q) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((E A A A 1) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((E A A) (if-same (ctx? (car x))
                       (if (if (ctx? (car x)) 't (ctx? (cdr x)))
                           (equal (if (ctx? (car x)) 't (ctx? (cdr x))) 't)
                           't)))
     ((E A A A Q) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A A A 1) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A A A) (equal 't 't))
     ((E A A A) (if-same 't 't))
     ((E A A E Q) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A E A 1) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ((E) (if-same (ctx? (car x))
                   (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
                       (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           (if (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
                           't)
                       't)))
     ((E A Q) (if-nest-A (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E A A A) (if-nest-A (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)))
     ((E E Q) (if-nest-E (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E E A A) (if-nest-E (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)))
     ((E E) (if-true (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         't)
                     't))
     ((E A A) (if-same (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't) 't))
     ((E A) (if-same (equal (ctx? (car x)) 't) 't))
     ((E E) (if-same (ctx? (cdr x))
                     (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         't)))
     ((E E A Q) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E A A) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E E Q) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E E A) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E A A 1) (equal-if (ctx? (cdr x)) 't))
     ((E E E) (if-same 't 't))
     ((E E A A) (equal 't 't))
     ((E E A) (if-same (equal (ctx? (cdr x)) 't) 't))
     ((E E) (if-same (ctx? (cdr x)) 't))
     ((E) (if-same (ctx? (car x)) 't))
     (() (if-same (atom x) 't)))))
```

何やってるかさっぱりわかりませんね
(さすがにif持ち上げのパターンはちょっと見えるようになってきたかも)
さらにもっと補助定理を増やして分割できないもんですかね

この前定理にできなかったifの持ち上げは
上のリスト見てたらどっちみち定理にできない気がしてきましたが
ほかにも定理にできるパターンがあるんじゃないかな？
全域性の証明で毎回出てくる`(if (natp (size x)) ... 'nil)`ってやつとか
`(equal (if (natp (size x)) y 'nil) y)`を定理にしてしまえばちょっと楽できるし
そんな感じで

このリストで言えば・・・
言えば・・・
あんまりいい感じにくくり出せそうなところがないな
えー

たとえば`(equal (if 't (equal 't 't) 't) 't)`を定理にしても
なんというか汎用性に欠けるというかひとかたまりとしての働きっぽくないというか
名前がつけづらいというのが象徴してる感じ

コメントでも付ける？

```
(J-Bob/prove (defun.ctx?)
  '(((dethm ctx?/t (x)
       (if (ctx? x)
           (equal (ctx? x) 't)
           't))
     (star-induction x)
     ; A部の(ctx? x)を展開
     ((A Q) (ctx? x))
     ((A A 1) (ctx? x))
     ; (if (atom x) を消去
     ((A Q) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((A A 1) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ; 整理
     ((A A 1 1) (equal-if x '?))
     ((A A 1) (equal '? '?))
     ((A A) (equal 't 't))
     ((A) (if-same (equal x '?) 't))
     ; E部の(ctx? x)を展開
     ((E A A Q) (ctx? x))
     ((E A A A 1) (ctx? x))
     ; (if (atom x) を消去
     ((E A A Q) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ((E A A A 1) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
     ; (if (ctx? (car x)) を持ち上げ
     ((E A A) (if-same (ctx? (car x))
                       (if (if (ctx? (car x)) 't (ctx? (cdr x)))
                           (equal (if (ctx? (car x)) 't (ctx? (cdr x))) 't)
                           't)))
     ((E A A A Q) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A A A 1) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A E Q) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A E A 1) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ; 整理
     ((E A A A A) (equal 't 't))
     ((E A A A) (if-same 't 't))
     ; (if (ctx? (car x)) を持ち上げ
     ((E) (if-same (ctx? (car x))
                   (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
                       (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           (if (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
                           't)
                       't)))
     ((E A Q) (if-nest-A (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E A A A) (if-nest-A (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)))
     ((E E Q) (if-nest-E (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E E A A) (if-nest-E (ctx? (car x)) 't (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)))
     ; 整理
     ((E E) (if-true (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         't)
                     't))
     ((E A A) (if-same (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't) 't))
     ((E A) (if-same (equal (ctx? (car x)) 't) 't))
     ; (if (ctx? (cdr x)) を持ち上げ
     ((E E) (if-same (ctx? (cdr x))
                     (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         't)))
     ((E E A Q) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E A A) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E E Q) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ((E E E A) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
     ; 整理
     ((E E A A 1) (equal-if (ctx? (cdr x)) 't))
     ((E E E) (if-same 't 't))
     ((E E A A) (equal 't 't))
     ((E E A) (if-same (equal (ctx? (cdr x)) 't) 't))
     ((E E) (if-same (ctx? (cdr x)) 't))
     ((E) (if-same (ctx? (car x)) 't))
     (() (if-same (atom x) 't)))))
```

まあわかりやすくなったと言えば・・・

って`(if (ctx? (car x))`の持ち上げ2回続けてやってるな
前提に手をつけない→付けざるを得ないのコンボのところか
ここは1回でいいだろ

```
     ; (if (ctx? (car x)) を持ち上げ
     ((E) (if-same (ctx? (car x))
                   (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
                       (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           (if (if (ctx? (car x)) 't (ctx? (cdr x)))
                               (equal (if (ctx? (car x)) 't (ctx? (cdr x))) 't)
                               't)
                           't)
                       't)))
     ((E A Q) (if-nest-A (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E A A A Q) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E A A A A 1) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
     ((E E Q) (if-nest-E (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
     ((E E A A Q) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ((E E A A A 1) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
     ; 整理
     ((E A A A A) (equal 't 't))
     ((E A A A) (if-same 't 't))
     ((E E) (if-true (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                         't)
                     't))
     ((E A A) (if-same (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't) 't))
     ((E A) (if-same (equal (ctx? (car x)) 't) 't))
```

少ーし短くなったか
コメントのおかげ
しかしもうちょっとなんとかならないかな
