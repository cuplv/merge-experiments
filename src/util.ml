let big_of_string s = Bigstringaf.of_string s ~off:0 ~len:(String.length s)

let get_blob v =
  let v = (function Scylla.Protocol.Blob b -> b | _ -> failwith "error") v in
  v

let get_string v = Bigstringaf.to_string (get_blob v)

let get_int v =
  let v = (function Scylla.Protocol.Int b -> b | _ -> failwith "error") v in
  Int32.to_int v

(* merge lca v1 v2 -> v3 *)
type mergefun = string -> string -> string -> (string, string) result

let (let*) x f = Result.bind x f
let (let+) x f = Result.map f x
let (let@+) x f = Option.map f x
let (let$) = Lwt.bind
let (and$) = Lwt.both

let rec loop_until_y (msg:string) : unit Lwt.t = 
  let$ () = Lwt_io.printf "%s" msg in
  let$ str = Lwt_io.read_line Lwt_io.stdin in
  if str="y" then Lwt.return ()
  else loop_until_y msg

type vector_clock = (string*int) list

let vc_from_string (s:string) : (string*int) list = 
  let pstrs = String.split_on_char ',' s in
  let vc = List.map 
    (fun pstr -> Scanf.sscanf pstr "(%s * %d)" 
                    (fun b n -> (b,n)))
    pstrs in
  vc

let vc_to_string (vc: (string*int) list) : string = 
  String.concat "," @@ 
    List.map (fun (b,n) -> Printf.sprintf "(%s * %d)" b n) vc

let vc_normal_form vc = List.sort_uniq
  (fun (b1,_) (b2,_) -> String.compare b1 b2) vc

let vc_bottom () = 
  List.map (fun b -> (b,0)) !Config._branch_list

let vc_compute_lub = function
  | [] -> raise (Invalid_argument "LUB requires at least one vc")
  | vcs -> 
      let lub: vector_clock -> vector_clock -> vector_clock =
        fun vc1 vc2 ->
          List.fold_left
          (fun vc1 (b,n) -> match List.assoc_opt b vc1 with
            | None -> (b,n)::vc1
            | Some n' when n'>= n -> vc1
            | Some _ -> (b,n)::(List.remove_assoc b vc1)) vc1 vc2 in
      vc_normal_form @@ List.fold_left lub (vc_bottom ()) vcs 

let vc_is_leq (vc1:vector_clock) (vc2:vector_clock) = 
  List.for_all 
    (fun (b,n) -> match n=0, List.assoc_opt b vc1 with 
      | true, _ -> true (* if vc2.b = 0 then true *)
      | false, None -> true (* if vc2.b > 0 and vc1.b = 0 then true*)
      | _ , Some n' when n' <= n -> true (* if vc1.b <= vc2.b then true *)
      | _, _ -> false (* else false *)) 
    vc2
