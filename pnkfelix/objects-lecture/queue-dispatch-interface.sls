#!r6rs
(library (obj-lecture queue-dispatch-interface)
  (export snoc isEmpty head tail) ;; does *not* define empty.  (Why not?)
  (import (rnrs base))

  ;; A Queue is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'snoc          => (Value -> Queue)
  ;; - 'is-empty      => (-> Boolean)
  ;; - 'head          => (-> Value)
  ;; - 'tail          => (-> Queue)

  ;; snoc : Queue SchemeValue -> Queue
  (define (snoc q v)
    (let ((p (q 'snoc)))
      (p v)))

  ;; isEmpty : Queue -> Boolean
  (define (isEmpty q)
    (let ((p (q 'is-empty)))
      (p)))

  ;; head : Queue -> SchemeValue
  (define (head q)
    (let ((p (q 'head)))
      (p)))

  ;; tail : Queue -> Queue
  (define (tail q)
    (let ((p (q 'tail)))
      (p))))
