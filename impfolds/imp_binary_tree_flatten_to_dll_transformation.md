# Imp Binary Tree Flatten To DLL Transformation

Version of 270325

## Type Definitions

```c
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

## Dll Append

```c
Treenode* dll_append(Treenode* ls_ptr, Treenode* ls_ptr_2) {
    return tree_impfold
            ls_ptr_2
            (Treenode* [] (Treenode* treenode_ptr) (Treenode* ihl) (Treenode* ihr) = {
               treenode_ptr->right = ihr;
               if (ihr != NULL) {
                ihr->left = treenode_ptr;
               }
               return treenode_ptr;
            })
            ls_ptr;
}
```

## Transformation process for imp_binary_tree_flatten_to_dll to imp_binary_tree_flatten_to_dll_v2

### Imp Binary Tree Flatten to DLL

```c
Treenode* imp_binary_tree_flatten_to_dll_ip (Treenode* tree_ptr) {
    if (tree_ptr == NULL) {
        return NULL
    } else {
        Treenode* left_subtreenode_ptr = treenode_ptr->left;
        Treenode* right_subtreenode_ptr = treenode_ptr->right;

        Treenode* ih_r =  imp_binary_tree_flatten_to_dll_ip right_subtreenode_ptr;
        Treenode* ih_l = imp_binary_tree_flatten_to_dll_ip left_subtreenode_ptr;

        Treenode* child_dll = dll_append(ihl, ihr);

        treenode_ptr->right = child_dll;
        if (child_dll != NULL) {
            child_dll->left = treenode_ptr;
        }

        return treenode_ptr;
    }
};
```

### Representing imp_binary_tree_flatten_to_dll using tree_impfold

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold(Treenode* tree_ptr) {
    return tree_impfold
            NULL
            (Treenode* [] (Treenode* treenode_ptr)(Treenode* ihl)(Treenode* ihr)= {
                Treenode* child_dll = dll_append(ihl, ihr);
                treenode_ptr->right = child_dll;
                if (child_dll != NULL) {
                    child_dll->left = treenode_ptr;
                }
                return treenode_ptr;
            })
            tree_ptr;
}
```

### Changing codomain from Treenode* to (Treenode* -> Treenode)

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc(Treenode* tree_ptr) {
    return tree_impfold
            (Treenode* [] (Treenode* acc) = {
                return acc;
            })
            (Treenode* [] (Treenode* treenode_ptr)(Treenode* ihl)(Treenode* ihr) (Treenode* acc)= {
                Treenode* child_dll = ihl (ihr acc)
                treenode_ptr->right = child_dll;
                if (child_dll != NULL) {
                    child_dll->left = treenode_ptr;
                }
                return treenode_ptr;
            })
            tree_ptr
            NULL;
}
```

### Unfolding the call to tree_impfold and defining its definiens as separate variables

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc_inlined_v1(Treenode* tree_ptr) {
    Treenode* lea = ([] (Treenode* acc) = {
                return acc;
            });
    Treenode* nod = ([] (Treenode* treenode_ptr)(Treenode* ihl[] (Treenode*))(Treenode* ihr (Treenode*))(Sllnode* acc) = {
                Treenode* child_dll = ihl (ihr acc)
                treenode_ptr->right = child_dll;
                if (child_dll != NULL) {
                    child_dll->left = treenode_ptr;
                }
                return treenode_ptr;
            });
    Treenode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return lea;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Treenode* ih_r[] (Treenode*)= visit right_subtreenode_ptr;
            Treenode* ih_l[] (Treenode*) = visit left_subtreenode_ptr;

            return nod treenode_ptr ih_l ih_r;
        }
    };
    return (visit tree_ptr) NULL;
};
```

### Unfolding the variable declarations except visit and commuting "visit tree_ptr" and the application to NULL

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc_inlined_v2(Treenode* tree_ptr) {
    Treenode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return ([] (Treenode* acc) = {
                return acc;
            });
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Treenode* ih_r[] (Treenode*) = visit right_subtreenode_ptr;
            Treenode* ih_l[] (Treenode*) = visit left_subtreenode_ptr;

            return ([] (Treenode* treenode_ptr)(Treenode* ihl (Treenode*))(Treenode*ihr (Treenode*))(Treenode* acc) = {
                Treenode* child_dll = ihl (ihr acc)
                treenode_ptr->right = child_dll;
                if (child_dll != NULL) {
                    child_dll->left = treenode_ptr;
                }
                return treenode_ptr;
            }) treenode_ptr ih_l ih_r;
        }
    };
    return visit tree_ptr NULL;
};
```

### Beta-reduction

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc_inlined_v3(Treenode* tree_ptr) {
    Treenode* visit (Treenode* treenode_ptr) = {
        if (treenode_ptr == NULL ) {
            return ([] (Treenode* acc) = {
                return acc;
            });
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Treenode* ih_r[] (Treenode*) = visit right_subtreenode_ptr;
            Treenode* ih_l[] (Treenode*) = visit left_subtreenode_ptr;

            return ([] (Sllnode* acc) = {
                Treenode* child_dll = ihl (ihr acc)
                treenode_ptr->right = child_dll;
                if (child_dll != NULL) {
                    child_dll->left = treenode_ptr;
                }
                return treenode_ptr;
            });
        }
    };
    return visit tree_ptr NULL;
};
```

### Commuting the conditional and the lambda-abstractions

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc_inlined_v4(Treenode* tree_ptr) {
    Treenode* visit (Treenode* treenode_ptr) = { [] (Treenode* acc)
        if (treenode_ptr == NULL ) {
            return acc;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Treenode* ih_r[] (Treenode*) = visit right_subtreenode_ptr;
            Treenode* ih_l[] (Treenode*) = visit left_subtreenode_ptr;

            Treenode* child_dll = ihl (ihr acc)
            treenode_ptr->right = child_dll;
            if (child_dll != NULL) {
                child_dll->left = treenode_ptr;
            }
            return treenode_ptr;
        }
    };
    return visit tree_ptr NULL;
};
```

### Transforming the explicit lambda chaining to a curried multi-parameter syntax

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_fold_acc_inlined_v5(Treenode* tree_ptr) {
    Sllnode* visit (Treenode* treenode_ptr) (Treenode* acc) = {
        if (treenode_ptr == NULL ) {
            return acc;
        } else {
            Treenode* left_subtreenode_ptr = treenode_ptr->left;
            Treenode* right_subtreenode_ptr = treenode_ptr->right;

            Treenode* ih_r[] (Treenode*) = visit right_subtreenode_ptr;
            Treenode* ih_l[] (Treenode*) = visit left_subtreenode_ptr;

            Treenode* child_dll = ihl (ihr acc)
            treenode_ptr->right = child_dll;
            if (child_dll != NULL) {
                child_dll->left = treenode_ptr;
            }
            return treenode_ptr;
        }
    };
    return visit tree_ptr NULL;
};
```

### Lambda-lifting and inlining ihl and ihr

```c
Treenode* imp_binary_tree_flatten_to_dll_ip_v2_aux (Treenode* tree_ptr) (Treenode* acc) {
    if (tree_ptr == NULL) {
        return acc
    } else {
        Treenode* left_subtreenode_ptr = treenode_ptr->left;
        Treenode* right_subtreenode_ptr = treenode_ptr->right;

        Treenode* child_dll = imp_binary_tree_flatten_to_dll_ip_v2_aux left_subtreenode_ptr (imp_binary_tree_flatten_to_dll_ip_v2_aux right_subtreenode_ptr acc);

        treenode_ptr->right = child_dll;
        if (child_dll != NULL) {
            child_dll->left = treenode_ptr;
        }

        return treenode_ptr;
    }
};

Treenode* imp_binary_tree_flatten_to_dll_ip_v2 (Treenode* tree_ptr) {
    return imp_binary_tree_flatten_to_dll_ip_v2_aux tree_ptr NULL;
};
```
