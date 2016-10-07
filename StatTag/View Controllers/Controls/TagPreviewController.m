//
//  TagPreviewController.m
//  StatTag
//
//  Created by Eric Whitley on 10/6/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "TagPreviewController.h"
#import "StatTag.h"
#import "TagGridView.h"
#import "StatTagShared.h"

@interface TagPreviewController ()

@end

@implementation TagPreviewController

static void *TagTypeContext = &TagTypeContext;
static void *TagFormatContext = &TagFormatContext;
static void *TagTableFormatContext = &TagTableFormatContext;


////table
//static void *TagTableFormatColumnNamesContext = &TagTableFormatColumnNamesContext;
//static void *TagTableFormatRowNamesContext = &TagTableFormatRowNamesContext;
//
////basic numeric
//static void *tagValueFormatDecimalPlaces = &tagValueFormatDecimalPlaces;
//static void *tagValueFormatUseThousands = &tagValueFormatUseThousands;
//
////overall value type
//static void *TagNumericValueType = &TagNumericValueType;
//
////datetime
//static void *TagDateTimeShowDate = &TagDateTimeShowDate;
//static void *TagDateTimeDateFormat = &TagDateTimeDateFormat;
//static void *TagDateTimeShowTime = &TagDateTimeShowTime;
//static void *TagDateTimeTimeFormat = &TagDateTimeTimeFormat;


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do view setup here.
}

-(void)viewDidAppear {
  [self generatePreviewImage];
  [self generatePreviewText];
  [self startObservingTagChanges];
}

//graph preview
/**
 1) colum headers?
 2) row headers?
 */

-(void) dealloc {
  [self stopObservingTagChanges];
}

-(void) startObservingTagChanges {
  [self addObserver:self
            forKeyPath:@"tag.Type"
               options:(NSKeyValueObservingOptionNew |
                        NSKeyValueObservingOptionOld)
               context:TagTypeContext];

  [self addObserver:self
         forKeyPath:@"tag.TableFormat.IncludeColumnNames"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTableFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.TableFormat.IncludeRowNames"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagTableFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.DecimalPlaces"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.UseThousands"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.DateFormat"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

  [self addObserver:self
         forKeyPath:@"tag.ValueFormat.TimeFormat"
            options:(NSKeyValueObservingOptionNew |
                     NSKeyValueObservingOptionOld)
            context:TagFormatContext];

//  NSLog(@"", [[[self tag] ValueFormat] UseThousands] );
  
}

-(void) stopObservingTagChanges {
  [self removeObserver:self
               forKeyPath:@"tag.Type"
                  context:TagTypeContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeColumnNames"
               context:TagTableFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.TableFormat.IncludeRowNames"
               context:TagTableFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.DecimalPlaces"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.UseThousands"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.DateFormat"
               context:TagFormatContext];
  [self removeObserver:self
            forKeyPath:@"tag.ValueFormat.TimeFormat"
               context:TagFormatContext];


}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  //https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOBasics.html
  
  if (context == TagTypeContext || context == TagTableFormatContext) {
    //we don't want to regenerate images for just "text" changes, so catch this up here
    [self generatePreviewText];
    [self generatePreviewImage];
  } else if (context == TagFormatContext) {
    [self generatePreviewText];
    //[self generatePreviewImage]; //explicitly commenting this out so we remember to NOT do this
    //we don't need to regenerate the table if we only changed text stuff
  } else {
    // Any unrecognized context must belong to super
    [super observeValueForKeyPath:keyPath
                         ofObject:object
                           change:change
                          context:context];
  }
}

-(void)generatePreviewText {
  
  //FIXME: NOTE this needs to be refactored to move the formatters into the singletone
  //super expensive
  
  if ([[self tag] Type] == [STConstantsTagType Figure]) {
    [self setShowsPreviewText:NO];
  } else {
    
    NSString* previewText;

    //use something smarter like a value formatter...
    
    if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Numeric]] ) {
      //number formatter
//      NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//      //formatter.locale = NSLocale(localeIdentifier: "en_US")  // locale determines the decimal point (. or ,); English locale has "."
//      //formatter.groupingSeparator = ""  // you will never get thousands separator as output
//      if(![[[self tag] ValueFormat] UseThousands]) {
//        [numberFormatter setGroupingSeparator:@""];
//      } else {
//        [numberFormatter setLocale:[NSLocale currentLocale]];
//      }
//      [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//      NSInteger numDigits = [[[self tag] ValueFormat] DecimalPlaces];
//      [numberFormatter setMinimumFractionDigits:numDigits];
//      [numberFormatter setMaximumFractionDigits:numDigits];
//      previewText = [numberFormatter stringFromNumber:@100000];
      
//      if([[[self tag] CachedResult] count] > 0) {
//        
//      }
      
      NSString* result = [[[[self tag] CachedResult] lastObject] ValueResult];
      if(result == nil) {
        result = @"100000";
      }
      
      previewText = [[[self tag] ValueFormat] Format:result];
    }
    else if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType DateTime]] ) {
      //date formatter
      //FIXME: move the date formatter to a singleton
      //March 14, 2001 19:30:50

      //+ (NSDate*)dateFromString:(NSString*)dateString
      //NSDate* previewDate = [STJSONUtility dateFromString:@"March 14, 2001 19:30:50"];
      /*
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:format];
       //FIXME: locale...
       [formatter setLocale:currentLoc];
       //  NSTimeZone *timeZone = [NSTimeZone localTimeZone];
       [formatter setTimeZone:[NSTimeZone localTimeZone]];
       return [formatter stringFromDate:dateValue];
       */
//      STValueFormat* vf = [[STValueFormat alloc] init];
//      if([[STConstantsDateFormats GetList] containsObject:[[[self tag] ValueFormat] DateFormat]] ) {
//        vf.DateFormat = [[[self tag] ValueFormat] DateFormat];
//      }
//      if([[STConstantsTimeFormats GetList] containsObject:[[[self tag] ValueFormat] TimeFormat]] ) {
//        vf.TimeFormat = [[[self tag] ValueFormat] TimeFormat];
//      }

      previewText = [[[self tag] ValueFormat] Format:@"March 14, 2001 19:30:50"];
      //previewText = [vf Format:@"March 14, 2001 19:30:50"];
    }
    else if([[[[self tag] ValueFormat] FormatType] isEqualToString:[STConstantsValueFormatType Percentage]] ) {
      //number formatter
      /*
      NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
      [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
      NSInteger numDigits = [[[self tag] ValueFormat] DecimalPlaces];
      [numberFormatter setGroupingSeparator:@""]; //what if we want thousands in percentages?
      [numberFormatter setMinimumFractionDigits:numDigits];
      [numberFormatter setMaximumFractionDigits:numDigits];
      previewText = [numberFormatter stringFromNumber:@100];
      */
      NSString* result = [[[[self tag] CachedResult] lastObject] ValueResult];
      if(result == nil) {
        result = @"1";
      }
      previewText = [[[self tag] ValueFormat] Format:result];
    } else {
      previewText = @"(Exactly as Generated)";
    }
    
    if(previewText == nil) {
      [self setShowsPreviewText:NO];
    } else {
      [[self previewText] setStringValue:previewText];
      [self setShowsPreviewText:YES];
    }
  }
  
}

-(void)generatePreviewImage {
  
  NSImage* preview;
  
  if([[self tag] Type] == [STConstantsTagType Table]) {
    TagGridView* grid = [[TagGridView alloc] initWithFrame:[[self previewImageView] bounds]];
    grid.useColumnLabels = [[[self tag] TableFormat] IncludeColumnNames];
    grid.useRowLabels = [[[self tag] TableFormat] IncludeRowNames];
    grid.gridSize = 6;
    //FIXME: move color
    grid.headerFillColor = [StatTagShared colorFromRGBRed:0 green:125 blue:255 alpha:1.0];
    preview = [[NSImage alloc] initWithData:[grid dataWithPDFInsideRect:[grid bounds]]];
  } else if ([[self tag] Type] == [STConstantsTagType Figure]) {
    //FIXME: move property

    //check the latest image result
    preview = [[NSImage alloc] initWithContentsOfFile:[[self tag] FormattedResult]];
    if(preview == nil) {
      //then try the cached result
      preview = [[NSImage alloc] initWithContentsOfFile: [[[[self tag] CachedResult] lastObject] FigureResult]];
    }
    if(preview == nil) {
      //if we can't access our original image (or we can't interpret the format)
      // then just use the default placeholder image
      preview = [NSImage imageNamed:@"figure_preview"]; //move this to a property later
    }
  }
  
  if(preview) {
    _previewImage = preview;
    [self setShowsPreviewImage:YES];
    self.previewImageView.image = _previewImage;
  } else {
    //we can't show anything, so don't
    [self setShowsPreviewImage:NO];
    //[self setValue:[NSNumber numberWithInt:NO] forKey:@"self.showsPreviewImage"];
  }
  
}

@end
