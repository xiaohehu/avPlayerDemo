//
//  xhMediaViewController.h
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioMix.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVFoundation.h>

@interface xhMediaViewController : UIViewController

@property (nonatomic, strong)           AVPlayerItem               *playerItem;
@property (nonatomic, strong)           AVPlayer                   *myAVPlayer;
@property (nonatomic, strong)           AVPlayerLayer              *myAVPlayerLayer;

- (id)initWithURL:(NSURL *)url;
- (void)playWithURL:(NSURL *)url;

@end
