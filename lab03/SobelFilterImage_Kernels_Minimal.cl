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

__constant sampler_t imageSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP | CLK_FILTER_LINEAR; 

__kernel void sobel_filter(__read_only image2d_t inputImage, __write_only image2d_t outputImage)
{
	const int2 coord = (int2)(get_global_id(0), get_global_id(1));

	float treshold = 70.0;
	int4 binarized = (int4)(0);
	
	const float4 conv_val = (float4){0.2989, 0.5870, 0.1140, 0.0}; 

	int2 square_dim = (int2)(10, 10);

	unsigned int minimal_pixel = UINT_MAX;
	float4 pixel = (float4)(0);
	float pixel_gray = 0;
	//if(coord.x == 50 && coord.y == 50 )
	{
		for(int row = (coord.x) - (square_dim.x/(int)2); row <= (coord.x) + (square_dim.x/(int)2); ++row){
			for(int col = coord.y - (square_dim.y/(int)2); col <= coord.y + (square_dim.y/(int)2); ++col){
				int x2 = (row - coord.x)*(row - coord.x);
				int a2 = (square_dim.x*square_dim.x/4);
				int y2 = (col - coord.y)*(col - coord.y);
				int b2 = (square_dim.y*square_dim.y/4);
				if(	((float)x2)/((float)a2) + ((float)y2)/((float)b2) <= 1)
				{
					pixel = convert_float4(read_imageui(inputImage, imageSampler, (int2)(row, col)));
					pixel_gray = dot(pixel, conv_val);
					minimal_pixel = (minimal_pixel > pixel_gray) ? pixel_gray : minimal_pixel;
					//printf("minimal = %d; \n\r", minimal_pixel);
					// printf("8");
				}
				else
				{
					// printf(" ");
				}
			}
			// printf("\n");
		}
		//printf("\n\r\n\r");
	}



	// write_imageui(outputImage, coord, convert_uint4(pixel));
	write_imageui(outputImage, coord, (uint4){minimal_pixel, minimal_pixel, minimal_pixel, 0});
			
}

	

	 






	

	




	

	

	
	
