# 定理証明手習い (19) atom

前回の`list?`シリーズで`list?`のA部の`(equal x '())`(=`list0?`)が
`list1?`や`list2?`では`'nil`に置き換えられているのは
何か一般的な書き換え規則があるんでしょうか
Scheme風に書いた方では`#t`が`#f`になってます
何かあるような気がしますが思いつきません

他の再帰する関数でやってみるとどうなるかな

ちょっと先回りして`remb`という関数を持ってきました
Booleanじゃない関数の方が違いがわかるかなと思って

```
(defun remb (xs)
  (if (atom xs)
      '()
      (if (equal (car xs) '?)
          (remb (cdr xs))
          (cons (car xs) (remb (cdr xs))))))
```

ちょっと長いですがやってみます
こう・・・かなあ？

```
(defun remb0 (xs) '())

(defun remb1 (xs)
  (if (atom xs)
      '()
      (if (equal (car xs) '?)
          (remb0 (cdr xs))
          (cons (car xs) (remb0 (cdr xs))))))

(defun remb2 (xs)
  (if (atom xs)
      '()
      (if (equal (car xs) '?)
          (remb1 (cdr xs))
          (cons (car xs) (remb1 (cdr xs))))))
```

さっきの話をあてはめてみると`remb`のA部の`'()`が`remb0`と同じで、
`remb1`や`remb2`のA部では何かに置き換えられる・・・
いやそこ意味ないんじゃないの？
なんでもいいのかな

`list1?`は長さ1のリストかどうかを判定する関数だからどんな長さのリストでも
わかりやすい値が決まりますが
`remb1`は長さ1のリストから`'?`を削除する関数だと考えると
長さ1のリスト以外では意味のある値を持ちませんね
部分関数の時の話からすると、そういうときはなんでもいいってことですかね？
なんでもいいことにしました

なんでもいいことにするとしたら、`remb0`はむしろこういう形？

```
(defun remb0 (xs) 
  (if (atom xs)
      '()
      (なんでもいい))

(defun remb1 (xs)
  (if (atom xs)
      (なんでもいい)
      (if (equal (car xs) '?)
          (remb0 (cdr xs))
          (cons (car xs) (remb0 (cdr xs))))))

(defun remb2 (xs)
  (if (atom xs)
      (なんでもいい)
      (if (equal (car xs) '?)
          (remb1 (cdr xs))
          (cons (car xs) (remb1 (cdr xs))))))
```

こう考えれば`remb`と`remb0`・`remb1`・`remb2`の関係は明確になってるか
これでいいか

