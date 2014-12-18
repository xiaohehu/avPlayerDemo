//
//  xhMediaViewController.m
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "xhMediaViewController.h"

@interface xhMediaViewController ()
{

    NSURL           *fileURL;
}

@end

@implementation xhMediaViewController
@synthesize shouldRepeat;
@synthesize myAVPlayer;
@synthesize myAVPlayerLayer;
@synthesize playerItem;

- (id)initWithURL:(NSURL *)url
{
    if (self == [super init]) {
        self.view.frame = [[UIScreen mainScreen] bounds];
        fileURL = url;
        [self playWithURL:fileURL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
//    [self playWithURL:fileURL];
    self.view.frame = [[UIScreen mainScreen] bounds];
}

- (void)playWithURL:(NSURL *)url
{
    if (myAVPlayer) {
        myAVPlayer = nil;
        [myAVPlayerLayer removeFromSuperlayer];
        myAVPlayerLayer = nil;
        playerItem = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    playerItem = [AVPlayerItem playerItemWithURL:url];
    myAVPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    myAVPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:myAVPlayer];
    CGRect frame = self.view.bounds;
    myAVPlayerLayer.frame = frame;
    myAVPlayerLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer: myAVPlayerLayer];
    
    [myAVPlayer play];
    
}

-(void) viewWillLayoutSubviews {
    self.view.frame = [[UIScreen mainScreen] bounds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
