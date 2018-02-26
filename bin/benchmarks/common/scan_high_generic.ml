module Make(M : Owl_types.Ndarray_Basic) = struct

  let _ = Printf.printf "Evaluating scan operation\n"

  let rank = (Array.length Sys.argv) - 1

  let _ =
    if (rank <= 0)
    then failwith "ERROR! Must provide the dimensions of the Ndarray."

  let dims = Array.init rank (fun i -> int_of_string Sys.argv.(i + 1))
  let _ = Printf.printf "Evaluating Ndarray of rank %d with dims: [" rank
  let _ = Array.iter (fun d -> Printf.printf "%d " d) dims
  let _ = Printf.printf "]\n"

  let v = ref (M.empty dims)

  let wrap_fun () =
    begin
      for rep = 0 to 20 do
        v := M.scan ~axis:(rank - 1) (fun x y -> x +. 1.) !v;
        v := M.scan ~axis:(rank - 1) (fun x y -> x -. 1.) !v;
      done
    end

  let _ = Function_timer.time_function wrap_fun
  let _ = Printf.printf "Done!\n"

end
