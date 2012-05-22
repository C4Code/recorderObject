//
//  C4WorkSpace.m
//  recorderObject
//
//  Created by Travis Kirton on 12-05-21.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "RecorderObject.h"
#import "C4DateTime.h"

@interface C4WorkSpace ()
-(void)addRecorderObject;
@end

@implementation C4WorkSpace {
}

-(void)setup {
    [C4DateTime millis];
    [self performSelector:@selector(addRecorderObject) withObject:nil afterDelay:1.0f];
}

-(void)addRecorderObject {
    if([self.canvas.subviews count] < 15) {
    RecorderObject *ro = [RecorderObject new];
    [self.canvas addShape:ro];
    }
    
    [self performSelector:@selector(addRecorderObject) withObject:nil afterDelay:0.5];
//    for(int i = 0; i< 51; i++) {
//    }
}					
@end
