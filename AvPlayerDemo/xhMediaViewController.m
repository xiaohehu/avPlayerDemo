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
    NSTimer         *checkTimer;
}

@end

@implementation xhMediaViewController
@synthesize repeat;
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                             object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.frame = [[UIScreen mainScreen] bounds];
    [self addGestureToView];
    [self createControlPanel];
    [self performSelector:@selector(createCheckTimer) withObject:nil afterDelay:2.0];
}

#pragma mark - Init AVPlayer with the URL
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

#pragma mark Listen avplayer's notification when reaches end
- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    if (repeat) {
        [myAVPlayer seekToTime:kCMTimeZero];
        [myAVPlayer play];
    }
    else
        return;
}

#pragma mark - Create the Control Panle
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

#pragma mark - Add Tap Gesutre to whole view
- (void)addGestureToView
{
    UITapGestureRecognizer *tapOnplayer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnPlayer:)];
    tapOnplayer.numberOfTapsRequired = 1;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer: tapOnplayer];
}

- (void)tapOnPlayer:(UIGestureRecognizer *)gesture
{
    [self hidePanel];
    [self unhidePanel];
}

#pragma mark - Add timer to hide control panel

- (void)createCheckTimer
{
        checkTimer =[NSTimer scheduledTimerWithTimeInterval:5.0
                            target:self
                            selector:@selector(checkControlPanel)
                            userInfo:nil
                            repeats:YES];
}

- (void) checkControlPanel
{
    if (!uiv_controlPanel.hidden) {
        [checkTimer invalidate];
        [self hidePanel];
        [self createCheckTimer];
    }
}

#pragma mark - Un/Hide control panel
- (void)hidePanel
{
    if (!uiv_controlPanel.hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            myAVPlayerLayer.backgroundColor = [UIColor blackColor].CGColor;
            uiv_controlPanel.alpha = 0.0;
        } completion:^(BOOL finished){
            uiv_controlPanel.hidden = YES;
        }];
    }
}

- (void)unhidePanel
{
    if (uiv_controlPanel.hidden) {
        uiv_controlPanel.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            myAVPlayerLayer.backgroundColor = [UIColor whiteColor].CGColor;
            uiv_controlPanel.alpha = 1.0;
        } completion:^(BOOL finished){        }];
    }
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
