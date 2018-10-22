#include "matrix.h"
#include <stdbool.h>

matrix_t matrix_create(int rows, int cols) { 
  matrix_t m = {rows,cols, (double *) calloc(cols*rows,sizeof(double))};
  return m;
}

double matrix_get(matrix_t m, int r, int c) { 
  assert(r < m.rows && c < m.cols);
  return m.elts[m.cols*r+c];
}

void matrix_set(matrix_t m, int r, int c, double d) { 
  assert(r < m.rows && c < m.cols);
  m.elts[m.cols*r+c] = d;
}


void matrix_free(matrix_t m) { 
	free(&m);
}

matrix_t matrix_multiply(matrix_t m1, matrix_t m2) { 
  /* TODO */
  matrix_t m = {m1.rows, m2.cols, (double *) calloc(m1.rows*m2.cols,sizeof(double))};
	double sum =0;
	for(int r=0; r<m1.rows; r++){
		for(int c=0; c<m2.cols; c++){
			sum = 0;
			for(int a=0; a<m1.cols; a++){
				sum+= matrix_get(m1,r,a)*matrix_get(m2,a,c);
			}
			matrix_set(m, r,c, sum);		
		}
	}
	return m;
	
}

matrix_t matrix_transpose(matrix_t m) { 
  /* TODO */
  matrix_t t = {m.cols, m.rows,  (double *) calloc(m.cols*m.rows,sizeof(double))};
	for(int r=0; r<t.rows; r++){
		for(int c=0; c<t.cols; c++){
			matrix_set(t,r,c, matrix_get(m, c,r));
		}
	}
  return t;
}

matrix_t matrix_multiply_transposed(matrix_t m1, matrix_t m2) { 
  assert(m1.cols == m2.cols);
  /* TODO */
  matrix_t m = {0, 0, NULL};
  return m;
}

matrix_t matrix_multiply_fast(matrix_t m1, matrix_t m2) { 
  /* TODO */
  matrix_t result = {0, 0, NULL};
  return result;
}

void matrix_print(matrix_t m) { 
  for (int i = 0; i < m.rows; i++) { 
    for (int j = 0; j < m.cols; j++) { 
      printf("%g\t", matrix_get(m, i, j));
    }
    printf("\n");
  }
  printf("\n");
}


