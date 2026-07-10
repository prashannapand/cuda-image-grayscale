#include <cuda_runtime.h>
#include <iostream>
#include <string>
extern"C"
{
    __global__ void mykernel(int*devicgrid,int x_axix,int y_axix,int*devicout)
{
 int alivneb=0;
 int col=blockIdx.x*blockDim.x+threadIdx.x;
 int row=blockDim.y*blockIdx.y+threadIdx.y;
 if(col>=x_axix || row>=y_axix)
 {
    return;
 }
 int ind=col+x_axix*row;
 for (int i = -1; i < 2; i++)
 {
    for(int  j = -1; j < 2; j++)
    {
        if(i==0&&j==0)
        {
            continue;
        }
        int num_col=(col+i+x_axix)%x_axix;
        int num_row=(row+j+y_axix)%y_axix;
        int num_indx=num_col+num_row*x_axix;
        if(devicgrid[num_indx]==1)
        {
            alivneb++;
        }

        
    }
    
 }
 int dat=devicgrid[ind];
 if(dat==1)
 {
    if(alivneb<2||alivneb>3)
    {
      devicout[ind]=0;
    }
    else
    {
        devicout[ind]=1;
    }
 }
 else
 {
    if (alivneb==3)
    {
        devicout[ind]=1;
    }
    else
    {
        devicout[ind]=0;
    }
    
 }

}
 __declspec(dllexport) int constructor(int*ingrid,int*outgrid,int x_axix,int y_axix)
 {
    if(ingrid==nullptr&&outgrid==nullptr&&x_axix==0&&y_axix==0)
    {
        return 1;
    }
    else if(ingrid==nullptr||outgrid==nullptr)
    {
        return 2;
    }
    else if(x_axix==0||y_axix==0)
    {
        return 3;
    }
    else
    {
        return 0;
    }
 }
    __declspec(dllexport) void gameoflife(int*ingrid,int*outgrid,int x_axix,int y_axix)
    {
        int*devicgrid=nullptr;
        int*devicout=nullptr;
        int size_dev=y_axix*x_axix*sizeof(int);
        cudaMalloc((void**)&devicgrid,size_dev);
        cudaMalloc((void**)&devicout,size_dev);
        cudaMemcpy(devicgrid,ingrid,size_dev,cudaMemcpyHostToDevice);
       dim3 block(16,16);
       int gnd1=((16+x_axix-1)/16);
       int gnd2=((16+y_axix-1)/16);
       dim3 grids(gnd1,gnd2);
       mykernel<<<grids,block>>>(devicgrid,x_axix,y_axix,devicout); 
       cudaMemcpy(outgrid,devicout,size_dev,cudaMemcpyDeviceToHost);
       cudaFree(devicgrid);
       cudaFree(devicout);
    }
}