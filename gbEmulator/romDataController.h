//
//  romDataController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "rom.h"

@interface romDataController : NSObject

@property (strong, nonatomic) NSMutableArray * roms;

- (NSInteger) numberOfRoms;
- (rom *) objectInRomsAtIndex:(NSUInteger)index;
- (void) addRomsObject:(rom *)romToAdd;

@end
