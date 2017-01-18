#!r6rs
;; This file attempts to mix and match the queue implementations.

;; (the example is a bit more mysterious in a language where
;;  the bindings (for the queue operations) can be over-written;
;;  such as R5RS Scheme.)

(import (only (prefix (obj-lecture queue1-dispatch) q1:) q1:empty)
        (only (prefix (obj-lecture queue2-dispatch) q2:) q2:empty)
        (obj-lecture queue-dispatch-interface)
        (rnrs))

(define an-important-queue-abc
  (snoc (snoc (snoc (q1:empty) 'a) 'b) 'c))

(display "B? ")
(display (head (tail an-important-queue-abc)))
(newline)

(display "A? ")
(display (head an-important-queue-abc))
(newline)

(define another-important-queue-xyz
  (snoc (snoc (snoc (q2:empty) 'x) 'y) 'z))

(display "Y? ")
(display (head (tail another-important-queue-xyz)))
(newline)

(display "X? ")
(display (head another-important-queue-xyz))
(newline)
