//
//  EventViewController.m
//  TaskTag
//
//  Created by Min Xing on 9/30/14.
//  Copyright (c) 2014 MakeSchool. All rights reserved.
//

#import "EventViewController.h"
#import "TaskViewController.h"
#import "Event.h"
#import "AppDelegate.h"


@interface EventViewController ()

@property (weak, nonatomic) IBOutlet UITableView *eventTableView;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.events = [NSMutableArray array];
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Get access to the managed object context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Create a new object using the entity description.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Create an error variable to pass to the execute method.
    NSError *error;
    // Retrieve results.
    NSArray *array = [context executeFetchRequest:request error:&error];
    if (array == nil) {
        // Error handling, e.g. display error to user.
    }
    self.events = [array mutableCopy];
    [self.eventTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    // Configure the cell...
    cell.textLabel.text = [self.events[indexPath.row] title];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewEvent"]) {
        // Get access to the managed object context.
        NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
        // Create a new object using the entity description.
        Event *newEvent = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
        TaskViewController *eventTaskViewController = [segue destinationViewController];
        eventTaskViewController.event = newEvent;
        [self.events addObject:newEvent];
    } else if ([segue.identifier isEqualToString:@"ExistingEvent"]) {
        TaskViewController *eventTaskViewController = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = self.eventTableView.indexPathForSelectedRow;
        eventTaskViewController.event =self.events[selectedIndexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Get the context.
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    // Get and delete object
    Event *event = [self.events objectAtIndex:indexPath.row];
    [context deleteObject:event];
    // Create an error variable to pass to the save method.
    NSError *error = nil;
    // Attempt to save the context and persist our changes.
    [context save:&error];
    if (error) {
        //Error
    }
    
    // Delete entry in the array.
    [self.events removeObjectAtIndex:indexPath.row];
    // Delete entry in the UI.
    [self.eventTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Server Communication

//TODO: Server

//- (void)sendEventToServer:(NSDictionary*)dictionary {
//    NSURL *url = [NSURL URLWithString:@"http://polar-refuge-5597.herokuapp.com/"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [request setHTTPMethod:@"POST"];
//    
//    // Convert dictionary to NSData.
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
//    
//    [request setHTTPBody:jsonData];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *urlSession = [NSURLSession
//                                sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    
//    NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        if (responseStatusCode == 200 && data) {
//            NSArray *downloadedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//            [self addToArrayJSONDictionary:downloadedJSON];
//        } else {
//            // error handling
//        }
//    }];
//    
//    [dataTask resume];
//}
//
//- (void)addToArrayJSONDictionary:(NSArray *)msgArray {
//    for (NSDictionary *jsonMsg in msgArray) {
////        Event *event = [Event eventWithJSONDictionary:jsonMsg];
//        [self.events addObject:event];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.eventTableView reloadData];
//        });
//    }
//}


@end
