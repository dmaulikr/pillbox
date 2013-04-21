//
//  Pill.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "Pill.h"
#import <Underscore.h>

@implementation Pill

@dynamic freq_type;
@dynamic freq_value;
@dynamic name;
@dynamic next_time;

#define  MAX_ITER 1000

-(NSDate*) timeRemaining: (NSDate*) base
{
    return [[self timeRemaining:base nValues:1] objectAtIndex:0];
}

-(NSArray*) timeRemaining: (NSDate*) base nValues:(int)nValues
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    double seconds_each = 0;
    switch ([self.freq_type intValue]) {
        case 0:
            seconds_each = [self.freq_value intValue] * 60 * 60;
            break;
        case 1:
            seconds_each = [self.freq_value intValue] * 60 * 60 * 24;
            break;
        case 2:
            seconds_each = [self.freq_value intValue] * 7 * 60 * 60 * 24;
            break;
        default:
            seconds_each = 10000000;
            break;
    }
    
    NSDate *ret = [base copy];
    NSDate *now = [NSDate date];
    
    int i = 0;
    while(nValues > 0 && i < MAX_ITER)
    {
        if([ret compare: now] != NSOrderedAscending)
        {
            [array addObject: ret];
            nValues--;
        }
        ret = [ret dateByAddingTimeInterval: seconds_each];
        i++;
    }
    
    return array;
}


-(NSDate*) timeRemaining
{
    return [self timeRemaining: self.next_time];
}

+(Pill*) firstTimeRemaining: (NSArray*) pills
{
    return Underscore.array(pills)
        .reduce(nil, ^(Pill *a, Pill *b) {
            NSDate *aa = [a timeRemaining];
            NSDate *bb = [b timeRemaining];
            return [aa compare:bb] == NSOrderedAscending? a: b;
    });
}

@end
