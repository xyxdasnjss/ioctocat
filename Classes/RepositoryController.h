#import <UIKit/UIKit.h>


@class GHRepository, GHUser, TextCell, LabeledCell;

@interface RepositoryController : UITableViewController <UIActionSheetDelegate> {
  @private
	GHRepository *repository;
	IBOutlet UIView *tableHeaderView;
	IBOutlet UILabel *nameLabel;
	IBOutlet UILabel *numbersLabel;
	IBOutlet UILabel *ownerLabel;
	IBOutlet UILabel *websiteLabel;
    IBOutlet UILabel *forkLabel;
	IBOutlet UITableViewCell *loadingCell;
    IBOutlet UITableViewCell *readmeCell;
    IBOutlet UITableViewCell *issuesCell;
    IBOutlet UITableViewCell *forkCell;
    IBOutlet UITableViewCell *eventsCell;
    IBOutlet UIImageView *iconView;
	IBOutlet LabeledCell *ownerCell;
	IBOutlet LabeledCell *websiteCell;
	IBOutlet TextCell *descriptionCell;
}

+ (id)controllerWithRepository:(GHRepository *)theRepository;
- (id)initWithRepository:(GHRepository *)theRepository;
- (IBAction)showActions:(id)sender;

@end
