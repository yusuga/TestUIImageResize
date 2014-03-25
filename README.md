TestUIImageResize
======================

CoreImage vs [NYXImagesKit](https://github.com/Nyx0uf/NYXImagesKit) vs Simple drawing CoreGraphics

Benchmark
---
300 trials

    [Simulator 32-bit]
        CIImage(GPU) 		0.021970
        CIImage(CPU) 		0.020830
        CoreGraphics(High) 	0.013109
        NYXImagesKit 		0.013835

    [Simulator 64-bit]
        CIImage(GPU) 		0.016388
        CIImage(CPU) 		0.015756
        CoreGraphics(High) 	0.012297
        NYXImagesKit 		0.012472

    [iPhone4 - iOS7.0]
        CIImage(GPU) 		0.038716
        CIImage(CPU) 		0.038286
        CoreGraphics(High) 	0.278495
        NYXImagesKit 		0.276627

    [iPhone4s - iOS7.0]
        CIImage(GPU) 		0.023969
        CIImage(CPU) 		0.024184
        CoreGraphics(High) 	0.268383
        NYXImagesKit 		0.271239

    [iPhone5 - iOS7.0]
        CIImage(GPU) 		0.015426
        CIImage(CPU) 		0.015094
        CoreGraphics(High) 	0.126053
        NYXImagesKit 		0.127374

    [iPhone5s - iOS7.0]
        CIImage(GPU) 		0.009434
        CIImage(CPU) 		0.009307
        CoreGraphics(High) 	0.066504
        NYXImagesKit 		0.066913

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