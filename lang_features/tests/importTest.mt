import testLib.importDummy;
import testLib.importDummy as AnImport;
import testLib.importN as NestedImport;
import testLib.importN;
import testLib.emptyProgram;

typedef int as ubyte;
typedef testLib.importDummy.dummyType as deepImportedType;
typedef NestedImport.importDummy.dummyType as namedDeepType;
typedef AnImport.dummyType as namedShallowType;
