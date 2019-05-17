//
//  BNRItemStore.m
//  Homepwner
//
//  Created by sharen on 2019/5/8.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
@interface BNRItemStore()
@property (nonatomic) NSMutableArray *privateItems;
@end

@implementation BNRItemStore

+(instancetype)sharedStore
{
    static BNRItemStore*sharedStore=nil;
    if(!sharedStore){
        sharedStore=[[self alloc] initPrivate];
    }
    return sharedStore;
}

-(instancetype)init
{
    @throw [NSException exceptionWithName:@"singleton" reason:@"Use +[BNRItemStore sharedStore]" userInfo:nil];
    return nil;
}
- (instancetype) initPrivate//真正的构造方法
{
    self=[super init];
    if(self){
        _privateItems=[[NSMutableArray alloc] init];
    }
    return self;
}
-(NSArray*)allItems
{
    return self.privateItems;
}

-(BNRItem*)createItem
{
    BNRItem *item=[BNRItem randomItem];
    [self.privateItems addObject:item];
    return item;
}
-(void) removeItems:(BNRItem *)item
{
    [self.privateItems removeObjectIdenticalTo:item];
}
-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if(fromIndex==toIndex)
        return;
    BNRItem*item=self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
}

@end
