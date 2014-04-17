Auto download & compile openssl
-----------

This batch script will automatically download the latest openssl source code and build it using Visual Studio compiler.

Supported Visual Studio are:
*  Visual Studio 2005
*  Visual Studio 2008
*  Visual Studio 2010
*  Visual Studio 2012
*  Visual Studio 2013

Usage :

    $ build.bat

Output :

    third-party
    |-- libopenssl
	|    |-- release-static-32 
    |    |    |-- include
    |    |    +-- lib
	|    |-- release-dll-32 
    |    |    |-- include
    |    |    +-- lib
	|    |-- debug-static-32 
    |    |    |-- include
    |    |    +-- lib
	|    |-- debug-dll-32 
    |    |    |-- include
    |    |    +-- lib
	|    |-- release-static-64
    |    |    |-- include
    |    |    +-- lib
	|    |-- release-dll-64
    |    |    |-- include
    |    |    +-- lib
	|    |-- debug-static-64 
    |    |    |-- include
    |    |    +-- lib
	|    |-- debug-dll-64
    |    |    |-- include
    |    |    +-- lib
    

License (build.bat)
-----------

    The MIT License (MIT)
    
    Copyright (c) 2013 Mohd Rozi
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
