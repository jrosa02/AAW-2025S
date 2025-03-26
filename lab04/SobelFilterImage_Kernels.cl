/**********************************************************************
Copyright �2015 Advanced Micro Devices, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

�	Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
�	Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
********************************************************************/
/*
 * For a description of the algorithm and the terms used, please see the
 * documentation for this sample.
 *
 * Each thread calculates a pixel component(rgba), by applying a filter 
 * on group of 8 neighbouring pixels in both x and y directions. 
 * Both filters are summed (vector sum) to form the final result.
 */

void bubbleSort(int arr[], int n);

void swap(int* arr, int i, int j) {
    int temp = arr[i];
    arr[i] = arr[j];
    arr[j] = temp;
}

void bubbleSort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
      
        // Last i elements are already in place, so the loop
        // will only num n - i - 1 times
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1])
                swap(arr, j, j + 1);
        }
    }
}

#define ELLIPSE 1
#define ELLIPSE_DIMX 7u
#define ELLIPSE_DIMY 7u

__constant sampler_t imageSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_LINEAR; 

__kernel void sobel_filter(__read_only image2d_t inputImage, __write_only image2d_t outputImage)
{
	const int2 coord = (int2)(get_global_id(0), get_global_id(1));

	int2 square_dim = (int2)(ELLIPSE_DIMX, ELLIPSE_DIMY);

	int sort_buffer[ELLIPSE_DIMX*ELLIPSE_DIMY] = {0};

	uint4 pixel = (uint4)(0);
	//if(coord.x == 50 && coord.y == 50 )
	{
		for(int row = (coord.x) - (square_dim.x/(int)2); row <= (coord.x) + (square_dim.x/(int)2); ++row){
			for(int col = coord.y - (square_dim.y/(int)2); col <= coord.y + (square_dim.y/(int)2); ++col){

				pixel = read_imageui(inputImage, imageSampler, (int2)(row, col));
#if ELLIPSE
				int x2 = (row - coord.x)*(row - coord.x);
				int a2 = (square_dim.x*square_dim.x/4);
				int y2 = (col - coord.y)*(col - coord.y);
				int b2 = (square_dim.y*square_dim.y/4);

				if(	((float)x2)/((float)a2) + ((float)y2)/((float)b2) <= 1)
#endif
				{
					size_t index = ELLIPSE_DIMX*(row-coord.x+(square_dim.x/(int)2))+(col-coord.y+(square_dim.y/(int)2));
					sort_buffer[index] = (int)pixel.x;
				}
			}
		}
	}

	bubbleSort(sort_buffer, ELLIPSE_DIMX*ELLIPSE_DIMY);
	size_t middle = sizeof(sort_buffer)/(2*sizeof(sort_buffer[0]))+1 + ELLIPSE_DIMX*ELLIPSE_DIMY*ELLIPSE/4;
	int median_val = sort_buffer[middle];


	uint4 outpixel = (uint4){median_val, median_val, median_val, 0};

	//write_imageui(outputImage, coord, convert_uint4(pixel));
	write_imageui(outputImage, coord, outpixel);
			
}

	
