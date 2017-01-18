#!r6rs
;;; This file contains WHITE-BOX tests (also known as GLASS-BOX tests)
;;; that rely on the particular representation used by queue1

(import (obj-lecture queue1)
        (obj-lecture test-syntax)
        (only (rnrs base) quote))

(test (empty)
      '())

(test (snoc (empty) 'a)
      '(a))

(test (head (snoc (empty) 'a)) 
      'a)

(test (snoc (snoc (empty) 'a) 'b)
      '(a b))

(test (tail (snoc (snoc (empty) 'a) 'b))
      '(b))

(test (tail
       (tail
        (tail (snoc (snoc (snoc (snoc (snoc (empty)
                                            'a)
                                      'b)
                                'c)
                          'd)
                    'e))))
      '(d e))
