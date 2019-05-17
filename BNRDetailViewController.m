//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by sharen on 2019/5/9.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import <UIKit/UIKit.h>

@interface BNRDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation BNRDetailViewController
//覆盖父类方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    BNRItem *item=self.item;
    self.nameField.text=item.itemName;
    self.serialNumberField.text=item.serialNumber;
    self.valueField.text=[NSString stringWithFormat:@"%d",item.valueInDollars];
    
    //创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormatter=nil;
    if(!dateFormatter){
        dateFormatter=[[NSDateFormatter alloc]init];
        dateFormatter.dateStyle=NSDateFormatterMediumStyle;
        dateFormatter.timeStyle=NSDateFormatterNoStyle;
    }
    //将转换后的日期字符串设置为dateLabel的标题
    self.dateLabel.text=[dateFormatter stringFromDate:item.dateCreated];
}
//覆盖父类方法
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    //将修改保存至BNRItem对象
    BNRItem *item=self.item;
    item.itemName=self.nameField.text;
    item.serialNumber=self.serialNumberField.text;
    item.valueInDollars=[self.valueField.text intValue];
}

-(void)setItem:(BNRItem*)item
{
    _item=item;
    self.navigationItem.title=item.itemName;
}
-(instancetype) initForNewItem:(BOOL)isView
{
    self=[super initWithNibName:nil bundle:nil];
    if(self){
        if(isView){
            UIBarButtonItem *doneItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            self.navigationItem.rightBarButtonItem=doneItem;
            
            UIBarButtonItem *cancelItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem=cancelItem;
        }
    }
    return self;
}

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

- (void) save:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}
-(void) cancel:(id)sender
{
    [[BNRItemStore sharedStore]removeItems:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:self.dismissBlock];
}

@end
