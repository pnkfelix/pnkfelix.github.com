#!r6rs
(library (obj-lecture queue1)
  (export empty snoc isEmpty head tail)
  (import (rnrs base))

  ;; A Queue is one of:
  ;; - '()
  ;; - (cons SchemeValue Queue)

  ;; interpretation: 
  ;; - the empty list is an empty queue
  ;; - a non-empty list L is a queue whose head is (car L) and 
  ;;   whose tail is (cdr L)

  ;; empty : -> Queue
  (define (empty) '())

  ;; snoc : Queue SchemeValue -> Queue
  (define (snoc q v)
    (cond
      ((null? q) (cons v '()))
      (else (cons (car q)
                  (snoc (cdr q) v)))))

  ;; isEmpty : Queue -> Boolean
  (define (isEmpty q)
    (null? q))

  ;; head : Queue -> SchemeValue
  (define (head q)
    (car q))

  ;; tail : Queue -> Queue
  (define (tail q)
    (cdr q)))
