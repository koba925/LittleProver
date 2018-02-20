# 定理証明手習い (34) 全域性の主張の作り方2

っていう話を

> 関数 (defun *name* (*x1* ... *xn*) *body*) および尺度 *m* が与えられたら、 *body* の部分式に対して次のようにして主張を構成する。

とか言って難しく書いてあります
難しいので`add-atoms`を1字1句このとおりにやってみます

```
(defun add-atoms (x ys)
  (if (atom x)
    (if (member? x ys)
        ys
        (cons x ys))
    (add-atoms (car x)
               (add-atoms (cdr x) ys))))
```

*name* が`add-atoms`、
*x1* が`x`、
*x2* が`ys`、
*body* が

```
(if (atom x)
  (if (member? x ys)
      ys
      (cons x ys))
  (add-atoms (car x)
             (add-atoms (cdr x) ys)))
```

*m* が`(size x)`、となります

*body* は`(if Q A E)`の形をしてますからまずはこのルールから

> - Q、A、Eに対する主張が *Cq* 、 *Ca* 、 *Ce* であるとき、(if Q A E)であれば、 *Ca* および *Ce* が同じなら *Cq* と *Ca* の連言を主張とし、そうでなければ *Cq* と (if *Q* *Ca* *Ce*)の連言とする。

（これルール2と呼びますね）

しかしそのためにはQ、A、Eに対する主張を調べる必要があります
ここでは以下の通り

Qは`(atom x)`
Aは`(if (member? x ys) ys (cons x ys))`
Eは`(add-atoms (car x) (add-atoms (cdr x) ys))`

Qからいきますか
これは`(if Q A E)`の形ではないのでこのルールを適用します

> - それ以外の式 *E* については、 *E* に出てくる再帰的な関数適用(*name* *e1* ... *en*)を調べる。まず、尺度 *m* に出てくる *x1* を *e1* に、...、 *xn* を *en* に置き換えることで、再帰的な関数適用に対する尺度 *mr* を作る。 *E* についての主張は、 *E* に出てくる再帰的な関数適用のそれぞれについての(< *mr* *m*)の連言とする。

（ルール3）

ここの *E* は`(if Q A E)`のEとは別です

さてQには再帰的な関数適用がありません
再帰的な関数適用がない場合について書いてねーじゃねーか！とツッコミたくなりますが

> 式 *e1* 、...、* en* の **連言** とは、 *e1* , ...,  *en* のそれぞれが真でなければならないということ。
> - 0個の式の連言は、`'t`である。

って書いてありました スキはなかった
ということで *Cq* は`'t`

つぎA
これは`(if Q A E)`の形なので再帰的にルールを適用します
ここでは

Q `(member? x ys)`
A `ys`
E `(cons x ys)`

Qから考えると、これは関数適用だけど再帰的な関数適用ではないのでここでも *Cq* は`'t`ということでいいですよね？
`member?`の全域性はすでに証明済みって風に考えればいいのかな？

Aに関してはこのルールで

> - 変数及びクォートされたリテラルであれば、`'t`を主張とする。

（ルール1）

*Ca* も`'t`

*Ce* もはルール3から`'t`ですね

*Ca* と *Ce* が同じなので`(if (member? x ys) ys (cons x ys))`の主張は *Cq* と *Ca* の連言、
すなわち`(if 't 't 'nil)` = `'t`となります

えーと元の式に戻って
次はE:`(add-atoms (car x) (add-atoms (cdr x) ys))`を考えます
ルール3ですね

まずは関数適用`(add-atoms (car x) (add-atoms (cdr x) ys))`について考えます
尺度 *m*:`(size x)`に出てくる *x1*:`x`を *e1*:`(car x)`に、
*x2*:`ys`を *e2*:`(add-atoms (cdr x) ys))`に置き換えると
この関数適用に対する尺度 *mr*:`(size (car x))`が出てきます
*E* に出てくる再帰的な関数適用はもうひとつ`(add-atoms (cdr x) ys)`があります
こちらも同様にするとこちらの尺度 *mr* は`(size (cdr x))`となります

> *E* についての主張は、 *E* に出てくる再帰的な関数適用のそれぞれについての(< *mr* *m*)の連言とする。

`(< mr m)`はそれぞれ
`(< (size (car x)) (size x))`
`(< (size (cdr x)) (size x))`となり
*Ce* はそれらの連言で
`(if (< (size (car x)) (size x)) (< (size (cdr x)) (size x)) 'nil)`となります

いったん整理

*Cq*: `'t`
*Ca*: `'t`
*Ce*: `(if (< (size (car x)) (size x)) (< (size (cdr x)) (size x)) 'nil)`

ルール2の

> そうでなければ *Cq* と(if *Q Ca Ce*)の連言とする。

にしたがうと *body* に対する主張は

```
(if 't 
  (if (atom x) 
      't 
      (if (< (size (car x)) (size x)) 
          (< (size (cdr x)) (size x))
          'nil))
  'nil)
```

となります
最後に

> 関数 name の全域性についての主張は、 *(natp m)* と *body* に対する主張の連言になる。

にしたがって

```
(if (natp (size x))
  (if 't 
    (if (atom x) 
        't 
        (if (< (size (car x)) (size x)) 
            (< (size (cdr x)) (size x))
            'nil))
    'nil)
  'nil)
```

できあがり！

なんですけど`if-true`しておきますか

```
(if (natp (size x))
  (if (atom x) 
      't 
      (if (< (size (car x)) (size x)) 
          (< (size (cdr x)) (size x))
          'nil))
  'nil)
```

これで本と同じ形に

> おおざっぱに考えると
> (if (natp (size x)) ... 'nil)はオマジナイで
> あとは関数の形をもとにしつつ
> (car x)や(cdr x)を見かけたらsizeが小さくなっていくことを
> 確かめるって感じでしょうか
> (equal x '?)は全域だってわかってるから'tに変換するってことかな
> でも全域だからって(atom x)を'tに置き換えちゃうとこれは変
> 明確なルールにするとすればどうなるんでしょう？
> Q部はそのままとか？
> もうちょっと何かありそう
> Q部が再帰することもあるでしょうし
> その時は1段ifを増やしてsizeが減ってることを言うんでしょうか

ま、まあだいたいあってる（ことにする

