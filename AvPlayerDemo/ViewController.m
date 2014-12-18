//
//  ViewController.m
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "ViewController.h"
#import "xhMediaViewController.h"

@interface ViewController ()
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
    
    _player = [[xhMediaViewController alloc] initWithURL:[NSURL fileURLWithPath:url]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_player.myAVPlayer currentItem]];

    [self.view addSubview: _player.view];    
}

- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    [_player.myAVPlayer seekToTime:kCMTimeZero];
    [_player.myAVPlayer play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
