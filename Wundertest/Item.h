//
//  Item.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/29/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// This object is Managed by CoreData

@interface Item : NSManagedObject

@property (nonatomic, retain) NSDate * addDate;
@property (nonatomic, retain) NSDate * completeDate;
@property (nonatomic, retain) NSNumber * isCompleted;
@property (nonatomic, retain) NSNumber * isStarred;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * starDate;

@end
