//
//  ContactObject.h
//  SendHubTest
//
//  Created by Christopher Cassano on 4/16/13.
//  Copyright (c) 2013 ChrisVCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactObject : NSObject

@property (nonatomic) NSString *name, *number;
@property (nonatomic) int contactId;
@property (nonatomic) BOOL blocked;

@end
