(load "j-bob/j-bob-lang.scm")

(defun member? (x ys)
  (if (atom ys)
      'nil
      (if (equal x (car ys))
          't
          (member? x (cdr ys)))))

(defun set? (xs)
  (if (atom xs)
      't
      (if (member? (car xs) (cdr xs))
          'nil
          (set? (cdr xs)))))

(defun add-atoms (x ys)
  (if (atom x)
      (if (member? x ys)
          ys
          (cons x ys))
      (add-atoms (car x)
                 (add-atoms (cdr x) ys))))

(add-atoms '((a . b) . (c . a)) '(d a e))
(add-atoms '(a . b) (add-atoms '(c . a) '(d a e)))
(add-atoms '(a . b) (add-atoms 'c (add-atoms 'a '(d a e))))
(add-atoms '(a . b) (add-atoms 'c '(d a e)))
(add-atoms '(a . b) (cons 'c '(d a e)))
(add-atoms '(a . b) '(c d a e))
(add-atoms 'a (add-atoms 'b '(c d a e)))
(add-atoms 'a (cons 'b '(c d a e)))
(add-atoms 'a '(b c d a e))
'(b c d a e)





