//
//  BNRItem.m
//  RandomItems
//
//  Created by sharen on 2019/5/7.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem
+ (instancetype) randomItem
{
    NSArray *randomAdjList=@[@"Fluffy",@"Rusty",@"Shiny"];//形容词数组
    NSArray *randomNounList=@[@"Bear",@"Spork",@"Mac"];//名词数组
    NSInteger adjIndex=arc4random()%[randomAdjList count];//随机获取形容词的索引
    NSInteger nounIndex=arc4random()%[randomNounList count];//随机获取名词的索引
    
    NSString *randomName=[NSString stringWithFormat:@"%@ %@",
                          randomAdjList[adjIndex],
                          randomNounList[nounIndex]];
    int randomValue=arc4random()%100;
    NSString *randomSerialNumber=[NSString stringWithFormat:@"%c%c%c%c",
                                  '0'+arc4random()%10,
                                  'A'+arc4random()%26,
                                  '0'+arc4random()%10,
                                  'A'+arc4random()%26];
    BNRItem *newItem=[[BNRItem alloc] initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    
    return newItem;
}

/*
- (void)setContainedItem:(BNRItem *)item
{
    _containedItem=item;
    self.containedItem.container=self;
}
 */

//覆盖description方法
- (NSString*) description
{
    NSString* descriptionString=[[NSString alloc] initWithFormat:@"%@ (%@): worth $%d,recorded on %@",
                                 self.itemName,
                                 self.serialNumber,
                                 self.valueInDollars,//int
                                 self.dateCreated];
    return descriptionString;
}

//覆盖deallocat方法
- (void) dealloc {
    NSLog(@"Destroyed:%@",self);
}

//实现指定的初始化方法
- (instancetype)initWithItemName:(NSString*)name
                  valueInDollars:(int)value
                    serialNumber:(NSString*)sNumber
{
    self=[super init];//调用父类的指定初始化方法
    //父类的指定初始化方法是否成功创建了父类对象
    if(self){
        _itemName=name;
        _serialNumber=sNumber;
        _valueInDollars=value;
        
        //设置系统时间为当前时间
        _dateCreated=[[NSDate alloc] init];
    }
    return self;
}

- (void) setThumbnailFromImage:(UIImage *)image
{
    CGSize origImageSize=image.size;//获取图片大小
    CGRect newRect=CGRectMake(0, 0, 40, 40);//缩略图的大小
    //确定缩放倍数，并保持宽高比不变
    float ratio=MAX(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);
    //根据当前设备的屏幕scaling factor 创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    //创建表示圆角矩形的UIBezierPath对象
    UIBezierPath *path=[UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:5.0];
    //根据UIBezierPath对象裁剪图形上下文
    [path addClip];
    //让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width=ratio*origImageSize.width;
    projectRect.size.height=ratio*origImageSize.height;
    projectRect.origin.x=(newRect.size.width-projectRect.size.width)/2.0;
    projectRect.origin.y=(newRect.size.height-projectRect.size.height)/2.0;
    
    //在上下文中绘制图片
    [image drawInRect:projectRect];
    
    //通过图形上下文得倒UIImage对象，并将其赋给thumbnail属性
    UIImage *smallImage=UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail=smallImage;
    //清理图形上下文
    UIGraphicsEndImageContext();
}

//练习
- (instancetype)initWithItemName:(NSString*)name serialNumber:(NSString*)sNumber;
{
    return[[BNRItem alloc] initWithItemName:name valueInDollars:0 serialNumber:sNumber];
}


- (instancetype)initWithItemName:(NSString *)name{
    return [self initWithItemName:name valueInDollars:0 serialNumber:@""];
}
- (instancetype)init
{
    return [self initWithItemName:@"Item"];
}
@end
