//
//  Beneficiarie.h
//  Beneficiaries
//
//  Created by Clinton Sexton on 6/17/24.
//
#import <UIKit/UIKit.h>


@interface Address : NSDictionary

@property (nonatomic, strong) NSString *firstLineMailing;
@property (nonatomic, strong) NSString *scndLineMailing;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *country;

@end

@interface Beneficiary : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *milddleName;

@property (nonatomic, strong) NSString *designationCode;
@property (nonatomic, strong) NSString *beneType;
@property (nonatomic, strong) NSString *phoenNumber;
@property (nonatomic, strong) NSString *socialSecurityNumber;
@property (nonatomic, strong) NSString *dateOfBirth;

@property (nonatomic, strong) Address *address;

+ (NSMutableArray*)jsonParser:(NSError **)jsonError inContainer:(NSMutableArray*)container;

@end


