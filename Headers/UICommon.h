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

@interface PHHandsetDialerNameLabelView : UIControl
@property (retain) UILabel * nameAndLabelLabel;
@end

@interface PHHandsetDialerLCDView : UIView
@property (retain) PHHandsetDialerNameLabelView * nameAndLabelView; 
@property (nonatomic,retain) UITextField * numberTextField;
@end

@interface PHHandsetDialerView {
	UIView* _lcdView;
	UIView* _phonePadView;
}
@property(retain) UIView* topBlankView;
@property(retain) UIView* bottomBlankView;
@property(retain) UIView* rightBlankView;
@property(retain) UIView* leftBlankView;
@end

@interface TPRevealingRingView : UIView
@property (nonatomic, retain) UIColor *colorInsideRing;
@property (nonatomic, retain) UIColor *colorOutsideRing;
@property (nonatomic) double alphaInsideRing;
@property (nonatomic) double alphaOutsideRing;
@property (nonatomic) double gammaBoost;
@property (nonatomic) bool gammaBoostInside;
@property (nonatomic) bool gammaBoostOuterRing;
@end

@interface PHHandsetDialerNumberPadButton
@property (nonatomic, readonly) TPRevealingRingView *revealingRingView;
- (void)setHighlighted:(bool)arg1;
- (void)setUsesColorDodgeBlending;
- (void)backToHighlighted;
@end