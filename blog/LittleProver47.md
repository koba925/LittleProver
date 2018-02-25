# 定理証明手習い (47) set?/t-nil

`set?/t-nil`も普通に証明できるかな
できない理由は思いつかない
`set?/t`と`set?/nil`をあわせた手間よりは楽にできるんじゃないかな
やってみよう

ここは自分で書いたコードだから全コード掲載！

```
(J-Bob/prove (defun.atoms)
  '(((dethm set?/t-nil (xs)
       (if (set? xs)
           (equal (set? xs) 't)
           (equal (set? xs) 'nil)))
     (list-induction xs)

     ; 証明すべき主張
     ; (if (atom xs)
     ;     (if (set? xs)
     ;         (equal (set? xs) 't)
     ;         (equal (set? xs) 'nil))
     ;     (if (if (set? (cdr xs))
     ;             (equal (set? (cdr xs)) 't)
     ;             (equal (set? (cdr xs)) 'nil))
     ;         (if (set? xs)
     ;             (equal (set? xs) 't)
     ;             (equal (set? xs) 'nil))
     ;         't))
     
     ;; A部から
     
     ; (set? xs)を展開
     ; どの(set?xs)から展開するかはあんまり気にしていない
     ((A Q) (set? xs))
     
     ; 整理
     ((A Q) (if-nest-A (atom xs)
                       't
                       (if (member? (car xs) (cdr xs))
                           'nil
                           (set? (cdr xs)))))
     ((A) (if-true (equal (set? xs) 't)
                   (equal (set? xs) 'nil)))
                   
     ; (set? xs)を展開
     ((A 1) (set? xs))

     ; 整理
     ((A 1) (if-nest-A (atom xs)
                       't
                       (if (member? (car xs) (cdr xs))
                           'nil
                           (set? (cdr xs)))))
     ((A) (equal 't 't))

     ; 現在の主張
     ; (if (atom xs)
     ;     't
     ;     (if (if (set? (cdr xs))
     ;             (equal (set? (cdr xs)) 't)
     ;             (equal (set? (cdr xs)) 'nil))
     ;         (if (set? xs)
     ;             (equal (set? xs) 't)
     ;             (equal (set? xs) 'nil))
     ;         't))
     
     ;; E部
     
     ; 帰納法の前提となる部分には手をつけないでその内側から

     ; (set? xs)を展開
     ((E A Q) (set? xs))
     
     ; 整理
     ((E A Q) (if-nest-E (atom xs)
                         't
                         (if (member? (car xs) (cdr xs))
                             'nil
                             (set? (cdr xs)))))

     ; (set? xs)を展開
     ((E A A 1) (set? xs))

     ; 整理
     ((E A A 1) (if-nest-E (atom xs)
                           't
                           (if (member? (car xs) (cdr xs))
                               'nil
                               (set? (cdr xs)))))

     ; (set? xs)を展開
     ((E A E 1) (set? xs))

     ; 整理
     ((E A E 1) (if-nest-E (atom xs)
                           't
                           (if (member? (car xs) (cdr xs))
                               'nil
                               (set? (cdr xs)))))

     ; 現在の主張
     ; (if (atom xs)
     ;     't
     ;     (if (if (set? (cdr xs))
     ;             (equal (set? (cdr xs)) 't)
     ;             (equal (set? (cdr xs)) 'nil))
     ;         (if (if (member? (car xs) (cdr xs)) 'nil (set? (cdr xs)))
     ;             (equal (if (member? (car xs) (cdr xs))
     ;                        'nil
     ;                        (set? (cdr xs))) 't)
     ;             (equal (if (member? (car xs) (cdr xs))
     ;                        'nil
     ;                        (set? (cdr xs))) 'nil))
     ;         't))

     ; (member? (car xs) (cdr xs))で持ち上げ
     ((E A) (if-same (member? (car xs) (cdr xs))
                     (if (if (member? (car xs) (cdr xs))
                             'nil
                             (set? (cdr xs)))
                         (equal (if (member? (car xs) (cdr xs))
                                    'nil
                                    (set? (cdr xs))) 't)
                         (equal (if (member? (car xs) (cdr xs))
                                    'nil
                                    (set? (cdr xs))) 'nil))))

     ; (E A A)の整理
     ((E A A Q) (if-nest-A (member? (car xs) (cdr xs))
                           'nil
                           (set? (cdr xs))))
     ((E A A) (if-false (equal (if (member? (car xs) (cdr xs))
                                   'nil
                                   (set? (cdr xs))) 't)
                        (equal (if (member? (car xs) (cdr xs))
                                   'nil
                                   (set? (cdr xs))) 'nil)))
     ((E A A 1) (if-nest-A (member? (car xs) (cdr xs))
                           'nil
                           (set? (cdr xs))))
     ((E A A) (equal 'nil 'nil))

     ; (E A E)の整理
     ((E A E Q) (if-nest-E (member? (car xs) (cdr xs))
                           'nil
                           (set? (cdr xs))))
     ((E A E A 1) (if-nest-E (member? (car xs) (cdr xs))
                             'nil
                             (set? (cdr xs))))
     ((E A E E 1) (if-nest-E (member? (car xs) (cdr xs))
                             'nil
                             (set? (cdr xs))))

     ; 持ち上げ完了

     ; 現在の主張
     ; (if (atom xs)
     ;     't
     ;     (if (if (set? (cdr xs))
     ;             (equal (set? (cdr xs)) 't)
     ;             (equal (set? (cdr xs)) 'nil))
     ;         (if (member? (car xs) (cdr xs))
     ;             't
     ;             (if (set? (cdr xs))
     ;                 (equal (set? (cdr xs)) 't)
     ;                 (equal (set? (cdr xs)) 'nil)))
     ;         't))

     ; (set? (cdr xs))で持ち上げ開始
     ((E) (if-same (set? (cdr xs))
                   (if (if (set? (cdr xs))
                           (equal (set? (cdr xs)) 't)
                           (equal (set? (cdr xs)) 'nil))
                       (if (member? (car xs) (cdr xs))
                           't
                           (if (set? (cdr xs))
                               (equal (set? (cdr xs)) 't)
                               (equal (set? (cdr xs)) 'nil)))
                       't)))

     ; 整理
     ((E A Q) (if-nest-A (set? (cdr xs))
                         (equal (set? (cdr xs)) 't)
                         (equal (set? (cdr xs)) 'nil)))
     ((E A A E) (if-nest-A (set? (cdr xs))
                           (equal (set? (cdr xs)) 't)
                           (equal (set? (cdr xs)) 'nil)))
     ((E E Q) (if-nest-E (set? (cdr xs))
                         (equal (set? (cdr xs)) 't)
                         (equal (set? (cdr xs)) 'nil)))
     ((E E A E) (if-nest-E (set? (cdr xs))
                           (equal (set? (cdr xs)) 't)
                           (equal (set? (cdr xs)) 'nil)))

     ; 持ち上げ完了

     ; 現在の主張
     ; (if (atom xs)
     ;     't
     ;     (if (set? (cdr xs))
     ;         (if (equal (set? (cdr xs)) 't)
     ;             (if (member? (car xs) (cdr xs))
     ;                 't
     ;                 (equal (set? (cdr xs)) 't)) 't)
     ;         (if (equal (set? (cdr xs)) 'nil)
     ;             (if (member? (car xs) (cdr xs))
     ;                 't
     ;                 (equal (set? (cdr xs)) 'nil)) 't)))

     ; equal-ifが使える形になった
     
     ; (E A)から
     ((E A A E 1) (equal-if (set? (cdr xs)) 't))
     
     ; 整理
     ((E A A E) (equal 't 't))
     ((E A A) (if-same (member? (car xs) (cdr xs)) 't))
     ((E A) (if-same (equal (set? (cdr xs)) 't) 't))

     ; (E E)も
     ((E E A E 1) (equal-if (set? (cdr xs)) 'nil))

     ; 整理
     ((E E A E) (equal 'nil 'nil))
     ((E E A) (if-same (member? (car xs) (cdr xs)) 't))
     ((E E) (if-same (equal (set? (cdr xs)) 'nil) 't))

     ; 現在の主張
     ; (if (atom xs) 't (if (set? (cdr xs)) 't 't))

     ((E) (if-same (set? (cdr xs)) 't))
     (() (if-same (atom xs) 't))

     ; 現在の主張
     ; 't
     )))
```

あらすじは同じようなもの

A部
`(set xs)`を展開して整理

E部
`(set xs)`を展開して整理
`(member? (car xs) (cdr xs))`で持ち上げ
`(set? (cdr xs))`で持ち上げ
`equal-if`の適用
整理

けど長い
ふたつの証明を足したよりは短いだろうか
短くても分けるべきかな
