//
//  WordDocumentViewer.m
//  StatTag
//
//  Created by Eric Whitley on 2/26/19.
//  Copyright © 2019 StatTag. All rights reserved.
//

#import "WordDocumentViewer.h"
#import "STCodeFile.h"

@interface WordDocumentViewer ()

@end

@implementation WordDocumentViewer

@synthesize statTagWordDocument = _statTagWordDocument;
@synthesize propertiesArrayController = _propertiesArrayController;
@synthesize fieldsTreeController = _fieldsTreeController;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear {
  
  //NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"entryIndex" ascending:YES selector:@selector(compare:)];
  //[[self documentFieldListTableView] setSortDescriptors:[NSArray arrayWithObject:sd]];
  

  
  [self populateViewData];
}

-(void)populateViewData {
  
  [[self fieldsTreeController] setContent:nil];
  [[self fieldContentsTextView] setString:@""];
  [[self propertiesArrayController] setContent:nil];
  [[self propertyContentsTextView] setString:@""];
  [[self tagPropertiesArrayController] setContent:nil];
  [[self tagJSONTextView] setString:@""];
  [[self cachedResultTextView] setString:@""];
  [[self tagCachedResultTextView] setString:@""];
  
  //field list
  for (NSInteger index = 0; index < [[[[self statTagWordDocument] document] fields] count] ; index++)
  {
    //right - we're fixed at two levels and this isn't a proper tree
    STMSWord2011Field* field = [[[[self statTagWordDocument] document] fields] objectAtIndex:index];
    WordFieldTreeItem* node = [[WordFieldTreeItem alloc] initWithField:field andParentField:nil forDocument:[self statTagWordDocument]];
    
    STMSWord2011TextRange* code = [field fieldCode];
    for(NSInteger fieldIndex = 0; fieldIndex < [[code fields] count] ; fieldIndex++)
    {
      //refactor
      STMSWord2011Field* innerField = [[code fields] objectAtIndex:fieldIndex];
      WordFieldTreeItem* innerWordField = [[WordFieldTreeItem alloc] initWithField:innerField andParentField:node forDocument:[self statTagWordDocument]];
      index = index + 1;//skip ahead - fields are sequential
    }
    [[self fieldsTreeController] insertObject:node atArrangedObjectIndexPath:[node indexPath]];
  }

  for(STMSWord2011Variable* var in [[[self statTagWordDocument] document] variables]) {
    WordDocProperty* p = [[WordDocProperty alloc] initWithName:[var name] andValue:[var variableValue] forType:@"Variable"];
    [[self propertiesArrayController] addObject:p];
  }
  for(STMSWord2011DocumentProperty* prop in [[[self statTagWordDocument] document] customDocumentProperties])
  {
    WordDocProperty* p = [[WordDocProperty alloc] initWithName:[prop name] andValue:[prop value] forType:@"Custom"];
    [[self propertiesArrayController] addObject:p];
  }

  /*
  for(STMSWord2011Variable* var in [[[self statTagWordDocument] document] shapes]) {
    WordDocProperty* p = [[WordDocProperty alloc] initWithName:[var name] andValue:[var name] forType:@"Shape"];
    [[self propertiesArrayController] addObject:p];
  }
  */

  /*
  for(STMSWord2011DocumentProperty* prop in [[[self statTagWordDocument] document] documentProperties])
  {
    WordDocProperty* p = [[WordDocProperty alloc] initWithName:[prop name] andValue:[prop value] forType:@"Microsoft"];
    [[self propertiesArrayController] addObject:p];
  }
  */
  
  
  //[[self fieldPropertiesTableView] reloadData];
  [[self propertyListTableView] reloadData];
  [[self documentFieldListTableView] reloadData];
  [[self tagPropertiesTableView] reloadData];
  
}

//table view delegate methods


-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
  
  NSTableCellView *cell = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:NULL];
  return cell;
}

-(void)outlineViewSelectionDidChange:(NSNotification *)notification
{
  if([[[notification object] identifier] isEqualToString:@"fieldsTable"])
  {
    WordFieldTreeItem* wordField = [[[self fieldsTreeController] selectedObjects] firstObject];
    [[self fieldContentsTextView] setString:[wordField fieldData]];
    [[self tagJSONTextView] setString:@""];

    if([wordField tag] != nil)
    {
      NSDictionary* d = [[wordField tag] toDictionary];
      [[self tagJSONTextView] setString:[NSString stringWithFormat:@"%@", d]];
      if(d != nil)
      {
        for(id key in d)
        {
          [[self tagPropertiesArrayController] addObject:@{key : [d objectForKey:key]}];
        }
      }
      
      
      [[self cachedResultTextView] setString:[NSString stringWithFormat:@"%@", [[wordField fieldTag] CachedResult]]];
      [[self tagCachedResultTextView] setString:[NSString stringWithFormat:@"%@", [[wordField tag] CachedResult]]];
      
    }
  }
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
  //ONLY listen for changes to our two tables
  if([[[notification object] identifier] isEqualToString:@"propertiesTable"])
  {
    WordDocProperty* prop = [[[self propertiesArrayController] selectedObjects] firstObject];
    NSString* propValue = @"";
    if([prop propertyValue] != nil) {
      propValue = [prop propertyValue];
    }
    [[self propertyContentsTextView] setString:propValue];
    
    //[[self fieldContentsTextView] setString:@"hey"];
    //NSDictionary* d = [[[self fieldsTreeController] selectedObjects] firstObject];

      //STMSWord2011Document* f = [self fieldsArrayController] selec//[[self fieldsArrayController] selectionIndexes];
      /*
      NSDictionary* d = [[[self fieldsTreeController] selectedObjects] firstObject];
      NSString* j = [d objectForKey:@"fieldText"];
      if(j == nil)
      {
        [[self fieldContentsTextView] setString:@""];
      } else {
        [[self fieldContentsTextView] setString:j];
      }
       */
  }
}

-(void)dismissControllerWithReturnCode:(StatTagResponseState)returnCode
{
  if([[self delegate] respondsToSelector:@selector(dismissWordDocumentViewerController:withReturnCode:)]) {
    [[self delegate] dismissWordDocumentViewerController:self withReturnCode:returnCode];
  }
}


- (IBAction)closeWindow:(id)sender {
  [self dismissControllerWithReturnCode:Cancel];
}


@end
