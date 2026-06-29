import tkinter as tk
from tkinter import filedialog
import cv2
import subprocess
import numpy as np
import os
def run_graysclae():
      try:
         root = tk.Tk()
         root.withdraw()
         print("pleses select image ")
         input_img=filedialog.askopenfilename(
            title="selectimage", 
            filetypes=[("imagefile", " *.png  *.jpg  *jpeg")]
         )
         if input_img is None:
             print("no image selsected")
             return
         else:
             print(" image selsected")
             raw_bytes=np.fromfile(input_img,dtype=np.uint8) 
             img=cv2.imdecode(raw_bytes,cv2.IMREAD_COLOR)
             if img is None:
                   print("couldnt be decoded")
                   return
         print("select where to save the gray image")
         output_im=filedialog.askdirectory(
             title="where to save the image"
         )
         if output_im is None:
             print("no path provided")
             return 
         output_img=os.path.join(output_im,"output.bin")
         height,width,channel=img.shape
         img_rgb=cv2.cvtColor(img,cv2.COLOR_BGR2RGB)
         input_file="img_rgb.bin"
         img_rgb.tofile(input_file)
         print(" file saved")
         executable="./gpu" if os.name!='nt' else"gpu.exe"
         cmd=[executable,str(height),str(width),input_file,output_img]
         print("launching gpu kernel")
         subprocess.run(cmd,capture_output=True,text=True)
         print(f"height is {height},weidth is {width},channel is{channel} ")
         gray_data=np.fromfile(output_img,dtype=np.uint8)
         gray_img=gray_data.reshape(height,width)
         output_gray_img=os.path.join(output_im,"output.png")
         cv2.imwrite(output_gray_img,gray_img)
         if os.path.exists(output_img):
             os.remove(output_img)
         if os.path.exists(input_file):
             os.remove(input_file)
      except Exception as e:
         print(f"error{e}")
         
run_graysclae()
