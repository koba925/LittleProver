;; 自分用prelude

(defun my/axioms ()
  '(; Consの公理（最初のバージョン）
    (dethm atom/cons (x y)
      (equal (atom (cons x y)) 'nil))
    (dethm car/cons (x y)
      (equal (car (cons x y)) x))
    (dethm cdr/cons (x y)
      (equal (cdr (cons x y)) y))
    ; Equalの公理（最終バージョン）
    (dethm equal-same (x)
      (equal (equal x x) 't))
    (dethm equal-swap (x y)
      (equal (equal x y) (equal y x)))
    (dethm equal-if (x y)
      (if (equal x y) (equal x y) 't))
    ; Ifの公理（最初のバージョン)
    (dethm if-true (x y)
      (equal (if 't x y) x))
    (dethm if-false (x y)
      (equal (if 'nil x y) y))
    (dethm if-same (x y)
      (equal (if x y y) y))))

(defun my/prelude ()
  (J-Bob/define (my/axioms)
    '()))
