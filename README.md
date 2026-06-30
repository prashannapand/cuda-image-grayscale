CUDA Accelerated Image Grayscale Pipeline

Its an hybrid application leverages on NVIDIA GPU via CUDA to accelerate image color-to-grayscale conversion, wrapped in an intuitive Python Tkinter user interface.



working mechanism 

python layer:

Opens a Tkinter file dialog to select an image, unpacks the visual pixels into raw RGB byte arrays using OpenCV, and manages the destination directory pathways.

cuda layer:

Accepts dimensions through command-line arguments, allocates shared memory space using cudaMallocManaged, distributes pixel calculations across a parallel 2D thread block grid, and safely flushes the processed bytes back to the storage drive.

tools required 

\-NVIDIA GPU

\-CUDA Toolkit with the nvcc compiler installed
-Python 3.x environment containing the opencv-python and numpy packages

To run:

first compile the cuda code like

nvcc gpu.cu -o gpu.exe, then python code 
python gpupy.py 






