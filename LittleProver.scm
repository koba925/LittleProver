(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

; Consの公理（最初のバージョン）

(defun my/axioms ()
  '((dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))))

; 自分用prelude
(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))

; chapter1.example1
(J-Bob/step (my/prelude)
  '(car (cons 'ham '(eggs)))
  '(((1) (cons 'ham '(eggs)))
    (() (car '(ham eggs)))))
; -> 'ham

; chapter1.example2
(J-Bob/step (my/prelude)
  '(atom '())
  '((() (atom '()))))
; -> 't

; chapter1.example3
(J-Bob/step (my/prelude)
  '(atom (cons a b))
  '((() (atom/cons a b))))
; -> 'nil
