import ctypes
import numpy as np
import pygame
import sys

pygame.init()
clock=pygame.time.Clock()
wi,hi=800,800
cell=32
row,col=wi//cell,hi//cell
screen=pygame.display.set_mode((hi,wi))
pygame.display.set_caption("game of life")
pygame.time.Clock()
cuda_engine=ctypes.CDLL("D:\gpu com\game_of_life.dll")
cuda_engine.constructor.argtypes=[
   ctypes.POINTER(ctypes.c_int),
    ctypes.POINTER(ctypes.c_int),
    ctypes.c_int,
    ctypes.c_int
]
cuda_engine.constructor.restype=ctypes.c_int
current_grid=np.random.choice([0,1],size=row*col,p=[1,0]).astype(np.int32)
next_grid=np.zeros(row*col,dtype=np.int32)

in_grid=current_grid.ctypes.data_as(ctypes.POINTER(ctypes.c_int))
out_grid=next_grid.ctypes.data_as(ctypes.POINTER(ctypes.c_int))

a=cuda_engine.constructor(in_grid,out_grid,row,col)
print(a)
drawing=True
running=True
while running:
    for event in pygame.event.get():
        if event.type==pygame.QUIT:
         running=False
        if event.type==pygame.KEYDOWN:
          if event.key==pygame.K_SPACE:
            drawing=False
        if drawing:
            if drawing and event.type==pygame.MOUSEBUTTONDOWN:
             if event.button==1:
                  mouse_x,mouse_y=pygame.mouse.get_pos()
                  click_x,click_y=mouse_x//cell,mouse_y//cell
                  if(click_x<col and click_y<row):
                        if(current_grid[click_x+click_y*col]==1):
                           current_grid[click_x+click_y*col]=0
                        else:
                           current_grid[click_x+click_y*col]=1
    screen.fill(color=(10,10,10))
    grid_2d=current_grid.reshape(row,col)
    for r in range(row):
       for c in range(col):
          if grid_2d[r,c]==1:
             pygame.draw.rect(
                screen,(255,255,255),
                (c * cell, r * cell, cell - 1, cell - 1)
             )
    if not drawing:
       cuda_engine.gameoflife(in_grid,out_grid,row,col)
       np.copyto(current_grid,next_grid)
    pygame.display.flip()
    clock.tick(5)
pygame.quit()
sys.exit()
     
        