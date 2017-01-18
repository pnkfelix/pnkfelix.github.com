#!r6rs
(library (obj-lecture queue1-encapsulated)
  (export empty snoc isEmpty head tail)
  (import (rnrs))
  
  ;; A Queue is an Abstract Value
  
  ;; Internally, a Queue is a (HiddenToken -> Listof[SchemeValue]
  ;; where HiddenToken is a singleton that no other code
  ;; knows about.
  
  ;; concrete->abstract : Listof[SchemeValue] -> Queue
  ;; abstract->concrete : Queue -> Listof[SchemeValue]
  ;; (see bottom of file for how to hide the token in library-less languages)
  (define hidden-token (cons 'unique 'and-hidden))
  (define (concrete->abstract lst)
    (let ((an-abstract-queue
           (lambda (token)
             (if (eq? token hidden-token)
                 lst
                 (error 'queue1-encapsulated
                        "unauthorized-access-attempt")))))
      an-abstract-queue))
  (define (abstract->concrete q)
    (q hidden-token))


  ;; empty : -> Queue
  (define (empty) 
    (concrete->abstract  
     '()))
  
  ;; snoc : Queue SchemeValue -> Queue
  (define (snoc q v)
    (concrete->abstract 
     (append (abstract->concrete q) (list v))))
  
  ;; isEmpty : Queue -> Boolean
  (define (isEmpty q)
    (null? (abstract->concrete q)))
  
  ;; head : Queue -> SchemeValue
  (define (head q)
    (car (abstract->concrete q)))
  
  ;; tail : Queue -> Queue
  (define (tail q)
    (concrete->abstract (cdr (abstract->concrete q)))))
#|
  ;; (Code below illustrates how one might hide the hidden-token
  ;;  outside of a library form; e.g. in R5RS Scheme.  The code must
  ;;  be run in a context where definitions are evaluated from top
  ;;  to bottom order.  (It will also work inside of a library form.)
  (define c->a)
  (define a->c)
  (define dummy 
    (let ((hidden-token ;; binds *the* HiddenToken
           (cons 'unique 'and-hidden)))
      (set! c->a
            (lambda (lst)
              (let ((an-abstract-queue
                     (lambda (token)
                       (if (eq? token hidden-token)
                           lst
                           (error 'queue1-encapsulated
                                  "unauthorized-access-attempt")))))
                an-abstract-queue)))
      (set! a->c
            (lambda (q)
              (q hidden-token)))))
  (define concrete->abstract c->a)
  (define abstract->concrete a->c)
|#
