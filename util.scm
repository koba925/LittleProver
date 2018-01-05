;; ユーティリティ

(define (last l)
  (cond ((null? (cdr l)) (car l))
        (else (last (cdr l)))))

(define (last-name l)
  (cadr (last l)))

(define (right-of str c)
  (list->string (cdr (memq c (string->list str)))))

(define (name-part sym)
  (string->symbol (right-of (symbol->string sym) #\.)))
