# 定理証明手習い (42) `set?/add-atoms`の証明

テキストに沿って証明を進めます
ここ、自分で考えたらやっぱりけっこう大変なんだろうなあ

59コマ目、`(if (member? a bs) bs (cons a bs))`のインデントが変？
それはともかくとして
ここで`(member? a bs)`を持ち上げるっていう発想がまず出てこない気がしますが
あれかな

> 帰納的な主張を構成するときも、全域性の主張を構成するときも、すべてのif式が外側にあることを想定しています。関数適用の引数にあるif式は無視されます。

に似てるのかな
主張の構成は終わってるけど、なにかしら関数の引数がifなのはいい感じじゃないみたいなところは
共通してるとか

> 次の`set?/t`という主張を使います。

`set?/t`の証明は後でいいってやつですね
J-Bob上でも証明は後でいいので

```
(J-Bob/prove (defun.atoms)
  '(((dethm set?/t (xs)
       (if (set? xs)
           (equal (set? xs) 't)
           't))
     nil)
    ((dethm set?/add-atoms (a bs)
    :
```

として進みます

65コマ目

> 下記にオレンジ色で示した２つのif式のQuestion部は、どちらも事実上`(set? (add-atoms (cdr a) bs))`が真かどうかを尋ねる内容です。なので、これもifの持ち上げができます。

事実上ってなんなの

`(set? (add-atoms (cdr a) bs))`と
`(equal (set? (add-atoms (cdr a) bs)) 't)`が同じこと、ってことか
確かに事実上同じことだけど
こういうのが意外と言えなかったりするのは経験済み

`set?/t`が使えるのかな？
うーんだめだな
前提の形が合わない

わからん
しかたがないからやれるところだけやってみよう

まず何はともあれ`(set? (add-atoms (cdr a) bs))`で`if-same`して
`(if (set? (add-atoms (cdr a) bs)) ...`の方を普通に`if-nest`する
E部の方は`if-true`で簡単にして、と
ここからが問題

ここからが・・・

て
もうできてるし

`(equal (set? (add-atoms (cdr a) bs)) 't)`の方が放置だったとは
（次の項目見たらすぐ分かる話だった）

