# 定理証明手習い (30) リベンジ

> これは以前行きづまった
> `(if (equal x '()) 't 'nil)`を`(equal x '())`に変形する
> にちょっと似てる？

さて`(if (equal a b) 't 'nil)`はどうかな
この前挑戦したときは`(if (equal a b) 't 'nil)`を変形して
`(equal a b)`にしようとしてましたが今ならこういう定理を証明するところですね

```
(dethm if-equal-t-nil (a b)
  (equal (if (equal a b) 't 'nil) (equal a b)))
```

前回は

> 考えてみると`(if (equal x '()) 't 'nil)`と`(equal x '())`が
> 同じであるというためには`(equal x '())`が`'t`と`'nil`しか返さないという
> 約束が必要ですね

などと言ってあきらめてましたが
今なら`'t`と`'nil`しか返さないって言えるんじゃないかな
こう表現すればいいよね
くっつけてひとつにしてもいいけど

```
(dethm equal-t (a b)
  (if (equal a b) (equal (equal a b) 't) 't))

(dethm equal-nil (a b)
  (if (equal a b) 't (equal (equal a b) 'nil)))
```

前半はこう

```
(J-Bob/prove (my/prelude)
  '(((dethm equal-t (a b)
       (if (equal a b) (equal (equal a b) 't) 't))
     nil
     ((A 1 2) (equal-if a b))
     ((A 1) (equal-same a))
     ((A) (equal 't 't))
     (() (if-same (equal a b) 't)))))
```

よしよし
後半は・・・あれ？

```
(J-Bob/prove (my/prelude)
  '(((dethm equal-nil (a b)
       (if (equal a b) 't (equal (equal a b) 'nil)))
     nil)))
```

手も足も出ない？
`(equal a a)`は公理で`'t`にできるけど`(equal a b)`ってどうしたらいいんだ？
真は`'t`以外でも何でもいいからちゃんと証明しないといけないけど
偽は`'nil`しかないから問題ないと思ってたんだけどなあ？
やっぱり`equal-nil`は公理にしていただけませんか？

# 定理証明手習い (31)
> 次のフォーカスで`ctx?/t`を使えるでしょうか？
> はい、オレンジ色で示したぜんていがあるので使えます。あとで`ctx?/t`の証明はしないといけませんけどね。

あとでいいんだっけ？
確かに下の方から証明していくって話ではあったけど・・・

```
(J-Bob/prove (defun.ctx?)
  '(((dethm ctx?/t (x)
         (if (ctx? x)
             (equal (ctx? x) 't)
             't))
     nil)
    ((dethm ctx?/sub (x y)
     :
``` 

これでちゃんと結果出るんだな 意外
でももう証明したしね

あとは長いけど`ctx?/t`の証明でだいたい感じはつかめてるので
流れに沿って進むだけ
`ctx?/t`の証明もどうやら思った通りの流れだった模様
(細部まで細かく答え合わせする気力なし)

どこで関数を展開するかはちょっと悩む
行き詰ったくらいでやるのがいい気もする