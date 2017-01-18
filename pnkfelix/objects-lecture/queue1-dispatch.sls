#!r6rs
(library (obj-lecture queue1-dispatch)
  (export empty snoc isEmpty head tail)
  (import (obj-lecture queue-dispatch-interface)
          (prefix (obj-lecture queue1) q1impl:)
          (rnrs base))

  ;; A Queue is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'snoc          => (Value -> Queue)
  ;; - 'is-empty      => (-> Boolean)
  ;; - 'head          => (-> Value)
  ;; - 'tail          => (-> Queue)

  ;; A QueueRep is whatever (obj-lecture queue1) uses for Queue

  ;; concrete->object : QueueRep -> Queue
  (define (concrete->object lst)
    (let ((queue-obj 
           (lambda (sym)
             (cond
               ((eq? sym 'snoc) 
                (lambda (val) 
                  (snoc-impl lst val)))
               ((eq? sym 'is-empty)
                (lambda () 
                  (isEmpty-impl lst)))
               ((eq? sym 'head)
                (lambda ()
                  (head-impl lst)))
               ((eq? sym 'tail)
                (lambda ()
                  (tail-impl lst)))))))
      queue-obj))

  ;; empty : -> Queue
  (define (empty) 
    (concrete->object (q1impl:empty)))

  ;; snoc-impl : QueueRep SchemeValue -> Queue
  (define (snoc-impl q1rep val)
    (concrete->object (q1impl:snoc q1rep val)))

  ;; isEmpty-impl : QueueRep -> Boolean
  (define (isEmpty-impl q1rep)
    (q1impl:isEmpty q1rep))

  ;; head-impl : QueueRep -> SchemeValue
  (define (head-impl q1rep)
    (q1impl:head q1rep))

  ;; tail-impl : QueueRep -> Queue
  (define (tail-impl q1rep)
    (concrete->object (q1impl:tail q1rep))))
