# 定理証明手習い (12) J-Bob/defineのテスト

J-Bob/defineで定義を使いまわせるようにしましたがテストはどうするかな
こうかな

```
(my/test
 "defun.pair"
 (defun.pair)
 (append (my/prelude)
         (list '(defun pair (x y)
                  (cons x (cons y '()))))))
```

でもこれだと証明が長いときは見づらそう
証明が間違ってると追加されないようだから、追加されたたことだけ確認すればいいか
内部構造に依存してるのは嫌だけどすっきりはする

```
(define (last l)
  (cond ((null? (cdr l)) (car l))
        (else (last (cdr l)))))

(define (last-name l)
  (cadr (last l)))

(my/test
 "defun.pair"
 (last-name (defun.pair))
 'pair)
```

このパターンはたくさん出てきそう
でこんな感じに書ければいいんだよなーと思ったんですが

```
(define (right-of str c)
  (list->string (cdr (memq c (string->list str)))))

(define (name-part sym)
  (string->symbol (right-of (symbol->string sym) #\.)))

(define-syntax my/test/define
  (syntax-rules ()
    ((_ name)
     (my/test
      (symbol->string name)
      (last-name (name))
      (name-part name)))))
```

`defun.pair`はシンボルじゃなくて関数なのでうまくいきませんでした
関数とシンボルは違うのか わかってなかった
関数の名前をシンボルか文字列で取得できればいいんだけど・・・

ということで最初からシンボルで渡して、強引に`eval`してやってます
`eval`を使うほどのことではないような何か忘れてるような
教えてえらい人

```
(define-syntax my/test/define
  (syntax-rules ()
    ((_ name)
     (my/test
      (symbol->string name)
      (last-name ((eval name (interaction-environment))))
      (name-part name)))))
```

まあ一応使えることは使えるので進みます

