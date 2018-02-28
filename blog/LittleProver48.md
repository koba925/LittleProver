# 定理証明手習い (48) rotate

ついに10章
（といってもラスボスは付録Cにいると思われる）

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
