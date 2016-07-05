/*
 * STStata.h
 */

#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>


@class STStataApplication, STStataDocument, STStataWindow;

enum STStataSaveOptions {
	STStataSaveOptionsYes = 'yes ' /* Save the file. */,
	STStataSaveOptionsNo = 'no  ' /* Do not save the file. */,
	STStataSaveOptionsAsk = 'ask ' /* Ask the user whether or not to save the file. */
};
typedef enum STStataSaveOptions STStataSaveOptions;

enum STStataPrintingErrorHandling {
	STStataPrintingErrorHandlingStandard = 'lwst' /* Standard PostScript error handling */,
	STStataPrintingErrorHandlingDetailed = 'lwdt' /* print a detailed report of PostScript errors */
};
typedef enum STStataPrintingErrorHandling STStataPrintingErrorHandling;

enum STStataSaveableFileFormat {
	STStataSaveableFileFormatNativeFormat = 'item' /* Native format */
};
typedef enum STStataSaveableFileFormat STStataSaveableFileFormat;

@protocol STStataGenericMethods

- (void) closeSaving:(STStataSaveOptions)saving savingIn:(NSURL *)savingIn;  // Close a document.
- (void) saveIn:(NSURL *)in_ as:(STStataSaveableFileFormat)as;  // Save a document.
- (void) printWithProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) delete;  // Delete an object.
- (void) duplicateTo:(SBObject *)to withProperties:(NSDictionary *)withProperties;  // Copy an object.
- (void) moveTo:(SBObject *)to;  // Move an object to a new location.

@end



/*
 * Standard Suite
 */

// The application's top-level scripting object.
@interface STStataApplication : SBApplication

- (SBElementArray<STStataDocument *> *) documents;
- (SBElementArray<STStataWindow *> *) windows;

@property (copy, readonly) NSString *name;  // The name of the application.
@property (readonly) BOOL frontmost;  // Is this the active application?
@property (copy, readonly) NSString *version;  // The version number of the application.

- (id) open:(id)x;  // Open a document.
- (void) print:(id)x withProperties:(NSDictionary *)withProperties printDialog:(BOOL)printDialog;  // Print a document.
- (void) quitSaving:(STStataSaveOptions)saving;  // Quit the application.
- (BOOL) exists:(id)x;  // Verify that an object exists.
- (NSInteger) DoCommand:(NSString *)x stopOnError:(BOOL)stopOnError addToReview:(BOOL)addToReview;  // execute a Stata command.
- (NSInteger) DoCommandAsync:(NSString *)x;  // Execute a Stata command asynchronously. The method copies the Stata command into a queue and then returns immediately. The command will be executed by Stata when it is its turn.
- (void) UtilIsStataFreeEvent;  // This command does nothing and exists only to allow porting of Stata for Windows OLE script with few changes.
- (BOOL) UtilIsStataFree;  // Check whether Stata has more commands to execute.
- (void) UtilShowStata:(NSInteger)x;  // Hide or unhide the Stata application.
- (NSString *) MacroValue:(NSString *)x;  // Get the value as a string for a Stata macro.
- (NSInteger) ScalarType:(NSString *)x;  // Determine whether a scalar is numeric or string.
- (double) ScalarNumeric:(NSString *)x;  // Get the value of a numeric scalar.
- (NSString *) ScalarString:(NSString *)x;  // Get the value of a string scalar.
- (NSInteger) StReturnType:(NSString *)x;  // Determine the type of a Stata saved result.
- (double) StReturnNumeric:(NSString *)x;  // Get the numeric value of a Stata saved result.
- (NSString *) StReturnString:(NSString *)x;  // Get the string value of a Stata saved result.
- (id) MatrixData:(NSString *)x;  // Get the data of a matrix.
- (id) MatrixRowNames:(NSString *)x;  // Get the row names of a matrix.
- (id) MatrixColNames:(NSString *)x;  // Get the column names of a matrix.
- (NSInteger) MatrixRowDim:(NSString *)x;  // Get the number of rows of a matrix.
- (NSInteger) MatrixColDim:(NSString *)x;  // Get the number of columns of a matrix.
- (NSInteger) StVariableIndex:(NSString *)x;  // Get the index of a variable name.
- (NSString *) VariableLabel:(NSString *)x;  // Get the label of a variable.
- (id) VariableLabelArray;  // Get the labels of all variables.
- (NSString *) StVariableName:(NSInteger)x;  // Get the name of a variable.
- (id) VariableNameArray;  // Get the names of all variables.
- (NSInteger) VariableType:(NSString *)x;  // Get the type of a variable.
- (id) VariableTypeArray;  // Get the data type array of all variables.
- (NSString *) VariableValLabel:(NSInteger)x;  // Get the value label name of a variable.
- (id) VariableValLabelArray;  // Get the value labels of all variables.
- (NSInteger) VariableValLabelCount:(NSString *)x;  // Get the number of values in a value label.
- (NSString *) VariableValLabelForValue:(NSString *)x value:(NSInteger)value;  // Get the label for a value in a value label.
- (id) VariableValLabelValueArray:(NSString *)x;  // Get all values in a value label.
- (id) VariableValLabelLabelArray:(NSString *)x;  // Get all labels in a value label.
- (id) VariableDataNumeric:(NSInteger)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a numeric variable from an optional range of observations.
- (id) VariableDataString:(NSInteger)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a string variable from an optional range of observations.
- (id) VariableDataStrL:(NSInteger)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a strL variable from an optional range of observations.
- (id) VariableDataNumericFromName:(NSString *)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a numeric variable from an optional range of observations.
- (id) VariableDataStringFromName:(NSString *)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a string variable from an optional range of observations.
- (id) VariableDataStrLFromName:(NSString *)x obsStart:(NSInteger)obsStart obsEnd:(NSInteger)obsEnd;  // Return data for a strL variable from an optional range of observations.
- (BOOL) VariableIsStrLFromName:(double)x;  // Check whether a variable's type is a strL.
- (BOOL) UtilIsStMissingValue:(double)x;  // Check whether a number will be treated as missing in Stata.
- (double) UtilGetStMissingValue;  // Get the number that represents the Stata missing value.
- (void) UtilSetStataBreak;  // set Stata break key to stop a lengthy Stata command execution.
- (NSInteger) UtilStataErrorCode;  // Get the return code.

@end

// A document.
@interface STStataDocument : SBObject <STStataGenericMethods>

@property (copy, readonly) NSString *name;  // Its name.
@property (readonly) BOOL modified;  // Has it been modified since the last save?
@property (copy, readonly) NSURL *file;  // Its location on disk, if it has one.


@end

// A window.
@interface STStataWindow : SBObject <STStataGenericMethods>

@property (copy, readonly) NSString *name;  // The title of the window.
- (NSInteger) id;  // The unique identifier of the window.
@property NSInteger index;  // The index of the window, ordered front to back.
@property NSRect bounds;  // The bounding rectangle of the window.
@property (readonly) BOOL closeable;  // Does the window have a close button?
@property (readonly) BOOL miniaturizable;  // Does the window have a minimize button?
@property BOOL miniaturized;  // Is the window minimized right now?
@property (readonly) BOOL resizable;  // Can the window be resized?
@property BOOL visible;  // Is the window visible right now?
@property (readonly) BOOL zoomable;  // Does the window have a zoom button?
@property BOOL zoomed;  // Is the window zoomed right now?
@property (copy, readonly) STStataDocument *document;  // The document whose contents are displayed in the window.


@end

