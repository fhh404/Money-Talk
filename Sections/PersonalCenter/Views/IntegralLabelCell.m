//
//  IntegralLabelCell.m
//  jiankemall
//
//  Created by kunge on 14/12/23.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "IntegralLabelCell.h"

@implementation IntegralLabelCell
@synthesize intergalContentLabel;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        intergalContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
        intergalContentLabel.textColor = [UIColor blackColor];
        intergalContentLabel.font = [UIFont fontWithName:@"Arail" size:15];
        [self.contentView addSubview:intergalContentLabel];

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
