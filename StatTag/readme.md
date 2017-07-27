
# StatTag for macOS #

# How StatTag is Structured #

We designed StatTag for macOS with a few key principles in mind:

* Ensure document compatibility between platforms.
* Ensure core feature parity across platforms.
* Mimic the Windows C# version's core framework as closely as possible in order to make it easier to keep the separate sources synced. It's very likely that a feature or enhancement in one could then be more easily developed, tested, and released.
* For user interaction, provide a consistent approach to the core concepts, but leverage platform-specific technologies where advantageous. 

What you'll find on macOS is that StatTag is composed of a few sub-projects:

* The **StatTag framework** - a fairly direct Objective-C port of the C# Windows framework
    * ***Models*** and associated components for the StatTag objects (Code Files, Tags, etc.)
    * ***Parsers*** for commands used by supported statistical programs like Sata, SAS, and R (EX: knowing how to interpret the command `display x` and transform the result to a specific type of StatTag response)
    * ***Integration with Microsoft Word*** for management of document content (such as embedding the results of statistical output into fields in Microsoft Word)
    * ***Integration with (Statistical Package)*** for communication with programs such as Stat, R, and SAS. We leverage public APIs where available and then incorporate them into a consistent interface / protocol for integration into StatTag.
* **The StatTag application** - The macOS application that provides user's the ability to interact with StatTag, statistical programs, and Word documents. *For end-users, this is StatTag.*
* **StatTag Help** - The AppleHelp project presented by the StatTag application.
* **Word Support Files** -  Files used by Microsoft Word 2011 and 2016 to help provide the StatTag toolbars.

# How We Got Here #

With StatTag for macOS we wanted to deliver an experience identical to the Windows version, but quickly realized that was neither technically appropriate nor "Mac-like" enough to suit our goals. We took two paths:

## The Add-in ##

Microsoft provides no formal, supported way of developing a full-fledged add-in for macOS as they do for Windows. The new JavaScript-based add-in API does not provide the capabilities StatTag needs. Following some [fantastic examples](https://www.codeproject.com/Articles/810282/Microsoft-Office-VBA-to-the-Macs) we tried to create a framework library that could be made accessible to Word via VBA. The prototype worked, but had some challenges.

Word 2011 (the initial target) is a 32-bit application. For reasons beyond our level of knowledge, certain pieces of key functionality (ex: getting a list of Word fields) simply failed to work when run in Word through the 32-bit framework. They worked when run in a 32-bit test app, but when the library was referenced by Word 2011, they failed to work as expected. In Word 2016 (32 bit), these same functions worked.

There was no reliable way to launch the UI within Word and properly gain focus. We utilized standard macOS programming conventions to launch windows, but consistently struggled with gaining focus such that text boxes could receive key events.

We then focused our attentions on Word 2016 and resolved nearly all of the issues we encountered, but then encountered a new challenge - the Apple Sandbox. Given the core focus of StatTag is to broker communication with a range of third-party applications, the Sandbox presented a serious challenge - we could no longer message those applications if we ran StatTag as a framework embedded in Word. Microsoft very graciously offered to work with us to help whitelist specific tools, but we didn't want to impose upon their generosity as we continued to roll out support for more applications. *Huge "thank you" to the Office for Mac team for being so willing to work with us.*


## The Full-Fledged Application ##

We then had an epiphany - "we need to change how we approach this." We realized by trying to mimic the Windows version we were failing to take advantage of macOS. When we looked at the situation from that point of view, it became apparent that we needed to deploy StatTag as a full application and simply interface with Word in a much more loosely coupled way.

From that point on, things rapidly progressed. We resolved the technical challenges and were also free to really think about bringing a macOS "feel" to the application.


Relationship to Windows C# Version
-----------
StatTag is progressing rapidly. When the Mac version was started, StatTag for Windows was already ~7 months into development. That meant it had a strong foundation, but was also known to have a lot of future growth. 

With the Windows version in the lead position, the Mac development team recognized that it would be hard to deliver an equally capable product with document-level compatibility unless they stayed as closely in sync with the Windows version as possible. The decision was that to help with that goal, the Mac version would be modeled very closely so changes could be monitored. As a single class file in the Windows version was introduced, altered, or even removed, we could review those changes in git and mirror them in Xcode.

You will see a nearly 1:1 relationship between classes, files, and folders. The notion is to help keep improvments in sync as development progresses in both versions.

* **Does this mean the Mac version isn't a full citizen port?** 
Absolutely not! The Mac development team took this approach to help _ensure_ macOS users would have a fully-featured Mac-friendly StatTag.

* **Does this mean the Mac version doesn't take advantage of native functionality in Objective-C?**
That's a fair question. Our design principle was, and continues to be, "keep the two versions as tightly in sync as possible." In some cases, we've elected to mimic .NET-like approaches to application development rather than embrace the full capabilities of a dynamic language like Objective-C. And we're OK with that. StatTag is still actively under development. Once that settles down there will be ample time for platform-specific refactoring, but for now the goal is to complete a full citizen version of StatTag on the Mac by keeping both versions tightly in sync.


Supported Platforms
-----------

StatTag aims to support: 

* macOS 10.10 and above. 
* Microsoft Word 2011 and 2016

Objective-C vs. Swift
-----------

The Mac team chose to use Objective-C over Swift when writing StatTag for a few simple technical reasons:

1. When we started StatTag we initially developed it as a framework that would be hosted in Word. Because of this, it must be accessible to the host application - in this case, Microsoft Word. Microsoft Word 2011 and 2016 for the Mac were both initially 32 bit applications. That meant that the framework must be able to be compiled as 32 bit.
2. On macOS, Swift only allows compilation of 64 bit targets. This meant we couldn't compile a 32 bit framework for use with Word.
3. By the time we changed course to a dedicated application (as opposed to a framework) we had already made a significant investment in Objective-C and wanted to keep our languages limited (we're already using Objective-C, VBA, and AppleScript).

We :heart: Swift. It's a fantastic language and we're super excited at the opportunity to use it in the future.


Interacting with Word and External Statistical Applications
-----------

StatTag utilizes the [AppleScript Scripting Bridge](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/Introduction/Introduction.html) and [AppleScript-Objective-C] (https://developer.apple.com/library/mac/releasenotes/ScriptingAutomation/RN-AppleScriptObjC/) (AppleScriptObjC aka ASOC) to message applications such as Microsoft Word and Stata. 

Applications can define AppleScript-accessible interfaces that can expose application functionality like "create document," "get current text selection," or any other number of useful behaviors. These can be considered to be very much like application programming interfaces (APIs), but are typically much lighter-weight and intended more for automation scripts. In our case, we're using them to directly interact with content to help tie bits of distributed data together across applications - like updating a field code in Word with statistical results from Stata.

We mentioned there are two similar, but different, complementary technologies - the Scripting Bridge and ASOC: 

* **Scripting Bridge**: AppleScript interfaces must be [publicly defined](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptableCocoaApplications/SApps_implement/SAppsImplement.html) by an application bundle. We use the scripting definition extractor `sdef` to extract this definition from the application. From there we use the scripting definition processor `sdp` to generate Objective-C headers that can be included in Xcode. This provides us simple, light-weight wrappers to the AppleScript interfaces.
* **ASOC**: It's also possible to message directly from Objective-C to AppleScript. You can define your AppleScript class in a scripting file and create an identically-named Objective-C class header file. Then you just mimic the AppleScript methods in your Objective-C header file. There are some restrictions - the types of objects you can bridge must be objects like NSNumber, NSDate, and NSString (they can't be C primitives) and you can't pass or return pointers.  

To interact with Microsoft Word, we were required to use both approaches.

###Generating Objective-C Scripting Bridge Headers###

To generate Objective-C headers from the AppleScript interfaces you'll use two programs - `sdef` and `sdp`. You can chain them together and should supply some sort of unique class prefix to avoid Objective-C typename collisions (EX: "ST" for "StatTag" and "Word2011" for a clearer attribution to Microsoft Word 2011):

```
sdef [path to app] | sdp -fh --basename [your class prefix]
```

```
sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ | sdp -fh --basename STWord2011
```

In your project you might then need to tell Xcode to also link against Objective-C:

* Navigate to  > (Your project) > (Your target(s)) > Build Settings > Linking > Other Linker Flags
* In `Other Linker Flags` add `-ObjC`

From the [documentation](https://developer.apple.com/library/mac/qa/qa1490/_index.html):

>This flag causes the linker to load every object file in the library that defines an Objective-C class or category. While this option will typically result in a larger executable (due to additional object code loaded into the application), it will allow the successful creation of effective Objective-C static libraries that contain categories on existing classes.

###Word Objective-C Scripting Bridge Challenges###

The Objective-C headers that were generated from Word had some challenges:

* Some enumerations were invalid and had to be updated manually. Generating the headers will throw an error: `enumerator of enumeration "e183": missing required "name" attribute`.  You will have to manually find and fix references in `e183` and `e315`. For example - in `e183` you can update the missing reference for `FieldMacro` (no name supplied) to be something like `STMSWord2011E183FieldMacroButton = '\002G\0003'`
* Certain generalized methods like `update` weren't available as expected. 
* Some functions like `execute find` did not seem to declare the expected return types. `execute find`, for example, should return a `BOOL` to indicate whether the operation was successful. The Objective-C interface returned an enumeration that indicated either "text range" or "insertion point."
* Some functions like `find` did not return values in properties like `found`. The values were `nil` when they should have contained a `BOOL`.
* Some message signatures like `- (STMSWord2011Border *) getBorder:(STMSWord20114040)x whichBorder:(STMSWord2011E122)whichBorder;` will be duplicates (in Objective-C at least) and will need to be manually removed. Given the dynamic nature of Objective-C you should be able to modify them without (radically) changing functionality.
* By far the largest challenge was the fact that many of the `SBElementArray` property collections for things like "tables in a document" or "images in a document" did not seem to be mutable. Elements could be created, but they could not be added to the document.

Example of sample code that should have worked (but did not) when creating a table:

```objective-c
//"doc" below is our active word doc
STMSWord2011Table *table = [[[app classForScriptingClass:@"table"] alloc]
initWithProperties:[NSDictionary dictionaryWithObjectsAndKeys:
range, @"text object",
[NSNumber numberWithInteger:rows], @"number of rows",
[NSNumber numberWithInteger:cols], @"number of columns",
nil]];
[[doc tables] addObject:table];
```

`addObject` did not fail - but it also did not seem to add the object.

If you used "pure" AppleScript (outside of Objective-C) you could, in fact, create the table:

```applescript
set theTable to make new table at theDoc with properties {text object: theRange, number of rows:numRows, number of columns:numCols}
```

The table is created in `theDoc` in `theRange` using the specified number of rows and columns.

###Using AppleScript-Objective-C###

For the moment, we've worked around this issue by instead using ASOC to create proxy classes that allow us to utilize AppleScript from Objective-C:

* Create AppleScript file `WordASOC.applescript`
* Create an Ojbective-C header file `WordASOC.h` (NOTE the name of the file is the same as its AppleScript peer)

In `WordASOC.applescript`

```applescript
on createTableAtRangeStart:theRangeStart andRangeEnd:theRangeEnd withRows:numRows andCols:numCols
set theRangeStart to theRangeStart as integer
set theRangeEnd to theRangeEnd as integer
set numRows to numRows as integer
set numCols to numCols as integer
tell application "Microsoft Word"
set theDoc to active document
set theRange to create range active document start theRangeStart end theRangeEnd
set theTable to make new table at theDoc with properties {text object: theRange, number of rows:numRows, number of columns:numCols}
return true --theTable
end tell
return false
end createTableAtRangeStart:andRangeEnd:withRows:andCols:
```

Then we'd set up our Objective-C header (`WordASOC.h`) to mimic the AppleScript method interface: 

```objective-c
-(NSNumber*)createTableAtRangeStart:(NSNumber*)rangeStart 
andRangeEnd:(NSNumber*)rangeEnd 
withRows:(NSNumber*)rows 
andCols:(NSNumber*)cols;
```

AppleScript resources like the above `WordAsoc.applescript` are _resources_ (treated similarly to images, sounds, or other assets) and will not be loaded by default. In your project your application or framework will need to load the AppleScript resources as needed. If you have an application, this can be done in `main.m` or your `Application Delegate`. For a framework, you should consider loading them on-demand in some sort of global singleton.

To load the AppleScript resource it's as simple as

```objective-c
NSBundle *frameworkBundle = [NSBundle bundleForClass:[self class]];
[frameworkBundle loadAppleScriptObjectiveCScripts];
```

Note that we've used `bundleForClass:[self class]` instead of referencing `mainBundle` because we might be loading from a framework's embedded resources.

While executing AppleScript this way is not ideal as it doesn't return a reference to the object, it does let us create and add tables to the Word document - the generated Objective-C interfaces do not.




# Project Settings #


## Add a Prefix Header ##
* **Apple LLVM (xx.xx) - Language**
* **Add to Prefix header** :
    * `$(SRCROOT)/$(PROJECT_NAME)/StatTag-Prefix.pch`


# Scintilla #

Start by building Scintilla outside of StatTag. Once you have the framework built, add it to the StatTag project as you would any other embedded framework.

To compile Scintilla support for StatTag you'll need to do the following

## LLVM options ##

* Go to your project's **Build Settings**
* Under **Apple LLVM Compiler x.x** - Preprocessing
* Option **Preprocessor Macros**
* Add to **Release** :
    * `SCI_NAMESPACE`
    * `SCI_LEXER`
* Add to **Debug** :
    * `SCI_NAMESPACE`
    * `SCI_LEXER`
    * `DEBUG = 1`

## Runpath Search Paths ##

* Go to your project's **Build Settings**
* **Runpath Linking**
* Add to **Runpath SearchPaths**
    * `@executable_path/../Frameworks`

## Framework Search Paths ##

* Go to your project's **Build Settings**
* **Search Paths**
* Add to **Framework SearchPaths**
    * `$(PROJECT_DIR)  (non-recursive)`

##Using Scintilla ##

Your .m file (where you reference Scintilla) needs to support Objective-C++, so change it to .mm

# AppleHelp #

We're using a dedicated AppleHelp build target (StatTagHelp). Compiling the project should automatically rebuild (where necessary) and reload the StatTagHelp target.

## Apple Help Settings ##

### StatTagHelp ###

In the StatTagHelp project, ensure the info.plist has the following set:

* **CFBundleSignature** : hbwr
* **HPDBookAccessPath** : redirect.html
* **HPDBookIconPath** : ../SharedGlobalArt/AppIconDefault.png
* **HPDBookIndexPath** : StatTagHelp.helpindex
* **HPDBookTitle** : StatTag Help
* **HPDBookType** : 3
* **HPDBookUsesExternalViewer** : false
* **HPDMaxWindowWidth** : 938

### StatTag ###

We're now going to tell StatTag how to use StatTagHelp

* **CFBundleHelpBookFolder** : StatTagHelp.help
* **CFBundleHelpBookName** : org.stattag.StatTagHelp.help


## Updating Apple Help ##

For the moment, we're going the "easy route" and simply saving our Word-based user document as HTML, then using that extract as the base help content (for English).

* Extract the Word document as filtered HTML
* In the Finder, copy the assets into the bundle directory (for now, that's just the en localized directory)
* Update any CSS references you might have changed

This will give you a simple basic HTML page for help. No navigation or sections beyond the table of contents in the Word document.

## Reindexing Apple Help ##

After updating content in the AppleHelp bundle target you'll want to reindex the help content.

If you don't already have Apple's Help Indexer, you'll need to download it from Apple.

* **Xcode** > **Open Developer Tool** > **More Developer Tools**
* Log in with your Apple ID
* Look for **"Additional Tools for Xcode (version)"** - in particular, look for "Help Indexer"
* **Download and install**

Once you have HelpIndexer...

* Go to the **StatTagHelp project**
* **Xcode** > **Open Developer Tool** > **Help Indexer**
* Select to the appropriate directory / directories for your updated help content, then **reindex**


# Word Integration - Calling Word from Cocoa #

Word exposes some API functionality via AppleScript. In order to use this API in an Objective-C application, we need to generate and import a header file.

## Generating a Scripting Definition Header File ##

We make liberal use of the [AppleScript scripting bridge](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ScriptingBridgeConcepts/UsingScriptingBridge/UsingScriptingBridge.html)

* To generate a scripting bridge header for use with Objective-C: `sdef [path to app] | sdp -fh --basename [your class prefix]`
* EX:  `sdef /Applications/R.app | sdp -fh --basename STR`

### Generating the Word Header ###

* Open **Terminal**
* Determine where your instance of Word is installed
* Identify a **class prefix name** (we used `STMSWord2011`). All objects generated by the utilities will be prefixed with that string for uniqueness
* Execute the following statement:
`sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ | sdp -fh --basename STWord2011`
* Add the header file to your project

NOTE: The above  will generate an error: ***"enumerator of enumeration "e183": missing required "name" attribute"*** Read below to resolve and continue.


### Fixing - Option 1: ###

Follow the instructions documented here: http://stackoverflow.com/questions/15338454/scripting-bridge-and-generate-microsoft-word-header-file

* Run `sdef /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ > STMSWord2011.sdef`
* Add missing name fields to e315 and e183
* Run `sdp -fh STMSWord2011.sdef --basename STMSWord2011`

NOTE: the missing ENUM e183 has a missing name for what appears to be [FieldMacroButton](https://msdn.microsoft.com/en-us/library/office/ff192211.aspx?f=255&MSPPError=-2147217396)

```
enum STMSWord2011E183 {
...
STMSWord2011E183FieldMacroButton = '\002G\0003',
```

### Fixing - Option 2: ###

Follow the instructions documented [here](https://github.com/rameshkumarpb/LinkMSWord/wiki/LinkMSWord)


# Word Ribbon Scripting and Template Files #

In order for Word to communicate with StatTag we need to integrate VB Script, AppleScript, and Objective-C. This lets us communicate from the Word application to StatTag.

From a button click to StatTag, the flow is:

(Word) -> Ribbon Button -> Event Handler -> VB Script function -> AppleScript -> (StatTag AppleScript hook) -> Objective-C

There are two main files we use for initiating communication from Word:

* The **Word template document** (`StatTagMacros.dotm`)
* An **AppleScript support file** (`StatTagScriptSupport.scpt`)

### StatTagMacros.dotm ###

This is the template file that contains the ribbon definition as well as the required VB Script used to call AppleScript. Because Word 2016 is sandboxed we have to use two separate approaches to calling AppleScript.

* For Word 2011, you can simply call "MacScript" and invoke the AppleScript directly.
* For Word 2016, you **must** use `AppleScriptTask` and you are limited to using only external AppleScript files.

Because of this, we've elected to consolidate all AppleScript code into a single support file and reference it in both Word 2011 and 2016.

### StatTagScriptSupport.scpt ###

This file contains the main AppleScript "shims" we use to simply call out to the Objective-C AppleScript interfaces in StatTag.

For example - if you click the "help" button in the StatTag Word 2016 ribbon, a related VB Script "help" sub will then call out to a "help" method in the AppleScript support file. This method will then, in turn, call into the StatTag AppleScript "openHelp" interface, which will pass the request on to the related "STAppleScript_OpenHelp" Objective-C script task interface.

```
    <command name="openHelp" code="STOPNHLP" description="Open Help">
      <cocoa class="STAppleScript_OpenHelp"/>
      <result type="boolean" description="Did launch UI and complete"/>
    </command>
```

The related AppleScript / Objective-C interfaces are defined in the `StatTag.sdef` file.

### Where Files Should be Installed ###

#### AppleScript ####

For sandboxed Word 2016, we're required to place files in the following path

* `~/Library/Application Scripts/com.microsoft.Word/`

For consistency, we're also going to place scripts in the same location for Word 2011.

#### Word Macro Templates ####

### For 2011 ###

* `/Applications/Microsoft Office 2011/Office/Startup/Word/`

### For 2016 ###

One-off Templates (from which a document MUST be based)

* `~/Library/Group Containers/UBF8T346G9.Office/User Content/Templates/`

### Global Templates ###

* `/Users/$USER/Library/Group Containers/UBF8T346G9.Office/User Content.localized/Startup.localized/Word`

#### How to Modify the Word 2016 Ribbon ####

The StatTag (Mac) Ribbon is governed by an XML file contained within the macro template file. The Mac version(s) of Word do not have any provided facilities to modify the file for easy distribution. If you need to modify the Ribbon, your best course of action is to get a Windows PC and install the publicly distributed "Office Custom UI Editor" tool. This tool lets you easily modify the Ribbon XML file embedded in the macro template file (including adding icons if desired).

##### Understanding Word 2016 AppleScript #####

- [Ron de Bruin's Office for Mac Automation](http://www.rondebruin.nl/mac/applescripttask.htm) (fantastic site)

##### Office Custom UI Editor #####

- [Office Custom UI Editor available](http://openxmldeveloper.org/blog/b/openxmldeveloper/archive/2009/08/07/7293.aspx)
- [Ribbon and Quick Access Toolbar(QAT) pages](http://www.rondebruin.nl/win/section2.htm)

##### Walk-Throughs of Editing the Ribbon XML File #####

- [How to add a custom Ribbon tab using VBA?](http://stackoverflow.com/questions/8850836/how-to-add-a-custom-ribbon-tab-using-vba)
- [Customize the Word Ribbon User Interface](http://www.gregmaxey.com/word_tip_pages/customize_ribbon_main.html)
- [Load different RibbonX when opening file in Excel 2007 or 2010/2016](http://www.rondebruin.nl/win/s2/win002.htm)
- [Change the Ribbon in Excel 2007-2016](http://www.rondebruin.nl/win/s2/win001.htm)
- [Change the Ribbon in Mac Excel 2016](http://www.rondebruin.nl/mac/macribbon/ribbonmac.htm)

##### Additional Links for AppleScript and VBA #####
* [AppleScript variable example](https://github.com/henriquebastos/autoword/blob/master/autoword.applescript)
* [Dictionary literal constructor](http://stackoverflow.com/questions/12535855/should-i-prefer-to-use-literal-syntax-or-constructors-for-creating-dictionaries)
* [how to pass word variable between AS and VBA](https://forum.keyboardmaestro.com/t/how-to-pass-km-variable-into-a-word-mac-2011-macro-as-a-variable/2582/4)
* [how to pass word variable between AS and VBA](http://answers.microsoft.com/en-us/mac/forum/macoffice2011-macword/can-i-pass-parameters-to-a-word-2011-macro-from/bfd3fe1d-317e-4d96-85f3-1758638e2653?auth=1)
