//
//  UILabel+GDIAdditions.m
//  GDI iOS Core
//
//  Created by Grant Davis on 2/23/12.
//  Copyright (c) 2012 Grant Davis Interactive, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in the
//  Software without restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
//  Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
//  AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "UILabel+GDIAdditions.h"
#import "UIView+GDIAdditions.h"


@implementation UILabel (GDIAdditions)

- (void)adjustSizeToFitText
{
    if (!self.text || [self.text length] == 0) {
        return;
    }
    CGSize labelSize;
    if (self.numberOfLines == 1) {
        labelSize = [self.text sizeWithAttributes:@{ NSFontAttributeName: self.font }];
    }
    else {
        NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraph.lineBreakMode = self.lineBreakMode;
        
        labelSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, FLT_MAX)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraph }
                                            context:nil].size;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, labelSize.height);
}

- (void)adjustWidthToFitText
{
    if (!self.text || [self.text length] == 0) {
        return;
    }
    
    CGSize labelSize = [self.text sizeWithAttributes:@{ NSFontAttributeName: self.font }];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelSize.width, self.frame.size.height);
}

- (void)adjustHeightToFitText
{
    if (!self.text || [self.text length] == 0 || self.numberOfLines > 0) {
        return;
    }
    
    NSMutableParagraphStyle *paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraph.lineBreakMode = self.lineBreakMode;
    CGSize labelSize = labelSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, FLT_MAX)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraph }
                                                           context:nil].size;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height);
}

+ (UILabel *)labelForSizing
{
    static UILabel *label;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        label = [[UILabel alloc] initWithFrame:CGRectZero];
    });
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    return label;
}

+ (UILabel *)labelForSizingWithFont:(UIFont *)font text:(NSString *)text width:(CGFloat)width
{
    UILabel *label = [UILabel labelForSizing];
    label.font = font;
    label.text = text;
    label.frameWidth = width;
    return label;
}

@end
