# 定理証明手習い (10) J-Bob/prove

「3 名前に何が？」では関数定義と証明が出てきます

関数はその定義で置き換えることができます（Defunの法則）
ここでは「再帰的でない」関数が対象です
再帰的な関数はどうするんでしょうか
Dethmの法則と似てるところもありますが定理はそもそも再帰できないという約束でした

そして証明
まだ証明されていない定理を主張といいます
主張を証明するには、主張の式の置き換えを繰り返して`'t`になることを示します

証明は`J-Bob/prove`の中で行います
証明で使う関数は`J-Bob/prove`の中で定義しないと使えない模様
トップレベルで定義した関数を`J-Bob/prove`の中から呼ぶことはできないようです
トップレベルで定義したからと言って二重定義のエラーになったりはしないので
作った関数をちょっとREPLで動かしてみたいみたいなときは
両方に定義を書くことになるのかな

```
(J-Bob/prove (my/prelude)
  '(((defun pair (x y)
       (cons x (cons y '())))
     nil)))
```

`nil`は「種」だそうですが詳細な説明は後で出てくるようです

```
(J-Bob/prove (<公理・定義済みの関数／定理>)
  '((<関数・定理の定義>
     <種>
     <証明>)
     ...))
```

となります
証明は`J-Bob/step`と同様に書いて、`'t`になるまで変形します

上の例では証明はありませんが実行すると`'t`になります
なぜかというと

> 与えられている`defun`が再帰的ではないので、全域性が自明であるために
> 証明案件は`'t`であり、それが成功するから

だそうですがちょっとちんぷんかんぷんです
定理は`'t`になることを証明する、関数は全域であることを証明する、ってことでしょうか
きっともうちょっと進めばわかるようになるんではないかと
