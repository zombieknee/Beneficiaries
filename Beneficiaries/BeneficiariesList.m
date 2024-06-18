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
    self.beneficiaries = [Beneficiary jsonParser:&jsonError inContainer:self.beneficiaries];
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
