module M = Owl_dense_ndarray.S

let x = M.sequential [|4; 4|]

let _ = M.print x
