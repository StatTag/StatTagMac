//
//  StatTagWordDocumentUnlinkedTagValidator.h
//  StatTag
//
//  Created by Eric Whitley on 10/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StatTagWordDocument;

@interface StatTagWordDocumentUnlinkedTagValidator : NSOperation {
  BOOL executing;
  BOOL finished;
}

@property StatTagWordDocument* statTagWordDoc;

-(instancetype)initWithStatTagWordDocument:(StatTagWordDocument*)doc;

@end
