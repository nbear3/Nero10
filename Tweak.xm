#import "Headers/UICommon.h"
extern "C" CFArrayRef CPBitmapCreateImagesFromData(CFDataRef cpbitmap, void*, int, void*);

// CONSTANTS 
static BOOL isEnabled = true;
static BOOL useBlur = true;
static BOOL useWallpaper = true;

NSMutableDictionary *whitelist;
CFStringRef kPrefsAppID = CFSTR("com.martinpham.nero10");


static void createBlurView(UIView *view, CGRect bound, int effect)  {
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:effect]];
    visualEffectView.frame = bound;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:visualEffectView];
    [view sendSubviewToBack:visualEffectView];
}


// Tweak Hooks
%group Tweak


%hook CNContactContentViewController
%property (assign) BOOL editMode;
- (void)didChangeToEditMode:(bool)arg1 {
	self.editMode = arg1;
	self.tableView.tag = arg1 ? 30052014 : 0;
	[self.tableView reloadData];

	%orig;
}
%end;


%hook UIViewController

%new
- (void)fixMyNumber {
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
	if ([self respondsToSelector:@selector(contactHeaderView)]) {
		UIView *header = [self performSelector:@selector(contactHeaderView)];
		if (header.tag != 181188) {
			header.tag = 181188;
			header.backgroundColor = [UIColor clearColor];
			createBlurView(header, header.bounds, UIBlurEffectStyleExtraLight);
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
	
	if ([ [[self class] description] isEqualToString:(@"CNContactContentViewController")]) {
		if ([self editMode]) {
			return;
		}
	}

	[[UIApplication sharedApplication] _setBackgroundStyle:4];

	UIImage *background;
	if (useWallpaper) {
		NSData *homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/HomeBackground.cpbitmap"];
		if (!homeWallpaperData) {
			homeWallpaperData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/SpringBoard/LockBackground.cpbitmap"];
		}
		CFDataRef homeWallpaperDataRef = (__bridge CFDataRef)homeWallpaperData;
		NSArray *imageArray = (__bridge NSArray *)CPBitmapCreateImagesFromData(homeWallpaperDataRef, NULL, 1, NULL);
		background = [UIImage imageWithCGImage:(CGImageRef)imageArray[0]];
	} else {
		background = [UIImage imageNamed:@"/var/mobile/Documents/nero10_bg.png"];
	}

	UIImageView *iv = [[UIImageView alloc] initWithImage:background];
	iv.frame = [UIScreen mainScreen].bounds;

	if (useBlur) {
		createBlurView(iv, iv.frame, UIBlurEffectStyleDark);
	}

	if ([ [[self class] description] isEqualToString:(@"ALApplicationPreferenceViewController")]) {
		[((UITableView *)MSHookIvar<UITableView *>(self, "_tableView")) setBackgroundView:iv];
	}else if ([self respondsToSelector:@selector(table)]) {
		[self.table setBackgroundView:iv];
	}else if ([self respondsToSelector:@selector(tableView)]) {
		[self.tableView setBackgroundView:iv];
	}else if ([self respondsToSelector:@selector(collectionView)]) {
		[self.collectionView setBackgroundView:iv];
	}else {
		for(UITableView *v in [self.view subviews]) {
			if ([v isKindOfClass:[UITableView class]]) {
				v.backgroundColor = [UIColor clearColor];
			}
		}

		for(UICollectionView *v in [self.view subviews]) {
			if ([v isKindOfClass:[UICollectionView class]]) {
				v.backgroundColor = [UIColor clearColor];
			}
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

%new
- (void)blurSearchBar {
	if (self.searchController.searchBar.tag != 181188) {
		self.searchController.searchBar.tag = 181188;
		// self.searchController.searchBar.barStyle = UIBarStyleBlackTranslucent;
		self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
		self.searchController.searchBar.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.25];
		UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
		searchField.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8];
	}
}

- (void)viewWillAppear:(bool)arg1 {
	%orig;

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
}


- (void)viewDidAppear:(bool)arg1 {
	%orig;

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
%end


%hook CNContactListViewController
- (void)tableView:(UITableView *)arg1 didSelectRowAtIndexPath:(NSIndexPath *)arg2 {
	%orig;
	[arg1 reloadRowsAtIndexPaths:@[arg2] withRowAnimation:UITableViewRowAnimationFade];
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
}

-(id)_createPreparedCellForItemAtIndexPath:(id)arg1 withLayoutAttributes:(id)arg2 applyAttributes:(BOOL)arg3 isFocused:(BOOL)arg4 notify:(BOOL)arg5 {
	UICollectionViewCell *cell = %orig;
	if (self.tag == 30052014) return cell;
	[self whiteTextForCell:cell withForceWhite:NO];
	return cell;
}
%end


%hook MPKeypadViewController
-(void)viewDidLoad {
	%orig;

	PHHandsetDialerView *_dialerView = (PHHandsetDialerView *)MSHookIvar<PHHandsetDialerView *>(self, "_dialerView");
	_dialerView.topBlankView.hidden = YES;
	_dialerView.bottomBlankView.hidden = YES;
	_dialerView.rightBlankView.hidden = YES;
	_dialerView.leftBlankView.hidden = YES;

	PHHandsetDialerLCDView* _lcdView =  (PHHandsetDialerLCDView *)MSHookIvar<PHHandsetDialerLCDView *>(_dialerView, "_lcdView");
	UIView* _phonePadView =  (UIView *)MSHookIvar<UIView *>(_dialerView, "_phonePadView");
	
	_lcdView.backgroundColor = [UIColor clearColor];
	_lcdView.numberTextField.textColor = [UIColor whiteColor];
	_lcdView.nameAndLabelView.nameAndLabelLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8];

	for(PHHandsetDialerNumberPadButton *v in [_phonePadView subviews]){
		[v setUsesColorDodgeBlending];
		[v setHighlighted:YES];
		TPRevealingRingView *rv = v.revealingRingView;
		rv.colorOutsideRing = [UIColor clearColor];
		rv.colorInsideRing = [UIColor clearColor];
	}
}
%end


%hook PHHandsetDialerNumberPadButton 
- (void)setHighlighted:(bool)arg1 {
	%orig;
	[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(backToHighlighted) userInfo:nil repeats:NO];
}

%new
- (void)backToHighlighted {
	[self setHighlighted:YES];
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
				cell.titleLabel.textColor = [UIColor whiteColor];
		}

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

- (id)_createPreparedCellForGlobalRow:(long long)arg1 withIndexPath:(id)arg2 willDisplay:(bool)arg3 {
	UITableViewCell *cell = %orig;

	if (self.tag == 30052014) return cell;
	[self whiteTextForCell:cell withForceWhite:NO];
	return cell;
}

-(id)_sectionHeaderView:(BOOL)arg1 withFrame:(CGRect)arg2 forSection:(long long)arg3 floating:(BOOL)arg4 reuseViewIfPossible:(BOOL)arg5 willDisplay:(BOOL)arg6 {
	UIView *view = %orig;

	if (self.tag == 30052014) return view;
	[self clearBackgroundForView:view withForceWhite:YES];

	if ([view respondsToSelector:@selector(contentView)]) {
		[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
	}
	
	return view;
}

-(id)_sectionFooterViewWithFrame:(CGRect)arg1 forSection:(long long)arg2 floating:(BOOL)arg3 reuseViewIfPossible:(BOOL)arg4 willDisplay:(BOOL)arg5 {
	UIView *view = %orig;
	if (self.tag == 30052014) return view;
	[self clearBackgroundForView:view withForceWhite:YES];

	if ([view respondsToSelector:@selector(contentView)]) {
		[self clearBackgroundForView:[view performSelector:@selector(contentView)] withForceWhite:YES]; 
	}

	return view;
}
%end

%end

// Preference Loading
static void loadPrefs()
{
	whitelist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.martinpham.nero10.plist"];
	if (whitelist != nil) {
		isEnabled = [[whitelist objectForKey:@"isEnabled"] boolValue];
		useBlur = [[whitelist objectForKey:@"useBlur"] boolValue];
		useWallpaper = [[whitelist objectForKey:@"useWallpaper"] boolValue];
	}
}

%ctor 
{
    @autoreleasepool {
        loadPrefs();
		NSString *bundle = [[NSBundle mainBundle] bundleIdentifier];

		/* put bundle you DO want to inject into here */
		if (isEnabled && [[whitelist objectForKey:bundle] boolValue]) {
			// NSLog(@"[Nero10] Bundle: %@", bundle);
			%init(Tweak);
		}

		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, kPrefsAppID, NULL, CFNotificationSuspensionBehaviorCoalesce);
	}
}
