(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

;; 自分用prelude

(defun my/axioms ()
  '(
    ; Consの公理（最初のバージョン）
    (dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))))

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))

;; 自分用テスト

(define my/test/passed 0)
(define my/test/failed 0)

(define-syntax my/test
  (syntax-rules ()
    ((_ name expected actual)
     (let ((exp expected))
       (if (equal exp (quote actual))
           (set! my/test/passed (+ my/test/passed 1))
           (begin
             (display name)
             (display " expected:")
             (display exp)
             (display " actual:")
             (display (quote actual))
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
   '(atom (cons a b))
   '((() (atom/cons a b))))
 'nil)

(my/test/result)