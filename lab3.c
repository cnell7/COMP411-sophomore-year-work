#include <stdio.h>
#include <string.h>

int findNull(char arr[]){
	for(int i = 0; i< 100; i++){
		if(arr[i] == '\0'){
			return i;
		}
	}
	return 0;
}

int isPal(char arr[]){
	int indexOfNull = findNull(arr);

	for(int i  =0; i < indexOfNull / 2; i++){
		if(arr[i] != arr[indexOfNull - 1 - i]){
			return 0;
		}
	}

	return 1;
}

void replaceChar(char arr[], char charReplace, char replacement){
	for(int i = 0; i < 100; i++){
		if(arr[i] == charReplace){
			arr[i] = replacement;
		}
	}
}

int main( int argc, char** argv ) {

	char input[100];
	char yesOrNo;
	char charReplace;
	char replacement;
	int indexOfNull;

	printf("Please enter a string (minimum 4 characters): ");
	scanf("%s", input);

	indexOfNull = findNull(input);

	while(indexOfNull < 4){
		printf("len(%s) < 4 characters, please retry: ", input);
		scanf("%s", input);
		indexOfNull = findNull(input);
	}

	printf("Replace a character in \"%s\" (y/n): ", input);
	scanf(" %c", &yesOrNo);

	if(yesOrNo == 'y'){
		printf("What character do you want to replace: ");
		scanf(" %c", &charReplace);
		printf("What is the replacement character: ");
		scanf(" %c", &replacement);
		replaceChar(input, charReplace, replacement);
	}

	if(isPal(input) == 1){
		printf("\"%s\" is a palindrome\n", input);
	} else{
		printf("\"%s\" is not a palindrome\n", input);
	}
}
