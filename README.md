# Grayscale_Image_Processing
Program in 8086 assembly language that performs the processing of a gray scale image -
with components between 0 and 255 and with a maximum of 100 lines and 100 columns, as follows:
- converts the gray scale image into a black and white image (type=0)
- transform all components below a given threshold into black components (type=1)
- transform all components above a given threshold into white components (type=2)
The program will be realized in the form of a function with the equivalent prototype in C:
void image_proc(unsigned char Image[][], unsigned char type, unsigned char n, unsigned char m)
where Image[][] is the matrix to be processed, n is the number of lines, m is the number of columns and type is the type
processing.
