//
//  DocumentBrowserTagSummary.h
//  StatTag
//
//  Created by Eric Whitley on 3/28/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TagIndicatorView.h"

@interface DocumentBrowserTagSummary : NSObject {
  NSString* _tagGroupTitle;
  TagIndicatorViewTagType _tagType;
}

@property (strong) NSString* tagGroupTitle;
@property TagIndicatorViewTagType tagType;
@property NSInteger tagCount;

-(instancetype)init;
-(instancetype)initWithTitle:(NSString*)title andType:(TagIndicatorViewTagType)type andCount:(NSInteger)count;

@end
