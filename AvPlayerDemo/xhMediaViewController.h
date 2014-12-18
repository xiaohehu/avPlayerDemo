//
//  xhMediaViewController.h
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xhMediaViewController : UIViewController

@property (nonatomic, readwrite)        BOOL            shouldRepeat;


- (id)initWithURL:(NSURL *)url;
- (void)playWithURL:(NSURL *)url;

@end
