# 定理証明手習い (48) rotate

ついに10章
（といってもラスボスは付録にいると思われる）

`rotate`
なんかこの動きは見たことがある
全体的に言えばrotateしてる感じはあるけど
ミクロに言うと何がどうなっているのかな
コンスの数は4

```
(defun rotate (x)
  (cons (car (car x))
        (cons (cdr (car x)) (cdr x))))
```

ああなるほど
carをcarのcarとcarのcdrに分けて、
carのcdrとcdrをくっつけているのか
こういう動きって応用っていうか何か実用性があったりするのかな

ifも再帰もない
全域性は自明

次は定理

```
(dethm rotate/cons (x y z)
  (equal (rotate (cons (cons x y) z))
         (cons x (cons y z))))
```

上の理解で合ってれば自明だけどJ-Bobは満足しない
`rotate`なんてしらねーよってことかな
`rotate`を展開して、`car/cons`と`cdr/cons`を繰り返したら`equal-same`で証明完了

なんか当たり前といえば当たり前
Lispのインタプリタになったような気分？
ただし評価は適用順じゃなくて正規順

で
この関数が何なのか

# 定理証明手習い (49) align

`align`か
それだ見覚えあったのは
確かそのときも全関数であることの証明だった

```
(defun align (x)
  (if (atom x)
      x
      (if (atom (car x))
          (cons (car x) (align (cdr x)))
          (align (rotate x)))))
```

うんうん
前に出てきた`align`もなんだかよくわからない関数だった

でもよく見ると`rotate`をコアとして
`rotate`がうまく動かないケースをそれっぽく動くようにしてる、っていう感じはする

> `(size x)`は尺度として適切でしょうか？

そういう話ね
なるほど

全域性についての主張の作り方と
帰納法の作り方をやったから
最後に尺度の作り方をやろうってことだな

見え見えだけど話に乗って`(size x)`で証明を進める

```
(if (atom x) 
    't 
    (if (atom (car x))
        't
        (< (size (rotate x)) (size x))))
```

まで来たところで`(rotate x)`を展開かな？と思ったら

> `cons/car+cdr`を2回使うとどうなりますか？

何するの？
あー`(rotate (cons (cons x y) z))`の形に寄せていくのか

> 洞察：繰り返しを避けるために補助定理を用意しよう

これ前に出てこなかったっけ？
大事なことだから2回言った？

> 洞察：帰納法の補助定理を作るべし

少し違った
大事なのは間違いないけど

しかしここで行き止まり
`rotate`してもコンスの回数が変わらないことは章の冒頭で確認済み

っていう話はここまで変形しないと言えないもの？

```
(if (atom x)
  't
  (if (atom (car x))
    't
    (< (size (cons (car (car x)) (cons (cdr (car x)) (cdr x))))
       (size (cons (cons (car (car x)) (cdr (car x))) (cdr x))))))
```

反例なら上に上げた主張の時点でもう言えてたと思うけど
逆にここまで来たら

```
(size (cons (car (car x)) (cons (cdr (car x)) (cdr x))))
```

と

```
(size (cons (cons (car (car x)) (cdr (car x))) (cdr x))))))
```

が等しい、くらい言えないものか
うんさっぱり見当がつきません
ていうか公理が足りなさそうだ
こんなのがあればできるかな（あと足し算）

```
(dethm )
(equal (size (cons a b)) (+ (size a) (size b) 1))
```

> たぶん、`(size x)`は適切な尺度ではないんですよ。

結局尺度っていうのは証明に使えるようなうまい式を探して書く、ってことなんだな
