(declare-const x (_ BitVec 64))
(declare-const y (_ BitVec 64))
(assert (not (=
      (bvadd (bvadd x y)
             (bvneg (bvshl (bvand x y)
                    ((_ bv1 64) 1))))
      (bvxor x y)
      )))
(check-sat)
