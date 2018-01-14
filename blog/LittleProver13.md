# 定理証明手習い (13) Jabberwockyリベンジ

> これって本当に定理なんですか？
> たぶん定理ですね。

関数や定理を定義する書き方がわかったので、これで`jabberwocky`も
まっとうに定義できるようになったはず
（`jabberwocky`は再帰的な関数じゃないから）

> `brillig`、`slithy`、`mimsy`、`mome`、`uffish`、`frumious`、`frabjous`が何を意味しているかによりますが。

関数は、`jabberwocky`がちゃんと定理になるよう定義

```
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
```

では実行 ※結果のインデントは手で修正

```
> (J-Bob/step (dethm.jabberwocky)
    '(cons 'gyre
           (if (uffish '(callooh callay))
               (cons 'gimble
                     (if (brillig '(callooh callay))
                         (cons 'borogove '(outgrabe))
                         (cons 'bandersnatch '(wabe))))
               (cons (frabjous '(callooh callay)) '(vorpal))))
    '(((2 A 2 E 1) (jabberwocky '(callooh callay)))))
(cons 'gyre
      (if (uffish '(callooh callay))
          (cons 'gimble
                (if (brillig '(callooh callay)) 
                    (cons 'borogove '(outgrabe)) 
                    (cons (frumious '(callooh callay)) '(wabe))))
          (cons (frabjous '(callooh callay)) '(vorpal))))
```

できた

