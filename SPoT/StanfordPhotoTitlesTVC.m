//
//  StanfordPhotoTitlesTVC.m
//  SPoT
//
//  Created by Alex Paul on 3/2/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "StanfordPhotoTitlesTVC.h"
#import "FlickrFetcher.h"

@interface StanfordPhotoTitlesTVC ()

@end

@implementation StanfordPhotoTitlesTVC

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return number of photos with this tag (titleForRow)    
    NSUInteger numberOfPhotos = 0;
    for (NSString *tag in [self allTagsArray]) {
        if ([self.titleForRow isEqualToString:tag]) {
            numberOfPhotos++;
        }
    }
    return numberOfPhotos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Stanford Photos %@", self.photos); 
    
    self.navigationItem.title = self.titleForRow;
}

- (NSString *)titleForRow:(NSUInteger)row
{
    return [self photoTitles][row]; 
}

- (NSMutableArray *)photoTitles
{
    NSMutableArray *photoTitles = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.photos) {
        NSString *tags = [dict valueForKey:@"tags"];
        NSRange range = [tags rangeOfString:[self.titleForRow lowercaseString]]; // titleForRow is Photo tag name
        if (range.location != NSNotFound) {
            NSLog(@"Photo title is %@", [dict valueForKey:@"title"]);
            //NSLog(@"Photo description is %@", [dict valueForKey:@"description"]);
            [photoTitles addObject:[dict valueForKey:@"title"]];
        }
    }
    return photoTitles;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"All Photos Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self titleForRow:indexPath.row]; 
    //cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];
    
    return cell;
}


@end
