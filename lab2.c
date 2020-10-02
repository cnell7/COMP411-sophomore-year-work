#include <stdio.h>
#include <stdbool.h>

int main( int argc, char** argv ) {

	int choice;
	int fill;
	int temp;
	bool goodChoice;
	goodChoice = false;

	while(goodChoice == false){
		printf("Please enter the array size (between 2 and 10): ");
		scanf("%d", &choice);
		
		if(choice > 2 && choice < 10){
			goodChoice = true;
		}
	}

	int list[choice];

	for(int i = 0; i < choice; i++){
		printf("Please enter the value for array[%d]: ", i);
		scanf("%d", &fill);
		list[i] = fill;
	}

	for(int i = 0; i < choice; i++){

		for(int j = 0; j < choice - i - 1; j ++){

			if(list[j] > list[j + 1]){
				temp = list[j];
				list[j] = list[j + 1];
				list[j + 1] = temp;
			}
		}
	}

	printf("The array values sorted in non-decreasing order are: " );

	for(int i = 0; i < choice; i++){

		if(i != choice - 1){
			printf("%d, ", list[i]);
		} else{
			printf("%d\n", list[i]);
		}
	}

	return 0;

}