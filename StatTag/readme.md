
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

StatTag as you see it is the product of a circuitous route. We wanted to deliver an experience identical to the Windows version, but quickly realized that was neither technically feasible nor "Mac-like" enough to suit our goals.

## The Add-in ##

Microsoft provides no formal, supported way of developing a full-fledged add-in for macOS as they do for Windows. The new JavaScript-based add-in API does not provide the capabilities StatTag needs. Following some [fantastic examples](https://www.codeproject.com/Articles/810282/Microsoft-Office-VBA-to-the-Macs) we tried to create a framework library that could be made accessible to Word via VBA. The prototype worked, but had some challenges.

Word 2011 (the initial target) is a 32-bit application. For reasons beyond our level of knowledge, certain pieces of key functionality (ex: getting a list of Word fields) simply failed to work when run in Word through the 32-bit framework. They worked when run in a 32-bit test app, but when the library was referenced by Word 2011, they failed to work as expected. In Word 2016 (32 bit), these same functions worked.

There was no reliable way to launch the UI within Word and properly gain focus. We utilized standard macOS programming conventions to launch windows, but consistently struggled with gaining focus such that text boxes could receive key events.

We then focused our attentions on Word 2016 and resolved nearly all of the issues we encountered, but then encountered a new challenge - the Apple Sandbox. Given the core focus of StatTag is to broker communication with a range of third-party applications, the Sandbox presented a serious challenge - we could no longer message those applications if we ran StatTag as a framework embedded in Word. Microsoft very graciously offered to work with us to help whitelist specific tools, but we didn't want to impose upon their generosity as we continued to roll out support for more applications. *Huge "thank you" to the Office for Mac team for being so willing to work with us.*


## The Full-Fledged Application ##

We then had an epiphany - "we need to change how we approach this." We realized by trying to mimic the Windows version we were failing to take advantage of macOS. When we looked at the situation from that point of view, it became apparent that we needed to deploy StatTag as a full application and simply interface with Word in a much more loosely coupled way.

From that point on, things rapidly progressed. We resolved the technical challenges and were also free to really think about bringing a macOS "feel" to the application.

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
