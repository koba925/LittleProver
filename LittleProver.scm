(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")
(load "mytest.scm")
(load "myprelude.scm")
(load "util.scm")

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

;; 2. もう少し、いつものゲームを

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
 "chapter2.example2"
 (J-Bob/step (my/prelude)
   '(if (atom (car a))
        (if (equal (car a) (cdr a))
            'hominy
            'grits)
        (if (equal (cdr (car a)) '(hash browns))
            (cons 'ketchup (car a))
            (cons 'mustard (car a))))
   '(((E A 2) (cons/car+cdr (car a)))))
 '(if (atom (car a))
      (if (equal (car a) (cdr a))
          'hominy
          'grits)
      (if (equal (cdr (car a)) '(hash browns))
          (cons 'ketchup (cons (car (car a)) (cdr (car a))))
          (cons 'mustard (car a)))))

(my/test
 "chapter2.example3"
 (J-Bob/step (my/prelude)
   '(cons 'statement
          (cons
           (if (equal a 'question)
               (cons n '(answer))
               (cons n '(else)))
           (if (equal a 'question)
               (cons n '(other answer))
               (cons n '(other else)))))
   '(((2) (if-same (equal a 'question)
                   (cons
                    (if (equal a 'question)
                        (cons n '(answer))
                        (cons n '(else)))
                    (if (equal a 'question)
                        (cons n '(other answer))
                        (cons n '(other else))))))
     ((2 A 1) (if-nest-A (equal a 'question)
                         (cons n '(answer))
                         (cons n '(else))))
     ((2 E 1) (if-nest-E (equal a 'question)
                         (cons n '(answer))
                         (cons n '(else))))
     ((2 A 2) (if-nest-A (equal a 'question)
                         (cons n '(other answer))
                         (cons n '(other else))))
     ((2 E 2) (if-nest-E (equal a 'question)
                         (cons n '(other answer))
                         (cons n '(other else))))))
 '(cons 'statement
        (if (equal a 'question)
            (cons (cons n '(answer)) (cons n '(other answer)))
            (cons (cons n '(else)) (cons n '(other else))))))

;; 3. 名前に何が？

(defun defun.pair ()
  (J-Bob/define (my/prelude)
    '(((defun pair (x y)
         (cons x (cons y '())))
       nil))))

(my/test/define 'defun.pair)

(defun defun.first-of ()
  (J-Bob/define (defun.pair)
    '(((defun first-of (x)
         (car x))
       nil))))

(my/test/define 'defun.first-of)

(defun defun.second-of ()
  (J-Bob/define (defun.first-of)
    '(((defun second-of (x)
         (car (cdr x)))
      nil))))

(my/test/define 'defun.second-of)

(defun dethm.first-of-pair ()
  (J-Bob/define (defun.second-of)
    '(((dethm first-of-pair (a b)
         (equal (first-of (pair a b)) a))
       nil
       ((1 1) (pair a b))
       ((1) (first-of (cons a (cons b '()))))
       ((1) (car/cons a (cons b '())))
       (() (equal-same a))))))

(my/test/define 'dethm.first-of-pair)

(defun dethm.second-of-pair ()
  (J-Bob/define (dethm.first-of-pair)
    '(((dethm second-of-pair (a b)
         (equal (second-of (pair a b)) b))
       nil
       ((1) (second-of (pair a b)))
       ((1 1 1) (pair a b))
       ((1 1) (cdr/cons a (cons b '())))
       ((1) (car/cons b '()))
       (() (equal-same b))))))

(my/test/define 'dethm.second-of-pair)

(my/test/result)

