//
//  AppDelegate.h
//  Beneficiaries
//
//  Created by Clinton Sexton on 6/16/24.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;

}

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

