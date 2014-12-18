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
    UIView          *uiv_controlPanel;
    UIButton        *uib_playPause;
}

@end

@implementation xhMediaViewController
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
    [self createControlPanel];
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
    myAVPlayerLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer: myAVPlayerLayer];
    
    [myAVPlayer play];
}

- (void)createControlPanel
{
    uiv_controlPanel = [UIView new];
    uiv_controlPanel.translatesAutoresizingMaskIntoConstraints = NO;
    uiv_controlPanel.backgroundColor = [UIColor blackColor];
    uiv_controlPanel.layer.borderWidth = 2.0;
    uiv_controlPanel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    uiv_controlPanel.layer.cornerRadius = 10.0;
    [self.view addSubview:uiv_controlPanel];
 
    // Size contstraints
    NSArray *control_constraint_H = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[uiv_controlPanel(60)]"
                                    options:0
                                    metrics:nil
                                    views:NSDictionaryOfVariableBindings(uiv_controlPanel)];

    NSArray *control_constraint_V = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"H:[uiv_controlPanel(300)]"
                                options:0
                                metrics:nil
                                views:NSDictionaryOfVariableBindings(uiv_controlPanel)];
    [self.view addConstraints: control_constraint_H];
    [self.view addConstraints: control_constraint_V];
    // Position constraints
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:@"V:[uiv_controlPanel]-offsetBottom-|"
                            options:0
                            metrics:@{@"offsetBottom": @60}
                            views:NSDictionaryOfVariableBindings(uiv_controlPanel)];

    [self.view addConstraints: constraints];
    
    [self.view addConstraint:
        [NSLayoutConstraint constraintWithItem:uiv_controlPanel
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                                 toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                             multiplier:1
                               constant:0]];
    
    [self addControlButtons];

}

- (void)addControlButtons
{
    uib_playPause = [UIButton buttonWithType: UIButtonTypeCustom];
    uib_playPause.frame = CGRectMake(0.0, 0.0, 300.0, 60.0);
    [uib_playPause setTitle:@"PAUSE" forState:UIControlStateNormal];
    [uib_playPause setTitle:@"PLAY" forState:UIControlStateSelected];
    [uiv_controlPanel addSubview: uib_playPause];
    [uib_playPause addTarget:self action:@selector(tapPlayPause:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapPlayPause:(id)sender
{
    UIButton *tappedBtn = sender;
    if (tappedBtn.selected) {
        [myAVPlayer play];
    }
    else
    {
        [myAVPlayer pause];
    }
    tappedBtn.selected = !tappedBtn.selected;
}

-(void) viewWillLayoutSubviews {
    self.view.frame = self.view.superview.bounds;
    myAVPlayerLayer.frame = self.view.bounds;
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
