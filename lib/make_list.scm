
(import
  (r7rs-setup)
  (scheme base)
  (scheme r5rs)
  (scheme file)
  (srfi 1)
  (srfi 28)
  (srfi 95)
  (srfi 130)
)

;(define fold-left
;  (lambda (kons knil ls)
;    (let lp (
;      (ls ls) (acc knil)
;    )
;      (if (pair? ls) (lp (cdr ls) (kons acc (car ls))) acc)
;    )
;  )
;)

(define read-lines
  (lambda (path . line-procs)
    (call-with-input-file
      path
      (lambda (p)
        (let loop (
          [ls '()]
          [l (read-line p)]
        )
          (if (eof-object? l)
            (reverse ls)
            (let (
              [l1 (fold (lambda (f r)
                (f r)) l line-procs)]
              ;[l1 (fold-left (lambda (r f)
              ;  (f r)) l line-procs)]
            )
              (loop (cons l1 ls) (read-line p))
            )
          )
        )
      )
    )
  )
)

(define trim-colon-space
  (lambda (s)
    (if
      (< (string-length s) 2)
      s
      (if (string=? (string-copy s 0 2) ": ")
        (string-copy s 2)
        s
      )
    )
  )
)

(define group
  (lambda (ls)
    (let loop (
      [ls1 ls] [gs '()] [g '()]
    )
      (if (null? ls1)
        gs
        (let (
          [l (car ls1)]
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
      [ja '()] [en '()] [gs1 gs]
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

  [jaen
    (index
      (group
        (read-lines "src/_list.md" string-trim-both trim-colon-space)))]

  [car-sort (lambda (a b) (string<? (car a) (car b)))]
  [ja (sort (car jaen) car-sort)] ; sort by Hiragana?
  [en (sort (cadr jaen) car-sort)]
)

  ;(write en) (newline)
  ;(write ja) (newline)

  (call-with-output-file "src/laa__enja.md" (lambda (enjap)
    (newline enjap)
    (for-each
      (lambda (e)
        (format enjap "~a\n" (car e))
        (format enjap ": ~a\n" (cadr e))
        (format enjap ": ~a\n" (caddr e))
        (for-each (lambda (ee) (format enjap ": ~a\n" ee)) (cddddr e))
        (newline enjap)
      )
      en
    )
  ))

  (call-with-output-file "src/lzz__jaen.md" (lambda (jaenp)
    (write ja jaenp)
  ))
)

