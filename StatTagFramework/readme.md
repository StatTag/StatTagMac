
Design Notes
=======

Relationship to Windows C# Version
-----------
StatTag is progressing rapidly. When the Mac version was started, StatTag for Windows was already ~7 months into development. That meant it had a strong foundation, but was also known to have a lot of future growth. 

With the Windows version in the lead position, the Mac development team recognized that it would be hard to deliver an equally capable product with document-level compatibility unless they stayed as closely in sync with the Windows version as possible. The decision was that to help with that goal, the Mac version would be modeled very closely so changes could be monitored. As a single class file in the Windows version was introduced, altered, or even removed, we could review those changes in git and mirror them in Xcode.

You will see a nearly 1:1 relationship between classes, files, and folders. The notion is to help keep improvments in sync as development progresses in both versions.

* **Does this mean the Mac version isn't a full citizen port?** 
Absolutely not! The Mac development team took this approach to help _ensure_ macOS users would have a fully-featured Mac-friendly StatTag.

* **Does this mean the Mac version doesn't take advantage of native functionality in Objective-C?**
That's a very fair question. Our design principle was, and continues to be, "keep the two versions as tightly in sync as possible." In some cases, we've elected to mimic .NET-like approaches to application development rather than embrace the full capabilities of a dynamic language like Objective-C. And we're OK with that. StatTag is still actively under development. Once that settles down there will be ample time for platform-specific refactoring, but for now the goal is to complete a full citizen version of StatTag on the Mac by keeping both versions tightly in sync.


Supported Platforms
-----------

StatTag aims to support: 

* macOS 10.7 and above. 
* Microsoft Word 2011 and 2016

How StatTag on the Mac Works
-----------

Microsoft Word for the Mac does not provide the ability to write and deploy "add-ins" as is possible on the Windows platform.

In order to provide an "add-in-like" experience, StatTag on the Mac utilizes VBA macros to call out to a Cocoa-based framework using standard C. The framework then does all of the "heavy-lifting" to create and manage tags, including presenting the user interface views. A simple Word template document embeds the "launch StatTag function X and return" macro, which effectively simulates some of the basic Windows add-in behavior. The user should never know that they're not really "in" Word at that point.

Why a framework instead of an application? For the first version of StatTag we want to ensure the user stays within Word completely and is presented with fully modal interfaces that appear to be embedded similar to a Windows add-in. Were we to deploy StatTag as an application, the major functionality would work identically, but it would be through an external application that could be closed or lose window focus. That can become confusing, especially if StatTag is doing some serious number crunching and the user returns focus back to Microsoft Word. At that point, document editing state becomes very confusing and it's likely that StatTag would overwrite content the user was in the process of modifying.


Objective-C vs. Swift
-----------

The Mac team chose to use Objective-C over Swift when writing StatTag for a few simple technical reasons:

1. Since we developed StatTag as a framework, it must be accessible to the host application - in this case, Microsoft Word. Microsoft Word 2011 and 2016 for the Mac are 32 bit applications. That means that the framework must be able to be compiled as 32 bit.
2. On macOS, Swift only allows compilation of 64 bit targets. This means we couldn't compile a 32 bit framework for use with Word.
3. Swift on macOS currently requires macOS 10.9. We want to target macOS 10.7 and above.

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


