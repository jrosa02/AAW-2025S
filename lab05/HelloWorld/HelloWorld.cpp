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

// For clarity,error checking has been omitted.

#include <CL/cl.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <string>
#include <fstream>

#define SUCCESS 0
#define FAILURE 1

using namespace std;

/* convert the kernel file into a string */
int convertToString(const char *filename, std::string& s)
{
	size_t size;
	char*  str;
	std::fstream f(filename, (std::fstream::in | std::fstream::binary));

	if(f.is_open())
	{
		size_t fileSize;
		f.seekg(0, std::fstream::end);
		size = fileSize = (size_t)f.tellg();
		f.seekg(0, std::fstream::beg);
		str = new char[size+1];
		if(!str)
		{
			f.close();
			return 0;
		}

		f.read(str, fileSize);
		f.close();
		str[size] = '\0';
		s = str;
		delete[] str;
		return 0;
	}
	cout<<"Error: failed to open file\n:"<<filename<<endl;
	return FAILURE;
}

int main(int argc, char* argv[])
{

	/*Step1: Getting platforms and choose an available one.*/
	cl_uint numPlatforms;	//the NO. of platforms
	cl_platform_id platform = NULL;	//the chosen platform
	cl_int	status = clGetPlatformIDs(0, NULL, &numPlatforms);
	if (status != CL_SUCCESS)
	{
		cout << "Error: Getting platforms!" << endl;
		return FAILURE;
	}

	/*For clarity, choose the first available platform. */
	if(numPlatforms > 0)
	{
		cl_platform_id* platforms = (cl_platform_id* )malloc(numPlatforms* sizeof(cl_platform_id));
		status = clGetPlatformIDs(numPlatforms, platforms, NULL);
		platform = platforms[0];
		free(platforms);
	}

	/*Step 2:Query the platform and choose the first GPU device if has one.Otherwise use the CPU as device.*/
	cl_uint				numDevices = 0;
	cl_device_id        *devices;
	status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, 0, NULL, &numDevices);	
	if (numDevices == 0)	//no GPU available.
	{
		cout << "No GPU device available." << endl;
		cout << "Choose CPU as default device." << endl;
		status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, 0, NULL, &numDevices);	
		devices = (cl_device_id*)malloc(numDevices * sizeof(cl_device_id));
		status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_CPU, numDevices, devices, NULL);
	}
	else
	{
		devices = (cl_device_id*)malloc(numDevices * sizeof(cl_device_id));
		status = clGetDeviceIDs(platform, CL_DEVICE_TYPE_GPU, numDevices, devices, NULL);
	}
	

	/*Step 3: Create context.*/
	cl_context context = clCreateContext(NULL,1, devices,NULL,NULL,NULL);
	
	/*Step 4: Creating command queue associate with the context.*/
	cl_command_queue commandQueue = clCreateCommandQueue(context, devices[0], 0, NULL);

	/*Step 5: Create program object */
	const char *filename = "HelloWorld_Kernel.cl";
	string sourceStr;
	status = convertToString(filename, sourceStr);
	const char *source = sourceStr.c_str();
	size_t sourceSize[] = {strlen(source)};
	cl_program program = clCreateProgramWithSource(context, 1, &source, sourceSize, NULL);
	
	/*Step 6: Build program. */
	status=clBuildProgram(program, 1,devices,NULL,NULL,NULL);

	/*Step 7: Initial input,output for the host and create memory objects for the kernel*/
	char input[0xFFF] = {0};
	if (argc > 1)
	{
		strcpy(input, (const char*)argv[1]);
	}
	else
	{
		cout << "Write input string:" << endl;
		cin >> input;
	}
	cout << "Your input string is:" << endl;
	cout << input << endl;
	size_t strlength = strlen(input);
	cout << "Length of input is:" << strlength << endl;
	size_t out_1_strlength = strlen(input);
	char *output_1 = (char*) malloc(out_1_strlength);
	size_t out_2_strlength = 4*strlen(input);
	char *output_2 = (char*) malloc(out_2_strlength);

	cl_mem inputBuffer = clCreateBuffer(context, CL_MEM_READ_ONLY|CL_MEM_COPY_HOST_PTR, (strlength + 1) * sizeof(char),(void *) input, NULL);
	cl_mem outputBuffer_1 = clCreateBuffer(context, CL_MEM_WRITE_ONLY , out_1_strlength * sizeof(char), NULL, NULL);
	cl_mem outputBuffer_2 = clCreateBuffer(context, CL_MEM_WRITE_ONLY , out_2_strlength * sizeof(char), NULL, NULL);
	cout << "Length of output is:" << out_1_strlength << endl;

	/*Step 8: Create kernel object */
	cl_kernel kernel = clCreateKernel(program,"helloworld", NULL);

	/*Step 9: Sets Kernel arguments.*/
	status = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void *)&inputBuffer);
	status = clSetKernelArg(kernel, 1, sizeof(cl_mem), (void *)&outputBuffer_1);
	status = clSetKernelArg(kernel, 2, sizeof(cl_mem), (void *)&outputBuffer_2);
	
	/*Step 10: Running the kernel.*/
	size_t global_work_size[1] = {strlength};
	status = clEnqueueNDRangeKernel(commandQueue, kernel, 1, NULL, global_work_size, NULL, 0, NULL, NULL);

	/*Step 11: Read the cout put back to host memory.*/
	status = clEnqueueReadBuffer(commandQueue, outputBuffer_1, CL_TRUE, 0, out_1_strlength * sizeof(char), output_1, 0, NULL, NULL);
	status = clEnqueueReadBuffer(commandQueue, outputBuffer_2, CL_TRUE, 0, out_2_strlength * sizeof(char), output_2, 0, NULL, NULL);
	
	output_1[out_1_strlength] = '\0';	//Add the terminal character to the end of output.
	cout << "\noutput_1 string:" << endl;
	cout << output_1 << endl;

	output_2[out_2_strlength] = '\0';	//Add the terminal character to the end of output.
	cout << "\noutput_2 string:" << endl;
	cout << output_2 << endl;

	/*Step 12: Clean the resources.*/
	status = clReleaseKernel(kernel);				//Release kernel.
	status = clReleaseProgram(program);				//Release the program object.
	status = clReleaseMemObject(inputBuffer);		//Release mem object.
	status = clReleaseMemObject(outputBuffer_1);
	status = clReleaseMemObject(outputBuffer_2);
	status = clReleaseCommandQueue(commandQueue);	//Release  Command queue.
	status = clReleaseContext(context);				//Release context.

	if (output_1 != NULL)
	{
		free(output_1);
		output_1 = NULL;
	}

	if (output_2 != NULL)
	{
		free(output_2);
		output_2 = NULL;
	}

	if (devices != NULL)
	{
		free(devices);
		devices = NULL;
	}

	std::cout<<"Passed!\n";
	return SUCCESS;
}