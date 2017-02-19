

@interface UIViewController (Z)
@property(readonly, nonatomic) UITableView *tableView;
@property(readonly, nonatomic) UITableView *table;
@property(readonly, nonatomic) UISearchController *searchController;
-(void)blurSearchBar;
@end
@interface UIView (Z)
@property(nonatomic) UIColor *textColor;
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) UILabel *detailTextLabel;
-(void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force;
- (void)whiteTextForCell:(UITableViewCell *)cell withForceWhite:(BOOL)force;
@end

@interface UITableViewCell (Z)
-(long long)tableViewStyle;
-(UITableView *)_tableView;
- (UILabel *)titleLabel;
- (UILabel *)valueLabel;
@end




static void createBlurView(UIView *view, CGRect bound, int effect)  {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    visualEffectView.frame = bound;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
}

static BOOL nero10Enabled() {
	return YES;
	NSDictionary *list = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.martinpham.nero10.plist"];
	NSString *id = [[NSBundle mainBundle] bundleIdentifier];
	// NSLog(@">>>>> %@", list);

	if (list != nil && list[id] != nil && [list[id] boolValue] == YES) {
		return YES;
	}

	return NO;
}


%hook UIViewController


- (void)viewDidLoad {
    %orig;
	
	if (nero10Enabled()) {
		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/var/mobile/bg.jpg"]];
		iv.frame = [UIScreen mainScreen].bounds;

		createBlurView(iv, iv.frame, UIBlurEffectStyleDark);

		if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
			[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(table)]) {
			[self.table setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(tableView)]) {
			[self.tableView setBackgroundView:iv];
		}
		
		
		self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
		self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
		
		
		UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
		
		if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
			((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")).separatorEffect = vibrancyEffect;
			((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")).sectionIndexBackgroundColor = [UIColor clearColor];
			// [((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setSectionIndexColor:[UIColor clearColor]];
			[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}else if ([self respondsToSelector:@selector(table)]) {
			self.table.separatorEffect = vibrancyEffect;
			self.table.sectionIndexBackgroundColor = [UIColor clearColor];
			// [self.table setSectionIndexColor:[UIColor clearColor]];
			[self.table setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}else if ([self respondsToSelector:@selector(tableView)]) {
			self.tableView.separatorEffect = vibrancyEffect;
			self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
			// [self.tableView setSectionIndexColor:[UIColor clearColor]];
			[self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
		}
		

		
		
		if ([self respondsToSelector:@selector(meContactBanner)]) {
			id me = [self performSelector:@selector(meContactBanner)];
			UILabel *label = [me performSelector:@selector(footnoteLabel)];
			UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

			label.textColor = [UIColor whiteColor];
			label.alpha = 0.8;
			valueLabel.textColor = [UIColor whiteColor];
			valueLabel.alpha = 0.9;
		}
		
		self.view.backgroundColor = [UIColor clearColor];
	}


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

- (void)viewWillAppear:(bool)arg1 {
	%orig;

	if (nero10Enabled()) {
		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];

		}


		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

	}
}


- (void)viewDidAppear:(bool)arg1 {
	%orig;

	if (nero10Enabled()) {
		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];

		}

		
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
}



%end

%hook CNContactListViewController
- (id)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(id)arg2 {
	UITableViewCell *cell = %orig;
	if (nero10Enabled()) {
		[arg1 whiteTextForCell:cell withForceWhite:NO];
	}
	return cell;
}
%end

%hook UITableView
%new
- (void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force {

		if ([view respondsToSelector:@selector(textLabel)]) {
			if(view.textLabel.textColor == [UIColor blackColor] || force) { 
				if (view.textLabel.textColor != [UIColor whiteColor]) {
					view.textLabel.alpha = 0.8;
				}
				view.textLabel.textColor = [UIColor whiteColor];
				
			}
		}
		if ([view respondsToSelector:@selector(detailTextLabel)]) {
			if(view.detailTextLabel.textColor == [UIColor blackColor] || force) { 
				if (view.detailTextLabel.textColor != [UIColor whiteColor]) {
					view.detailTextLabel.alpha = 0.8;
				}
				view.detailTextLabel.textColor = [UIColor whiteColor];
			}
		}

	view.backgroundColor = [UIColor clearColor];
	for(UIView *v in [view subviews]) {
		v.backgroundColor = [UIColor clearColor];

		if ([v respondsToSelector:@selector(textColor)]) {
			if(v.textColor == [UIColor blackColor] || force) { 
				if (v.textColor != [UIColor whiteColor]) {
					v.alpha = 0.8;
				}
				v.textColor = [UIColor whiteColor];
			}
		}

		[self clearBackgroundForView:v withForceWhite:force];
	}
}
%new
- (void)whiteTextForCell:(UITableViewCell *)cell withForceWhite:(BOOL)force {
	UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
		[cell _tableView].separatorEffect = vibrancyEffect;
		
		cell.backgroundColor = [UIColor clearColor];
		cell.textLabel.textColor = [UIColor whiteColor];

		if ([cell respondsToSelector:@selector(titleLabel)]) {
			// if(cell.titleTextLabel.textColor == [UIColor blackColor]e) { 
				// if (view.textLabel.textColor != [UIColor whiteColor]) {
					// view.textLabel.alpha = 0.8;
				// }
				cell.titleLabel.textColor = [UIColor whiteColor];
				
			// }
		}

		UIView *selectionColor = [[UIView alloc] init];
		selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
		cell.selectedBackgroundView = selectionColor;

		[self clearBackgroundForView:cell withForceWhite:force];
		[self clearBackgroundForView:cell.contentView withForceWhite:force];

		if (cell.tableViewStyle == UITableViewStyleGrouped) {
			if ([cell viewWithTag:181188] == nil) {
				UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
				whiteView.tag = 181188;
				whiteView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.09];

				[cell addSubview:whiteView];
				[cell sendSubviewToBack:whiteView];
			}
		}
}

// -(UIColor *)sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }

// -(id)_sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }

-(BOOL)_shouldSetIndexBackgroundColorToTableBackgroundColor {
	return YES;
}
-(UIColor *)sectionIndexTrackingBackgroundColor {
	return [UIColor clearColor];
}
// -(UIColor *)sectionIndexColor {
// 	return [UIColor clearColor];
// }
-(UIColor *)sectionIndexBackgroundColor {
	return [UIColor clearColor];
}

- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 {
	UITableViewCell *cell = %orig;

	if (nero10Enabled()) {
		[self whiteTextForCell:cell withForceWhite:NO];

	}
	return cell;
}

-(id)cellForRowAtIndexPath:(id)arg1 {
	UITableViewCell *cell = %orig;


	if (nero10Enabled()) {
		[self whiteTextForCell:cell withForceWhite:NO];

	}
	return cell;	
}
-(id)dequeueReusableCellWithIdentifier:(id)arg1 {
	UITableViewCell *cell = %orig;


	if (nero10Enabled()) {
		[self whiteTextForCell:cell withForceWhite:NO];

	}
	return cell;	
}
-(id)_createPreparedCellForRowAtIndexPath:(id)arg1 willDisplay:(BOOL)arg2  {
		UITableViewCell *cell = %orig;


	if (nero10Enabled()) {
		[self whiteTextForCell:cell withForceWhite:NO];

	}
	return cell;
}
- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 willDisplay:(bool)arg3 {
	UITableViewCell *cell = %orig;


	if (nero10Enabled()) {

		[self whiteTextForCell:cell withForceWhite:NO];
	}

	return cell;
}
-(void)_configureCellForDisplay:(UITableViewCell*)cell forIndexPath:(id)arg2 {

	%orig;
	


	if (nero10Enabled()) {

		[self whiteTextForCell:cell withForceWhite:NO];
	}

}
-(id)_sectionHeaderView:(BOOL)arg1 withFrame:(CGRect)arg2 forSection:(long long)arg3 floating:(BOOL)arg4 reuseViewIfPossible:(BOOL)arg5 willDisplay:(BOOL)arg6 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		[self clearBackgroundForView:view withForceWhite:YES];

		if ([view respondsToSelector:@selector(contentView)]) {
			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
		}
	}
	return view;
}

-(id)_sectionFooterViewWithFrame:(CGRect)arg1 forSection:(long long)arg2 floating:(BOOL)arg3 reuseViewIfPossible:(BOOL)arg4 willDisplay:(BOOL)arg5 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		[self clearBackgroundForView:view withForceWhite:YES];

		if ([view respondsToSelector:@selector(contentView)]) {
			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
		}
	}
	return view;
}

// -(void)setTableHeaderView:(UIView *)view {
// 	// NSLog(@"333");
// 	if (nero10Enabled()) {	
// 		[self clearBackgroundForView:view withForceWhite:YES];

// 		if ([view respondsToSelector:@selector(contentView)]) {
// 			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
// 		}
// 	}
// 	%orig(view);
// }
// -(void)setTableFooterView:(UIView *)view {
// 	// NSLog(@"444");
// 	if (nero10Enabled()) {	
// 		[self clearBackgroundForView:view withForceWhite:YES];

// 		if ([view respondsToSelector:@selector(contentView)]) {
// 			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
// 		}
// 	}
// 	%orig(view);
// }
%end


%hook SpringBoard
- (void)applicationDidFinishLaunching: (id) application {
    %orig;

	UIImage *i = [[[%c(SBWallpaperController) performSelector:@selector(sharedInstance)] performSelector:@selector(_activeWallpaperView)] performSelector:@selector(_displayedImage)];
	
	[UIImageJPEGRepresentation(i, 1) writeToFile:@"/var/mobile/bg.jpg" atomically:YES];
}
%end