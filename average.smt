(set-option :pp.bv-literals false)
(declare-const x (_ BitVec 16))
(declare-const y (_ BitVec 16))

(define-fun prom1 ((x1 (_ BitVec 16)) (y1 (_ BitVec 16))) (_ BitVec 16)
  (bvudiv (bvadd x1 y1) (_ bv2 16)))

(define-fun prom2 ((x1 (_ BitVec 16)) (y1 (_ BitVec 16))) (_ BitVec 16)
   (bvadd (bvand x1 y1)
          (bvlshr (bvxor x1 y1) (_ bv1 16))
   )
) 

(assert (bvult x (_ bv32768 16)))
(assert (bvult y (_ bv32768 16)))
(assert (not (= (prom1 x y) (prom2 x y))))

; comment
(check-sat)

