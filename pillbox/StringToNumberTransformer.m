//
//  StringToNumberTransformer.m
//  pillbox
//
//  Created by Jordi Coscolla on 20/04/13.
//  Copyright (c) 2013 Jordi Coscolla. All rights reserved.
//

#import "StringToNumberTransformer.h"

@implementation StringToNumberTransformer

+ (id)instance {
	return [[[self class] alloc] init] ;
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSNumber class];
}

- (NSNumber *)transformedValue:(NSString *)value {
	return [NSNumber numberWithInteger:[value integerValue]];
}

- (NSString *)reverseTransformedValue:(NSNumber *)value {
	return [value stringValue];
}

@end