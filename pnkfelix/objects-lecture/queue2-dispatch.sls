#!r6rs
(library (obj-lecture queue2-dispatch)
  (export empty snoc isEmpty head tail)
  (import (obj-lecture queue-dispatch-interface)
          (prefix (obj-lecture queue2) q2impl:)
          (rnrs base))

  ;; A Queue is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'snoc          => (Value -> Queue)
  ;; - 'is-empty      => (-> Boolean)
  ;; - 'head          => (-> Value)
  ;; - 'tail          => (-> Queue)

  ;; A QueueRep is whatever (obj-lecture queue2) uses for Queue

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
    (concrete->object (q2impl:empty)))

  ;; snoc-impl : QueueRep SchemeValue -> Queue
  (define (snoc-impl q2rep val)
    (concrete->object (q2impl:snoc q2rep val)))

  ;; isEmpty-impl : QueueRep -> Boolean
  (define (isEmpty-impl q2rep)
    (q2impl:isEmpty q2rep))

  ;; head-impl : QueueRep -> SchemeValue
  (define (head-impl q2rep)
    (q2impl:head q2rep))

  ;; tail-impl : QueueRep -> Queue
  (define (tail-impl q2rep)
    (concrete->object (q2impl:tail q2rep))))
