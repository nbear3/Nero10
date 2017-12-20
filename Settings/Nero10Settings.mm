#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSSwitchTableCell.h>

@interface Nero10SettingsController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation Nero10SettingsController

- (id)specifiers {
	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Nero10" target:self];
	}
	return _specifiers;
}

 -(void)choosePhoto{
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerLibrary.delegate = self;
    [self.navigationController presentViewController:pickerLibrary animated:YES completion:nil];
 }

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Documents/nero10_bg.png"];
    UIImage *picture = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImagePNGRepresentation(picture);
    [imageData writeToFile:path atomically:YES];
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)respring {
    CFNotificationCenterPostNotification (CFNotificationCenterGetDarwinNotifyCenter(),
                                          CFSTR("respringDevice"),
                                          NULL,
                                          NULL,
                                          false);
}

-(void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/nbear3/Nero10"]];
}

@end
