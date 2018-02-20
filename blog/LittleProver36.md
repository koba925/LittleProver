# 定理証明手習い (36) スターではない

8章から続いて、`atoms`関連の関数・定理について考えていきます
`set?`は`member?`を呼び出しているのでだんだんこの世界も複雑になってきました
`set?`、`member?`、`add-atoms`の全域性については8章で証明済みです

```
(dethm set?/atoms (a)
  (equal (set? (atoms a)) 't))

(dethm set?/add-atoms (a)
  (equal (set? (add-atoms a '())) 't))

(defun add-atoms (x ys)
  (if (atom x)
    (if (member? x ys)
        ys
        (cons x ys))
    (add-atoms (car x)
               (add-atoms (cdr x) ys))))
```

まず、`set?/add-atoms`をスター型帰納法で証明しようとしますが
1回`add-atoms`を展開してこういう形になったところで

```
  :
  (if (equal (set? (add-atoms (car a) '())) 't)
    (if (equal (set? (add-atoms (cdr a) '())) 't)
      (equal
       (set? (if (atom a)
                 (if (member? a '()) '() (cons a '()))
                 (add-atoms (car a) (add-atoms (cdr a) '()))))
  :
```

前提と関数適用の形がマッチしないからスター型帰納法はつかえそうにありませんね、と
あきらめてしまってますが
7章では、帰納法の前提に合った形にするためにいろいろがんばった気がします
こんなに簡単にあきらめてしまっていいんでしょうか

7章の証明を同じくらいのタイミングで止めるとこうなってます

```
    :
    (if (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't)
      (if (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't)
        (if (ctx? y)
          (equal (ctx? (if (atom y)
                           (if (equal y '?) x y)
                           (cons (sub x (car y)) (sub x (cdr y))))) 't)
    :
```

たしかにぴったりマッチしてる
これでいろいろがんばったくらいだから今回は無理か

ところで上の形はこれで普通に出力されます

```
(J-Bob/prove (defun.atoms)
  '(((dethm set?/add-atoms (a)
       (equal (set? (add-atoms a '())) 't))
     (star-induction a)
     ((E A A 1 1) (add-atoms a '())))))
```

使えない帰納法だからと言ってエラーになったりはしないんですね
`list-induction`でも`list-induction`なりの式が出てきます
（まあ`nil`でもエラーにはならないわけだから）
種とは何なのか どう使われてるのか

というわけで

> この関数に合った帰納法のための前提が必要です。

`list-induction`や`star-induction`を元にしたものだけではなく、
いろんな帰納法があるってことですね
そしてまず前提だけ考えてみると

ここでは、とりあえずやってみてだめだったら他の方法を考える、そういうものです、
ってことも言おうとしてるんでしょうか
それとも単にスター型じゃうまくいかないことを見せたかっただけなのか

