(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")
(load "mytest.scm")
(load "myprelude.scm")

; 1 いつものゲームにルールを

(my/test
 "chapter1.example1"
 (J-Bob/step (my/prelude)
   '(car (cons 'ham '(eggs)))
   '(((1) (cons 'ham '(eggs)))
     (() (car '(ham eggs)))))
 ''ham)

(my/test
 "chapter1.example2"
 (J-Bob/step (my/prelude)
   '(atom '())
   '((() (atom '()))))
 ''t)

(my/test
 "chapter1.example3"
 (J-Bob/step (my/prelude)
   '(atom (cons 'ham '(eggs)))
   '((() (atom/cons 'ham '(eggs)))))
 ''nil)

(my/test
 "chapter1.example4"
 (J-Bob/step (my/prelude)
   '(atom (cons a b))
   '((() (atom/cons a b))))
 ''nil)

(my/test
 "chapter1.example5"
 (J-Bob/step (my/prelude)
   '(equal 'flapjack (atom (cons a b)))
   '(((2) (atom/cons a b))
     (() (equal 'flapjack 'nil))))
 ''nil)

(my/test
 "chapter1.example6"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1 1 1) (car/cons p q))
     ((1) (cdr/cons p '()))
     (() (atom '()))))
 ''t)

(my/test
 "chapter1.example7"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1) (cdr/cons (car (cons p q)) '()))
     (() (atom '()))))
 ''t)

(my/test
 "chapter1.example8"
 (J-Bob/step (my/prelude)
   '(car (cons (equal (cons x y) (cons x y)) '(and crumpets)))
   '(((1 1) (equal-same (cons x y)))
     ((1) (cons 't '(and crumpets)))
     (() (car '(t and crumpets)))))
 ''t)

(my/test
 "chapter1.example9"
 (J-Bob/step (my/prelude)
   '(equal (cons x y) (cons 'bagels '(and lox)))
   '((() (equal-swap (cons x y) (cons 'bagels '(and lox))))))
 '(equal (cons 'bagels '(and lox)) (cons x y)))

(my/test
 "chapter1.example10"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (cdr x) (car y)))))
 '(cons y (equal (cdr x) (equal (atom x) 'nil))))

(my/test
 "chapter1.example11"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (car (cons (cdr x) (car y))) '(oats)))
     ((2 2 2) (atom/cons (atom (cdr (cons a b))) (equal (cons a b) c)))
     ((2 2 2 1 1 1) (cdr/cons a b))
     ((2 2 2 1 2) (equal-swap (cons a b) c))))
 '(cons y (equal (car (cons (car (cons (cdr x) (car y))) '(oats)))
                 (equal (atom x)
                        (atom (cons (atom b) (equal c (cons a b))))))))

(my/test
 "chapter1.example12"
 (J-Bob/step (my/prelude)
   '(atom (car (cons (car a) (cdr b))))
   '(((1) (car/cons (car a) (cdr b)))))
 '(atom (car a)))

(my/test
 "chapter2.example1"
 (J-Bob/step (my/prelude)
   '(if (car (cons a b)) c c)
   '(((Q) (car/cons a b))
     (() (if-same a c))
     (() (if-same (if (equal a 't)
                      (if (equal 'nil 'nil) a b)
                      (equal 'or (cons 'black '(coffee))))
                  c))
     ((Q E 2) (cons 'black '(coffee)))
     ((Q A Q) (equal-same 'nil))
     ((Q A) (if-true a b))
     ((Q A) (equal-if a 't))))
 '(if (if (equal a 't)
          't
          (equal 'or '(black coffee)))
      c
      c))

(my/test
 "chapter2.trial1"
 (J-Bob/step (my/prelude)
   '(if (equal x y) (if (equal y z) (equal x z) 't) 't)
   '(((A Q) (equal-swap y z))
     ((A A 1) (equal-if x y))
     ((A A 2) (equal-if z y))
     ((A A) (equal-same y))
     ((A) (if-same (equal z y) 't))
     (() (if-same (equal x y) 't))))
 ''t)

(my/test
 "chapter2.trial2"
 (J-Bob/step (my/prelude)
   '(if (equal a b) (if (equal b c) a b) c)
   '(((A A) (equal-trans a b c))))
 '(if (equal a b) (if (equal b c) c b) c))

(my/test/result)
