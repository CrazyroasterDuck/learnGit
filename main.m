//
//  main.m
//  RandomItems
//
//  Created by sharen on 2019/5/7.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSMutableArray *items=[[NSMutableArray alloc] init];
        BNRItem *backpack=[[BNRItem alloc]initWithItemName:@"Backpack"];
        [items addObject:backpack];
        BNRItem *Calculator=[[BNRItem alloc]initWithItemName:@"Calculator"];
        [items addObject:Calculator];
        backpack.containedItem=Calculator;
        backpack=nil;
        Calculator=nil;
        
        for(BNRItem *item in items){
            NSLog(@"%@",item);
        }
        
        NSLog(@"Setting items  to nil...");
        items=nil;//释放items指向的对象
    }
    return 0;
}

