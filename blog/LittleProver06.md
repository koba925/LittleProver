# 定理証明手習い (6) 公理も自分で

ところで

> `prelude`は、J-Bobの公理および最初に用意されている関数の集まりです。

公理も自分で書いてみたい
最初に公理が必要になるのはこれ

```
; chapter1.example3
(J-Bob/step (prelude)
  '(atom (cons a b))
  '((() (atom/cons a b))))
```

j-bob.scmをチラ見して、からっぽのpreludeを作ってみる

```
(defun my/axioms ()
  '())

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))
```

この`my/prelude`を使って実行してみる

```
> (J-Bob/step (my/prelude)
    '(atom (cons a b))
    '((() (atom/cons a b))))
(atom (cons a b))
```

書き換えは起こらない
ていうか`atom/cons`なんてねーよ、っていうエラーになるかと思ったけどそこはハズレ

ここで`my/axioms`を書き換え

```
(defun my/axioms ()
  '((dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))))
```

実行

```
> (J-Bob/step (my/prelude)
    '(atom (cons a b))
    '((() (atom/cons a b))))
'nil
```

できた
ほかの公理も入れておく
追加されたら都度更新

