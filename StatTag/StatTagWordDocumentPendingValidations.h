//
//  StatTagWordDocumentPendingValidations.h
//  StatTag
//
//  Created by Eric Whitley on 10/26/17.
//  Copyright © 2017 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatTagWordDocumentPendingValidations : NSObject

@property NSMutableDictionary<NSString*, NSOperation*>* validationsInProgress;
@property NSOperationQueue* validationQueue;


@end
