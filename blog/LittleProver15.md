# 定理証明手習い (15) 型？

「4. これが完全なる朝食」のはじめに

> 関数`list0?`を定義してください。
> 
> ```
> (defun list0? (x)
>   (if (equal x 'oatmeal)
>       'nil
>       (if (equal x '())
>           't
>           (if (equal x '(toast))
>               'nil
>               'nil)))
> ```
> 
> はいはい、やり直しましょうね。
> 
> ```
> (defun list0? (x)
>   (equal x '()))
> ```

ってくだりがあるんですが、これはただのジョークでしょうか
公理を使えば書き換えられるんでしょうか
やってみます

```
  (if (equal x 'oatmeal) 'nil (if (equal x '()) 't (if (equal x '(toast)) 'nil 'nil)))
= (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil))
```

`(if (equal x '()) 't 'nil)`はどう見ても`(equal x '())`なんですが
どうやって変形していいかわかりません
別方面から進めてみます

```
= (if (equal x '())
    (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil))
    (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil)))
= (if (equal x '()) 
    (if (equal x 'oatmeal) 'nil 't) 
    (if (equal x 'oatmeal) 'nil 'nil))
= (if (equal x '()) 
    (if (equal x 'oatmeal) 'nil 't) 
    'nil)
= (if (equal x '()) 
    (if (equal '() 'oatmeal) 'nil 't) 'nil)
= (if (equal x '()) (if 'nil 'nil 't) 'nil)
= (if (equal x '()) 't 'nil)
```

結局残りました

公理とにらめっこしてみましたが簡単にする方向には進みそうにないので
いったん式を増やすんでしょうか

妄想ではこんな風に終わりそうな気がするんですが何かが足りないような

```
= (if (equal x '()) 't 'nil)
= ...
= ...
= (if (equal x '()) (equal x '()) (equal x '()))
= (equal x '())
```

逆算すると`equal-if`でもうちょっといける？

```
= (if (equal x '()) 't 'nil)
= ...
= ...
= (if (equal x '()) (equal '() '()) (equal x '()))
= (if (equal x '()) (equal x '()) (equal x '()))
= (equal x '())
```

`(equal '() '())`は公理でも関数適用でも`'t`に書き換えられるけど
`'t`を`(equal '() '())`に書き換えるっていうのは可能なんでしょうか
今知ってる範囲のJ-Bobでは書きようがない気がします

それにそっちがんばってもElse部がなあ

変形できないのかなあと思っても悪魔の証明みたいな感じですが
考えてみると`(if (equal x '()) 't 'nil)`と`(equal x '())`が
同じであるというためには`(equal x '())`が`'t`と`'nil`しか返さないという
約束が必要ですね
それがなければここで終わり？

そもそもJ-Bobでは`'t`と`'nil`以外の値はどう扱われてるんでしょうか

```
(define (if/nil Q A E)
  (if (equal? Q 'nil) (E) (A)))
(define-syntax if
  (syntax-rules ()
    ((_ Q A E)
     (if/nil Q (lambda () A) (lambda () E)))))
```

`'nil`以外は`'t`扱いのようです

じゃあ`(equal x '())`が`'t`と`'nil`しか返さないっていう公理があれば
`(if (equal x '()) 't 'nil)`を`(equal x '())`に変形できるかな？
・・・
`'t`か`'nil`である＆`'t`ではない、から`'nil`であることが言える？
うーんわからない

そもそも「`'t`と`'nil`しか返さない」ってどうやって書くんだ
それは公理じゃないのか？
型？
型かもしれないな
