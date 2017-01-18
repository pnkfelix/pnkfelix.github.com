#!r6rs
;; This file attempts to mix and match the queue implementations.

;; (the example is a bit more mysterious in a language where
;;  the bindings (for the queue operations) can be over-written;
;;  such as R5RS Scheme.)

(import (prefix (obj-lecture queue1) q1:)
        (prefix (obj-lecture queue2) q2:)
        (rnrs))

(define an-important-queue-abc
  (q1:snoc (q1:snoc (q1:snoc (q1:empty) 'a) 'b) 'c))

(display "B? ")
(display (q1:head (q1:tail an-important-queue-abc)))
(newline)

(display "A? ")
(display (q2:head an-important-queue-abc))
(newline)

(define another-important-queue-xyz
  (q1:snoc (q2:snoc (q1:snoc (q2:empty) 'x) 'y) 'z))

(display "Y? ")
(display (q1:head (q1:tail another-important-queue-xyz)))
(newline)

(display "X? ")
(display (q2:head another-important-queue-xyz))
(newline)
