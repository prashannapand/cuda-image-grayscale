
#include <fstream>
#include <iostream>
#include <cuda_runtime.h>
#include <string>
__global__ void kernel(unsigned char* h_in,unsigned char* h_out,int width,int height)
{
  int col = threadIdx.x+blockIdx.x*blockDim.x;
  int row = threadIdx.y+blockIdx.y*blockDim.y;
  if(row<height && col<width)
  {
    int ind=row*width+col;
    int rgb=3*ind;
    h_out[ind]=(unsigned char)(0.299f*h_in[rgb]+0.587f*h_in[rgb+1]+0.144*h_in[rgb+2]);
  }
}

int main(int argc,char*argv[])
{
  unsigned char* h_in,*h_out;
  if(argc<5)
  {
    std::cerr<<"argument missing";
  }
  int img_height = std::stoi(argv[1]); 
  int img_width  = std::stoi(argv[2]);
  std::string input_path=argv[3];
  std::string output_path=argv[4];
  int total = img_height * img_width * 3;
  int totalout = img_height * img_width ;
  cudaMallocManaged(&h_in, total * sizeof(unsigned char));
  cudaMallocManaged(&h_out, totalout * sizeof(unsigned char));
  std::ifstream file(input_path, std::ios::binary);
  file.read((char*)h_in, total);
  file.close();
  dim3 block(16,16);
  dim3 grid((img_width+block.x-1)/block.x,(img_height+block.y-1)/block.y);
  kernel<<<grid,block>>>(h_in,h_out,img_width,img_height);
  cudaDeviceSynchronize();
  std::ofstream out(output_path,std::ios::binary);
  out.write((char*)h_out,totalout);
  out.close();
  cudaFree(h_in);
  cudaFree(h_out);
  return 0;
}