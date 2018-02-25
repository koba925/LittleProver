# 定理証明手習い (46) set?/nil

A部は`set?`を展開して整理するだけ すぐ終わる
E部はやっぱりまず前提をスルーしてその内側から
`set?`を展開して
`(atom xs)`を整理して
`(member? (car xs) (cdr xs))`で持ち上げて
`(set? (cdr xs))`で持ち上げて
整理してやるだけ

あれ？`set?/t`と変わらないな
こっちの方が難しくなるのかと思ったけど
これなら本文に載らないのもうなずけるか

前に証明しようとしてできなかったのはこれ

```
(dethm equal-nil (a b)
  (if (equal a b) 't (equal (equal a b) 'nil))
```

`a`≠`b`のとき`(equal a b)`がどういう値になるか、なんにも手がかりがなかったんだよな
置き換えたいのはE部だから`equal-if`は使えないし
組み込みだから展開することもできないし
公理もなさそうなんだけど

今回証明したのはこれ

```
(dethm set?/nil (xs)
  (if (set? xs)
      't
      (equal (set? xs) 'nil))
```

主張はこれ

```
(if (atom xs)
    (if (set? xs) 't (equal (set? xs) 'nil))
    (if (if (set? (cdr xs)) 't (equal (set? (cdr xs)) 'nil))
        (if (set? xs) 't (equal (set? xs) 'nil))
        't))
```

`(set? xs)`はどうして`'nil`だと言えたのかというと
A部では`(equal (set? xs) 'nil)`は消えてしまうし
E部ではもうちょっと複雑だけど`set?`を展開して変形している間に消えてしまったり
`set?`の中にある`'nil`が出てきて`(equal 'nil 'nil)`になったり
前提で？消えてしまったりする

```
(defun set? (xs)
  (if (atom xs)
      't
      (if (member? (car xs) (cdr xs))
          'nil
          (set? (cdr xs)))))
```

やっぱり組み込みの関数が返す値について考えるなら公理っていうか仕様がないと難しいよなあ
なんでそういうのがないんだろう
`a`≠`b`のとき`(equal a b)`が`'nil`である、っていうのは不要なのかなあ
