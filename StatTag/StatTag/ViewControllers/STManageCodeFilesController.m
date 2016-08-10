//
//  STManageCodeFilesController.m
//  StatTag
//
//  Created by Eric Whitley on 8/10/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STManageCodeFilesController.h"
#import "StatTag.h"

@interface STManageCodeFilesController ()

@end

@implementation STManageCodeFilesController
@synthesize fileTableView;
@synthesize arrayController;
@synthesize codeFiles = _codeFiles;

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
  //[self populateArrayController];
  //[fileTableView reloadData];
  for(STCodeFile* cf in _codeFiles) {
    NSLog(@"package : %@, path : %@", [cf StatisticalPackage], [cf FilePath]);
  }

}

-(void)populateArrayController {
  
//  NSMutableDictionary *value = [[NSMutableDictionary alloc] init];
//  // Add some values to the dictionary
//  // which match up to the NSTableView bindings
//  [value setObject:[NSNumber numberWithInt:0] forKey:@"id"];
//  [value setObject:[NSString stringWithFormat:@"test"] forKey:@"name"];
  
//  [arrayController addObject:value];
//  [arrayController addObjects:[self codeFiles]];
}

- (void)windowWillClose:(NSNotification *)notification {
  [[NSApplication sharedApplication] stopModal];
}



- (void)insertObject:(STCodeFile *)cf inCodeFilesAtIndex:(NSUInteger)index {
  [_codeFiles insertObject:cf atIndex:index];
}

- (void)removeObjectFromCodeFilesAtIndex:(NSUInteger)index {
  [_codeFiles removeObjectAtIndex:index];
}




@end
