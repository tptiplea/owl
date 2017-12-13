(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)


type 'a node = {
  mutable id   : int;            (* unique identifier *)
  mutable name : string;         (* name of the node *)
  mutable prev : 'a node array;  (* parents of the node *)
  mutable next : 'a node array;  (* children of the node *)
  mutable attr : 'a;             (* indicate the validity *)
}

type order = BFS | DFS


let _global_id = ref 0


let node ?(name="") ?(prev=[||]) ?(next=[||]) attr =
  _global_id := !_global_id + 1;
  {
    id = !_global_id;
    name;
    prev;
    next;
    attr;
  }


let connect parents children =
  Array.iter (fun parent ->
    Array.iter (fun child ->
        parent.next <- (Array.append parent.next [|child|]);
        child.prev <- (Array.append child.prev [|parent|]);
    ) children
  ) parents


(* TODO *)
let remove x = None


let refnum x = Array.length x.next


let parents x = x.prev


let children x = x.next


(* depth-first search from [x]; [f : node -> unit] is applied to each node;
  [next node -> node array] returns the next set of nodes to iterate;
*)
let dfs_iter f x next =
  let h = Hashtbl.create 512 in
  let rec _dfs_iter y =
    Array.iter (fun z ->
      if Hashtbl.mem h z.id = false then (
        f z;
        Hashtbl.add h z.id None;
        _dfs_iter (next z);
      )
    ) y
  in
  _dfs_iter x


(* TODO: BFS iterator *)
let bfs_iter f next x = failwith "owl_graph:bfs_iter"


let iter_ancestors order f x =
  match order with
  | BFS -> bfs_iter f x parents
  | DFS -> dfs_iter f x parents


let iter_descendants order f x =
  match order with
  | BFS -> bfs_iter f x children
  | DFS -> dfs_iter f x children


(* TODO *)
let copy = None



(* ends here *)
