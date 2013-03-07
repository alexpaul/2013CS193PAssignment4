//
//  RecentPhotosTVC.m
//  SPoT
//
//  Created by Alex Paul on 3/6/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "RecentPhotosTVC.h"
#import "RecentPhotos.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface RecentPhotosTVC ()

@end

@implementation RecentPhotosTVC

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:0];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"Show Image"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                    NSURL *url = [FlickrFetcher urlForPhoto:[self recentPhotosUsingPhotoId][indexPath.row] format:FlickrPhotoFormatLarge];
                    [segue.destinationViewController performSelector:@selector(setImageURL:) withObject:url];
                    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                        ImageViewController *imageVC = (ImageViewController *)segue.destinationViewController;
                        imageVC.photoId = [self recentPhotosUsingPhotoId][indexPath.row][FLICKR_PHOTO_ID];
                    }
                }
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self recentPhotosUsingPhotoId] count]; // recect photos count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Recent Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}


- (NSString *)titleForRow:(NSUInteger)row
{
    return [self recentPhotosUsingPhotoId][row][FLICKR_PHOTO_TITLE];
}


- (NSString *)subtitleForRow:(NSUInteger)row
{
    return [[[self recentPhotosUsingPhotoId][row] valueForKey:@"description"]valueForKey:@"_content"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.photos = [FlickrFetcher stanfordPhotos];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
            
    self.navigationItem.title = @"Recents";
        
    NSLog(@"There are %d recent photos", [[self recentPhotosUsingPhotoId] count]);
}

- (NSArray *)recentPhotosUsingPhotoId
{
    NSMutableArray *photoIds = [[NSMutableArray alloc] init];
    NSMutableArray *recentPhotosUsingPhotoId = [[NSMutableArray alloc] init];
    
    for(RecentPhotos *recents in [RecentPhotos recentPhotos]) {
        [photoIds addObject:recents.photoId]; 
    }
    
    for (NSString *photoId in photoIds) {
        for (NSDictionary *dict in self.photos) {
            if ([[dict objectForKey:@"id"] isEqualToString:photoId]) {
                [recentPhotosUsingPhotoId addObject:dict]; 
            }
        }
    }
    return recentPhotosUsingPhotoId; 
}

@end
