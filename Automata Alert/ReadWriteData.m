//
//  NMReadWriteData.m
//  Next Meal
//
//  Created by Anson Liu on 5/29/14.
//  Copyright (c) 2014 Apparent Etch. All rights reserved.
//

#import "ReadWriteData.h"

@implementation ReadWriteData

+ (BOOL)doesFileExist:(NSString *)filename
{
    if (!filename) {
        NSLog(@"no filename provided");
        filename = @"menulist";
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filepath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:filename];
    
    //NSLog(@"filepath is %@", filepath);
    
    BOOL fileExists = [fileManager fileExistsAtPath:filepath];
    
    return fileExists;
}

+ (NSData *)readFile:(NSString *)filename
{
    if (!filename) {
        NSLog(@"no filename provided");
        filename = @"tmp";
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filepath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:filename];
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:filepath];
    
    return data;
}

+ (BOOL)saveFile:(NSData *)data withFilename:(NSString *)filename
{
    if (!filename) {
        NSLog(@"no filename provided");
        filename = @"tmp";
    }
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *filepath = [[documentsPath stringByAppendingString:@"/"] stringByAppendingString:filename];
    
    BOOL writeSuccess = [data writeToFile:filepath atomically:YES];
    
    return writeSuccess;
}

@end
