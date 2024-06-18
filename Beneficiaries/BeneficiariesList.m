//
//  ViewController.m
//  Beneficiaries
//
//  Created by Clinton Sexton on 6/16/24.
//

#import "BeneficiariesList.h"
#import "Beneficiary.h"
@interface ViewController ()

@end

@implementation ViewController

@synthesize beneficiaries;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSError *jsonError = nil;
    self.beneficiaries = [[NSMutableArray alloc] init];
    
    // need to make this in to a class
    [self jsonParser:&jsonError];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Beneficiary *beneficiary = self.beneficiaries[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", beneficiary.firstName, beneficiary.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Benefit Type: %@ Designation Code: %@", beneficiary.beneType, beneficiary.designationCode];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.beneficiaries.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Beneficiary *beneficiary = self.beneficiaries[indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ %@ (%@)",beneficiary.firstName, beneficiary.lastName, beneficiary.designationCode];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert setValue:[self formatAddress:beneficiary] forKey:@"attributedMessage"];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Helper Functions 

- (void)jsonParser:(NSError **)jsonError {
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
        [self.beneficiaries addObject:newBeneficiary];
    }
}

- (NSString*)DOBFormatter:(Beneficiary *)beneficiary {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMddyyyy"];
    
    NSDate *dob = [formatter dateFromString:beneficiary.dateOfBirth];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    return [formatter stringFromDate:dob];
}

- (NSMutableAttributedString *)formatAddress:(Beneficiary *)benficiary {
    
    NSString *addressString = [NSString stringWithFormat:@"%@\n\t\t\t\t%@\n\t\t\t\t%@\n\t\t\t\t%@\n\t\t\t\t",
                               benficiary.address[@"firstLineMailing"],
                               benficiary.address[@"city"],
                               benficiary.address[@"zipCode"],
                               benficiary.address[@"stateCode"]];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSMutableAttributedString *attributedAddressString = [[NSMutableAttributedString alloc] initWithString:
                                       [NSString stringWithFormat:@"SSN \t\t\t\t %@\nDOB \t\t\t %@\nPhone \t\t\t %@\n\nAddress \t\t\t %@",
                                        benficiary.socialSecurityNumber,
                                        [self DOBFormatter:benficiary],
                                        benficiary.phoenNumber,
                                        addressString]];
    
    [attributedAddressString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedAddressString length])];
    [attributedAddressString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, [attributedAddressString length])];
    return attributedAddressString;
}

@end
