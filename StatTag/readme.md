

Scintilla

## LLVM options ##

//* Change your compiler C option to C-99
//* Compile sources as Objective-C++

http://stackoverflow.com/questions/10266622/how-do-i-interface-my-objc-program-with-an-objc-library/10275263#10275263

Go to your project's Build Settings
Under Apple LLVM Compiler x.x - Preprocessing
Option Preprocessor Macros
Add to both Debug and Release :
SCI_NAMESPACE SCI_LEXER


Your .m file (where you reference Scintilla) needs to support Objective-C++, so change it to .mm

