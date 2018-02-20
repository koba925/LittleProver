# 定理証明手習い (38) 帰納法を作る

ということで`add-atoms`用の帰納法が作れるのならどんなものでしょうか
`list-induction`のときは主張を読んでみたら普通に帰納法だねって感じだったので
まず自分で普通に考えてみます

再掲（何度目

```
(defun add-atoms (x ys)
  (if (atom x)
    (if (member? x ys)
        ys
        (cons x ys))
    (add-atoms (car x)
               (add-atoms (cdr x) ys))))
```

こんな感じですかね

```
aがアトムのとき
  (set? (add-atoms a '())) であること
aがアトムでないとき
  (set? (add-atoms (cdr a) bs)) かつ
  (set? (add-atoms (car a) (add-atoms (cdr a) bs))) ならば
  (set? (add-atoms a '())) であること
```

`(set? (add-atoms (car a) (add-atoms (cdr a) bs)))ならば`のところが
ちょっと長い感じがします
`(set? (add-atoms (cdr a) bs))`であるということはすでに言っているので
`(set? (add-atoms (car a) bs))ならば`でいいのかな
いやそれだと`bs`がなんでもいいことになってしまうか

ていうか`add-atoms`の`ys`って`set?`なんだっけか
それは定義域の話？
`set?`じゃなければ値は未定義でなんでもいいけど関数は全域ね、ってやつ？
`set?/add-atoms`では`'()`からスタートだから常に`(set? ys)`は満たされてる感じではあります

では本の流れに沿って見ていきます
スタートは`(equal (set? (add-atoms a '())) 't))`
`add-atoms`の引数を変数にして`(equal (set? (add-atoms a bs) 't))`
これは`bs`が`set?`のときに成り立つので
`(if (set? bs) (equal (set? (add-atoms a bs) 't)))`となります
これを定理にします

```
(dethm set?/add-atoms (a bs)
  (if (set? bs)
      (equal (set? (add-atoms a bs)) 't)
      't))
```

`set?/add-atoms`は1引数で定義されてましたが
スター型再帰じゃだめだったからこっちで上書きってことですかね
引数の数は違いますが多相ってわけじゃない気がするので

たぶんここ↓が核心

> `set?/add-atoms`についての帰納的な主張で言うべきことは、「関数`add-atoms`が再帰的に呼ばれない場合には`set?/add-atoms`は真であり、再帰的に呼ばれる場合にはその関数適用の引数について`set/add-atoms`が真であるならばもとの引数についても真である」です。

えーと
再帰的に呼ばれない場合はいいとして再帰的に呼ばれるときはと

`add-atoms`を再帰的に呼んでいるのは`(add-atoms (car x) (add-atoms (cdr x) ys)))`のところ
2回呼んでますね
1回目（内側）は引数が`(cdr x)`と`ys`なので
`(set?/add-atoms (cdr x) ys)`が真であること
2回目（外側）は引数が`(car x)`と`(add-atoms (cdr x) ys))`なので
`(set?/add-atoms (car x) (add-atoms (cdr x) ys)))`が真であること
となります

こういうことかな

```
(if (atom? x)
    (set?/add-atoms x ys)
    (if (set?/add-atoms (cdr x) ys)
        (if (set?/add-atoms (car x) (add-atoms (cdr x) ys))
            (set?/add-atoms x ys)
            't)
        't))
```

`set?/add-atoms`を開くとテキストに出てくる形に・・・なってないな
変数名は置いとくとしても
前提の内と外が逆か
順番は大事かな？
大丈夫そうな感じはするけど
それさえOKなら最初に考えた通り

テキストは先に`set?/add-atoms`を開いててちょっと見づらくなってる気がします
先に開いておかないといけない訳があるんでしょうか

直接の対象は`set?/add-atoms`だけど`add-atoms`を見てその再帰のパターンで
`set?/add-atoms`の中身を置き換えてやったり
`set?`だって再帰的な関数なのに`add-atoms`ばっかり出てくるあたりは
相変わらずもやっとしたまま
`set?`の方も考えなきゃいけないパターンはないのかなあ

