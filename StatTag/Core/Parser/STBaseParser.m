//
//  STBaseParser.m
//  StatTag
//
//  Created by Eric Whitley on 6/14/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import "STBaseParser.h"
#import "STConstants.h"
#import "STTag.h"
#import "STExecutionStep.h"

@implementation STBaseParser

@synthesize StartTagRegEx = _StartTagRegEx;
@synthesize EndTagRegEx = _EndTagRegEx;

-(NSString*)CommentCharacter {
  return @"";
}

-(id)init {
  self = [super init];
  if(self) {
    [self SetupRegEx];
  }
  return self;
}

//http://stackoverflow.com/questions/9276246/how-to-write-regular-expressions-in-objective-c-nsregularexpression
-(NSArray*)DetectTag:(NSRegularExpression*)tagRegex line:(NSString*)line {
  if(line == nil) {
    line = [[NSString alloc] init];
  }
  NSRange searchRange = NSMakeRange(0, [line length]);
  NSArray* matches = [tagRegex matchesInString:line options:0 range: searchRange];
  return matches;
}


-(void)SetupRegEx {
  //FIXME: go back and look at regex - Luke is setting options on the regex here so we should go back and have this return some sort of regex object (if possible) with options set instead of just the string
  // RegexOptions.Singleline
  NSError *error;
  if(_StartTagRegEx == nil){
    _StartTagRegEx = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s*[\\%@]{{2,}}\\s*%@\\s*%@(.*)", [self CommentCharacter], [STConstantsTagTags StartTag], [STConstantsTagTags TagPrefix]] options:0 error:&error] ;
    if(error != nil){
      NSLog(@"%@ - StartTagRegEx: %@", NSStringFromSelector(_cmd), error);
    }
  }
  if(_EndTagRegEx == nil){
    _EndTagRegEx = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"\\s*[\\%@]{{2,}}\\s*%@", [self CommentCharacter], [STConstantsTagTags EndTag]] options:0 error:&error] ;
    if(error != nil){
      NSLog(@"%@ - EndTagRegEx: %@", NSStringFromSelector(_cmd), error);
    }
  }
}


-(NSArray<NSString*>*)PreProcessContent:(NSArray<NSString*>*) originalContent {
  return nil;
}


//MARK: protocol implementation - the subclasses will need to actually override this
-(NSArray<STTag*>*)Parse:(STCodeFile*)file  {
  return [self Parse:file filterMode:[STConstantsParserFilterMode IncludeAll] tagsToRun:nil];
}
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode {
  return [self Parse:file filterMode:filterMode tagsToRun:nil];
}
-(NSArray<STTag*>*)Parse:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun {
  
  [self SetupRegEx];
  
  NSMutableArray *tags = [[NSMutableArray alloc] init];
  if(file == nil){
    return tags;
  }

  NSMutableArray *lines = [file LoadFileContent];
  if(lines == nil){
    //FIXME: what about 0 count?
    return tags;
  }
  
  NSNumber *startIndex;
  //http://stackoverflow.com/questions/895495/how-do-i-test-if-a-primitive-in-objective-c-is-nil
  //NSNumber *num = [NSNumber numberWithInt:0];
  //[num intValue]
  
  STTag *tag;
  for (int index = 0; index < [lines count]; index++) {

    //var line = lines[index].Trim();
    NSString *line = [[lines objectAtIndex:index] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //var match = StartTagRegEx.Match(line);
    NSArray* matches = [_StartTagRegEx matchesInString:line options:0 range: NSMakeRange(0, line.length)];
    
    if([matches count] > 0){
      tag = [[STTag alloc] init];
      tag.LineStart = @(index);
      tag.CodeFile = file;
      
      startIndex = @(index);
      //FIXME: add the error object...
      
      //ProcessTag(match.Groups[1].Value, tag);
      NSRange group1 = [matches[0] rangeAtIndex:1];
      NSString *matchText = [line substringWithRange:group1];
      [self ProcessTag:matchText Tag:tag error:nil];

    } else if (startIndex != nil) {
      matches = [_EndTagRegEx matchesInString:line options:0 range: NSMakeRange(0, line.length)];
      if([matches count] > 0){
        //FIXME: review this - we're not using primitive types, so it's unclear what happens if we set the value like this
        //tests show it seems to work, but be careful to test
        tag.LineStart = startIndex;
        tag.LineEnd = @(index);
        [tags addObject:tag];
        startIndex = nil;
      }
    }
  }

  if(filterMode == [STConstantsParserFilterMode ExcludeOnDemand]) {
    //    return tags.Where(x => x.RunFrequency == Constants.RunFrequency.Always).ToArray();
    NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [aTag RunFrequency] == [STConstantsRunFrequency Always];
    }];
    return [tags filteredArrayUsingPredicate:tagPredicate];
  } else if (filterMode == [STConstantsParserFilterMode TagList] && tagsToRun != nil){
    //    return tags.Where(x => tagsToRun.Contains(x)).ToArray();
    NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(STTag *aTag, NSDictionary *bindings) {
      return [tagsToRun containsObject:aTag];
    }];
    return [tags filteredArrayUsingPredicate:tagPredicate];
  }
  
  return tags;
  
}


-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file{
  return [self GetExecutionSteps:file filterMode:[STConstantsParserFilterMode IncludeAll] tagsToRun:nil];
}
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode{
  return [self GetExecutionSteps:file filterMode:filterMode tagsToRun:nil];
}
-(NSArray<STExecutionStep*>*)GetExecutionSteps:(STCodeFile*)file filterMode:(int)filterMode tagsToRun:(NSArray<STTag*>*)tagsToRun {
  
  NSMutableArray<STExecutionStep*> *executionSteps = [[NSMutableArray alloc]init];
  NSMutableArray<NSString*> *lines = [[NSMutableArray alloc] initWithArray:[self PreProcessContent:[file LoadFileContent]]];

  if(lines == nil || [lines count] == 0){
    return executionSteps;
  }
  
  NSNumber *startIndex;
  BOOL isSkipping = NO;
  STExecutionStep *step;

  for (int index = 0; index < [lines count]; index++)
  {
    NSString *line = [[lines objectAtIndex:index] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if(step == nil){
      step = [[STExecutionStep alloc]init];
    }
    
    NSArray* matches = [_StartTagRegEx matchesInString:line options:0 range: NSMakeRange(0, line.length)];

    if([matches count] > 0){
      // If the previous code block had content, save it off and create a new one
      if([[step Code] count] > 0){
        [executionSteps addObject:step];
        step = [[STExecutionStep alloc] init];
      }
      STTag *tag = [[STTag alloc] init];
      tag.CodeFile = file;
      
      startIndex = @(index);

      //ProcessTag(match.Groups[1].Value, tag);
      NSRange group1 = [matches[0] rangeAtIndex:1];
      NSString *matchText = [line substringWithRange:group1];
      [self ProcessTag:matchText Tag:tag error:nil];
      
      
      if (filterMode == [STConstantsParserFilterMode ExcludeOnDemand]
          && [tag RunFrequency] == [STConstantsRunFrequency OnDemand])
      {
        isSkipping = true;
      }
      else if (filterMode == [STConstantsParserFilterMode TagList]
               && tagsToRun != nil
               && ![tagsToRun containsObject:tag]
               )
      {
        isSkipping = true;
      }
      else
      {
        step.Type = [STConstantsExecutionStepType Tag];
        step.Tag = tag;
        [[step Code]addObject:line];
      }
    } else if (startIndex != nil){
      if (!isSkipping) {
        [[step Code] addObject:line];
      }

      matches = [_EndTagRegEx matchesInString:line options:0 range: NSMakeRange(0, line.length)];
      if([matches count] > 0){
        isSkipping = NO;
        startIndex = nil;

        if ([[step Code] count] > 0)
        {
          [executionSteps addObject:step];
        }
        step = [[STExecutionStep alloc] init];
      }
      
    } else if (!isSkipping){
      [[step Code] addObject:line];
    }
  }
  
  if (step != nil && [[step Code] count] > 0)
  {
    [executionSteps addObject:step];
  }

  return executionSteps;
}

-(BOOL)IsImageExport:(NSString*)command {
  return false;
}

-(NSString*)GetImageSaveLocation:(NSString*)command {
  return nil;
}

-(BOOL)IsValueDisplay:(NSString*)command {
  return false;
}

-(NSString*)GetValueName:(NSString*)command {
  return nil;
}

-(BOOL)IsTableResult:(NSString*)command {
  return false;
}

-(NSString*)GetTableName:(NSString*)command {
  return nil;
}

//TODO: not implemented
-(void)ProcessTag:(NSString*)tagText Tag:(STTag*)tag error:(NSError**)error {
  if([tagText hasPrefix:[STConstantsTagType Value]]) {
    tag.Type = [STConstantsTagType Value];
    //FIXME: incomplete implementation
    //    ValueParameterParser.Parse(tagText, tag);
    
  } else if([tagText hasPrefix:[STConstantsTagType Figure]]) {
    tag.Type = [STConstantsTagType Figure];
    //FIXME: incomplete implementation
    //    FigureParameterParser.Parse(tagText, tag);
    
  } else if([tagText hasPrefix:[STConstantsTagType Table]]) {
    tag.Type = [STConstantsTagType Table];
    //FIXME: incomplete implementation
    //    TableParameterParser.Parse(tagText, tag);
    //    ValueParameterParser.Parse(tagText, tag);
  } else {
    //populate error
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Unsupported tag type", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Unsupported tag type", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Unsupported tag type", nil)
                               };
    *error = [NSError errorWithDomain:STStatTagErrorDomain code:NSURLErrorFileDoesNotExist userInfo:userInfo];
  }

}

@end
