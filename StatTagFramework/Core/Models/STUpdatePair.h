//
//  STUpdatePair.h
//  StatTag
//
//  Created by Eric Whitley on 6/21/16.
//  Copyright © 2016 StatTag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STUpdatePair<T> : NSObject {
  id _Old;
  id _New;
}

@property (copy, nonatomic) T Old;
@property (copy, nonatomic) T New;

-(instancetype)init;
-(instancetype)init:(T)oldItem newItem:(T)newItem;

-(NSString*)description;

@end
