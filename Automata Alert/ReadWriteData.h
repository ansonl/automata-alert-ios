//
//  NMReadWriteData.h
//  Next Meal
//
//  Created by Anson Liu on 5/29/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadWriteData : NSObject

+ (BOOL)doesFileExist:(NSString *)filename;

+ (NSData *)readFile:(NSString *)filename;

+ (BOOL)saveFile:(NSData *)data withFilename:(NSString *)filename;

@end
