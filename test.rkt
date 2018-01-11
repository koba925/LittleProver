(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")

(J-Bob/prove (prelude)
  '(((defun list? (x)
       (if (atom? x)
           (equal x '())
           (list? (cdr x))))
     (size x))))