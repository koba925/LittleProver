(load "j-bob/j-bob-lang.scm")
(load "j-bob/j-bob.scm")
(load "mytest.scm")
(load "myprelude.scm")
(load "util.scm")

; 1 いつものゲームにルールを

(my/test
 "chapter1.example1"
 (J-Bob/step (my/prelude)
   '(car (cons 'ham '(eggs)))
   '(((1) (cons 'ham '(eggs)))
     (() (car '(ham eggs)))))
 ''ham)

(my/test
 "chapter1.example2"
 (J-Bob/step (my/prelude)
   '(atom '())
   '((() (atom '()))))
 ''t)

(my/test
 "chapter1.example3"
 (J-Bob/step (my/prelude)
   '(atom (cons 'ham '(eggs)))
   '((() (atom/cons 'ham '(eggs)))))
 ''nil)

(my/test
 "chapter1.example4"
 (J-Bob/step (my/prelude)
   '(atom (cons a b))
   '((() (atom/cons a b))))
 ''nil)

(my/test
 "chapter1.example5"
 (J-Bob/step (my/prelude)
   '(equal 'flapjack (atom (cons a b)))
   '(((2) (atom/cons a b))
     (() (equal 'flapjack 'nil))))
 ''nil)

(my/test
 "chapter1.example6"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1 1 1) (car/cons p q))
     ((1) (cdr/cons p '()))
     (() (atom '()))))
 ''t)

(my/test
 "chapter1.example7"
 (J-Bob/step (my/prelude)
   '(atom (cdr (cons (car (cons p q)) '())))
   '(((1) (cdr/cons (car (cons p q)) '()))
     (() (atom '()))))
 ''t)

(my/test
 "chapter1.example8"
 (J-Bob/step (my/prelude)
   '(car (cons (equal (cons x y) (cons x y)) '(and crumpets)))
   '(((1 1) (equal-same (cons x y)))
     ((1) (cons 't '(and crumpets)))
     (() (car '(t and crumpets)))))
 ''t)

(my/test
 "chapter1.example9"
 (J-Bob/step (my/prelude)
   '(equal (cons x y) (cons 'bagels '(and lox)))
   '((() (equal-swap (cons x y) (cons 'bagels '(and lox))))))
 '(equal (cons 'bagels '(and lox)) (cons x y)))

(my/test
 "chapter1.example10"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (cdr x) (car y)))))
 '(cons y (equal (cdr x) (equal (atom x) 'nil))))

(my/test
 "chapter1.example11"
 (J-Bob/step (my/prelude)
   '(cons y (equal (car (cons (cdr x) (car y))) (equal (atom x) 'nil)))
   '(((2 1) (car/cons (car (cons (cdr x) (car y))) '(oats)))
     ((2 2 2) (atom/cons (atom (cdr (cons a b))) (equal (cons a b) c)))
     ((2 2 2 1 1 1) (cdr/cons a b))
     ((2 2 2 1 2) (equal-swap (cons a b) c))))
 '(cons y (equal (car (cons (car (cons (cdr x) (car y))) '(oats)))
                 (equal (atom x)
                        (atom (cons (atom b) (equal c (cons a b))))))))

(my/test
 "chapter1.example12"
 (J-Bob/step (my/prelude)
   '(atom (car (cons (car a) (cdr b))))
   '(((1) (car/cons (car a) (cdr b)))))
 '(atom (car a)))

;; 2. もう少し、いつものゲームを

(my/test
 "chapter2.example1"
 (J-Bob/step (my/prelude)
   '(if (car (cons a b)) c c)
   '(((Q) (car/cons a b))
     (() (if-same a c))
     (() (if-same (if (equal a 't)
                      (if (equal 'nil 'nil) a b)
                      (equal 'or (cons 'black '(coffee))))
                  c))
     ((Q E 2) (cons 'black '(coffee)))
     ((Q A Q) (equal-same 'nil))
     ((Q A) (if-true a b))
     ((Q A) (equal-if a 't))))
 '(if (if (equal a 't)
          't
          (equal 'or '(black coffee)))
      c
      c))

(my/test
 "chapter2.example2"
 (J-Bob/step (my/prelude)
   '(if (atom (car a))
        (if (equal (car a) (cdr a))
            'hominy
            'grits)
        (if (equal (cdr (car a)) '(hash browns))
            (cons 'ketchup (car a))
            (cons 'mustard (car a))))
   '(((E A 2) (cons/car+cdr (car a)))))
 '(if (atom (car a))
      (if (equal (car a) (cdr a))
          'hominy
          'grits)
      (if (equal (cdr (car a)) '(hash browns))
          (cons 'ketchup (cons (car (car a)) (cdr (car a))))
          (cons 'mustard (car a)))))

(my/test
 "chapter2.example3"
 (J-Bob/step (my/prelude)
   '(cons 'statement
          (cons
           (if (equal a 'question)
               (cons n '(answer))
               (cons n '(else)))
           (if (equal a 'question)
               (cons n '(other answer))
               (cons n '(other else)))))
   '(((2) (if-same (equal a 'question)
                   (cons
                    (if (equal a 'question)
                        (cons n '(answer))
                        (cons n '(else)))
                    (if (equal a 'question)
                        (cons n '(other answer))
                        (cons n '(other else))))))
     ((2 A 1) (if-nest-A (equal a 'question)
                         (cons n '(answer))
                         (cons n '(else))))
     ((2 E 1) (if-nest-E (equal a 'question)
                         (cons n '(answer))
                         (cons n '(else))))
     ((2 A 2) (if-nest-A (equal a 'question)
                         (cons n '(other answer))
                         (cons n '(other else))))
     ((2 E 2) (if-nest-E (equal a 'question)
                         (cons n '(other answer))
                         (cons n '(other else))))))
 '(cons 'statement
        (if (equal a 'question)
            (cons (cons n '(answer)) (cons n '(other answer)))
            (cons (cons n '(else)) (cons n '(other else))))))

;; 3. 名前に何が？

(defun defun.pair ()
  (J-Bob/define (my/prelude)
    '(((defun pair (x y)
         (cons x (cons y '())))
       nil))))

(my/test/define 'defun.pair)

(defun defun.first-of ()
  (J-Bob/define (defun.pair)
    '(((defun first-of (x)
         (car x))
       nil))))

(my/test/define 'defun.first-of)

(defun defun.second-of ()
  (J-Bob/define (defun.first-of)
    '(((defun second-of (x)
         (car (cdr x)))
      nil))))

(my/test/define 'defun.second-of)

(defun dethm.first-of-pair ()
  (J-Bob/define (defun.second-of)
    '(((dethm first-of-pair (a b)
         (equal (first-of (pair a b)) a))
       nil
       ((1 1) (pair a b))
       ((1) (first-of (cons a (cons b '()))))
       ((1) (car/cons a (cons b '())))
       (() (equal-same a))))))

(my/test/define 'dethm.first-of-pair)

(defun dethm.second-of-pair ()
  (J-Bob/define (dethm.first-of-pair)
    '(((dethm second-of-pair (a b)
         (equal (second-of (pair a b)) b))
       nil
       ((1) (second-of (pair a b)))
       ((1 1 1) (pair a b))
       ((1 1) (cdr/cons a (cons b '())))
       ((1) (car/cons b '()))
       (() (equal-same b))))))

(my/test/define 'dethm.second-of-pair)

(defun dethm.jabberwocky ()
  (J-Bob/define (my/prelude)
    '(((defun brillig (x) 't)
       nil)
      ((defun slithy (x) 't)
       nil)
      ((defun uffish (x) 't)
       nil)
      ((defun mimsy (x) 'borogove)
       nil)
      ((defun mome (x) 'rath)
       nil)
      ((defun frumious (x) 'bandersnatch)
       nil)
      ((defun frabjous (x) 'beamish)
       nil)
      ((dethm jabberwocky (x)
         (if (brillig x)
             (if (slithy x)
                 (equal (mimsy x) 'borogove)
                 (equal (mome x) 'rath))
             (if (uffish x)
                 (equal (frumious x) 'bandersnatch)
                 (equal (frabjous x) 'beamish))))
       nil
       ((Q) (brillig x))
       (() (if-true
            (if (slithy x)
                (equal (mimsy x) 'borogove)
                (equal (mome x) 'rath))
            (if (uffish x)
                (equal (frumious x) 'bandersnatch)
                (equal (frabjous x) 'beamish))))
       ((Q) (slithy x))
       (() (if-true
            (equal (mimsy x) 'borogove)
            (equal (mome x) 'rath)))
       ((1) (mimsy x))
       (() (equal-same 'borogove))))))

(my/test/define 'dethm.jabberwocky)

(my/test
 "chapter2.exampleJW"
 (J-Bob/step (dethm.jabberwocky)
   '(cons 'gyre
          (if (uffish '(callooh callay))
              (cons 'gimble
                    (if (brillig '(callooh callay))
                        (cons 'borogove '(outgrabe))
                        (cons 'bandersnatch '(wabe))))
              (cons (frabjous '(callooh callay)) '(vorpal))))
   '(((2 A 2 E 1) (jabberwocky '(callooh callay)))))
 '(cons 'gyre
        (if (uffish '(callooh callay))
            (cons 'gimble
                  (if (brillig '(callooh callay)) 
                      (cons 'borogove '(outgrabe)) 
                      (cons (frumious '(callooh callay)) '(wabe))))
            (cons (frabjous '(callooh callay)) '(vorpal)))))

(defun defun.in-pair? ()
  (J-Bob/define (dethm.second-of-pair)
    '(((defun in-pair? (xs)
         (if (equal (first-of xs) '?)
             't
             (equal (second-of xs) '?)))
       nil))))

(my/test/define 'defun.in-pair?)

(defun dethm.in-first-of-pair ()
  (J-Bob/define (defun.in-pair?)
    '(((dethm in-first-of-pair (b)
         (equal (in-pair? (pair '? b)) 't))
       nil
       ((1 1) (pair '? b))
       ((1) (in-pair? (cons '? (cons b '()))))
       ((1 Q 1) (first-of (cons '? (cons b '()))))
       ((1 Q 1) (car/cons '? (cons b '())))
       ((1 Q) (equal-same '?))
       ((1) (if-true 't (equal (second-of (cons '? (cons b '()))) '?)))
       (() (equal-same 't))))))

(my/test/define 'dethm.in-first-of-pair)

(defun dethm.in-second-of-pair ()
  (J-Bob/define (dethm.in-first-of-pair)
    '(((dethm in-second-of-pair (a)
         (equal (in-pair? (pair a '?)) 't))
       nil
       ((1) (in-pair? (pair a '?)))
       ((1 E 1) (second-of (pair a '?)))
       ((1 E 1 1 1) (pair a '?))
       ((1 E 1 1) (cdr/cons  a (cons '? '())))
       ((1 E 1) (car/cons '? '()))
       ((1 E) (equal-same '?))
       ((1) (if-same (equal (first-of (pair a '?)) '?) 't))
       (() (equal-same 't))))))

(my/test/define 'dethm.in-second-of-pair)

(my/test
 "chapter4.example0"
 (J-Bob/step (my/prelude)
   '(if (equal x 'oatmeal)
        'nil
        (if (equal x '())
            't
            (if (equal x '(toast))
                'nil
                'nil)))
   '(((E E) (if-same (equal x '(toast)) 'nil))
     (() (if-same (equal x '())
                  (if (equal x 'oatmeal) 'nil (if (equal x '()) 't 'nil))))
     ((A E) (if-nest-A (equal x '()) 't 'nil))
     ((E E) (if-nest-E (equal x '()) 't 'nil))
     ((E) (if-same (equal x 'oatmeal) 'nil))
     ((A Q 1) (equal-if x '()))
     ((A Q) (equal '() 'oatmeal))
     ((A) (if-false 'nil 't))))
 '(if (equal x '()) 't 'nil))

;; 4. これが完全なる朝食

(defun defun.list0? ()
  (J-Bob/define (dethm.in-second-of-pair)
    '(((defun list0? (x)
         (equal x '()))
       nil))))

(my/test/define 'defun.list0?)

(defun defun.list1? ()
  (J-Bob/define (defun.list0?)
    '(((defun list1? (x)
         (if (atom x)
             'nil
             (list0? (cdr x))))
       nil))))

(my/test/define 'defun.list1?)

(defun defun.list2? ()
  (J-Bob/define (defun.list1?)
    '(((defun list2? (x)
         (if (atom x)
             'nil
             (list1? (cdr x))))
       nil))))

(my/test/define 'defun.list2?)

(my/test
 "dethm.contradiction"
 (J-Bob/prove
   (list-extend (my/prelude)
     '(defun partial (x)
        (if (partial x) 'nil 't)))
   '(((dethm contradiction () 'nil)
      nil
      (() (if-same (partial x) 'nil))
      ((A) (if-nest-A (partial x) 'nil 't))
      ((E) (if-nest-E (partial x) 't 'nil))
      ((A Q) (partial x))
      ((E Q) (partial x))
      ((A Q) (if-nest-A (partial x) 'nil 't))
      ((E Q) (if-nest-E (partial x) 'nil 't))
      ((A) (if-false 'nil 't))
      ((E) (if-true 't 'nil))
      (() (if-same (partial x) 't)))))
 ''t)

(defun defun.list? ()
  (J-Bob/define (defun.list2?)
    '(((defun list? (x)
         (if (atom x)
             (equal x '())
             (list? (cdr x))))
       (size x)
       ((Q) (natp/size x))
       (() (if-true (if (atom x) 't (< (size (cdr x)) (size x))) 'nil))
       ((E) (size/cdr x))
       (() (if-same (atom x) 't))))))

(my/test/define 'defun.list?)

(defun defun.sub ()
  (J-Bob/define (defun.list?)
    '(((defun sub (x y)
         (if (atom y)
             (if (equal y '?)
                 x
                 y)
             (cons (sub x (car y))
                   (sub x (cdr y)))))
       (size y)
       ((Q) (natp/size y))
       (() (if-true (if (atom y)
                        't
                        (if (< (size (car y)) (size y))
                            (< (size (cdr y)) (size y))
                            'nil))
                    'nil))
       ((E Q) (size/car y))
       ((E A) (size/cdr y))
       ((E) (if-true 't 'nil))
       (() (if-same (atom y) 't))))))

(my/test/define 'defun.sub)

(my/test
 "chapter4.partial"
 (J-Bob/prove
   (list-extend (my/prelude)
     '(dethm size-same (x)
        (equal (< (size x) (size x)) 'nil)))
   '(((defun partial (x)
        (if (partial x) 'nil 't))
      (size x)
      ((Q) (natp/size x))
      (() (if-true (if (< (size x) (size x)) 't 'nil) 'nil))
      ((Q) (size-same x))
      (() (if-false 't 'nil)))))
 ''nil)

(my/test
 "chapter4.partial2"
 (J-Bob/prove
   (list-extend (my/prelude)
     '(dethm smaller-same (x)
        (equal (< x x) 'nil)))
   '(((defun partial (x)
        (if (partial x) 'nil 't))
      (size x)
      ((Q) (natp/size x))
      (() (if-true (if (< (size x) (size x)) 't 'nil) 'nil))
      ((Q) (smaller-same (size x)))
      (() (if-false 't 'nil))
      )))
 ''nil)

;; 5. 何回も何回も何回も考えよう

(defun defun.memb? ()
  (J-Bob/define (defun.sub)
    '(((defun memb? (xs)
         (if (atom xs)
             'nil
             (if (equal (car xs) '?)
                 't
                 (memb? (cdr xs)))))
       (size xs)
       ((Q) (natp/size xs))
       (() (if-true (if (atom xs)
                        't
                        (if (equal (car xs) '?)
                            't
                            (< (size (cdr xs)) (size xs))))
                    'nil))
       ((E E) (size/cdr xs))
       ((E) (if-same (equal (car xs) '?) 't))
       (() (if-same (atom xs) 't))))))

(my/test/define 'defun.memb?)

(defun defun.remb ()
  (J-Bob/define (defun.memb?)
    '(((defun remb (xs)
         (if (atom xs)
             '()
             (if (equal (car xs) '?)
                 (remb (cdr xs))
                 (cons (car xs) (remb (cdr xs))))))
       (size xs)
       ((Q) (natp/size xs))
       (() (if-true (if (atom xs) 't (< (size (cdr xs)) (size xs))) 'nil))
       ((E) (size/cdr xs))
       (() (if-same (atom xs) 't))))))

(my/test/define 'defun.remb)

(defun dethm.memb?/remb0 ()
  (J-Bob/define (defun.remb)
    '(((dethm memb?/remb0 ()
         (equal (memb? (remb '())) 'nil))
       nil
       ((1 1) (remb '()))
       ((1 1 Q) (atom '()))
       ((1 1) (if-true '()
                       (if (equal (car '()) '?)
                           (remb (cdr '()))
                           (cons (car '()) (remb (cdr '()))))))
       ((1) (memb? '()))
       ((1 Q) (atom '()))
       ((1) (if-true 'nil (if (equal (car '()) '?)
                              't
                              (memb? (cdr '())))))
       (() (equal-same 'nil))))))

(my/test/define 'dethm.memb?/remb0)

(defun dethm.memb?/remb1 ()
  (J-Bob/define (dethm.memb?/remb0)
    '(((dethm memb?/remb1 (x1)
         (equal (memb? (remb (cons x1 '()))) 'nil))
       nil
       ((1 1) (remb (cons x1 '())))
       ((1 1 Q) (atom/cons x1 '()))
       ((1 1) (if-false '()
                        (if (equal (car (cons x1 '())) '?)
                            (remb (cdr (cons x1 '())))
                            (cons (car (cons x1 '()))
                                  (remb (cdr (cons x1 '())))))))
       ((1 1 Q 1) (car/cons x1 '()))
       ((1 1 A 1) (cdr/cons x1 '()))
       ((1 1 E 1) (car/cons x1 '()))
       ((1 1 E 2 1) (cdr/cons x1 '()))
       ((1) (if-same (equal x1 '?)
                     (memb? (if (equal x1 '?)
                                (remb '())
                                (cons x1 (remb '()))))))
       ((1 A 1) (if-nest-A (equal x1 '?)
                           (remb '())
                           (cons x1 (remb '()))))
       ((1 E 1) (if-nest-E (equal x1 '?)
                           (remb '())
                           (cons x1 (remb '()))))
       ((1 A) (memb?/remb0))
       ((1 E) (memb? (cons x1 (remb '()))))
       ((1 E Q) (atom/cons x1 (remb '())))
       ((1 E) (if-false 'nil
                        (if (equal (car (cons x1 (remb '()))) '?)
                            't
                            (memb? (cdr (cons x1 (remb '())))))))
       ((1 E Q 1) (car/cons x1 (remb '())))
       ((1 E) (if-nest-E (equal x1 '?) 't (memb? (cdr (cons x1 (remb '()))))))
       ((1 E 1) (cdr/cons x1 (remb '())))
       ((1 E) (memb?/remb0))
       ((1) (if-same (equal x1 '?) 'nil))
       (() (equal-same 'nil))))))

(my/test/define 'dethm.memb?/remb1)

(defun dethm.memb?/remb2 ()
  (J-Bob/define (dethm.memb?/remb1)
    '(((dethm memb?/remb2 (x1 x2)
         (equal (memb? (remb (cons x2 (cons x1 '())))) 'nil))
       nil
       ((1 1) (remb (cons x2 (cons x1 '()))))
       ((1 1 Q) (atom/cons x2 (cons x1 '())))
       ((1 1) (if-false '()
                        (if (equal (car (cons x2 (cons x1 '()))) '?)
                            (remb (cdr (cons x2 (cons x1 '()))))
                            (cons (car (cons x2 (cons x1 '())))
                                  (remb (cdr (cons x2 (cons x1 '()))))))))
       ((1 1 Q 1) (car/cons x2 (cons x1 '())))
       ((1 1 A 1) (cdr/cons x2 (cons x1 '())))
       ((1 1 E 1) (car/cons x2 (cons x1 '())))
       ((1 1 E 2 1) (cdr/cons x2 (cons x1 '())))
       ((1) (if-same (equal x2 '?)
                     (memb? (if (equal x2 '?)
                                (remb (cons x1 '()))
                                (cons x2 (remb (cons x1 '())))))))
       ((1 A 1) (if-nest-A (equal x2 '?)
                           (remb (cons x1 '()))
                           (cons x2 (remb (cons x1 '())))))
       ((1 E 1) (if-nest-E (equal x2 '?)
                           (remb (cons x1 '()))
                           (cons x2 (remb (cons x1 '())))))
       ((1 A) (memb?/remb1 x1))
       ((1 E) (memb? (cons x2 (remb (cons x1 '())))))
       ((1 E Q) (atom/cons x2 (remb (cons x1 '()))))
       ((1 E) (if-false 'nil
                        (if (equal (car (cons x2 (remb (cons x1 '())))) '?)
                            't
                            (memb? (cdr (cons x2 (remb (cons x1 '()))))))))
       ((1 E Q 1) (car/cons x2 (remb (cons x1 '()))))
       ((1 E E 1) (cdr/cons x2 (remb (cons x1 '()))))
       ((1 E) (if-nest-E (equal x2 '?) 't (memb? (remb (cons x1 '())))))
       ((1 E) (memb?/remb1 x1))
       ((1) (if-same (equal x2 '?) 'nil))
       (() (equal-same 'nil))))))

(my/test/define 'dethm.memb?/remb2)

(defun dethm.memb?/remb ()
  (J-Bob/define (dethm.memb?/remb2)
    '(((dethm memb?/remb (xs)
         (equal (memb? (remb xs)) 'nil))
       (list-induction xs)
       ((A 1 1) (remb xs))
       ((A 1 1) (if-nest-A (atom xs)
                           '()
                           (if (equal (car xs) '?)
                               (remb (cdr xs))
                               (cons (car xs) (remb (cdr xs))))))
       ((A 1) (memb? '()))
       ((A 1 Q) (atom '()))
       ((A 1) (if-true 'nil
                       (if (equal (car '()) '?)
                           't
                           (memb? (cdr '())))))
       ((A) (equal-same 'nil))
       ((E A 1 1) (remb xs))
       ((E A 1 1) (if-nest-E (atom xs)
                             '()
                             (if (equal (car xs) '?)
                                 (remb (cdr xs))
                                 (cons (car xs) (remb (cdr xs))))))
       ((E A 1) (if-same (equal (car xs) '?)
                         (memb? (if (equal (car xs) '?)
                                    (remb (cdr xs))
                                    (cons (car xs) (remb (cdr xs)))))))
       ((E A 1 A 1) (if-nest-A (equal (car xs) '?)
                               (remb (cdr xs))
                               (cons (car xs) (remb (cdr xs)))))
       ((E A 1 E 1) (if-nest-E (equal (car xs) '?)
                               (remb (cdr xs))
                               (cons (car xs) (remb (cdr xs)))))
       ((E A 1 A) (equal-if (memb? (remb (cdr xs))) 'nil))
       ((E A 1 E) (memb? (cons (car xs) (remb (cdr xs)))))
       ((E A 1 E Q) (atom/cons (car xs) (remb (cdr xs))))
       ((E A 1 E) (if-false 'nil
                            (if (equal (car (cons (car xs) (remb (cdr xs)))) '?)
                                't
                                (memb? (cdr (cons (car xs) (remb (cdr xs))))))))
       ((E A 1 E Q 1) (car/cons (car xs) (remb (cdr xs))))
       ((E A 1 E E 1) (cdr/cons (car xs) (remb (cdr xs))))
       ((E A 1 E) (if-nest-E (equal (car xs) '?) 't (memb? (remb (cdr xs)))))
       ((E A 1 E) (equal-if (memb? (remb (cdr xs))) 'nil))
       ((E A 1) (if-same (equal (car xs) '?) 'nil))
       ((E A) (equal-same 'nil))
       ((E) (if-same (equal (memb? (remb (cdr xs))) 'nil) 't))
       (() (if-same (atom xs) 't))))))

(my/test/define 'dethm.memb?/remb)

(defun defun.ctx? ()
  (J-Bob/define (dethm.memb?/remb)
    '(((defun ctx? (x)
         (if (atom x)
             (equal x '?)
             (if (ctx? (car x))
                 't
                 (ctx? (cdr x)))))
       (size x)
       ((Q) (natp/size x))
       (() (if-true (if (atom x)
                        't
                        (if (< (size (car x)) (size x))
                            (if (ctx? (car x))
                                't
                                (< (size (cdr x)) (size x)))
                            'nil))
                    'nil))
       ((E Q) (size/car x))
       ((E A E) (size/cdr x))
       ((E A) (if-same (ctx? (car x)) 't))
       ((E) (if-true 't 'nil))
       (() (if-same (atom x) 't))))))

(my/test/define 'defun.ctx?)


(defun dethm.ctx?/t ()
  (J-Bob/define (defun.ctx?)
    '(((dethm ctx?/t (x)
         (if (ctx? x)
             (equal (ctx? x) 't)
             't))
       (star-induction x)
       ; A部の(ctx? x)を展開
       ((A Q) (ctx? x))
       ((A A 1) (ctx? x))
       ; (if (atom x) を消去
       ((A Q) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
       ((A A 1) (if-nest-A (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
       ; 整理
       ((A A 1 1) (equal-if x '?))
       ((A A 1) (equal '? '?))
       ((A A) (equal 't 't))
       ((A) (if-same (equal x '?) 't))
       ; E部の(ctx? x)を展開
       ((E A A Q) (ctx? x))
       ((E A A A 1) (ctx? x))
       ; (if (atom x) を消去
       ((E A A Q) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
       ((E A A A 1) (if-nest-E (atom x) (equal x '?) (if (ctx? (car x)) 't (ctx? (cdr x)))))
       ; (if (ctx? (car x)) を持ち上げ
       ((E) (if-same (ctx? (car x))
                     (if (if (ctx? (car x)) (equal (ctx? (car x)) 't) 't)
                         (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                             (if (if (ctx? (car x)) 't (ctx? (cdr x)))
                                 (equal (if (ctx? (car x)) 't (ctx? (cdr x))) 't)
                                 't)
                             't)
                         't)))
       ((E A Q) (if-nest-A (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
       ((E A A A Q) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
       ((E A A A A 1) (if-nest-A (ctx? (car x)) 't (ctx? (cdr x))))
       ((E E Q) (if-nest-E (ctx? (car x)) (equal (ctx? (car x)) 't) 't))
       ((E E A A Q) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
       ((E E A A A 1) (if-nest-E (ctx? (car x)) 't (ctx? (cdr x))))
       ; 整理
       ((E A A A A) (equal 't 't))
       ((E A A A) (if-same 't 't))
       ((E E) (if-true (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           't)
                       't))
       ((E A A) (if-same (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't) 't))
       ((E A) (if-same (equal (ctx? (car x)) 't) 't))
       ; (if (ctx? (cdr x)) を持ち上げ
       ((E E) (if-same (ctx? (cdr x))
                       (if (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           (if (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't)
                           't)))
       ((E E A Q) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
       ((E E A A) (if-nest-A (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
       ((E E E Q) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
       ((E E E A) (if-nest-E (ctx? (cdr x)) (equal (ctx? (cdr x)) 't) 't))
       ; 整理
       ((E E A A 1) (equal-if (ctx? (cdr x)) 't))
       ((E E E) (if-same 't 't))
       ((E E A A) (equal 't 't))
       ((E E A) (if-same (equal (ctx? (cdr x)) 't) 't))
       ((E E) (if-same (ctx? (cdr x)) 't))
       ((E) (if-same (ctx? (car x)) 't))
       (() (if-same (atom x) 't))))))

(my/test/define 'dethm.ctx?/t)

(defun dethm.ctx?/sub ()
  (J-Bob/define (dethm.ctx?/t)
    '(((dethm ctx?/sub (x y)
         (if (ctx? x)
             (if (ctx? y)
                 (equal (ctx? (sub x y)) 't)
                 't)
             't))
       (star-induction y)
       (() (if-same (ctx? x)
                    (if (atom y)
                        (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't)
                        (if (if (ctx? x) (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't) 't)
                            (if (if (ctx? x) (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't)
                                (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't)
                                't)
                            't))))
       ((A A) (if-nest-A (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't))
       ((A E Q) (if-nest-A (ctx? x) (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't) 't))
       ((A E A Q) (if-nest-A (ctx? x) (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't))
       ((A E A A) (if-nest-A (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't))
       ((E A) (if-nest-E (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't))
       ((E E Q) (if-nest-E (ctx? x) (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't) 't))
       ((E E) (if-true (if (if (ctx? x) (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't) (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't) 't) 't))
       ((E E Q) (if-nest-E (ctx? x) (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't))
       ((E E) (if-true (if (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't) 't))
       ((E E) (if-nest-E (ctx? x) (if (ctx? y) (equal (ctx? (sub x y)) 't) 't) 't))
       ((E) (if-same (atom y) 't))
       ((A A A 1 1) (sub x y))
       ((A A A 1 1) (if-nest-A (atom y) (if (equal y '?) x y) (cons (sub x (car y)) (sub x (cdr y)))))
       ((A A A) (if-same (equal y '?) (equal (ctx? (if (equal y '?) x y)) 't)))
       ((A A A A 1 1) (if-nest-A (equal y '?) x y))
       ((A A A E 1 1) (if-nest-E (equal y '?) x y))
       ((A A A A 1) (ctx?/t x))
       ((A A A E 1) (ctx?/t y))
       ((A A A A) (equal-same 't))
       ((A A A E) (equal-same 't))
       ((A A A) (if-same (equal y '?) 't))
       ((A A) (if-same (ctx? y) 't))
       ((A E A A A 1 1) (sub x y))
       ((A E A A A 1 1) (if-nest-E (atom y) (if (equal y '?) x y) (cons (sub x (car y)) (sub x (cdr y)))))
       ((A E A A A 1) (ctx? (cons (sub x (car y)) (sub x (cdr y)))))
       ((A E A A A 1 Q) (atom/cons (sub x (car y)) (sub x (cdr y))))
       ((A E A A A 1) (if-false (equal (cons (sub x (car y)) (sub x (cdr y))) '?)
                                (if (ctx? (car (cons (sub x (car y)) (sub x (cdr y)))))
                                    't
                                    (ctx? (cdr (cons (sub x (car y)) (sub x (cdr y))))))))
       ((A E A A A 1 Q 1) (car/cons (sub x (car y)) (sub x (cdr y))))
       ((A E A A A 1 E 1) (cdr/cons (sub x (car y)) (sub x (cdr y))))
       ((A E A A Q) (ctx? y))
       ((A E A A Q) (if-nest-E (atom y) (equal y '?) (if (ctx? (car y)) 't (ctx? (cdr y)))))
       ((A E) (if-same (ctx? (car y))
                       (if (if (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't)
                           (if (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't)
                               (if (if (ctx? (car y)) 't (ctx? (cdr y)))
                                   (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't)
                                   't)
                               't)
                           't)))
       ((A E A Q) (if-nest-A (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't))
       ((A E A A A Q) (if-nest-A (ctx? (car y)) 't (ctx? (cdr y))))
       ((A E A A A) (if-true (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't) 't))
       ((A E E Q) (if-nest-E (ctx? (car y)) (equal (ctx? (sub x (car y))) 't) 't))
       ((A E E A A Q) (if-nest-E (ctx? (car y)) 't (ctx? (cdr y))))
       ((A E E) (if-true (if (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't)
                             (if (ctx? (cdr y)) (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't) 't)
                             't)
                         't))
       ((A E A A A 1 Q) (equal-if (ctx? (sub x (car y))) 't))
       ((A E A A A 1) (if-true 't (ctx? (sub x (cdr y)))))
       ((A E A A A) (equal-same 't))
       ((A E A A) (if-same (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't) 't))
       ((A E A) (if-same (equal (ctx? (sub x (car y))) 't) 't))
       ((A E E) (if-same (ctx? (cdr y))
                         (if (if (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't)
                             (if (ctx? (cdr y)) (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't) 't)
                             't)))
       ((A E E A Q) (if-nest-A (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't))
       ((A E E A A) (if-nest-A (ctx? (cdr y)) (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't) 't))
       ((A E E E Q) (if-nest-E (ctx? (cdr y)) (equal (ctx? (sub x (cdr y))) 't) 't))
       ((A E E E A) (if-nest-E (ctx? (cdr y)) (equal (if (ctx? (sub x (car y))) 't (ctx? (sub x (cdr y)))) 't) 't))
       ((A E E E) (if-same 't 't))
       ((A E E A A 1 E) (equal-if (ctx? (sub x (cdr y))) 't))
       ((A E E A A 1) (if-same (ctx? (sub x (car y))) 't))
       ((A E E A A) (equal-same 't))
       ((A E E A) (if-same (equal (ctx? (sub x (cdr y))) 't) 't))
       ((A E E) (if-same (ctx? (cdr y)) 't))
       ((A E) (if-same (ctx? (car y)) 't))
       ((A) (if-same (atom y) 't))
       (() (if-same (ctx? x) 't))))))

(my/test/define 'dethm.ctx?/sub)

(my/test 
 "mucha"
 (J-Bob/prove (my/prelude)
  '(((dethm mucha (a b)
       (equal a b))
     nil)
    ((dethm kucha ()
       (equal 't 'nil))
     nil
     ((1) (mucha 't 'nil)))))
 '(equal 'nil 'nil))

(defun dethm.if/natp/size ()
  (J-Bob/define (dethm.ctx?/sub)
    '(((dethm if/natp/size (x a b)
         (equal (if (natp (size x)) a b) a))
       nil
       ((1 Q) (natp/size x))
       ((1) (if-true a b))
       (() (equal-same a))))))

(my/test/define 'dethm.if/natp/size)

(defun defun.member? ()
  (J-Bob/define (dethm.if/natp/size)
    '(((defun member? (x ys)
         (if (atom ys)
             'nil
             (if (equal x (car ys))
                 't
                 (member? x (cdr ys)))))
       (size ys)
       (() (if/natp/size ys
                         (if (atom ys)
                             't
                             (if (equal x (car ys))
                                 't
                                 (< (size (cdr ys)) (size ys))))
                         'nil))
       ((E E) (size/cdr ys))
       ((E) (if-same (equal x (car ys)) 't))
       (() (if-same (atom ys) 't))))))

(my/test/define 'defun.member?)

(defun defun.set? ()
  (J-Bob/define (defun.member?)
    '(((defun set? (xs)
         (if (atom xs)
             't
             (if (member? (car xs) (cdr xs))
                 'nil
                 (set? (cdr xs)))))
       (size xs)
       (() (if/natp/size xs
                         (if (atom xs)
                             't
                             (if (member? (car xs) (cdr xs))
                                 't
                                 (< (size (cdr xs)) (size xs))))
                         'nil))
       ((E E) (size/cdr xs))
       ((E) (if-same (member? (car xs) (cdr xs)) 't))
       (() (if-same (atom xs) 't))))))

(my/test/define 'defun.set?)

(defun defun.add-atoms ()
  (J-Bob/define (defun.set?)
    '(((defun add-atoms (x ys)
         (if (atom x)
             (if (member? x ys)
                 ys
                 (cons x ys))
             (add-atoms (car x)
                        (add-atoms (cdr x) ys))))
       (size x)
       (() (if/natp/size x
                         (if (atom x)
                             't
                             (if (< (size (car x)) (size x))
                                 (< (size (cdr x)) (size x))
                                 'nil))
                         'nil))
       ((E Q) (size/car x))
       ((E A) (size/cdr x))
       ((E) (if-true 't 'nil))
       (() (if-same (atom x) 't))))))

(my/test/define 'defun.add-atoms)

;; テスト結果

(my/test/result)

;; 作業エリア

