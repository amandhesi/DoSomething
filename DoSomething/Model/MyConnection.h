//
//  MyConnection.h
//  DoSomething
//
//  Created by Aman Dhesi on 7/30/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
    NSURLConnection * internalConnection;
    NSMutableData * container;
}

-(id)initWithRequest:(NSURLRequest *)req;

@property (nonatomic,copy)NSURLConnection * internalConnection;
@property (nonatomic,copy)NSURLRequest *request;
@property (nonatomic,copy)void (^completionBlock) (NSData *data, NSError * err);


-(void)start;

@end
