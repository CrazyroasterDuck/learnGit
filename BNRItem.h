//
//  BNRItem.h
//  RandomItems
//
//  Created by sharen on 2019/5/7.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItem : NSObject
//@property (nonatomic,strong) BNRItem *containedItem;
//@property (nonatomic,weak) BNRItem *container;//自对象设置为弱引用，否则出现强循环引用
@property (nonatomic,copy)NSString *itemName;
@property (nonatomic,copy)NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic,readonly,strong) NSDate *dateCreated;
@property (nonatomic,strong) UIImage *thumbnail;
//声明类方法
+ (instancetype) randomItem;
//接下来声名实例变量的存取方法
- (void) setItemName:(NSString*)str;
- (NSString*)itemName;

- (void)setSerialNumber:(NSString*)str;
- (NSString*)serialNumber;

- (void) setValueInDollars:(int)v;
- (int) valueInDollars;

- (NSDate*)dateCreated;

//两个初始化方法
- (instancetype)initWithItemName:(NSString*)name
                  valueInDollars:(int)value
                    serialNumber:(NSString*)sNumber;//类的指定初始化方法；

- (instancetype)initWithItemName:(NSString*)name serialNumber:(NSString*)sNumber;//练习

- (instancetype)initWithItemName:(NSString *)name;


- (void) setContainedItem:(BNRItem*)item;
- (BNRItem*)containedItem;

- (void) setContainer:(BNRItem*)item;
- (BNRItem*)container;

- (void)setThumbnailFromImage:(UIImage *)image;
@end
