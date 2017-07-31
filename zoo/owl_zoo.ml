(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)


let write_file f s =
  let h = open_out f in
  Printf.fprintf h "%s" s;
  close_out h


let preprocess script =
  let prefix = "." ^ (Filename.basename script) in
  let tmp_script = Filename.temp_file prefix "ml" in
  let content =
    "#require \"owl\"\n" ^
    "#require \"owl_zoo\"\n" ^
    Printf.sprintf "#use \"%s\"\n" script
  in
  write_file tmp_script content;
  tmp_script


let remove_gist gist =
  Log.debug "owl_zoo: %s removed" gist;
  let dir = Sys.getenv "HOME" ^ "/.owl/zoo/" ^ gist in
  let cmd = Printf.sprintf "rm -rf %s" dir in
  Sys.command cmd |> ignore


let upload_gist gist =
  Log.debug "owl_zoo: %s uploading" gist;
  let cmd = Printf.sprintf "owl_upload_gist.sh %s" gist in
  Sys.command cmd |> ignore


let download_gist gist =
  Log.debug "owl_zoo: %s downloading" gist;
  let cmd = Printf.sprintf "owl_download_gist.sh %s" gist in
  Sys.command cmd |> ignore


let list_gist () =
  let dir = Sys.getenv "HOME" ^ "/.owl/zoo/" in
  Log.debug "owl_zoo: %s" dir;
  let cmd = Printf.sprintf "owl_list_gist.sh" in
  Sys.command cmd |> ignore


let run args script =
  let new_script = preprocess script in
  let cmd = Printf.sprintf "utop %s %s" args new_script in
  Sys.command cmd


let print_info () =
  let info =
    "Owl's Zoo System\n\n" ^
    "Usage: \n" ^
    "  owl [utop options] [script-file]\texecute an Owl script\n" ^
    "  owl -upload [gist-directory]\t\tupload code snippet to gist\n" ^
    "  owl -download [gist-id]\t\tdownload code snippet from gist\n" ^
    "  owl -remove [gist-id]\t\t\tremove a cached gist\n" ^
    "  owl -list\t\t\t\tlist all the cached gists\n" ^
    "  owl -help\t\t\t\tprint out help information\n"
  in
  print_endline info


let _ =
  Log.color_on (); Log.(set_log_level DEBUG);

  if Array.length Sys.argv < 2 then
    print_info ()
  else if Sys.argv.(1) = "-upload" then
    upload_gist Sys.argv.(2)
  else if Sys.argv.(1) = "-download" then
    download_gist Sys.argv.(2)
  else if Sys.argv.(1) = "-remove" then
    remove_gist Sys.argv.(2)
  else if Sys.argv.(1) = "-list" then
    list_gist ()
  else if Sys.argv.(1) = "-help" then
    print_info ()
  else (
    let len = Array.length Sys.argv in
    let script = Sys.argv.(len - 1) in
    let args = Array.sub Sys.argv 1 (len - 2)
      |> Array.fold_left (fun a s -> a ^ s ^ " ") ""
    in
    run args script |> ignore
  )


(*
let read_file f =
  let h = open_in f in
  let s = Utils.Stack.make () in
  (
    try while true do
      let l = input_line h |> String.trim in
      Utils.Stack.push s l;
    done with End_of_file -> ()
  );
  close_in h;
  Utils.Stack.to_array s

*)
