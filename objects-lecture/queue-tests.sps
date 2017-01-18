#!r6rs
;;; This file contains BLACK-BOX tests that rely *only*
;;; on guarantees provided by the Queue abstract data type (ADT).

(import (obj-lecture queue1) ;; switch between queue impls
        (obj-lecture test-syntax)
        (only (rnrs base) quote))

(test (isEmpty (empty)) 
      #t)

(test (isEmpty (snoc (empty) 'a)) 
      #f)

(test (head (snoc (empty) 'a)) 
      'a)

(test (head (snoc (snoc (empty) 'a) 'b))
      'a)

(test (head (tail (snoc (snoc (empty) 'a) 'b)))
      'b)

(test (head (tail
             (tail
              (tail (snoc (snoc (snoc (snoc (snoc (empty)
                                                  'a)
                                            'b)
                                      'c)
                                'd)
                          'e)))))
      'd)
