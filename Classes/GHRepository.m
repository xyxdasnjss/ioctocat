#import "GHRepository.h"
#import "GHResource.h"
#import "iOctocat.h"
#import "GHIssues.h"
#import "GHForks.h"
#import "GHEvents.h"
#import "GHReadme.h"
#import "GHBranches.h"
#import "NSURL+Extensions.h"
#import "NSDictionary+Extensions.h"


@implementation GHRepository

@synthesize name;
@synthesize owner;
@synthesize readme;
@synthesize descriptionText;
@synthesize mainBranch;
@synthesize htmlURL;
@synthesize homepageURL;
@synthesize isPrivate;
@synthesize isFork;
@synthesize hasIssues;
@synthesize hasWiki;
@synthesize hasDownloads;
@synthesize forks;
@synthesize events;
@synthesize watcherCount;
@synthesize forkCount;
@synthesize openIssues;
@synthesize closedIssues;
@synthesize branches;
@synthesize pushedAtDate;

+ (id)repositoryWithOwner:(NSString *)theOwner andName:(NSString *)theName {
	return [[[self.class alloc] initWithOwner:theOwner andName:theName] autorelease];
}

- (id)initWithOwner:(NSString *)theOwner andName:(NSString *)theName {
	[super init];
	[self setOwner:theOwner andName:theName];
	return self;
}

- (void)dealloc {
	[name release], name = nil;
	[owner release], owner = nil;
	[readme release], readme = nil;
	[descriptionText release], descriptionText = nil;
	[htmlURL release], htmlURL = nil;
	[homepageURL release], homepageURL = nil;
    [openIssues release], openIssues = nil;
    [closedIssues release], closedIssues = nil;
    [forks release], forks = nil;
    [events release], events = nil;
	[branches release], branches = nil;
    [super dealloc];
}

- (BOOL)isEqual:(id)anObject {
	return [self hash] == [anObject hash];
}

- (NSUInteger)hash {
	return [self.repoId hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<GHRepository name:'%@' owner:'%@' isPrivate:'%@' isFork:'%@'>", name, owner, isPrivate ? @"YES" : @"NO", isFork ? @"YES" : @"NO"];
}

- (NSString *)repoId {
    return [NSString stringWithFormat:@"%@/%@", owner, name];
}

- (NSString *)repoIdAndStatus {
    return [NSString stringWithFormat:@"%@/%@/%@", owner, isPrivate ? @"private" : @"public", name];
}

- (NSString *)resourcePath {
	// Dynamic path, because it depends on the owner and
	// name which are not always available in advance
	return [NSString stringWithFormat:kRepoFormat, owner, name];
}

- (void)setOwner:(NSString *)theOwner andName:(NSString *)theName {
	self.owner = theOwner;
	self.name = theName;
    self.forks = [GHForks forksWithRepository:self];
    self.readme = [GHReadme readmeWithRepository:self];
    self.branches = [GHBranches branchesWithRepository:self];
    self.events = [GHEvents eventsWithRepository:self];
	self.openIssues = [GHIssues issuesWithRepository:self andState:kIssueStateOpen];
	self.closedIssues = [GHIssues issuesWithRepository:self andState:kIssueStateClosed];
}

- (GHUser *)user {
	return [[iOctocat sharedInstance] userWithLogin:owner];
}

- (int)compareByRepoId:(GHRepository *)theOtherRepository {
    return [[self repoId] localizedCaseInsensitiveCompare:[theOtherRepository repoId]];
}

- (int)compareByRepoIdAndStatus:(GHRepository *)theOtherRepository {
    return [[self repoIdAndStatus] localizedCaseInsensitiveCompare:[theOtherRepository repoIdAndStatus]];
}

- (int)compareByName:(GHRepository *)theOtherRepository {
    return [[self name] localizedCaseInsensitiveCompare:[theOtherRepository name]];
}

#pragma mark Loading

- (void)setValues:(id)theDict {
    NSDictionary *resource = [theDict objectForKey:@"repository"] ? [theDict objectForKey:@"repository"] : theDict;
    
    self.htmlURL = [NSURL URLWithString:[resource objectForKey:@"html_url"]];
    self.homepageURL = [NSURL smartURLFromString:[resource objectForKey:@"homepage"]];
    self.descriptionText = [theDict valueForKeyPath:@"description" defaultsTo:@""];
    self.mainBranch = [theDict valueForKeyPath:@"master_branch" defaultsTo:@"master"];
    self.isFork = [[resource objectForKey:@"fork"] boolValue];
    self.isPrivate = [[resource objectForKey:@"private"] boolValue];
    self.hasIssues = [[resource objectForKey:@"has_issues"] boolValue];
    self.hasWiki = [[resource objectForKey:@"has_wiki"] boolValue];
    self.hasDownloads = [[resource objectForKey:@"has_downloads"] boolValue];
    self.forkCount = [[resource objectForKey:@"forks"] integerValue];
    self.watcherCount = [[resource objectForKey:@"watchers"] integerValue];
	self.pushedAtDate = [resource objectForKey:@"pushed_at"];
}

@end
