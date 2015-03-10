//
//  SearchTableViewCell.m
//  jiankemall
//
//  Created by jianke on 14-12-3.
//  Copyright (c) 2014年 kunge. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell
@synthesize contentLabel,clearBtn;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        contentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:contentLabel];
        
        
        clearBtn = [[UIButton alloc] init];
        [self.contentView addSubview:clearBtn];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
