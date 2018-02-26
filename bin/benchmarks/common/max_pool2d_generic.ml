module Make(M : Owl_types.Ndarray_Basic) = struct

  let _ = Printf.printf "Evaluating max_pool2d operation\n"

  let num_arg = (Array.length Sys.argv) - 1

  let _ =
    if (num_arg != 7)
    then failwith "ERROR! Must provide the stride, and dimensions of the input and kernel as follows:\n
          [batch; input_column; input_row; input_channel; kernel_column; kernel_row; stride]"

  let dims_input = Array.map int_of_string
      (* batch; input_column; input_row; input_channel *)
      [|Sys.argv.(1); Sys.argv.(2); Sys.argv.(3); Sys.argv.(4)|]
  (* kernel_column; kernel_row; *)
  let kernel = Array.map int_of_string [|Sys.argv.(5); Sys.argv.(6);|]
  let stride = int_of_string Sys.argv.(7)
  let _ = Printf.printf "Evaluating input Ndarray with dims: ["
  let _ = Array.iter (fun d -> Printf.printf "%d " d) dims_input
  let _ = Printf.printf "]\n"
  let _ = Printf.printf "And kernel with dims: ["
  let _ = Array.iter (fun d -> Printf.printf "%d " d) dims_input
  let _ = Printf.printf "]\n"
  let _ = Printf.printf "And stride %d \n" stride

  let input = M.empty dims_input
  let stride = [|stride; stride|]
  let output_shape = (M.max_pool2d input kernel stride) |> M.shape
  let output' = M.ones output_shape

  let wrap_fun () =
    begin
      for rep = 0 to 10 do
        let _ = M.max_pool2d input kernel stride in
        let _ = M.max_pool2d_backward Owl_types.SAME input kernel stride output' in
        ()
      done
    end

  let _ = Function_timer.time_function wrap_fun
  let _  = Printf.printf "Done!\n"

end
