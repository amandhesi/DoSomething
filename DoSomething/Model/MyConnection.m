//
//  MyConnection.m
//  DoSomething
//
//  Created by Aman Dhesi on 7/30/14.
//  Copyright (c) 2014 Aman Dhesi. All rights reserved.
//

#import "MyConnection.h"

static NSMutableArray *sharedConnectionList = nil;

@implementation MyConnection
@synthesize request,completionBlock,internalConnection;

-(id)initWithRequest:(NSURLRequest *)req {
    self = [super init];
    if (self) {
        [self setRequest:req];
    }
    return self;
}

-(void)start {
    
    container = [[NSMutableData alloc]init];
    
    internalConnection = [[NSURLConnection alloc]initWithRequest:[self request] delegate:self startImmediately:YES];
    
    if(!sharedConnectionList)
        sharedConnectionList = [[NSMutableArray alloc] init];
    [sharedConnectionList addObject:self];
    
}


#pragma mark NSURLConnectionDelegate methods

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [container appendData:data];
    
}

//If finish, return the data and the error nil
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if([self completionBlock])
        [self completionBlock](container,nil);
    
    [sharedConnectionList removeObject:self];
    
}

//If fail, return nil and an error
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    if([self completionBlock])
        [self completionBlock](nil,error);
    
    [sharedConnectionList removeObject:self];
    
}

@end