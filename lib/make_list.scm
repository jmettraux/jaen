
(import (scheme base) (scheme r5rs) (scheme file) (srfi 130))

(define read-lines
  (lambda (path)
    (call-with-input-file
      path
      (lambda (p)
        (let loop (
          (ls '())
          (l (read-line p))
        )
          (if (eof-object? l)
            (reverse ls)
            (loop (cons l ls) (read-line p))
          )
        )
      )
    )
  )
)

(define read-trimmed-lines
  (lambda (path)
    (map string-trim-both (read-lines path))
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

(write (group (read-trimmed-lines "src/_list.md")))

