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

__kernel void helloworld(__global char* in, __global char* out_1, __global char* out_2)
{
	int num = get_global_id(0);
	if (in[num] >= 65 && in[num]<=90)
	{
		out_1[num] = in[num] + (97-65); 
	}
	else if (in[num] >= 97 && in[num]<=122)
	{
		out_1[num] = in[num] - (97-65);
	}
	else
	{
		out_1[num] = in[num];
	}


	printf("%d\n\r", num);
	switch (in[num]) {
		case '0': 			out_2[4*num] = '0'; out_2[4*num+1] = '0'; out_2[4*num+2] = '0'; out_2[4*num+3] = '0'; break;
		case '1': 			out_2[4*num] = '0'; out_2[4*num+1] = '0'; out_2[4*num+2] = '0'; out_2[4*num+3] = '1'; break;
		case '2': 			out_2[4*num] = '0'; out_2[4*num+1] = '0'; out_2[4*num+2] = '1'; out_2[4*num+3] = '0'; break;
		case '3':			out_2[4*num] = '0'; out_2[4*num+1] = '0'; out_2[4*num+2] = '1'; out_2[4*num+3] = '1'; break;
		case '4': 			out_2[4*num] = '0'; out_2[4*num+1] = '1'; out_2[4*num+2] = '0'; out_2[4*num+3] = '0'; break;
		case '5': 			out_2[4*num] = '0'; out_2[4*num+1] = '1'; out_2[4*num+2] = '0'; out_2[4*num+3] = '1'; break;
		case '6': 			out_2[4*num] = '0'; out_2[4*num+1] = '1'; out_2[4*num+2] = '1'; out_2[4*num+3] = '0'; break;
		case '7': 			out_2[4*num] = '0'; out_2[4*num+1] = '1'; out_2[4*num+2] = '1'; out_2[4*num+3] = '1'; break;
		case '8': 			out_2[4*num] = '1'; out_2[4*num+1] = '0'; out_2[4*num+2] = '0'; out_2[4*num+3] = '0'; break;
		case '9': 			out_2[4*num] = '1'; out_2[4*num+1] = '0'; out_2[4*num+2] = '0'; out_2[4*num+3] = '1'; break;
		case 'A': case 'a': out_2[4*num] = '1'; out_2[4*num+1] = '0'; out_2[4*num+2] = '1'; out_2[4*num+3] = '0'; break;
		case 'B': case 'b': out_2[4*num] = '1'; out_2[4*num+1] = '0'; out_2[4*num+2] = '1'; out_2[4*num+3] = '1'; break;
		case 'C': case 'c': out_2[4*num] = '1'; out_2[4*num+1] = '1'; out_2[4*num+2] = '0'; out_2[4*num+3] = '0'; break;
		case 'D': case 'd': out_2[4*num] = '1'; out_2[4*num+1] = '1'; out_2[4*num+2] = '0'; out_2[4*num+3] = '1'; break;
		case 'E': case 'e': out_2[4*num] = '1'; out_2[4*num+1] = '1'; out_2[4*num+2] = '1'; out_2[4*num+3] = '0'; break;
		case 'F': case 'f': out_2[4*num] = '1'; out_2[4*num+1] = '1'; out_2[4*num+2] = '1'; out_2[4*num+3] = '1'; break;
		default: 			out_2[4*num] = '_'; out_2[4*num+1] = '_'; out_2[4*num+2] = '_'; out_2[4*num+3] = '_'; break;
	}

}