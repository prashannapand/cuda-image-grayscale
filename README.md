GPU-Accelerated RGB to Grayscale Converter

A high-performance image processing pipeline that offloads standard RGB-to-grayscale rendering arithmetic onto parallel GPU threads using NVIDIA CUDA Unified Memory. The setup features a lightweight Python Tkinter GUI / CLI wrapper that handles user file management, formats native array buffers natively via OpenCV, and dispatches the execution block directly to a compiled native CUDA binary.

🚀 Architecture OverviewThe system runs as an integrated dual-layer application:Frontend (Python): Uses Tkinter file dialogs to easily choose an image and destination path. 

It decodes standard image layouts (.jpg, .png), flattens the multidimensional array to an uncompressed .bin matrix, calls the underlying CUDA executable via a structured subprocess, and reconstructs the output binary stream back into a visible .png file.Backend (CUDA C++): Loads uncompressed binary blocks natively into high-performance cudaMallocManaged arrays. 

It spawns custom parallel processing blocks (16 * 16 thread configurations) that execute the hardware-accelerated NTSC luminance formula in a true single-pass 2D mapping grid.

Grayscale = 0.299 * R + 0.587* G + 0.114 * B


