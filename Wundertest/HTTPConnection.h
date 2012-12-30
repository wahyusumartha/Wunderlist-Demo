//
//  HTTPConnection.h
//  Wundertest
//
//  Created by Sergo Beruashvili on 12/30/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
    This is not an actual class , i writed down few methods , which will be necessary
 
 */


// We could have HTTPConnectionDelegate for callback methods




@interface HTTPConnection : NSObject

/*
 
 We need several methods ,  all HTTP connection should performed in BACKGROUND THREAD , otherwise our view will be blocked
 
 1 login method , user will authenticate , and we will store its settings in Core-Data or NSUserDefaults
 
 2 getItems method , after user logins or after application launch and we have user looged in , we want to check if an user has created new items from another device , then fetch it and insert it in Core-Data , after this our NSFetchedResultsController will update its content and user will have his/her Items in tableview
 
 3 after user creates/updates/deletes items , we want to sync it with our database , so he/she will be able to see it on another devices, we will send data to our server
 
 4 it would be good if all the Item could have its unique identifier across all the devices and if user marks Item as completed/starred on PC after syncing data he/she gets completed/starred item in iPhone/iPad too
 
 5 we could use Push notifications  , we  will ask for permissions then send device id to our database
 
 */

@end
