//
//  KWOCTableViewCell.m
//  ShanghaiCard
//
//  Created by 渴望 on 2018/11/1.
//  Copyright © 2018 渴望. All rights reserved.
//

#import "KWOCTableViewCell.h"

@interface KWOCTableViewCellItem ()

@property (nonatomic, weak, readwrite) Class cellClass;

@end

@implementation KWOCTableViewCellItem

- (NSString *)cellIdentifier {
    NSString *className = NSStringFromClass([self class]);
    if ([className hasSuffix:@"Item"]) {
        _cellIdentifier = [className substringToIndex:className.length - 4];
    }
    return _cellIdentifier;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight = 0.f;
    }
    return _cellHeight;
}

- (Class)cellClass {
    return NSClassFromString(self.cellIdentifier);
}

+ (instancetype)item {
    return [[[self class]alloc] init];
}

@end







@interface KWOCTableViewCell ()


@end

@implementation KWOCTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self kw_initUI];
    }
    return self;
}

- (void)kw_initUI {
    _sideMargin = DYCellSideMarge;
    
    
    self.textLabel.textColor = [UIColor Title];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.textColor = [UIColor Content];
    self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)dy_noneSelectionStyle {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - setter
- (void)setItem:(KWOCTableViewCellItem *)item
{
    _item = item;
    if ([item isMemberOfClass:[KWOCTableViewCellItem class]]) {
        if ([NSString xhq_notEmpty:item.title]) {
            self.textLabel.text = item.title;
        }
        if ([NSString xhq_notEmpty:item.imageName]) {
            UIImage *image = [UIImage imageNamed:item.imageName];
//            UIImage *image = [UIImage iconWithInfo:TBCityIconInfoMake(item.imageName, 20, XHQHexColor(0x288AFF))];
            
            self.imageView.image = image;
        }
    }
    if (self.accessoryType == UITableViewCellAccessoryNone && !self.accessoryView) {
        self.accessoryType = item.isShowIndicator ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    }
}


- (void)setSideMargin:(CGFloat)sideMargin {
    if (_sideMargin != sideMargin) {
        _sideMargin = sideMargin;
        [self layoutIfNeeded];
    }
}


@end
