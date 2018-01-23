let () = begin
  Alcotest.run "Owl" [
    "algodiff diff", Unit_algodiff_diff.test_set;
    "algodiff grad", Unit_algodiff_grad.test_set;
    "dense matrix", Unit_dense_matrix.test_set;
    "dense ndarray", Unit_dense_ndarray.test_set;
    "sparse matrix", Unit_sparse_matrix.test_set;
    "sparse ndarray", Unit_sparse_ndarray.test_set;
    "stats", Unit_stats.test_set;
    "lazy evaluation", Unit_lazy.test_set;
    "linear algebra", Unit_linalg.test_set;
    "slicing basic", Unit_slicing_basic.test_set;
    "slicing fancy", Unit_slicing_fancy.test_set;
  ]
end
