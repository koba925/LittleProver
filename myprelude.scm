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
