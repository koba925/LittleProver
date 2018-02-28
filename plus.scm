(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

(J-Bob/prove (prelude)
  '(((dethm 1=1 ()
       (equal '1 '1))
     nil
     (() (equal-same '1)))))

(J-Bob/prove (prelude)
  '(((dethm 1<2 ()
       (< '1 '2))
     nil
     (() (< '1 '2))
     )))

(J-Bob/prove (prelude)
  '(((dethm 1<1+1 ()
       (< '1 (+ '1 '1)))
     nil
     ((2) (+ '1 '1))
     (() (< '1 '2))
     )))

(J-Bob/prove (prelude)
  '(((defun add (a b)
       (+ a b))
     nil
     )))

(J-Bob/prove (prelude)
  '(((dethm size/consa (a b)
       (equal (size (cons a b)) (+ (size (cons a b)) '1)))
     nil)))