//
//  SDYPersonalCell.h
//  SDYHotel
//
//  Created by admin on 2017/12/29.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,OrderState){
    OrderStateNoLook = 0,
    OrderStateNoSlove,
    OrderStateSolved,
    OrderStateAll
};

typedef void(^ButtonClick)(OrderState state);


@interface SDYPersonalCell : UITableViewCell

@property (nonatomic, copy) ButtonClick buttonClick;


- (IBAction)noLookButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stateNoLookLabel;

- (IBAction)noSloveButton:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateNoSloveLabel;


- (IBAction)slovedButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *stateSlovedLabel;


- (IBAction)allOrderButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *allOrderLabel;



@end
