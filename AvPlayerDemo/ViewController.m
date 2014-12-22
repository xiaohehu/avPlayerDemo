//
//  ViewController.m
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "ViewController.h"
#import "xhMediaViewController.h"

@interface ViewController () <xhMediaDelegate>
@property (nonatomic, strong)       xhMediaViewController           *player;
@end

@implementation ViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)tapButton:(id)sender {
    NSString *url = [[NSBundle mainBundle]
                     pathForResource:@"neoscape_bug"
                     ofType:@"mov"];
    if (_player) {
        [_player removeFromParentViewController];
        _player = nil;
    }
    _player = [[xhMediaViewController alloc] initWithURL:[NSURL fileURLWithPath:url]];
    _player.delegate = self;
    _player.repeat = YES;
    _player.controlPanel = YES;
    [self.view addSubview: _player.view];
}

- (void)didRemoveFromSuperView:mediaVC
{
    [UIView animateWithDuration:0.33 animations:^{
        _player.view.alpha = 0.0;
    } completion:^(BOOL finished){
        [_player.view removeFromSuperview];
        _player.view = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
