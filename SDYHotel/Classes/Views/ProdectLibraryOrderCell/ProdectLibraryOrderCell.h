//
//  ProdectLibraryOrderCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/17.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdectLibraryOrderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *productName;

@property (weak, nonatomic) IBOutlet UILabel *shopName;

@property (weak, nonatomic) IBOutlet UILabel *number;

- (IBAction)deleteBtn:(id)sender;

@end
