#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<dlfcn.h>

int main()
{
    char o[10];
    int a,b;
    while(scanf(" %s %d %d",o,&a,&b)==3)
    {
        char libname[20];
        strcpy(libname,"./lib");
        strcat(libname,o);
        strcat(libname,".so");

        void *pntr=dlopen(libname,RTLD_LAZY);
        if(pntr==NULL)
        {
            printf("Error!! %s\n",dlerror());
            continue;
        }

        int (*func)(int,int);//function pointer initialization
        func=(int(*)(int,int))dlsym(pntr,o);//finding the function in the symbol table
        if(func==NULL)
        {
            printf("Error!! %s\n",dlerror());
            dlclose(pntr);
            continue;
        }

        int ans=func(a,b);
        printf("%d\n",ans);
        dlclose(pntr);
    }
}
