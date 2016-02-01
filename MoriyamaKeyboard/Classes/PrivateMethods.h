//
//  PrivateMethods.h
//  Moriyama
//
//  Created by Ichiro on 2016/02/01.
//  Copyright © 2016年 Ichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSObject ()

- (NSString *)_ivarDescription;
- (NSString *)_shortMethodDescription;
- (NSString *)_methodDescription;

@end


@interface UIView ()

- (NSString *)recursiveDescription;
- (NSString *)_autolayoutTrace;

@end

@interface UIViewController ()

- (NSString *)_printHierarchy;

@end