
int add(int a, int b)
{
    return a + b;
}

int max(int *listPtr, int size)
{
    int currentMax = *listPtr;

    for (int i = 0; i < size; i++)
    {
        if (currentMax < *listPtr)
        {
            currentMax = *listPtr;
        }
        listPtr++;
    }

    return currentMax;
}

float dotProduct(float *listPtrA, float *listPtrB, int size)
{
    float sum = 0;

    for (int i = 0; i < size; i++)
    {
        sum = sum + (*listPtrA * *listPtrB);
        listPtrA++;
        listPtrB++;
    }
    return sum;
}