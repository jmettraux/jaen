
(import
  (scheme base)
  (scheme r5rs)
  (scheme file)
  (srfi 95)
  (srfi 130))

(write (sort '("bb" "びんしょうりょく" "たいきゅうりょく" "cc" "zz" "cc") string<?))

