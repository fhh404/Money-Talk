//
//  ProtoclCell.m
//  jiankemall
//
//  Created by kunge on 14/12/25.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "ProtoclCell.h"

@implementation ProtoclCell
@synthesize contentLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contentLabel = [[UILabel alloc] init];
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.font = [UIFont fontWithName:@"Arial" size:14];
        contentLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:contentLabel];
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
