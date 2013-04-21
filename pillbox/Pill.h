//
//  Pill.h
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Pill : NSManagedObject

@property (nonatomic, retain) NSNumber * freq_type;
@property (nonatomic, retain) NSNumber * freq_value;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * next_time;

-(NSDate*) timeRemaining;
-(NSArray*) timeRemaining: (NSDate*) base nValues:(int)nValues;
+(Pill*) firstTimeRemaining: (NSArray*) pills;
@end
