//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by sharen on 2019/5/8.
//  Copyright © 2019年 QingShuXueTang. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"



@implementation BNRItemsViewController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRDetailViewController *detailViewController=[[BNRDetailViewController alloc]initForNewItem:NO];
    NSArray *items=[[BNRItemStore sharedStore]allItems];
    BNRItem *selectedItem=items[indexPath.row];
    
    //将选中的BNRItem对象赋值给DetailViewController对象
    detailViewController.item=selectedItem;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

-(instancetype) init
{
    self=[super initWithStyle:UITableViewStylePlain];
    if(self){
        UINavigationItem *navItem=self.navigationItem;
        navItem.title=@"Homepwner";
        
        //创建新的UIBarButtonItem对象，将其目标对象设置为当前对象，将其动作设置成addNewItem
        UIBarButtonItem *bbi=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem=bbi;//为UInavigationItem对象设置为当前对象的rightBarButtonItem属性赋值，指向新创建的UIBarButtonItem属性
        navItem.leftBarButtonItem=self.editButtonItem;
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore]allItems]count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath]; //声明重用UITableView
    BNRItemCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    NSArray *items=[[BNRItemStore sharedStore]allItems];
    BNRItem *item=items[indexPath.row];
    
    //cell.textLabel.text=[item description];
    cell.nameLabel.text=item.itemName;
    cell.serialNumberLabel=item.serialNumber;
    cell.valueLabel.text=[NSString stringWithFormat:@"$%d",item.valueInDollars];
    
    return cell;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建UINib对象，该对象代表包含了BNRItemCell的NIB文件
    UINib *nib=[UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
}


- (IBAction)addNewItem:(id)sender
{
    BNRItem* newItem=[[BNRItemStore sharedStore] createItem];
    BNRDetailViewController *detailViewController=
                            [[BNRDetailViewController alloc] initForNewItem:YES];
    detailViewController.item=newItem;
    
    detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
    UINavigationController *navController=[[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle=UIModalPresentationFormSheet;//以模态形式显示UINavigationController对象的外观
    navController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:navController animated:YES completion:nil];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{   //在数据源中删除数据
    if(editingStyle==UITableViewCellEditingStyleDelete){
        NSArray *items=[[BNRItemStore sharedStore] allItems];
        BNRItem *item=items[indexPath.row];
        [[BNRItemStore sharedStore]removeItems:item];
        
        //还要删除表格视图中的相应表格行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
//实现表行的迁移功能
- (void) tableView:(UITableView *)tableView
moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath
       toIndexPath:(nonnull NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];//类似于刷新界面
}
@end

