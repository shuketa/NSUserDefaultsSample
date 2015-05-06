

#import "TableViewController.h"
#import "ContentItem.h"

NSString *const kAlreadyReadListKey = @"AlreadyReadList";

@interface TableViewController ()
@property (nonatomic, strong) NSMutableArray *alreadyReadList;
@property (nonatomic, strong) NSMutableArray *contents;
@end


@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createStubDate];
    
    [self setupAlreadyReadItemsIfNeed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        
        [self apiRequestResponseDummy];
        [self.tableView reloadData];
    });
}

- (void)createStubDate
{
    NSMutableArray *dummyItem = [NSMutableArray array];
    
    for (int i = 0; i < 100; i++) {
        if ((i % 3) == 0) {
            [dummyItem addObject:[NSString stringWithFormat:@"ID%d",i]];
        }
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:dummyItem forKey:kAlreadyReadListKey];
    if ([userDefaults synchronize] == NO) {
        NSLog(@"cannot save to NSUserDefaults");
    }
}

- (void)apiRequestResponseDummy
{
    [self setupAlreadyReadItemsIfNeed];
    
    self.contents = [NSMutableArray array];
    
    for (int i = 0; i < 100; i++) {
        ContentItem *item = [[ContentItem alloc] init];
        
        item.contentTitle = [NSString stringWithFormat:@"titleIS%d", i];
        item.contentId = [NSString stringWithFormat:@"ID%d",i];
        if ([self isAlreadyReadItem:item.contentId]) {
            item.isAlreadyRead = YES;
        } else {
            item.isAlreadyRead = NO;
        }
        [self.contents addObject:item];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSLog(@"numberOfSectionsInTableView");
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSLog(@"numberOfSectionsInTableView");
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    ContentItem *item = self.contents[indexPath.section];
    
    cell.textLabel.text = item.contentTitle;
    
    if (item.isAlreadyRead) {
        cell.backgroundColor = [UIColor darkGrayColor];
    } else {
        cell.backgroundColor = [UIColor redColor];
    }
    
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ContentItem *item = self.contents[indexPath.section];

    [self addAlreadyReadItemIfNeed:item.contentId];
    
}


#pragma mark - Already Read Item

- (void)setupAlreadyReadItemsIfNeed
{
    NSLog(@"loadAlreadyReadItems(S)");
    
    if (self.alreadyReadList) {
        NSLog(@"already loaded");
        return;
    }
    
    self.alreadyReadList = [NSMutableArray array];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *list = [userDefaults arrayForKey:kAlreadyReadListKey];
    if (list) {
        [self.alreadyReadList removeAllObjects];
        [self.alreadyReadList addObjectsFromArray:list];
    }
}

- (BOOL)isAlreadyReadItem:(NSString*)item
{
    NSLog(@"isAlreadyReadItem(S)");
    
    if (!self.alreadyReadList || ([self.alreadyReadList count] <= 0)) {
        NSLog(@"not exist shoud save data");
        return false;
    }
    
    for (NSString *local in self.alreadyReadList) {
        if ([local isEqualToString:item]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)addAlreadyReadItemIfNeed:(NSString*)item
{
    NSLog(@"addAlreadyReadItemIfNeed(S)");
    
    if ([self isAlreadyReadItem:item]) {
        return;
    }
    
    [self.alreadyReadList addObject:item];
    
    [self saveAlreadyReadItem];
}

- (void)saveAlreadyReadItem
{
    NSLog(@"saveAlreadyReadItem(S)");
    
    if (!self.alreadyReadList || ([self.alreadyReadList count] <= 0)) {
        NSLog(@"not exist shoud save data");
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.alreadyReadList forKey:kAlreadyReadListKey];
    if ([userDefaults synchronize] == NO) {
        NSLog(@"cannot save to NSUserDefaults");
    }
}

@end
