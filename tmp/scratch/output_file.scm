
;(import
;  (scheme file)
;  (srfi 130))
(import
  (scheme r5rs)
  (scheme base)
  (scheme file)
)

(call-with-output-file "out.txt"
  (lambda (p)
    (display "nada" p)
  )
)

