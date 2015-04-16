///////////////////////////////////////
//             DSL_INT_ARRAY          //
///////////////////////////////////////

void * createIntArray()
{
    DSL_intArray * arr = new DSL_intArray();
    void * retval = arr;
    return retval;
}
void * createIntArray_InitialSize(int initialSize)
{
    DSL_intArray * arr = new DSL_intArray(initialSize);
    void * retval = arr;
    return retval;
}
void * createIntArray_Copy(void * void_intarr)
{
    DSL_intArray * likeThisOne = reinterpret_cast<DSL_intArray*>(void_intarr);
    DSL_intArray * arr = new DSL_intArray(*likeThisOne);
    void * retval = arr;
    return retval;
}

void freeIntArray(void * void_intarr)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    delete arr;
}

void intarray_UseAsList(void * void_intarr, int nItems)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    arr->UseAsList(nItems);
}
int intarray_NumItems(void * void_intarr)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    return arr->NumItems();
}
int intarray_GetSize(void * void_intarr)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    return arr->GetSize();
}
int intarray_GetIndex(void * void_intarr, int index)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    return (*arr)[index];
}
void intarray_SetIndex(void * void_intarr, int index, int value)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    (*arr)[index] = value;
}
int intarray_Insert(void * void_intarr, int here, int thisNumber)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    return arr->Insert(here, thisNumber);
}
int intarray_Add(void * void_intarr, int thisNumber)
{
    DSL_intArray * arr = reinterpret_cast<DSL_intArray*>(void_intarr);
    return arr->Add(thisNumber);
}