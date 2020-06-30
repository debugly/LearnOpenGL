//
//  MRTableViewController.m
//  GLKitTutorial_Example
//
//  Created by Matt Reach on 2020/6/30.
//  Copyright © 2020 summerhanada@163.com. All rights reserved.
//

#import "MRTableViewController.h"
#import <GLKitTutorial/ViewController0x01.h>
#import <GLKitTutorial/ViewController0x02.h>
#import <GLKitTutorial/ViewController0x03.h>
#import <GLKitTutorial/ViewController0x04.h>

@interface MRTableViewController ()

@end

@implementation MRTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GLKitTutorial";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSBundle *fmwkBundle = [NSBundle bundleForClass:[ViewController0x01 class]];
    NSString *xibBundlePath = [fmwkBundle pathForResource:@"GLKitTutorial" ofType:@"bundle"];
    NSBundle *xibBundle = [NSBundle bundleWithPath:xibBundlePath];
    
    NSInteger row = indexPath.row;
    if (row == 0) {
        ViewController0x01 *vc0x01 = [[ViewController0x01 alloc] initWithNibName:@"ViewController0x01" bundle:xibBundle];
        [self.navigationController pushViewController:vc0x01 animated:YES];
    } else if (row == 1) {
       ViewController0x02 *vc0x02 = [[ViewController0x02 alloc] init];
       [self.navigationController pushViewController:vc0x02 animated:YES];
    } else if (row == 2) {
       ViewController0x03 *vc0x03 = [[ViewController0x03 alloc] init];
       [self.navigationController pushViewController:vc0x03 animated:YES];
    } else if (row == 3) {
      ViewController0x04 *vc0x04 = [[ViewController0x04 alloc] init];
      [self.navigationController pushViewController:vc0x04 animated:YES];
   }
}

@end
