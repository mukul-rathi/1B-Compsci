#include "matrix.h"
#include <stdbool.h>

matrix_t matrix_create(int rows, int cols) { 
  /* TODO */
  matrix_t m = {0, 0, NULL};
  return m;
}

double matrix_get(matrix_t m, int r, int c) { 
  /* TODO */
  assert(r < m.rows && c < m.cols);
  return 0.0;
}

void matrix_set(matrix_t m, int r, int c, double d) { 
  assert(r < m.rows && c < m.cols);
  /* TODO */
}


void matrix_free(matrix_t m) { 
  /* TODO */
}

matrix_t matrix_multiply(matrix_t m1, matrix_t m2) { 
  /* TODO */
  matrix_t m = {0, 0, NULL};
  return m;
}

matrix_t matrix_transpose(matrix_t m) { 
  /* TODO */
  matrix_t t = {0, 0, NULL}; 
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


