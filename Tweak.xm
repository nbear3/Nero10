@interface UIViewController (Z)
@property(readonly, nonatomic) UITableView *tableView;
@property(readonly, nonatomic) UITableView *table;
@property(readonly, nonatomic) UISearchController *searchController;
-(void)blurSearchBar;
@end
@interface UIView (Z)
@property(nonatomic) UIColor *textColor;
-(void)clearBackgroundForView:(UIView *)view;
@end



static void createBlurView(UIView *view, CGRect bound, int effect)  {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    visualEffectView.frame = bound;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
}


%hook UIViewController


- (void)viewDidLoad {
    %orig;
	

	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/var/mobile/bg.jpg"]];
    iv.frame = [UIScreen mainScreen].bounds;

	createBlurView(iv, iv.frame, UIBlurEffectStyleDark);

	if ([self respondsToSelector:@selector(table)]) {
		[self.table setBackgroundView:iv];
	}else if ([self respondsToSelector:@selector(tableView)]) {
		[self.tableView setBackgroundView:iv];
	}
	
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    
    
    UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    
	if ([self respondsToSelector:@selector(table)]) {
		self.table.separatorEffect = vibrancyEffect;
	}else if ([self respondsToSelector:@selector(tableView)]) {
		self.tableView.separatorEffect = vibrancyEffect;
	}
    
    
    
    self.view.backgroundColor = [UIColor clearColor];

}

%new
- (void)blurSearchBar {
	if (self.searchController.searchBar.tag != 181188) {
		self.searchController.searchBar.tag = 181188;
		self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
		self.searchController.searchBar.backgroundColor = [UIColor clearColor];
		
		
		self.searchController.searchBar.subviews[0].subviews[0].alpha = 0;
		
		createBlurView(self.searchController.searchBar, self.searchController.searchBar.bounds, UIBlurEffectStyleDark);
	}
}

- (void)viewDidAppear:(bool)arg1 {
	%orig;

	if ([self respondsToSelector:@selector(searchController)]) {
		[self blurSearchBar];

		[NSTimer scheduledTimerWithTimeInterval:0.3f
                                    repeats:NO
                                      block:^(NSTimer * _Nonnull timer) {
			[self blurSearchBar];
    	}];

	}


	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

%end



%hook UITableView
%new
- (void)clearBackgroundForView:(UIView *)view {
	view.backgroundColor = [UIColor clearColor];
	for(UIView *v in [view subviews]) {
		v.backgroundColor = [UIColor clearColor];

		if ([v respondsToSelector:@selector(textColor)]) {
			v.textColor = [UIColor whiteColor];
		}
	}
}

- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 {
	UITableViewCell *cell = %orig;
// cell.textLabel.text = @"Doh";

	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];

	UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
    cell.selectedBackgroundView = selectionColor;

	[self clearBackgroundForView:cell.contentView];

	return cell;
}

- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 willDisplay:(bool)arg3 {
	UITableViewCell *cell = %orig;
// cell.textLabel.text = @"Doh";

	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.textColor = [UIColor whiteColor];

	UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
    cell.selectedBackgroundView = selectionColor;


	[self clearBackgroundForView:cell.contentView];

	return cell;
}


%end


%hook SpringBoard
- (void)applicationDidFinishLaunching: (id) application {
    %orig;

	UIImage *i = [[[%c(SBWallpaperController) performSelector:@selector(sharedInstance)] performSelector:@selector(_activeWallpaperView)] performSelector:@selector(_displayedImage)];
	
	[UIImageJPEGRepresentation(i, 1) writeToFile:@"/var/mobile/bg.jpg" atomically:YES];
}
%end