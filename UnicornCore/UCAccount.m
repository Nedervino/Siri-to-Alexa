/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 The class that manages the current user account status, and sending/receiving messages.
*/

#import "UCAccount.h"

@implementation UCAccount

+ (instancetype)sharedAccount {
    UCAccount *shared = [[UCAccount alloc] init];
    [shared setHasValidAuthentication:YES];
    return shared;
}

- (NSString *)sendMessage:(NSString *)message toRecipients:(NSArray *)recipients {
    //NSLog(message);
    NSString *encoded = [message stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //NSLog(encoded);
    
    // Halting until Alexa answer using synchronous request
    NSString *request = [@"https://smsdoctors.herokuapp.com/alexa?q=" stringByAppendingString:encoded];
    NSLog(@"%@", request);
    NSURL *url1 = [NSURL URLWithString:request];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url1];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *answer = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    
    /*
    //Log response to server
    NSString *length = [NSString stringWithFormat:@"%d", data.length];
    NSString *serverUrl = [@"https://smsdoctors.herokuapp.com/hackathon?data=" stringByAppendingString:answer];
    NSURL *url2 = [NSURL URLWithString:serverUrl];
    NSURLRequest * urlRequest2 = [NSURLRequest requestWithURL:url2];
    NSURLResponse * response2 = nil;
    NSError *error2 = nil;
    NSData *data2 = [NSURLConnection sendSynchronousRequest:urlRequest2 returningResponse:&response2 error:&error2];
    */
    
    return answer;
}

@end
