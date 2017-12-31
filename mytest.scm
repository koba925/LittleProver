;; 自分用テスト

(define my/test/passed 0)
(define my/test/failed 0)

(define (my/test name actual expected)
  (if (equal expected actual)
      (set! my/test/passed (+ my/test/passed 1))
      (begin
        (display name)
        (display "\nactual  :")
        (display actual)
        (display "\nexpected:")
        (display expected)
        (newline)
        (set! my/test/failed (+ my/test/failed 1)))))

(define (my/test/result)
  (display "Test passed:")
  (display my/test/passed)
  (display " failed:")
  (display my/test/failed)
  (display " total:")
  (display (+ my/test/passed my/test/failed))
  (newline))
