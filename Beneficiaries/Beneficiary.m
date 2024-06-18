//
//  Beneficiary.m
//  Beneficiaries
//
//  Created by Clinton Sexton on 6/18/24.
//

#import "Beneficiary.h"

@implementation Beneficiary

+ (NSMutableArray*)jsonParser:(NSError **)jsonError inContainer:(NSMutableArray*)container {
    NSString *jsonPath =  [[NSBundle mainBundle] pathForResource:@"Beneficiaries" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:jsonError];
    
    for (int i = 0; i <[jsonArray count]; i++) {
        Beneficiary *newBeneficiary = [[Beneficiary alloc] init];
        NSDictionary *jsonDict = [jsonArray objectAtIndex:i];
        newBeneficiary.firstName = [jsonDict objectForKey:@"firstName"];
        newBeneficiary.lastName = [jsonDict objectForKey:@"lastName"];
        newBeneficiary.beneType = [jsonDict objectForKey:@"beneType"];
        if ([[jsonDict objectForKey:@"designationCode"]  isEqual: @"C"]) {
            newBeneficiary.designationCode = @"Contigent";
        } else if ([[jsonDict objectForKey:@"designationCode"] isEqual: @"P"]) {
            newBeneficiary.designationCode = @"Primary";
        }
        newBeneficiary.socialSecurityNumber = [jsonDict objectForKey:@"socialSecurityNumber"];
        newBeneficiary.dateOfBirth = [jsonDict objectForKey:@"dateOfBirth"];
        newBeneficiary.phoenNumber = [jsonDict objectForKey:@"phoneNumber"];
        newBeneficiary.address = [jsonDict objectForKey:@"beneficiaryAddress"];
        [container addObject:newBeneficiary];
    }
    
    return container;
}


@end
