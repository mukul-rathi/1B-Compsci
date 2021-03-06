#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include "graph.h"

Node *empty = NULL;

Node *node(int value, Node *left, Node *right) { 
  Node *r = malloc(sizeof(Node));
  r->marked = false;
  r->value = value;
  r->left = left;
  r->right = right;
  return r;
}


/* Basic Problems */

int size(Node *node) { 
	if(node==NULL || node->marked){
		return 0;
	}	
	else{
		node->marked = true;
		return 1 + size(node->left) + size(node->right);
	}
}


void unmark(Node *node) { 
  if(node!=NULL && node->marked){
		node->marked = false;
		unmark(node->left);
		unmark(node->right);
	}
}

bool path_from(Node *node1, Node *node2) {
  if(node1==NULL || node2 ==NULL){
		return false;
	}
	return (node1==node2)||path_from(node1->left,node2)||path_from(node1->right, node2);
}
bool cyclic(Node *node) { 
	if(node==NULL) return false;
  return path_from(node->left, node) || path_from(node->right, node);
} 


/* Challenge problems */

void get_nodes(Node *node, Node **dest) { 
	static int counter =0;
  if(dest[0]==NULL){	//we have a new buffer so start counting from 0 again
		counter=0;
	}
	if(node!=NULL && !node->marked){
		node->marked = true;
		dest[counter++] = node;
		get_nodes(node->left, dest);
		get_nodes(node->right, dest);
	}
}

void graph_free(Node *node) { 
  /* TODO */
  unmark(node);
  int n = size(node);
	unmark(node);
	Node * dest[n];
  dest[0] = NULL; //used to indicate when to reset counter in get_nodes
	get_nodes(node, dest);
	for(int i=0; i<n; i++){
			free(dest[i]);
	}

}


