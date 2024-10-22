function <eleType:type,length:int,init:eleType>array():eleType[length] {
    statements {
        for i in length {
            retVal[i]=init;
        }
        return retVal;
    }
}