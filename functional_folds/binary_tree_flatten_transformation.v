(* Start of binary_tree_flatten_transformation.v *)
(* Version of 250325 *)

(* ***************************** *)
(* Imports *)

Require Import List.

(* ***************************** *)
(* Type Defintions *)

Inductive binary_tree (V : Type) : Type :=
  Leaf : binary_tree V
| Node : V -> binary_tree V -> binary_tree V -> binary_tree V.

(* ***************************** *)
(* list_fold_right *)

Definition binary_tree_fold (V W : Type) (lea : W) 
(nod : V -> W -> W -> W) (t : binary_tree V) : W :=
  let fix visit t :=
    match t with
      Leaf _ =>
      lea
    | Node _ v t1 t2 =>
        let ihl := visit t1
        in let ihr := visit t2
           in nod v ihl ihr
    end
  in visit t.

(* ***************************** *)
(* List eqb *)

Fixpoint eqb_list (V : Type) (eqb_V : V -> V -> bool) (v1s v2s : list V) : bool :=
  match v1s with
    nil =>
    match v2s with
      nil =>
      true
    | v2 :: v2s' =>
      false
    end
  | v1 :: v1s' =>
    match v2s with
      nil =>
      false
    | v2 :: v2s' =>
      eqb_V v1 v2 && eqb_list V eqb_V v1s' v2s'
    end
  end.

(* ***************************** *)
(* Binary Tree Flatten Unit Test *)

Definition test_binary_tree_flatten (candidate : forall V : Type, binary_tree V -> list V) : bool :=
  (eqb_list nat Nat.eqb (candidate nat (Leaf nat)) nil)
  &&
    (eqb_list nat Nat.eqb (candidate nat (Node nat 1 (Leaf nat) (Leaf nat))) (1 :: nil))
  &&
    (eqb_list nat Nat.eqb (candidate nat (Node nat 1 (Node nat 2 (Leaf nat) (Leaf nat)) (Leaf nat))) (1 :: 2 :: nil))
  &&
    (eqb_list nat Nat.eqb (candidate nat (Node nat 1 (Leaf nat) (Node nat 2 (Leaf nat) (Leaf nat)))) (1 :: 2 :: nil))
  &&
    (eqb_list nat Nat.eqb (candidate nat (Node nat 1 (Node nat 3 (Leaf nat) (Leaf nat)) (Node nat 2 (Leaf nat) (Leaf nat)))) (1 :: 3 :: 2 :: nil))
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) (Leaf (list nat))) nil)
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) (Node (list nat) (1 :: nil) (Leaf (list nat)) (Leaf (list nat)))) ((1 :: nil) :: nil))
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) (Node (list nat) (1 :: nil) (Leaf (list nat)) (Node (list nat) (2 :: nil) (Leaf (list nat)) (Leaf (list nat))))) ((1 :: nil):: (2 :: nil) :: nil))
&&
  (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) (Node (list nat) (1 :: nil) (Node (list nat) (2 :: nil) (Leaf (list nat)) (Leaf (list nat))) (Leaf (list nat)))) ((1 :: nil):: (2 :: nil) :: nil))
  &&
    (eqb_list (list nat) (eqb_list nat Nat.eqb) (candidate (list nat) (Node (list nat) (1 :: nil) (Node (list nat) (2 :: nil) (Leaf (list nat)) (Leaf (list nat)))(Node (list nat) (3 :: nil) (Leaf (list nat)) (Leaf (list nat))))) ((1 :: nil):: (2 :: nil) :: (3 :: nil) :: nil))
.

(* ***************************** *)
(* Transformation process for binary_tree_flatten to binary_tree_flatten *)

(** Binary Tree Flatten **)

Fixpoint binary_tree_flatten (V : Type) (t : binary_tree V) : list V :=
  match t with
  | Leaf _ =>
     nil
  | Node _ v t1 t2 =>
     v :: (binary_tree_flatten V t1) ++ (binary_tree_flatten V t2)
  end.

Compute (test_binary_tree_flatten binary_tree_flatten).

(** ************************* **)
(** Representing binary_tree_flatten using binary_tree_fold **)

Definition binary_tree_flatten_fold (V : Type) (t : binary_tree V) : list V :=
  binary_tree_fold
    V
    (list V)
    nil
    (fun v ihl ihr => v :: ihl ++ ihr)
    t.

Compute (test_binary_tree_flatten binary_tree_flatten_fold).

(** ************************* **)
(** Changing codomain from List V to (List V -> List V) **)

Definition binary_tree_flatten_fold_acc (V : Type) (t : binary_tree V) : list V :=
  binary_tree_fold
    V
    (list V -> list V)
    (fun acc => acc)
    (fun v ihl ihr acc => v :: (ihl (ihr acc)))
    t
    nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc).

(** ************************* **)
(** Unfolding binary_tree_fold and inlining its definiens **)

Definition binary_tree_flatten_fold_acc_inlined_v1 (V : Type) (t : binary_tree V) : list V :=
  (let V := V in
   let W := list V -> list V in
   let lea := (fun acc => acc) in
   let nod := (fun v ihl ihr acc => v :: (ihl (ihr acc))) in
   let t := t in
   let fix visit t :=
       match t with
         Leaf _ =>
         lea
       | Node _ v t1 t2 =>
         nod v (visit t1) (visit t2)
       end
   in visit t) nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc_inlined_v1).

(** ************************* **)
(** Unfolding the outer let expressions and commuting the "let fix visit" and the application to nil **)

Definition binary_tree_flatten_fold_acc_inlined_v2 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t :=
    match t with
      Leaf _ =>
      (fun acc => acc)
    | Node _ v t1 t2 =>
      (fun v ihl ihr acc => v :: (ihl (ihr acc))) v (visit t1) (visit t2)
    end
  in visit t nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc_inlined_v2).

(* ************************* *)
(** Beta-reduction **)

Definition binary_tree_flatten_fold_acc_inlined_v3 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t :=
    match t with
      Leaf _ =>
      (fun acc =>  acc)
    | Node _ v t1 t2 =>
      (fun acc => v :: (visit t1 (visit t2 acc)))
    end
  in visit t nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc_inlined_v3).

(** ************************* **)
(** Commuting the match-expression and lambda-expressions **)

Definition binary_tree_flatten_fold_acc_inlined_v4 (V : Type) (t : binary_tree V) : list V :=
  let fix visit t := fun acc =>
    match t with
      Leaf _ =>
      acc
    | Node _ v t1 t2 =>
      v :: (visit t1 (visit t2 acc))
    end
  in visit t nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc_inlined_v4).

(** ************************* **)
(** Transforming the explicit lambda chaining to a curried multi-parameter syntax **)

Definition binary_tree_flatten_fold_acc_inlined_v5 (V :  Type) (t : binary_tree V) : list V :=
  let fix visit t acc :=
    match t with
      Leaf _ =>
        acc
    | Node _ v t1 t2 =>
      v :: (visit t1 (visit t2 acc))
    end
  in visit t nil.

Compute (test_binary_tree_flatten binary_tree_flatten_fold_acc_inlined_v5).

(** ************************* **)
(** Lambda-lifting **)

Fixpoint binary_tree_flatten_v2_aux (V : Type) (t : binary_tree V)
(acc : list V) : list V :=
  match t with
    Leaf _ =>
      acc
  | Node _ v t1 t2 =>
    v :: (binary_tree_flatten_v2_aux V t1
    (binary_tree_flatten_v2_aux V t2 acc))
  end.

Definition binary_tree_flatten_v2 (V : Type) (t : binary_tree V) : list V :=
  binary_tree_flatten_v2_aux V t nil.

Compute (test_binary_tree_flatten binary_tree_flatten_v2).

(** ************************* **)
(* ***************************** *)

(* End of File *)
Proposition a :
