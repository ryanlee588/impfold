# Imp Binary Tree Flatten To SLL Transformation

Version of 270325

## Type Definitions

```c
typedef struct Sllnode {
    V value;
    struct Sllnode* next;
} Sllnode;

typedef struct Treenode {
    V value;
    struct Treenode* left;
    struct Treenode* right;
} Treenode;

```

## Tree Impfold

```c
V tree_impfold (V lea) (V (*nod)[] (Treenode*) (V) (V)) (Treenode* treenode_ptr) {
    if (tree_pointer == NULL) {
        return lea;
    } else {
        Treenode* left_subtreenode_ptr = treenode_ptr->left;
        Treenode* right_subtreenode_ptr = treenode_ptr->right;

        V ih_r = tree_impfold lea nod right_subtreenode_ptr;
        V ih_l = tree_impfold lea nod left_subtreenode_ptr;

        return nod treenode_ptr ih_l ih_r;
    }
}
```

## SLL Impfold Right

```c
V sll_impfoldr (V base_case) (V (*cons_case)[] (Sllnode*) (V)) (Sllnode* sllnode_ptr) {
    if (sllnode_ptr == NULL) {
        return base_case;
    } else {
        Sllnode* next_ptr = sllnode_ptr->next;

        V ih = sll_impfoldr base_case cons_case next_ptr;

        return cons_case sllnode_ptr ih;
    }
}
```

## Sll Append

```c
Sllnode* sll_append(Sllnode* ls_ptr, Sllnode* ls_ptr_2) {
    return sll_impfoldr
            ls_ptr_2
            (Sllnode* [] (Sllnode* node_ptr) (Sllnode* ih) = {
               node_ptr->next = ih;
                return node_ptr;
            })
            ls_ptr;
}
```

## Transformation process for imp_binary_tree_flatten_to_sll to imp_binary_tree_flatten_to_sll_v2

### Imp Binary Tree Flatten to SLL

```c
Sllnode* imp_binary_tree_flatten_to_sll (Treenode* tree_ptr) {
    if (tree_ptr == NULL) {
        return NULL
    } else {
        Treenode* left_subtreenode_ptr = treenode_ptr->left;
        Treenode* right_subtreenode_ptr = treenode_ptr->right;

        Sllnode* ih_r =  imp_binary_tree_flatten_to_sll right_subtreenode_ptr;
        Sllnode* ih_l = imp_binary_tree_flatten_to_sll left_subtreenode_ptr;

        Sllnode* child_list = sll_append_right(ihl, ihr);

        Sllnode* current_node = malloc(sizeof(Sllnode));
        current_node->value = tree_ptr->value;
        current_node->next = child_list;

        free tree_ptr;

        return current_node;
    }
};
```

### Representing imp_binary_tree_flatten_to_sll using tree_impfold

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold(Treenode* tree_ptr) {
    return tree_impfold
            NULL
            (Sllnode* [] (Treenode* treenode_ptr)(Sllnode* ihl)(Sllnode* ihr) = {
                Sllnode* child_list = sll_append_right(ihl, ihr);

                Sllnode* current_node = malloc(sizeof(Sllnode));
                current_node->value = treenode_ptr->value;
                current_node->next = child_list;

                free treenode_ptr;

                return current_node;
            })
            tree_ptr;
};
```

### Changing codomain from Sllnode* to (Sllnode* -> Sllnode)

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc(Treenode* tree_ptr) {
    return tree_impfold
            (Sllnode* [] (Sllnode* acc) = {
                return acc;
            })
            (Sllnode* [] (Treenode* treenode_ptr)(Sllnode* ihl)(Sllnode* ihr)(Sllnode* acc) = {
                Sllnode* child_list = ihl (ihr acc);
                Sllnode* current_node = malloc(sizeof(Sllnode));
                current_node->value = treenode_ptr->value;
                current_node->next = child_list
                free treenode_ptr;
                return current_node;
            })
            tree_ptr
            NULL;
};
```

### Unfolding the call to tree_impfold and defining its definiens as separate variables

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc_inlined_v1(Treenode* tree_ptr) {
    Sllnode* lea = ([] (Sllnode* acc) = {
                return acc;
            });
    Sllnode* nod = ([] (Treenode* treenode_ptr)(Sllnode* ihl (Sllnode*))(Sllnode* ihr (Sllnode*))(Sllnode* acc) = {
                Sllnode* child_list = ihl (ihr acc);
                Sllnode* current_node = malloc(sizeof(Sllnode));
                current_node->value = treenode_ptr->value;
                current_node->next = child_list
                free treenode_ptr;
                return current_node;
            });
    Sllnode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return lea;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Sllnode* ih_r[] (Sllnode*)= visit right_subtreenode_ptr;
            Sllnode* ih_l[] (Sllnode*) = visit left_subtreenode_ptr;

            return nod treenode_ptr ih_l ih_r;
        }
    };
    return (visit tree_ptr) NULL;
};
```

### Unfolding the variable declarations except visit and commuting "visit tree_ptr" and the application to NULL

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc_inlined_v2(Treenode* tree_ptr) {
    Sllnode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return ([] (Sllnode* acc) = {
                return acc;
            });
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Sllnode* ih_r[] (Sllnode*) = visit right_subtreenode_ptr;
            Sllnode* ih_l[] (Sllnode*) = visit left_subtreenode_ptr;

            return ([] (Treenode* treenode_ptr)(Sllnode* ihl (Sllnode*))(Sllnode* ihr (Sllnode*))(Sllnode* acc) = {
                Sllnode* child_list = ihl (ihr acc);
                Sllnode* current_node = malloc(sizeof(Sllnode));
                current_node->value = treenode_ptr->value;
                current_node->next = child_list
                free treenode_ptr;
                return current_node;
            }) treenode_ptr ih_l ih_r;
        }
    };
    return visit tree_ptr NULL;
};
```

### Beta-reduction

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc_inlined_v3(Treenode* tree_ptr) {
    Sllnode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return ([] (Sllnode* acc) = {
                return acc;
            });
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Sllnode* ih_r[] (Sllnode*) = visit right_subtreenode_ptr;
            Sllnode* ih_l[] (Sllnode*) = visit left_subtreenode_ptr;

            return ([] (Sllnode* acc) = {
                Sllnode* child_list = ihl (ihr acc);
                Sllnode* current_node = malloc(sizeof(Sllnode));
                current_node->value = treenode_ptr->value;
                current_node->next = child_list
                free treenode_ptr;
                return current_node;
            });
        }
    };
    return visit tree_ptr NULL;
};
```

### Commuting the conditional and the lambda-abstractions

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc_inlined_v4(Treenode* tree_ptr) {
    Sllnode* visit (Treenode* treenode_ptr) = { [] (Sllnode* acc)
        if (treenode_ptr == NULL ) {
            return acc;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Sllnode* ih_r[] (Sllnode*) = visit right_subtreenode_ptr;
            Sllnode* ih_l[] (Sllnode*) = visit left_subtreenode_ptr;

            Sllnode* child_list = ihl (ihr acc);
            Sllnode* current_node = malloc(sizeof(Sllnode));
            current_node->value = treenode_ptr->value;
            current_node->next = child_list
            free treenode_ptr;
            return current_node;
        }
    };
    return visit tree_ptr NULL;
};
```

### Transforming the explicit lambda chaining to a curried multi-parameter syntax

```c
Sllnode* imp_binary_tree_flatten_to_sll_fold_acc_inlined_v5(Treenode* tree_ptr) {
    Sllnode* visit (Treenode* treenode_ptr) (Sllnode* acc) = {
        if (treenode_ptr == NULL ) {
            return acc;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Sllnode* ih_r[] (Sllnode*) = visit right_subtreenode_ptr;
            Sllnode* ih_l[] (Sllnode*) = visit left_subtreenode_ptr;

            Sllnode* child_list = ihl (ihr acc);
            Sllnode* current_node = malloc(sizeof(Sllnode));
            current_node->value = treenode_ptr->value;
            current_node->next = child_list
            free treenode_ptr;
            return current_node;
        }
    };
    return visit tree_ptr NULL;
};
```

### Lambda-lifting and inlining ihl and ihr

```c
Sllnode* imp_binary_tree_flatten_to_sll_v2_aux (Treenode* tree_ptr) (Sllnode* acc) {
    if (tree_ptr == NULL) {
        return acc
    } else {
        Treenode* left_subtreenode_ptr = treenode_ptr->left;
        Treenode* right_subtreenode_ptr = treenode_ptr->right;

        Sllnode* child_list = imp_binary_tree_flatten_to_sll_v2_aux left_subtreenode_ptr (imp_binary_tree_flatten_to_sll_v2_aux right_subtreenode_ptr acc);

        Sllnode* current_node = malloc(sizeof(Sllnode));
        current_node->value = tree_ptr->value;
        current_node->next = child_list;

        free tree_ptr;

        return current_node;
    }
};

Sllnode* imp_binary_tree_flatten_to_sll_v2 (Treenode* tree_ptr) {
    return imp_binary_tree_flatten_to_sll_v2_aux tree_ptr NULL;
};
```
