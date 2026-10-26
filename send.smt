(declare-const s Int)
(declare-const e Int)
(declare-const n Int)
(declare-const d Int)
(declare-const m Int)
(declare-const o Int)
(declare-const r Int)
(declare-const y Int)


(assert (>= s 1))
(assert (>= e 0))
(assert (>= n 0))
(assert (>= d 0))
(assert (>= m 1))
(assert (>= o 0))
(assert (>= r 0))
(assert (>= y 0))

(assert (<= s 9))
(assert (<= e 9))
(assert (<= n 9))
(assert (<= d 9))
(assert (<= m 9))
(assert (<= o 9))
(assert (<= r 9))
(assert (<= y 9))


(assert (= (+ d (* 10 n) (* 100 e) (* 1000 s)
              e (* 10 r) (* 100 o) (* 1000 m))
           (+ y (* 10 e) (* 100 n) (* 1000 o) (* 10000 m))))

(assert  (distinct s e n d m o r y))

(check-sat)           
(get-model)
