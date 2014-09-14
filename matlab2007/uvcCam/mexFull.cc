//Read camera data and split into 480x640 Y, Cb and Cr

#include "mex.h"
#include <stdint.h>

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

const int M = 480;
const int N = 640;

int dims[3];
dims[0] = M;
dims[1] = N;
dims[2] = 3;
plhs[0] = mxCreateNumericArray(3,dims,mxUINT8_CLASS,mxREAL);

uint8_t* in  = (uint8_t*) mxGetData(prhs[0]);
uint8_t* out = (uint8_t*) mxGetData(plhs[0]);

int indOut2 = M*N; 
int indOut3 = 2*indOut2;

for (int i = 0; i<M; i++) {
  for (int j = 0; j<N/2; j++) {
    int indOut1 = i+j*(M*2);
    int indIn = j*4+i*N*2;
    out[indOut1] = in[indIn];
    out[indOut1+indOut2] = in[indIn+1];
    out[indOut1+indOut3] = in[indIn+3];

    out[indOut1+M] = in[indIn+2];
    out[indOut1+M+indOut2] = in[indIn+1];
    out[indOut1+M+indOut3] = in[indIn+3];
  }
}

}
