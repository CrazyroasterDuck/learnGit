//
//  BNRItemCell.h
//  
//
//  Created by sharen on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BNRItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
