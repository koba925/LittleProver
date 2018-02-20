# 定理証明手習い (40) 種

リスト型帰納法やスター型帰納法はDefun帰納法に含まれるそうです

リスト型帰納法は`list-induction`から作ります

```
(defun list-induction (x)
  (if (atom x)
      '()
      (cons (car x) (list-induction (cdr x)))))
```

`memb?/remb`あたりでやってみましょうか

```
(equal (memb? (remb xs)) 'nil)
```

・・・

ここは、`remb`から作るんじゃないの？
`set?/add-atoms`は`add-atoms`から作ったんだから
どういうこと？

```
(defun remb (xs)
  (if (atom xs)
      '()
      (if (equal (car xs) '?)
          (remb (cdr xs))
          (cons (car xs) (remb (cdr xs))))))
```

構造は同じだから、`list-introduction`を`remb`だと思ってやれってことかな
ということは逆に、`remb`を種にしても？

```
> (J-Bob/prove (dethm.memb?/remb2)
    '(((dethm memb?/remb (xs)
         (equal (memb? (remb xs)) 'nil))
       (remb xs))))
(if (atom xs)
  (equal (memb? (remb xs)) 'nil)
  (if (equal (memb? (remb (cdr xs))) 'nil) (equal (memb? (remb xs)) 'nil) 't))
```

おーできたできた

> 100%定義できるのなら自動でできたりするはずだけどどうなんだろう？

なんて思ってましたがすでに自動でできてたというわけで

じゃあ`list-introduction`は何のために？
一般化とか抽象化とかそういうのかな
あと、少しDefun式をやるときの手間も減るか そうか

じゃあこういうつもりで

```
(defun remb (x)
  (if (atom x)
      '()
      (cons (car x) (remb (cdr x)))))
```

ざっくりやると

*Q* : `(atom x)`
*Ca* : `(equal (memb? (remb xs)) 'nil)`
*Ce* : 

```
(if (equal (memb? (remb (cdr xs)) 'nil))
    (memb? (remb xs))
    't)
```

から

```
(if (atom x)
    (equal (memb? (remb xs)) 'nil)
    (if (equal (memb? (remb (cdr xs)) 'nil))
        (memb? (remb xs))
        't))
```

になる、と
よし

`star-induction`も同じでしょう
逆に、`set?/add-atoms`にはどんな種を与えるのかと思ってましたが
そっちも謎が解けました
`(add-atoms a bs)`を与えてやればいいんですね

```
> (J-Bob/prove (defun.atoms)
    '(((dethm set?/add-atoms (a bs)
         (if (set? bs)
             (equal (set? (add-atoms a bs)) 't)
             't))
       (add-atoms a bs))))
(if (atom a)
  (if (set? bs) (equal (set? (add-atoms a bs)) 't) 't)
  (if (if (set? (add-atoms (cdr a) bs)) (equal (set? (add-atoms (car a) (add-atoms (cdr a) bs))) 't) 't)
    (if (if (set? bs) (equal (set? (add-atoms (cdr a) bs)) 't) 't)
      (if (set? bs) (equal (set? (add-atoms a bs)) 't) 't)
      't)
    't))
```

出た出た

`list-induction`みたいなのも作れるかな？

```
> (J-Bob/prove (defun.atoms)
    '(((defun flatten-induction (x ys)
         (if (atom x)
             (cons x ys)
             (flatten-induction (car x)
               (flatten-induction (cdr x) ys))))
       nil)
      ((dethm set?/add-atoms (a bs)
         (if (set? bs)
             (equal (set? (add-atoms a bs)) 't)
             't))
       (flatten-induction a bs))))
(if (atom a)
  (if (set? bs) (equal (set? (add-atoms a bs)) 't) 't)
  (if (if (set? (flatten-induction (cdr a) bs))
        (equal (set? (add-atoms (car a) (flatten-induction (cdr a) bs))) 't)
        't)
    (if (if (set? bs) (equal (set? (add-atoms (cdr a) bs)) 't) 't)
      (if (set? bs) (equal (set? (add-atoms a bs)) 't) 't)
      't)
    't))
```

一瞬うまく行った気がしましたが前半の前提で`flatten-induction`が残ってしまいました
何か間違ってるのかなあ
証明を入れても変わらないし
もしかしてJ-Bobでは書けないとか？だから`xxxx-induction`みたいにしてないとか？
いやそれはないな
ただの間違いだろう
でもわからないので進む
きっと付録Cまで行けばわかる
