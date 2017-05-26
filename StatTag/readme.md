

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



/*****
We need to monitor the following

1) application launched
2) application terminated

Combine these
-----
3) document closed
4) document opened
5) document is not open / no active document


******/

#Generating AppleHelp#

##Converting from Word to Markdown##

To generate AppleHelp, we first take the supporting "Welcome to StatTag.docx" file and convert it to markdown.

* Install pandoc `brew install pandoc` (http://pandoc.org)
* Convert from Word to markdown `pandoc -s Welcome\ to\ StatTag\ for\ macOS\ \(Beta\ 1\).docx -t markdown -o stattag_help.md` (http://pandoc.org/demos.html)
* Make sure your original art files are accessible, as the images will not be extracted

##Converting from Markdown to AppleHelp##

Once your markdown exists, you'll need to break it up into the separate files that represent the individual sections of your document. Alternatively, you can leave the entire document as one markdown file and have one single page of help.

We're using a fork `https://github.com/dbrisinda/jekyll-apple-help` or Jekyll Apple Help (originally from `https://github.com/chuckhoupt/jekyll-apple-help`) to help us convert from Markdown to AppleHelp.

* Organize your project files as specified by Jekyll Apple Help.
* Replace the files in the AppleHelp project
* Adjust navigation as required



