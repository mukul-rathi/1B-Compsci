#include <stdlib.h>
#include "tree.h"

Tree *empty = NULL;

/* BASE EXERCISE */

int tree_member(int x, Tree *tree) { 
	if(tree==NULL){
		return 0;
	}
	else if (tree->value==x) {
		return 1;
	}
	else if(tree->value>x){
		return tree_member(x, tree->left);
	}
	else{
		return tree_member(x, tree->right);
	}

}

Tree *tree_insert(int x, Tree *tree) { 
	if(tree==NULL){
		Tree *newTree = (Tree *)malloc(sizeof(Tree));
		newTree->value=x;
		newTree->left=empty;
		newTree->right=empty;
		return newTree;
	}
	else{
		if(x < tree->value){ //recurse on left subtree
			tree->left = tree_insert(x, tree->left);
		} 
		else if(x > tree->value){ //recurse on right subtree
			tree->right = tree_insert(x, tree->right);
		}
		//if x==tree->value we don't do anything as already present
		return tree;
	}
}

void tree_free(Tree *tree) { 
  // NB: the struct provided has no parent pointer so we cannot
// update parent to reflect that they no longer have a child 
// so we have a dangling pointer. 
	if(tree!=NULL){
		tree_free(tree->left);
		tree_free(tree->right);
		free(tree);
	}

}

/* CHALLENGE EXERCISE */ 

void pop_minimum(Tree *tree, int *min, Tree **new_tree) { 
	*new_tree = tree;
	if(tree==NULL){
		min = NULL;
	}
	else{
		Tree *currNode = tree;
		Tree *prevNode = NULL;
		while(currNode->left !=NULL){ 
		//repeatedly traverse down left subtree to find min
			prevNode = currNode;
			currNode = currNode->left;
		}
		//currNode is min node, prev node is parent
		*min = currNode->value;
		tree_free(currNode);
		if(prevNode==NULL){
			*new_tree = empty;
		}
		else{
			prevNode->left = empty;
		}
	}


}

Tree *tree_remove(int x, Tree *tree) { 
  /* TODO */
 	if(tree==NULL){ //x not present
		return empty;
	}
	else{
		if(x<tree->value){
			tree->left = tree_remove(x, tree->left);
		}
		else if(x>tree->value){
			tree->right = tree_remove(x, tree->right);
		}
		else{ //x==tree->value
			//if only one subtree, shift up
			if(tree->right==NULL){
				tree = tree->left;
			}
			else if(tree->left==NULL){
				tree = tree->right;
			}
			else{
				int *min = &x;
		 		//delete min of right subtree
				pop_minimum(tree->right, min, &(tree->right));
				tree->value = *min; //copy across min value
			}
		}

		return tree;
	}
}	 		
 

