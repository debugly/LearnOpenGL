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
#import <GLKitTutorial/ViewController0x05.h>
#import <GLKitTutorial/ViewController0x06.h>
#import <GLKitTutorial/ViewController0x07.h>
#import <GLKitTutorial/ViewController0x08.h>
#import <GLKitTutorial/ViewController0x09.h>
#import <GLKitTutorial/ViewController0x0a.h>

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
        [self.navigationController pushViewController:[[ViewController0x02 alloc] init] animated:YES];
    } else if (row == 2) {
        [self.navigationController pushViewController:[[ViewController0x03 alloc] init] animated:YES];
    } else if (row == 3) {
        [self.navigationController pushViewController:[[ViewController0x04 alloc] init] animated:YES];
    } else if (row == 4) {
        [self.navigationController pushViewController:[[ViewController0x05 alloc] init] animated:YES];
    } else if (row == 5) {
        [self.navigationController pushViewController:[[ViewController0x06 alloc] init] animated:YES];
    } else if (row == 6) {
        [self.navigationController pushViewController:[[ViewController0x07 alloc] init] animated:YES];
    } else if (row == 7) {
        [self.navigationController pushViewController:[[ViewController0x08 alloc] init] animated:YES];
    } else if (row == 8) {
        [self.navigationController pushViewController:[[ViewController0x09 alloc] init] animated:YES];
    } else if (row == 9) {
        [self.navigationController pushViewController:[[ViewController0x0a alloc] init] animated:YES];
    }
}

@end

