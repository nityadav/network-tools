/* compile with: mex sp_factor.c
 * usage: WH = sp_factor(I, J, W, H)
 * compute WH = W*H but in a sparse manner
 */
/* Written by Zhirong Yang
 */
#include "mex.h"

#define MAX(x,y) ( x < y ? y : x )

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  double *I, *J, *W, *H, *WH;
  mwIndex i,j,k,t;
  mwSize nz,m,r,n;
  
  if ((nlhs < 1) || (nrhs!=4))
    mexErrMsgTxt("Usage: WH = sp_factor(I, J, W, H)");
  
  I = mxGetPr(prhs[0]);
  J = mxGetPr(prhs[1]);
  W = mxGetPr(prhs[2]);
  H = mxGetPr(prhs[3]);
  
  nz = mxGetM(prhs[0]);
  m  = mxGetM(prhs[2]);
  r  = mxGetN(prhs[2]);
  n  = mxGetN(prhs[3]);

  plhs[0] = mxCreateDoubleMatrix(nz, r, mxREAL);
  
  WH  = mxGetPr(plhs[0]);
  
  for(t=0; t<nz; t++) {
      i = I[t]-1;
      j = J[t]-1;
      for(k=0; k<r; k++) {
          WH[nz*k+t] = W[m*k+i] * H[r*j+k];
      }
  }
}
