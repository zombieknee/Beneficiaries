//
//  ViewController.h
//  Beneficiaries
//
//  Created by Clinton Sexton on 6/16/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *beneficiaries;
    NSArray *tmp;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *beneficiaries;

@end

