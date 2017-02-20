

@interface UIViewController (Z)
@property(readonly, nonatomic) UITableView *tableView;
@property(readonly, nonatomic) UITableView *collectionView;
@property(readonly, nonatomic) UITableView *table;
@property(readonly, nonatomic) UISearchController *searchController;
-(void)blurSearchBar;
-(void)fixMyNumber;
-(void)quickFix;
@property (assign) BOOL editMode;
@end

@interface UIApplication (Z)
- (void)_setBackgroundStyle:(long long)style;
@end

@interface UIView (Z)
@property(nonatomic) UIColor *textColor;
@property(nonatomic) UILabel *textLabel;
@property(nonatomic) UILabel *nameLabel;
@property(nonatomic) UILabel *detailTextLabel;
-(void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force;
- (void)whiteTextForCell:(id)cell withForceWhite:(BOOL)force;
@end

@interface UITableViewCell (Z)
-(long long)tableViewStyle;
-(UITableView *)_tableView;
- (UILabel *)titleLabel;
- (UILabel *)valueLabel;
@end
@interface CNContactContentViewController
@property (assign) BOOL editMode;
@property(readonly, nonatomic) UITableView *tableView;
@end




static void createBlurView(UIView *view, CGRect bound, int effect)  {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    visualEffectView.frame = bound;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
}

static BOOL nero10Enabled() {
	// return YES;
	NSDictionary *list = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.martinpham.nero10.plist"];
	NSString *id = [[NSBundle mainBundle] bundleIdentifier];
	// NSLog(@">>>>> %@", list);

	if (list != nil && list[id] != nil && [list[id] boolValue] == YES) {
		return YES;
	}

	return NO;
}

%hook CNContactContentViewController
%property (assign) BOOL editMode;
- (void)didChangeToEditMode:(bool)arg1 {
	// NSLog(@">>> didChangeToEditMode >>> %@", arg1 ? @"Y" : @"N");
	self.editMode = arg1;
	self.tableView.tag = arg1 ? 30052014 : 0;
	[self.tableView reloadData];

	%orig;
}
%end;

%hook UIViewController
%new
- (void)fixMyNumber {
	// NSLog(@">>> fixMyNumber >>> %@", self);


		if ([self respondsToSelector:@selector(meContactBanner)]) {
			id me = [self performSelector:@selector(meContactBanner)];
			if ([me respondsToSelector:@selector(footnoteLabel)]) {
				UILabel *label = [me performSelector:@selector(footnoteLabel)];


				label.textColor = [UIColor whiteColor];
				label.alpha = 0.6;
			}

			if ([me respondsToSelector:@selector(footnoteValueLabel)]) {
				UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

				valueLabel.textColor = [UIColor whiteColor];
				valueLabel.alpha = 0.8;
			}
		}
}
%new
- (void)quickFix {
	// NSLog(@">>> quickFix >>> %@", self);

		// if ([self respondsToSelector:@selector(meContactBanner)]) {
		// 	id me = [self performSelector:@selector(meContactBanner)];
		// 	UILabel *label = [me performSelector:@selector(footnoteLabel)];
		// 	UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

		// 	label.textColor = [UIColor whiteColor];
		// 	label.alpha = 0.8;
		// 	valueLabel.textColor = [UIColor whiteColor];
		// 	valueLabel.alpha = 0.9;
		// }

		if ([self respondsToSelector:@selector(contactHeaderView)]) {
			UIView *header = [self performSelector:@selector(contactHeaderView)];
			if (header.tag != 181188) {
				header.tag = 181188;
				header.backgroundColor = [UIColor clearColor];
				// NSLog(@">>> quickFix >>> %@", header.nameLabel);
				// header.nameLabel.textColor = [UIColor whiteColor];
				createBlurView(header, header.bounds, UIBlurEffectStyleExtraLight);
				
				// header.nameLabel.textColor = [UIColor whiteColor];
			}
			

		}

		if ([self respondsToSelector:@selector(actionsWrapperView)]) {	
			UIView *action = [self performSelector:@selector(actionsWrapperView)];
			if (action.tag != 181188) {
				action.tag = 181188;
				action.backgroundColor = [UIColor clearColor];
				createBlurView(action, action.bounds, UIBlurEffectStyleExtraLight);
			}
		}	
}


- (void)viewDidLoad {
    %orig;

	// NSLog(@">>> viewDidLoad >>> %@", self);
	
	if (nero10Enabled()) {
		// temporary disable
		// if (

		// 	// [[[self class] description] isEqualToString:(@"CNContactContentViewController")]
		// 	// || [[[self class] description] isEqualToString:(@"CNContactViewController")]
		// 	// || [[[self class] description] isEqualToString:(@"CNContactInlineActionsViewController")]
		// 	) {
		// 		return;
		// }
		

		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				return;
			}
		}

		[[UIApplication sharedApplication] _setBackgroundStyle:4];


		UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"/var/mobile/bg.jpg"]];
		iv.frame = [UIScreen mainScreen].bounds;


		// for(UIWindow *window in [UIApplication sharedApplication].windows) {
				// [window addSubview:iv];
				// [window sendSubviewToBack:iv];
			// window.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"/var/mobile/bg.jpg"]];
		// }




		createBlurView(iv, iv.frame, UIBlurEffectStyleDark);

		if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
			[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(table)]) {
			[self.table setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(tableView)]) {
			[self.tableView setBackgroundView:iv];
		}else if ([self respondsToSelector:@selector(collectionView)]) {
			[self.collectionView setBackgroundView:iv];
		}else {
			// self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"/var/mobile/bg.jpg"]];
			// [self.view addSubview:iv];
			// [self.view sendSubviewToBack:iv];

			// NSLog(@">>> viewDidLoad >>> %@ %@", self, self.view);


			for(UITableView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UITableView class]]) {
					[v setBackgroundView:iv];
				}
			}

			for(UICollectionView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UICollectionView class]]) {
					// [v setBackgroundView:iv];
					v.backgroundColor = [UIColor clearColor];
				}
			}

			if([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.calculator"]) {
				[self.view addSubview:iv];
				[self.view sendSubviewToBack:iv];
			}


		}
		
		@try {
			self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
			self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
		}
		@catch(NSException *e){}
		
		
		@try {
			if([[UIApplication sharedApplication].windows count] == 1)
			{
				UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
				[window addSubview:iv];
				[window sendSubviewToBack:iv];
			}
		}
		@catch(NSException *e){}

		
		
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
		}else{

			for(UITableView *v in [self.view subviews]) {
				if ([v isKindOfClass:[UITableView class]]) {
					v.separatorEffect = vibrancyEffect;
					v.sectionIndexBackgroundColor = [UIColor clearColor];
					// [v setSectionIndexColor:[UIColor clearColor]];
					[v setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
				}
			}
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

	// NSLog(@">>> viewWillAppear >>> %@", self);

	if (nero10Enabled()) {
		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				return;
			}
		}

		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];
			

		}
		if ([ [[self class] description] isEqualToString:(@"CNContactListViewController")]) {
			[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(fixMyNumber) userInfo:nil repeats:NO];
		} else if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(quickFix) userInfo:nil repeats:NO];
		}  

		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


		
		/*
		// temporary disable
		if ([self respondsToSelector:@selector(meContactBanner)]) {
			id me = [self performSelector:@selector(meContactBanner)];
			UILabel *label = [me performSelector:@selector(footnoteLabel)];
			UILabel *valueLabel = [me performSelector:@selector(footnoteValueLabel)];

			label.textColor = [UIColor whiteColor];
			label.alpha = 0.8;
			valueLabel.textColor = [UIColor whiteColor];
			valueLabel.alpha = 0.9;
		}else if ([self respondsToSelector:@selector(contactHeaderView)]) {
			UIView *header = [self performSelector:@selector(contactHeaderView)];
			header.backgroundColor = [UIColor clearColor];
		}else if ([self respondsToSelector:@selector(actionsWrapperView)]) {	
			UIView *action = [self performSelector:@selector(actionsWrapperView)];
			action.backgroundColor = [UIColor clearColor];
		}
		*/

	}
}


- (void)viewDidAppear:(bool)arg1 {
	%orig;


	// NSLog(@">>> viewDidAppear >>> %@", self);

	if (nero10Enabled()) {
		if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
			if ([self editMode]) {
				self.tableView.tag = 30052014;
				return;
			}
		}

		if ([self respondsToSelector:@selector(searchController)]) {
			[self blurSearchBar];

			[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(blurSearchBar) userInfo:nil repeats:NO];

		}

		
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	}
}



// - (id)tableView:(UITableView *)arg1 cellForRowAtIndexPath:(id)arg2 {
// 	UITableViewCell *cell = %orig;
// 	if (nero10Enabled()) {
// 		[arg1 whiteTextForCell:cell withForceWhite:NO];
// 	}
// 	return cell;
// }
%end

%hook CNContactListViewController
- (void)tableView:(UITableView *)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2 {
	%orig;


	if (nero10Enabled()) {
		// UITableViewCell *cell = [arg1 cellForRowAtIndexPath:arg2];
		// [arg1 whiteTextForCell:cell withForceWhite:NO];

		[arg1 reloadRowsAtIndexPaths:@[arg2] withRowAnimation:UITableViewRowAnimationFade];
	}
}
%end

%hook UICollectionView 
%new
- (void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force {
	if(view.tag == 181188) return;

	view.backgroundColor = [UIColor clearColor];
	for(UIView *v in [view subviews]) {
		if(v.tag == 181188) continue;
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
- (void)whiteTextForCell:(UICollectionViewCell *)cell withForceWhite:(BOOL)force {		
		cell.backgroundColor = [UIColor clearColor];


		UIView *selectionColor = [[UIView alloc] init];
		selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
		cell.selectedBackgroundView = selectionColor;

		[self clearBackgroundForView:cell withForceWhite:force];
		// [self clearBackgroundForView:cell.contentView withForceWhite:force];
}

-(id)_createPreparedCellForItemAtIndexPath:(id)arg1 withLayoutAttributes:(id)arg2 applyAttributes:(BOOL)arg3 isFocused:(BOOL)arg4 notify:(BOOL)arg5 {
	UICollectionViewCell *cell = %orig;


	if (nero10Enabled()) {
		if (self.tag == 30052014) return cell;
		[self whiteTextForCell:cell withForceWhite:NO];
	}

	return cell;
}
%end

%hook UITableView
%new
- (void)clearBackgroundForView:(UIView *)view withForceWhite:(BOOL)force {
	if(view.tag == 181188) return;
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
		if(v.tag == 181188) continue;
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
		// NSLog(@">>> whiteTextForCell >>> %@", [[cell class] superclass]);
		BOOL contactCell = NO;
		if (
			[[[[cell class] superclass] description] isEqualToString:(@"CNPropertySimpleTransportCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertyCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertyAlertCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNLabeledCell")]
			|| [[[[cell class] superclass] description] isEqualToString:(@"CNPropertySimpleEditingCell")]
			) {
			((UIView *)[cell subviews][0]).hidden = YES;
			contactCell = YES;
		}

		UIView *selectionColor = [[UIView alloc] init];
		selectionColor.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.3];
		cell.selectedBackgroundView = selectionColor;

		[self clearBackgroundForView:cell withForceWhite:force];
		// [self clearBackgroundForView:cell.contentView withForceWhite:force];

		if (cell.tableViewStyle == UITableViewStyleGrouped) {
			if ([cell viewWithTag:181188] == nil && !contactCell) {
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

// -(BOOL)_shouldSetIndexBackgroundColorToTableBackgroundColor {
// 	return YES;
// }
// -(UIColor *)sectionIndexTrackingBackgroundColor {
// 	return [UIColor clearColor];
// }
// -(UIColor *)sectionIndexColor {
// 	return [UIColor clearColor];
// }
// -(UIColor *)sectionIndexBackgroundColor {
// 	return [UIColor clearColor];
// }

// - (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 {
// 	UITableViewCell *cell = %orig;

// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;
// }

// -(id)cellForRowAtIndexPath:(id)arg1 {
// 	UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;	
// }
// -(id)dequeueReusableCellWithIdentifier:(id)arg1 {
// 	UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;	
// }
// -(id)_createPreparedCellForRowAtIndexPath:(id)arg1 willDisplay:(BOOL)arg2  {
// 		UITableViewCell *cell = %orig;


// 	if (nero10Enabled()) {
// 		[self whiteTextForCell:cell withForceWhite:NO];

// 	}
// 	return cell;
// }
- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 willDisplay:(bool)arg3 {
	UITableViewCell *cell = %orig;


	if (nero10Enabled()) {
		if (self.tag == 30052014) return cell;
		[self whiteTextForCell:cell withForceWhite:NO];
	}

	return cell;
}
// -(void)_configureCellForDisplay:(UITableViewCell*)cell forIndexPath:(id)arg2 {

// 	%orig;
	


// 	if (nero10Enabled()) {

// 		[self whiteTextForCell:cell withForceWhite:NO];
// 	}

// }
-(id)_sectionHeaderView:(BOOL)arg1 withFrame:(CGRect)arg2 forSection:(long long)arg3 floating:(BOOL)arg4 reuseViewIfPossible:(BOOL)arg5 willDisplay:(BOOL)arg6 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		if (self.tag == 30052014) return view;
		[self clearBackgroundForView:view withForceWhite:YES];
		
		// if ([[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.mobilephone"])
		// {
		// 	createBlurView(view, view.bounds, UIBlurEffectStyleDark);
		// 	// view.alpha = 0.7;
		// }

		

		if ([view respondsToSelector:@selector(contentView)]) {
			[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
		}
	}
	return view;
}

-(id)_sectionFooterViewWithFrame:(CGRect)arg1 forSection:(long long)arg2 floating:(BOOL)arg3 reuseViewIfPossible:(BOOL)arg4 willDisplay:(BOOL)arg5 {
	UIView *view = %orig;
	if (nero10Enabled()) {	
		if (self.tag == 30052014) return view;
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

// %hook UIApplication
// - (void)_setBackgroundStyle:(long long)arg1 {
//     %orig(4);
// }
// %end


// // Translucent Cydia but Dark Translucent, thanks to stonesam92
// static NSString *LOG_HTML_URL = @"cydia.saurik.com/ui/ios~iphone/1.1/progress";
// @interface UIWebBrowserView : UIView
// - (NSURL *)_documentUrl;
// @end
// @interface _UIWebViewScrollView : UIView
// @end


// %hook UIWebBrowserView

// - (void)loadRequest:(NSURLRequest *)request {
//     %orig;

// 	if (nero10Enabled()) {	
// 		if ([request.URL.absoluteString rangeOfString:LOG_HTML_URL].length != 0) {
// 			[[UIApplication sharedApplication] _setBackgroundStyle:4];
// 			[UIView animateWithDuration:0.3
// 								delay:0.6
// 								options:0
// 							animations:^{
// 								self.alpha = 0.3;
// 								self.superview.backgroundColor = [UIColor clearColor];
// 								}
// 							completion:nil];
// 		}
// 	}
// }

// %end

// %hook _UIWebViewScrollView
// - (void)setBackgroundColor:(UIColor *)color {
// 	if (nero10Enabled()) {	
// 		for (UIWebBrowserView *view in self.subviews) {
// 			if ([view isKindOfClass:%c(UIWebBrowserView)] 
// 			&& 
// 					[view._documentUrl.absoluteString rangeOfString:LOG_HTML_URL].length != 0
// 					) {
// 				%orig([UIColor clearColor]);
// 				return;
// 			}
// 		}
// 	}
//     %orig;
// }
// %end