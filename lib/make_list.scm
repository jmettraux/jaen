
(import
  (scheme base)
  (scheme r5rs)
  (scheme file)
  (srfi 95)
  (srfi 130))

; TODO have a line-procs and for-each each of the proc
;      so that trim-line can be simplified string-trim-both out...

(define read-lines
  (lambda (path . line-proc)
    (let (
      (lp (if (> (length line-proc) 0) (car line-proc) (lambda (l) l)))
    )
      (call-with-input-file
        path
        (lambda (p)
          (let loop (
            (ls '())
            (l (read-line p))
          )
            (if (eof-object? l)
              (reverse ls)
              (loop (cons (lp l) ls) (read-line p))
            )
          )
        )
      )
    )
  )
)

(define trim-line
  (lambda (l)
    (let (
      (l1 (string-trim-both l))
    )
      (if (< (string-length l1) 2)
        l1
        (if (string=? (substring l1 0 2) ": ")
          (substring l1 2)
          l1
        )
      )
    )
  )
)

(define group
  (lambda (ls)
    (let loop (
      (ls1 ls) (gs '()) (g '())
    )
      (if (null? ls1)
        gs
        (let (
          (l (car ls1))
        )
          (if (string=? l "")
            ; THEN add group if not empty; loop
            (begin
              (if (not (null? g))
                (loop (cdr ls1) (cons (reverse g) gs) '())
                (loop (cdr ls1) gs '())
              )
            )
            ; ELSE add l to group; loop
            (loop (cdr ls1) gs (cons l g))
          )
        )
      )
    )
  )
)

(define index
  (lambda (gs)
    (let loop (
      (ja '()) (en '()) (gs1 gs)
    )
      (if (null? gs1)
        (list ja en)
        (let (
          (g (car gs1))
        )
          (loop
            (cons (cons (car g) g) ja)
            (cons (cons (caddr g) g) en)
            (cdr gs1)
          )
        )
      )
    )
  )
)

(letrec (

  (jaen (index (group (read-lines "src/_list.md" trim-line))))

  (car-sort (lambda (a b) (string<? (car a) (car b))))
  (ja (sort (car jaen)) car-sort)
  (en (sort (cadr jaen)) car-sort)
)
  (call-with-output-file "src/laa__enja.md" (lambda (enjap)
  (call-with-output-file "src/lzz__jaen.md" (lambda (jaenp)
    (write ja jaenp)
    (write en enjap)
  ))
  ))
)

