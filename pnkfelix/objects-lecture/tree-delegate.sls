#!r6rs
;; This file defines the Tree "class" that implements Collection
(library (obj-lecture tree-delegate)
  (export leaf left right isLeaf nodeValue node)
  (import (obj-lecture collection-delegate)
          (rnrs base))

  ;; A Tree is a (Msg -> Procedure)
  ;; where Msg is one of:
  ;; - 'left
  ;; - 'right 
  ;; - 'is-leaf
  ;; - 'node-val 
  ;; - 'make-node

  ;; plus the abstract methods that Collection needs implemented:
  ;; - 'is-empty
  ;; - 'add-elem
  ;; - 'some-elem

  ;; (when viewing Trees as collections, the values are held at the
  ;;  nodes; leaves have no values and thus are the empty collections.)

  (define (leaf)           (leaf->object)) ;; constructor implemented below
  (define (left t)         ((t 'left) t))
  (define (right t)        ((t 'right) t))
  (define (isLeaf t)       ((t 'is-leaf) t))
  (define (nodeValue t)    ((t 'node-val) t))
  (define (node t1 t2 val) ((t1 'make-node) t1 t2 val))

  ;; abstract-tree : -> Tree
  ;; constructs handler for Collection methods in terms of Tree methods.
  (define (abstract-tree)
    ;; Our "superclass" is Collection, so make one to handle any messages
    ;; we do not know about
    (let ((super (base-collection)))
      (lambda (sym)
        (cond
          ;; Three "methods" we must implement to claim to be 
          ;; a concretely implemented subclass of Collection
          ((eq? sym 'is-empty) (lambda (self) (isLeaf self)))
          ((eq? sym 'add-elem) (lambda (self v)
                                 (node self (leaf) v))) ;; make new node+leaf
          ((eq? sym 'some-elem)
           ;; (This is a bit tricker than Felix would like...)
           (lambda (self)
             (cond 
               ((isLeaf self)
                (error 'some-elem "cant-use-some-elem-on-empty-trees!"))
               ((isLeaf (left self))   ;; [() x B] -> (x B)
                (list (nodeValue self) (right self)))
               ((isLeaf (right self))  ;; [A x ()] -> (x A)
                (list (nodeValue self) (left self)))
               (else                   ;; [[A x B] -> (y [C x B]) 
                                       ;; where (y C) = someElem of A
                (let* ((val-and-rest (anyElem (left self)))
                       (lft-val  (list-ref val-and-rest 0))
                       (lft-rest (list-ref val-and-rest 1)))
                  (list lft-val (node lft-rest
                                      (right self)
                                      (nodeValue self))))))))

          (else        ;; For any other messages, we pass the buck up to 
           (super sym) ;; parent class and ask it what it wants to do
           )))))

  ;; node-fields->object : Tree Tree Value -> Tree
  (define (node-fields->object lft rgt val)
    (let ((super (abstract-tree)))
      (lambda (sym)
        (cond
          ((eq? sym 'is-leaf)    (lambda (self) #f))
          ((eq? sym 'left)       (lambda (self) lft))
          ((eq? sym 'right)      (lambda (self) rgt))
          ((eq? sym 'node-val)   (lambda (self) val))
          ((eq? sym 'make-node)
           (lambda (self t2 val)
             (node-fields->object self t2 val)))

          (else         ;; For any other messages, we pass the buck up to 
           (super sym)) ;; parent class and ask it what it wants to do
          ))))

  ;; leaf->object : -> Tree
  (define (leaf->object)
    (let ((super (abstract-tree)))
      (lambda (sym)
        (cond
          ((eq? sym 'is-leaf)   (lambda (self) #t))
          ((eq? sym 'left)      (lambda (self) (error 'left "I'm a leaf")))
          ((eq? sym 'right)     (lambda (self) (error 'right "I'm a leaf")))
          ((eq? sym 'make-node) 
           (lambda (self t2 val)
             (node-fields->object self t2 val)))

          (else         ;; For any other messages, we pass the buck up to
           (super sym)) ;; parent class and ask it what it wants to do
          )))))
