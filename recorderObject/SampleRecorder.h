//
//  SampleRecorder.h
//  audioRecord2
//
//  Created by Travis Kirton on 12-05-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "C4Object.h"
#import "C4DateTime.h"

@interface SampleRecorder : C4Object <AVAudioRecorderDelegate>
-(void)recordSample;
-(void)recordSampleWithId:(NSInteger)sampleId;
-(void)stopRecording;
-(void)deleteAudioFile;
-(void)prepareForRemoval;

@property (readwrite, strong) NSMutableDictionary *settings;
@property (readwrite, strong) NSURL *fileURL;
@property (readwrite, strong) AVAudioRecorder *audioRecorder;
@end
