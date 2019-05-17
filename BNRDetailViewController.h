//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by sharen on 2019/5/9.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface BNRDetailViewController : UIViewController
-(instancetype)initForNewItem:(BOOL)idView;
@property (nonatomic,strong) BNRItem *item;
@property (nonatomic,copy) void(^dismissBlock)(void);
@end
