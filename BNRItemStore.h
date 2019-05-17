//
//  BNRItemStore.h
//  Homepwner
//
//  Created by sharen on 2019/5/8.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRItem;
@interface BNRItemStore : NSObject
@property (nonatomic,readonly) NSArray *allItems;

+ (instancetype)sharedStore;
-(BNRItem*)createItem;
-(void)removeItems:(BNRItem*)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
@end
