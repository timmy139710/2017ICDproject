# Image Processing with Gaussian Blur

### Summary:  
Design a image processing engine which supports the following features:  
1. Frame size is 128x128, and input photo is in grayscale format.
2. Be able to request and read the image from host.
3. Apply a gaussian blur filter to the original image, window size is 5x5.  
4. Corners and edges are ignored, only apply the filter to center 124x124 pixels.
5. Be able to write the processed pixel to assigned memory location.  
6. Synthesis the design and pass post-synthesis simulation.

### Block Diagram:  
1. System block diagram:
<img src=https://github.com/timmy139710/Integrated-Circuit-Design/blob/master/pic/Final_block.png alt="block" width=500 height=300>  
 
2. Gaussian Blur Filter:
<p align="left">
<img src=https://github.com/timmy139710/Integrated-Circuit-Design/blob/master/pic/Final_image1.png alt="p1" width=256 height=256>
<img src=https://github.com/timmy139710/Integrated-Circuit-Design/blob/master/pic/Final_image2.png alt="p2" width=256 height=256>
</p>

<!-- <p class="left">
<img src=https://github.com/timmy139710/CAD-VLSI-System-Design/blob/master/pic/final_5.png alt="p3" width=256 height=256>
<img src=https://github.com/timmy139710/CAD-VLSI-System-Design/blob/master/pic/final_6.png alt="p4" width=256 height=256>  
</p> -->

3. Post-Synthesis Simulation  
<img src=https://github.com/timmy139710/Integrated-Circuit-Design/blob/master/pic/Final_sim.png alt="block" width=500 height=500>  