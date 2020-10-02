#include <stdio.h>
#define M_PI 3.14159265358979323846

int main( int argc, char** argv ) {
	int i;
	float area;
	printf("Please select a 2D shape (1 = circle, 2 = rectangle, 3 = triangle): ");
	scanf("%d", &i);
	if(i == 1){
		float rad;
		printf("You selected a circle, please enter the radius: ");
		scanf("%f", &rad);
		area = M_PI * (rad * rad);
		printf("The area of your circle is: %.1f \n", area);
	} else if(i == 2){
		float length;
		float width;
		printf("You selected a rectangle, please enter the length: ");
		scanf("%f", &length);
		printf("You selected a rectangle, please enter the width: ");
		scanf("%f", &width);
		area = length * width;
		printf("The area of your rectangle is: %.1f \n", area);
	} else{
		float base;
		float height;
		printf("You selected a triangle, ");
		printf("You selected a triangle, please enter the base: ");
		scanf("%f", &base);
		printf("You selected a triangle, please enter a height: ");
		scanf("%f", &height);
		area = .5 * base * height;
		printf("The area of your triangle is: %.1f \n", area);
	}
	return 0;

}