//
//  IntegralLabel2Cell.m
//  jiankemall
//
//  Created by kunge on 14/12/24.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "IntegralLabel2Cell.h"

@implementation IntegralLabel2Cell
@synthesize intergalLabel2;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        intergalLabel2 = [[UILabel alloc] init];
        intergalLabel2.textColor = [UIColor blackColor];
        intergalLabel2.font = [UIFont fontWithName:@"Arial" size:15];
        [self.contentView addSubview:intergalLabel2];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
