;; 自分用prelude

(defun my/axioms ()
  '(; Consの公理（最終バージョン）
    (dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))
    (dethm cons/car+cdr (x)
      (if (atom x) 't (equal (cons (car x) (cdr x)) x)))
    ; Equalの公理（最終バージョン）
    (dethm equal-same (x)
      (equal (equal x x) 't))
    (dethm equal-swap (x y)
      (equal (equal x y) (equal y x)))
    (dethm equal-if (x y)
      (if (equal x y) (equal x y) 't))
    ; Ifの公理（最終バージョン)
    (dethm if-true (x y)
      (equal (if 't x y) x))
    (dethm if-false (x y)
      (equal (if 'nil x y) y))
    (dethm if-same (x y)
      (equal (if x y y) y))
    (dethm if-nest-A (x y z)
      (if x (equal (if x y z) y) 't))
    (dethm if-nest-E (x y z)
      (if x 't (equal (if x y z) z)))
    ; Sizeの公理
    (dethm natp/size (x)
      (equal (natp (size x)) 't))
    (dethm size/car (x)
      (if (atom x) 't
          (equal (< (size (car x)) (size x)) 't)))
    (dethm size/cdr (x)
      (if (atom x) 't
          (equal (< (size (cdr x)) (size x)) 't)))))

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '(((defun list-induction (x)
         (if (atom x)
             '()
             (cons (car x)
                   (list-induction (cdr x)))))
       (size x)
       ((A E) (size/cdr x))
       ((A) (if-same (atom x) 't))
       ((Q) (natp/size x))
       (() (if-true 't 'nil)))
      ((defun star-induction (x)
         (if (atom x)
             x
             (cons (star-induction (car x))
                   (star-induction (cdr x)))))
       (size x)
       ((A E A) (size/cdr x))
       ((A E Q) (size/car x))
       ((A E) (if-true 't 'nil))
       ((A) (if-same (atom x) 't))
       ((Q) (natp/size x))
       (() (if-true 't 'nil))))))
