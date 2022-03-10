#include<stdio.h>
#include<cuda.h>
#include <time.h>

//Subhan Khaliq
//P180095

__global__ void odd_even_sort(int* x,int I,int n)
{
        int id=blockIdx.x;
        if(I==0 && ((id*2+1)< n)){
                if(x[id*2]>x[id*2+1]){
                        int X=x[id*2];
                        x[id*2]=x[id*2+1];
                        x[id*2+1]=X;
                }
        }
        if(I==1 && ((id*2+2)< n)){
                if(x[id*2+1]>x[id*2+2]){
                        int X=x[id*2+1];
                        x[id*2+1]=x[id*2+2];
                        x[id*2+2]=X;
                }
        }
}
void populate(int array[], int n){
    printf("Populate the Array with Random number between 0-10");
    for(int i = 0; i < n; i++){
        array[i] = (rand() %10) +1;
    }
}
int main()
{
        int array[100],n,c[100],i;
        int *d;
	double time_spent = 0.0;

        printf("Enter size of the Array : ");
        scanf("%d",&n);
        //Populate Array with Random Numbers
        populate(array,n);
        cudaMalloc((void**)&d, n*sizeof(int));

        cudaMemcpy(d,array,n*sizeof(int),cudaMemcpyHostToDevice);
        //Time Spend While Execution
        clock_t begin = clock();
        for(i=0;i<n;i++){

                //int size=n/2;

                odd_even_sort<<<n/2,1>>>(d,i%2,n);
        }
	clock_t end = clock();
        printf("\n");


        cudaMemcpy(c,d,n*sizeof(int), cudaMemcpyDeviceToHost);
        printf("Sorted Array is:\t");
        for(i=0; i<n; i++)
        {
                printf("%d\t",c[i]);
        }
        printf("\n");
        time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
        printf("The time is %f seconds", time_spent);
        printf("\n");
        cudaFree(d);
        return 0;
}
