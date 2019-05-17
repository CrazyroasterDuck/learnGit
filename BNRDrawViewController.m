//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by sharen on 2019/5/10.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"
@interface BNRDrawViewController ()

@end

@implementation BNRDrawViewController
- (void) loadView{
    self.view=[[BNRDrawView alloc]initWithFrame:CGRectZero];
}


@end
