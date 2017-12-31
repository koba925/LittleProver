(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

; chapter1.example1
(J-Bob/step (prelude)
  '(car (cons 'ham '(eggs)))
  '(((1) (cons 'ham '(eggs)))
    (() (car '(ham eggs)))))
; -> 'ham
