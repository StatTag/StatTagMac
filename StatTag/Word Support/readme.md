
## About Word Integration ##

### Where Files Should be Installed ###

#### AppleScript ####

For sandboxed Word 2016, we're required to place files in the following path

* `~/Library/Application Scripts/com.microsoft.Word/`

For consistency, we're also going to place scripts in the same location for 2011


#### Word Macro Templates ####

### For 2011 ###

* `/Applications/Microsoft Office 2011/Office/Startup/Word/`

### For 2016 ###

One-off Templates (from which a document MUST be based)

* `~/Library/Group Containers/UBF8T346G9.Office/User Content/Templates/`

### Global Templates ###

* `/Users/$USER/Library/Group Containers/UBF8T346G9.Office/User Content.localized/Startup.localized/Word`

#### How to Modify the Word 2016 Ribbon ####

The StatTag (Mac) Ribbon is governed by an XML file contained within the macro template file. The Mac version(s) of Word do not have any provided facilities to modify the file for easy distribution. If you need to modify the Ribbon, your best course of action is to get a Windows PC and install the publicly distrbuted "Office Custom UI Editor" tool. This tool lets you easily modify the Ribbon XML file embedded in the macro template file (including adding icons if desired).

##### Office Custom UI Editor #####

- http://openxmldeveloper.org/blog/b/openxmldeveloper/archive/2009/08/07/7293.aspx
- http://www.rondebruin.nl/win/section2.htm

##### Walk-Throughs of Editing the Ribbon XML File #####

- http://stackoverflow.com/questions/8850836/how-to-add-a-custom-ribbon-tab-using-vba
- http://www.gregmaxey.com/word_tip_pages/customize_ribbon_main.html
- http://www.rondebruin.nl/win/s2/win002.htm
- http://www.rondebruin.nl/win/s2/win001.htm
- http://www.rondebruin.nl/mac/macribbon/ribbonmac.htm


