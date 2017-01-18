#!r6rs
;; This file defines the Queue1 "class" that implements Collection
(library (obj-lecture queue1-delegate)
  (export empty snoc isEmpty head tail)
  (import (only (obj-lecture collection-delegate) base-collection)
          (prefix (obj-lecture queue1) q1impl:)
          (rnrs base))

  ;; A Queue is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'snoc      => (Self * Value -> Queue)
  ;; - 'is-empty  => (Self -> Bool)
  ;; - 'head      => (Self -> Value)
  ;; - 'tail      => (Self -> Queue)
  ;; 
  ;; plus the abstract methods that Collection needs implemented:
  ;; - 'is-empty
  ;; - 'add-elem
  ;; - 'some-elem

  ;; A QueueRep is whatever (obj-lecture queue1) uses to represent Queue

  (define (snoc q v)     ((q 'snoc) q v))
  (define (isEmpty q)    ((q 'is-empty) q))
  (define (head q)       ((q 'head) q))
  (define (tail q)       ((q 'tail) q))

  ;; QueueRep -> Queue
  (define (concrete->object q1rep)
    ;; Our "superclass" is Collection, so make one to handle
    ;; any messages we don't know about.
    (let ((super (base-collection)))
      (let ((queue-obj 
             (lambda (sym)
               (cond
                 ;; These four are standard Queue messages from 
                 ;; queue1-dispatch with self parameter added to each
                 ((eq? sym 'snoc)
                  (lambda (self val)
                    (snoc-impl q1rep val)))
                 ((eq? sym 'is-empty)
                  (lambda (self) 
                    (isEmpty-impl q1rep)))
                 ((eq? sym 'head)
                  (lambda (self)
                    (head-impl q1rep)))
                 ((eq? sym 'tail)
                  (lambda (self)
                    (tail-impl q1rep)))
                 ;; These two are the "abstract methods" that we are
                 ;; responsible for implementing if we want to claim
                 ;; to be a concretely implemented subclass of 
                 ;; Collection
                 ;; This code "links" the messages that Collection 
                 ;; supports to the procedures that we've already defined
                 ;; for Queue
                 ((eq? sym 'add-elem)
                  (lambda (self val)
                    (snoc self val)))
                 ((eq? sym 'some-elem)
                  (lambda (self)
                    (list (head self) (tail self))))
                 ;; The is-empty message is handled above; we got
                 ;; lucky.  (Food for thought: what if the 
                 ;; interface for Collection's is-empty did not 
                 ;; that of Queue's is-empty?)

                 (else         ;; For other messages, we pass the buck up to
                  (super sym)) ;; parent class and ask it what it wants to do.
                 ))))
        queue-obj)))

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
