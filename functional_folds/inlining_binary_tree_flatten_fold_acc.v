Require Import List.

(* Type Defintions *)

Inductive binary_tree(V : Type) : Type :=
  Leaf : binary_tree V
| Node : V -> binary_tree V -> binary_tree V -> binary_tree V.

(* ************************* *)
(* Unfolding binary_tree_fold and inlining its definiens *)

Definition binary_tree_flatten_inlined_v1 (V : Type) (t : binary_tree V) : list V :=
  (let V := V in
   let W := list V -> list V in
   let lea := (fun acc => acc) in
   let nod := (fun v h1 h2 acc => v :: (h1 (h2 acc))) in
   let t := t in
   let fix visit t :=
       match t with
         Leaf _ =>
         lea
       | Node _ v t1 t2 =>
         nod v (visit t1) (visit t2)
       end
   in visit t) nil.

(* ************************* *)
(* Unfolding the outer let expressions and commuting the "let fix visit" and the application to nil *)

Definition binary_tree_flatten_inlined_v2 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t :=
    match t with
      Leaf _ =>
      (fun acc => acc)
    | Node _ v t1 t2 =>
      (fun v h1 h2 acc => v :: (h1 (h2 acc))) v (visit t1) (visit t2)
    end
  in visit t nil.

(* ************************* *)
(* Beta-reduction *)

Definition binary_tree_flatten_inlined_v3 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t :=
    match t with
      Leaf _ =>
      (fun acc =>  acc)
    | Node _ v t1 t2 =>
      (fun acc => v :: (visit t1 (visit t2 acc)))
    end
  in visit t nil.

(* ************************* *)
(* Commuting the match-expression and lambda-expressions *)

Definition binary_tree_flatten_inlined_v4 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t := fun acc =>
    match t with
      Leaf _ =>
      acc
    | Node _ v t1 t2 =>
      v :: (visit t1 (visit t2 acc))
    end
  in visit t nil.

(* ************************* *)
(* Transforming the explicit lambda chaining to a curried multi-parameter syntax *)

Definition binary_tree_flatten_inlined_v5 (V :  Type) (t : binary_tree V) : list V :=
  let fix visit t acc :=
    match t with
      Leaf _ =>
        acc
    | Node _ v t1 t2 =>
      v :: (visit t1 (visit t2 acc))
    end
  in visit t nil.

(* ************************* *)
(* Lambda-lifting *)

Fixpoint binary_tree_flatten_inlined_v6_aux (V : Type) (t : binary_tree V)
(acc : list V) : list V :=
  match t with
    Leaf _ =>
      acc
  | Node _ v t1 t2 =>
    v :: (binary_tree_flatten_inlined_v6_aux V t1
    (binary_tree_flatten_inlined_v6_aux V t2 acc))
  end.

Definition binary_tree_flatten_inlined_v6 (V : Type) (t : binary_tree V) : list V :=
  binary_tree_flatten_inlined_v6_aux V t nil.

(* ************************* *)
