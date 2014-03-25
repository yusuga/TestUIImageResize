TestUIImageResize
======================

CoreImage vs [NYXImagesKit](https://github.com/Nyx0uf/NYXImagesKit) vs Simple drawing CoreGraphics vs [GPUImage](https://github.com/BradLarson/GPUImage)

Benchmark
---
300 trials

Resize 1276x1276px -> 450x450px

    [Simulator 32-bit]
        CoreImage(GPU) 		0.031818
        CoreImage(CPU) 		0.027545
        CoreGraphics(High) 	0.014121
        NYXImagesKit 		0.014675
        GPUImage 			0.018156

    [Simulator 64-bit]
        CoreImage(GPU) 		0.016388
        CoreImage(CPU) 		0.015756
        CoreGraphics(High) 	0.012297
        NYXImagesKit 		0.012472
        GPUImage 			Unknown

    [iPhone4 - iOS7.0]
        CoreImage(GPU) 		0.038021
        CoreImage(CPU) 		0.038575
        CoreGraphics(High) 	0.276835
        NYXImagesKit 		0.275012
        GPUImage 			0.129696
        
    [iPhone4s - iOS7.0]
        CoreImage(GPU) 		0.023805
        CoreImage(CPU) 		0.023923
        CoreGraphics(High) 	0.268174
        NYXImagesKit 		0.268512
        GPUImage 			0.104870

    [iPhone5 - iOS7.0]
        CoreImage(GPU) 		0.015223
        CoreImage(CPU) 		0.014789
        CoreGraphics(High) 	0.125799
        NYXImagesKit 		0.126759
        GPUImage 			0.047676

    [iPhone5s - iOS7.0]
        CoreImage(GPU) 		0.009390
        CoreImage(CPU) 		0.009296
        CoreGraphics(High) 	0.067254
        NYXImagesKit 		0.067010
        GPUImage 			0.029759

License
----------
    Copyright &copy; 2014 Yu Sugawara (https://github.com/yusuga)
    Licensed under the MIT License.

    Permission is hereby granted, free of charge, to any person obtaining a 
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.