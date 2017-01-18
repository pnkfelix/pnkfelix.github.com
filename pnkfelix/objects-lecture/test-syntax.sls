#!r6rs 
;;; This file defines a simplistic testing macro.
(library (obj-lecture test-syntax)
  (export test)
  (import (rnrs base)
          (rnrs io simple))

  (define-syntax test
    (syntax-rules ()
      ((_ EXPR EXPECTED)
       (let ((actual-val EXPR)
             (expect-val EXPECTED))
         (cond ((equal? actual-val expect-val)
                (display "success") (newline))
               (else
                (display "FAILURE ") 
                (write 'EXPR)
                (newline)
                (display "   should be: ")
                (write expect-val)
                (newline)
                (display "     but got: ")
                (write actual-val)
                (newline))))))))
