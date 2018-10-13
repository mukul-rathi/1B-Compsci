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
  /* TODO */
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
  /* TODO */
	if(tree!=NULL){
		tree_free(tree->left);
		tree_free(tree->right);
		free(tree);
	}

}

/* CHALLENGE EXERCISE */ 

void pop_minimum(Tree *tree, int *min, Tree **new_tree) { 
  /* TODO */
}

Tree *tree_remove(int x, Tree *tree) { 
  /* TODO */
  return empty;
}
