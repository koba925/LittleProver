(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

;; 自分用テスト

(define my/test/passed 0)
(define my/test/failed 0)

(define-syntax my/test
  (syntax-rules ()
    ((_ name actual expected)
     (let ((act actual))
       (if (equal (quote expected) actual)
           (set! my/test/passed (+ my/test/passed 1))
           (begin
             (display name)
             (display "\nactual  :")
             (display act)
             (display "\nexpected:")
             (display (quote expected))
             (newline)
             (set! my/test/failed (+ my/test/failed 1))))))))

(define (my/test/result)
  (display "Test passed:")
  (display my/test/passed)
  (display " failed:")
  (display my/test/failed)
  (display " total:")
  (display (+ my/test/passed my/test/failed))
  (newline))

;; 自分用prelude

(defun my/axioms ()
  '(; Consの公理（最初のバージョン）
    (dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))
    ; Equalの公理（最初のバージョン）
    (dethm equal-same (x)
      (equal (equal x x) 't))
    (dethm equal-swap (x y)
      (equal (equal x y) (equal y x)))))

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))

; 1 いつものゲームにルールを

(my/test
 "chapter1.example1"
 (J-Bob/step (my/prelude)
   '(car (cons 'ham '(eggs)))
   '(((1) (cons 'ham '(eggs)))
     (() (car '(ham eggs)))))
 'ham)

(my/test
 "chapter1.example2"
 (J-Bob/step (my/prelude)
   '(atom '())
   '((() (atom '()))))
 't)

(my/test
 "chapter1.example3"
 (J-Bob/step (my/prelude)
   '(atom (cons 'ham '(eggs)))
   '((() (atom/cons 'ham '(eggs)))))
 'nil)

(my/test
 "chapter1.example4"
 (J-Bob/step (my/prelude)
   '(atom (cons a b))
   '((() (atom/cons a b))))
 'nil)

(my/test
 "chapter1.example5"
 (J-Bob/step (my/prelude)
   '(equal 'flapjack (atom (cons a b)))
   '(((2) (atom/cons a b))
     (() (equal 'flapjack 'nil))))
 'nil)

(my/test
 "chapter1.example6"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1 1 1) (car/cons p q))
     ((1) (cdr/cons p '()))
     (() (atom '()))))
 't)

(my/test
 "chapter1.example7"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1) (cdr/cons (car (cons p q)) '()))
     (() (atom '()))))
 't)

(my/test
 "chapter1.example8"
 (J-Bob/step (my/prelude)
   '(car (cons (equal (cons x y) (cons x y)) '(and crumpets)))
   '(((1 1) (equal-same (cons x y)))
     ((1) (cons 't '(and crumpets)))
     (() (car '(t and crumpets)))))
 't)

(my/test
 "chapter1.example9"
 (J-Bob/step (my/prelude)
   '(equal (cons x y) (cons 'bagels '(and lox)))
   '((() (equal-swap (cons x y) (cons 'bagels '(and lox))))))
 (equal (cons 'bagels '(and lox)) (cons x y)))

(my/test/result)
