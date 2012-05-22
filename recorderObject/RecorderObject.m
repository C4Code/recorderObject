//
//  RecorderObject.m
//  recorderObject
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "RecorderObject.h"

@interface RecorderObject ()
-(void)startRecording;
-(void)stopRecording;
-(void)play;
-(void)updateAndDisplayMeters;
-(void)fadeOut;
-(void)stopPlaying;
-(void)removeFile;
-(void)removeRecorder;
-(void)startMeters;
-(void)prepareForRemoval;

@property (readwrite, strong) SampleRecorder *sr;
@property (readwrite, strong) MeteringSample *ms;
@property (readwrite, strong) C4Shape *backgroundShape;
@property (readwrite, strong) UIColor *color;
@end

@implementation RecorderObject {
    NSUInteger objectID;
    NSTimer *meterTimer, *movementTimer;
    BOOL recordingStarted;
}
@synthesize sr, ms, backgroundShape, color;

-(id)init  {
    self = [super init];
    if(self != nil) {
        self.sr = [SampleRecorder new];
        self.color = C4GREY;
        objectID = [C4DateTime millis];
        [self ellipse:CGRectMake(334, 262, 100, 100)];
        self.fillColor = [UIColor clearColor];
        self.backgroundShape = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
        self.backgroundShape.animationDuration = 0.0f;
        self.backgroundShape.lineWidth = 0.0f;
        self.backgroundShape.fillColor = [UIColor clearColor];
        
        [self addSubview:backgroundShape];
        movementTimer = [NSTimer timerWithTimeInterval:1.5f 
                                                target:self 
                                              selector:@selector(moveCircleRandomly) 
                                              userInfo:nil 
                                               repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:movementTimer forMode:NSDefaultRunLoopMode];
        [movementTimer fire];
        [self performSelector:@selector(startRecording) withObject:self afterDelay:0.5f];
        recordingStarted = NO;
        [self listenFor:@"noErrorInDeletingFile" fromObject:self.sr andRunMethod:@"prepareForRemoval"];
        [self listenFor:@"readyToBeRemoved" fromObject:self.sr andRunMethod:@"removeRecorder"];
    }
    return self;
}



-(void)startRecording {
    if(!recordingStarted) {
        [self.sr recordSampleWithId:objectID];
        [self performSelector:@selector(stopRecording) withObject:nil afterDelay:1.0];
        recordingStarted = YES;
    }
}

-(void)stopRecording {
    [self.sr stopRecording];
    self.ms = [[MeteringSample alloc] initWithURL:[sr fileURL]];
    [self performSelector:@selector(play) withObject:nil afterDelay:0.25];
}

-(void)play {
    [self.ms play];
    [self performSelector:@selector(startMeters) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f];
}

-(void)startMeters {
    meterTimer = [NSTimer timerWithTimeInterval:1/15.0f 
                                         target:self 
                                       selector:@selector(updateAndDisplayMeters) 
                                       userInfo:nil 
                                        repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:meterTimer forMode:NSDefaultRunLoopMode];
}

-(void)updateAndDisplayMeters {
    if(self.ms.player.isMeteringEnabled == YES) {
        [self.ms.player updateMeters];
        CGFloat a = [C4Math pow:10 raisedTo:0.05 * [self.ms.player averagePowerForChannel:0]]*5;
        self.backgroundShape.animationDuration = 0.0f;
        @try {
            self.backgroundShape.fillColor = [self.color colorWithAlphaComponent:a];
        }
        @catch (NSException *exception) {
            C4Log(@"%@",exception);
        }
    }
}

-(void)fadeOut {
    if (self.ms.volume > 0.0f) {
        self.ms.volume -= 0.01f;
        [self performSelector:@selector(fadeOut) withObject:nil afterDelay:1.0f/30.0f];
    } else {
        [self performSelector:@selector(stopPlaying) withObject:nil afterDelay:[movementTimer timeInterval] + 0.1];
        [meterTimer invalidate];
        [movementTimer invalidate];
    }
}

-(void)stopPlaying {
    if(self.ms.isPlaying) {
        [self.ms stop];
        self.ms = nil;
    }
    @try {
        [self performSelector:@selector(removeFile) withObject:nil afterDelay:1.0f];
    }
    @catch (NSException *exception) {
        C4Log(@"%@",exception);
    }
}

-(void)removeFile {
    @try {
        [self.sr deleteAudioFile];
    }
    @catch (NSException *exception) {
        C4Log(@"%@",exception);
    }
}

-(void)prepareForRemoval {
    C4Log(@"prepareForRemoval");
    [(SampleRecorder *)self.sr prepareForRemoval];
}

-(void)removeRecorder {
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.5];
}

-(void)moveCircleRandomly {
    self.animationDuration = 1.0f;
    self.center = CGPointMake([C4Math randomInt:768],[C4Math randomInt:1024]);
}
@end

