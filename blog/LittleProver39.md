# 定理証明手習い (39) Defun式帰納法

Defun式帰納法、とか言ってまた難しく書いてあります
ていうか前よりわからないので今回も定義にしたがって追ってみます

> 主張 *C*、関数(defun *namef* (*x1* ... *xn*) *bodyf*)、変数 *y1* ... *yn* に対し、 *bodyf* の *x1* を *y1* に、...、 *xn* を *yn* に置き換えた *bodyi* の部分式についての主張を次のように構成する。

まず、主張 *C* はこれってことでいいんだよな
`dethm`は不要かな？

```
(dethm set?/add-atoms (a bs)
  (if (set? bs)
      (equal (set? (add-atoms a bs)) 't)
      't))
```

関数はこれ

```
(defun add-atoms (x ys)
  (if (atom x)
    (if (member? x ys)
        ys
        (cons x ys))
    (add-atoms (car x)
               (add-atoms (cdr x) ys))))
```

なので

*namef* : `add-atoms`
*x1* : `x`
*x2* : `ys`
*bodyf* :

```
(if (atom x)
  (if (member? x ys)
      ys
      (cons x ys))
  (add-atoms (car x)
             (add-atoms (cdr x) ys)))
```

変数 *y1* ... ってのがどこから出てきてるのか書いてない気がするけど
空気を読んで主張と関数を見比べる

*y1* : `a`
*y2* : `bs`

そうすると

*bodyi* :

```
(if (atom a)
    (if (member? a bs)
        bs
        (cons a bs))
    (add-atoms (car a)
               (add-atoms (cdr a) bs)))
```

ではスタート

*bodyi* 全体はifの形だからこっちのルールから

> * (if *Q* *A* *E*)については、 *A*に対する主張を *Ca*、 *E*に対する主張を *Ce*として、「 *Q*の帰納法のための前提が *Cae*を含意する」を主張とする。ただし *Cae*は、 *Ca*と *Ce*が等しい場合は *Ca*で、それ以外の場合については(if *Q* *Ca* *Ce*)である。

ここでは

*Q*: `(atom a)`
*A*: `(if (member? a bs) bs (cons a bs))`
*E*: `(add-atoms (car a) (add-atoms (cdr a) bs))`

*Ca*から考えてみます
えーと「*A*に対する主張」ってなんだっけ？

ちょっとピンとこないので前回やったことから逆算してみようか

> `x`がアトムの場合、関数`add-atoms`は再帰的ではありません。
> その場合については、`set?/add-atoms`が真であるという必要がありますよね。
> つまり、このように書き下せばいいわけですね。
> 
> ```
> (if (set? bs)
>     (equal (set? (add-atoms a bs)) 't)
>     't)
> ```

ああ、そういうこと？
「*A*に対する主張」っていうのは「 *A* に分岐する場合の *C* 」てこと？
*A* の中身はなんにも関係なし？
*A* がまた`(if Q A E)`の形だからルールを再帰的に適用して・・・
って思ってたんですけど、うーん、ちょっと先に進んでみようかな

ここで`set?/add-atoms`を開いてるからできあがりも開いた形になるわけですね
上のように書き下す代わりに`(set?/add-atoms a bs)`でもいけたりするんじゃないかな？

じゃ次 *Ce*
上と同じように考えちゃだめなんだろうな

> こんな単純な帰納的主張でいいんですか？
> 
> ```
> (if (set? bs)
>     (equal (set? (add-atoms a bs)) 't)
>     't)
> ```
> 
> よくありません。

そういうことを言ってたのか
*E* は(if Q A E)の形じゃないから次のルールを適用する、ってことになるのかな？

> * その他の式 *E* については、「 *E* の帰納法のための前提は *C* を含意する」を主張とする。

「帰納法のための前提」の作り方はこれ

> 主張 *C*、再帰的な関数適用(*name* *e1* ... *en*)、変数 *x1* ... *xn* について、この関数適用に対する帰納法のための前提は、 *C*に出てくる *x1* を *e1* に、...、 *xn* を *en* に置き換えたものになる。

最初の関数適用は

`(add-atoms (car a) (add-atoms (cdr a) bs))`

*name* : `add-atoms`
*e1* : `(car a)`
*e2* : `(add-atoms (cdr a) bs)`

といってもどこから始めるかによりますけど
自分は内側から始めたんで逆順になったんでした
ここでは上から見ていって最初に出て来る方、くらいの意味かな

*C* は

```
(if (set? bs)
    (equal (set? (add-atoms a bs)) 't)
    't))
```

*x1* : `x`
*x2* : `ys`

なので

`a`を`(car a)`に、`b`を`(add-atoms (cdr a) bs)`に置き換えてやると

```
(if (set? (add-atoms (cdr a) bs))
    (equal (set? (add-atoms (car a) (add-atoms (cdr a) bs))) 't)
    't)
```

となります
もうひとつの再帰的な関数適用は`(add-atoms (cdr a) bs)`なので同様にすると

```
(if (set? bs)
    (equal (set? (add-atoms (cdr a) bs)) 't)
    't)
```

このふたつが *C* を含意する、を書くと *Ce*ができます

```
(if (if (set? (add-atoms (cdr a) bs))
        (equal (set? (add-atoms (car a) (add-atoms (cdr a) bs))) 't)
        't)
    (if (if (set? bs)
            (equal (set? (add-atoms (cdr a) bs)) 't)
            't)
        (if (set? bs)
            (equal (set? (add-atoms a bs)) 't)
            't)
        't)    
    't)
```

*Ce*が求められたので

> *Cae*は、 *Ca*と *Ce*が等しい場合は *Ca*で、それ以外の場合については(if *Q* *Ca* *Ce*)である。

から

*Cae*は

```
(if (atom a)
    (if (set? bs)
        (equal (set? (add-atoms a bs)) 't)
        't)
    (if (if (set? (add-atoms (cdr a) bs))
            (equal (set? (add-atoms (car a)
                                    (add-atoms (cdr a) bs)))
                   't)
            't)
        (if (if (set? bs)
                (equal (set? (add-atoms (cdr a) bs)) 't)
                't)
            (if (set? bs)
                (equal (set? (add-atoms a bs)) 't)
                't)
            't)
        't))
```

となりました
これでできあがっちゃってるんですけど？

> 「 *Q*の帰納法のための前提が *Cae*を含意する」を主張とする。

*Q* は`(atom a)`で、再帰的な関数適用がひとつもないから

> * 前提が0個の場合、含意は *e0* によって表す。

によってそのまま、ですね
最後に

> *C*の帰納的な主張は、このように構成される *bodyi* 全体に対する主張である。

今作ったのが「*bodyi* 全体に対する主張」なので、これでできあがり！

なんですけど
「部分式」ってところがもやっとしてるんですよね・・・

> *A* がまた`(if Q A E)`の形だからルールを再帰的に適用して・・・
> って思ってたんですけど

のところ
全体、っていうからにはやっぱり部分に再帰していかないと・・・
やってみよう

主張は *C* のままでいいんだろうな
部分式が`(if (member? a bs) bs (cons a bs))`

*Q*: `(member? a bs)`
*A*: `bs`
*E*: `(cons a bs)`

* *A* 、 *E* はどちらもifの形ではないから「 *E* の帰納法のための前提は *C* を含意する」を主張とする」を適用
* 再帰的な関数適用はないから前提0個の含意で *C* そのもの
* 「 *Cae* は、 *Ca* と *Ce* が等しい場合は *Ca* 」から *Cae* も *C* そのもの

てわけか
すっきりした

部分式、っていう言葉だけ取ると
`(add-atoms (cdr a) bs)`を`(add-atoms (car a) (add-atoms (cdr a) bs))`の部分式として扱う、
っていうのもありそうだけどここは部分式に分けるルールがないのでこれでいい気がする

雰囲気でやるだけならなんとなくできちゃったけど、定義にしたがってやるのはなんか大変
100%定義できるのなら自動でできたりするはずだけどどうなんだろう？

