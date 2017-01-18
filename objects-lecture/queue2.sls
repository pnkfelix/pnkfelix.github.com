#!r6rs
(library (obj-lecture queue2)
  (export empty snoc isEmpty head tail)
  (import (rnrs base))

  ;; A LoV is one of:  [[ LoV is also written Listof[SchemeValue] ]]
  ;; - '()
  ;; - (cons SchemeValue LoV)

  ;; A Queue is a (list LoV LoV)
  ;;
  ;; interpretation: 
  ;; A Queue (F R) is the sequence (append F (reverse R))
  ;;
  ;; INVARIANT: for any Queue (F R), F is null only if R is null.

  ;; empty : -> Queue
  (define (empty) 
    (list '() '()))

  ;; snoc : Queue SchemeValue -> Queue
  (define (snoc q v)
    (cond ;; (why do we know the first clause below is okay?)
      ((null? (car q)) (list (list v) '())) 
      (else (list (car q) (cons v (cadr q))))))

  ;; isEmpty: Queue -> Boolean
  (define (isEmpty q) 
    (and (null? (car q)) (null? (cadr q))))

  ;; head : Queue -> SchemeValue
  (define (head q) 
    (car (car q)))

  ;; tail : Queue -> Queue
  (define (tail q)
    (cond 
      ((null? (cdr (car q))) (list (reverse (cadr q)) '()))
      (else (list (cdr (car q)) (cadr q))))))
