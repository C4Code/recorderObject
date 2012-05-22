//
//  MySample.m
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "MeteringSample.h"

@implementation MeteringSample
@synthesize player = _player;
+(MeteringSample *)sampleURL:(NSURL *)sampleURL {
    MeteringSample *s = [[MeteringSample alloc] initWithURL:sampleURL];
    return s;
}

-(id)initWithURL:(NSURL *)sampleURL {
    self = [super init]; 
    if(self != nil) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:sampleURL error:nil];
        self.player.delegate = self;
        self.meteringEnabled = YES;
        self.loops = YES;
    }
    return self;
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    C4Log(@"finished");
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    
}

@end