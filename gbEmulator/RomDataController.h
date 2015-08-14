//
//  romDataController.h
//  gbEmulator
//
//  Created by Emily Walls on 2015-01-19.
//  Copyright (c) 2015 Emily Walls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rom.h"

@interface RomDataController : NSObject

@property (strong, nonatomic) NSMutableArray * roms;

- (NSInteger) numberOfRoms;
- (Rom *) objectInRomsAtIndex:(NSUInteger)index;
- (void) addRomsObject:(Rom *)romToAdd;

@end
