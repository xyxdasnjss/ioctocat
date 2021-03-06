#import "GHGists.h"
#import "GHGist.h"
#import "GHUser.h"
#import "iOctocat.h"


@implementation GHGists

@synthesize gists;

+ (id)gistsWithPath:(NSString *)thePath {
	return [[[[self class] alloc] initWithPath:thePath ] autorelease];
}

- (id)initWithPath:(NSString *)thePath {
	[super init];
	self.resourcePath = thePath;
	self.gists = [NSMutableArray array];
	return self;
}

- (void)dealloc {
	[gists release], gists = nil;
	[super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Gists resourcePath:'%@'>", resourcePath];
}

- (void)setValues:(id)theResponse {
	NSMutableArray *resources = [NSMutableArray array];
	for (NSDictionary *dict in theResponse) {
		GHGist *resource = [GHGist gistWithId:[dict valueForKey:@"id"]];
		[resource setValues:dict];
		[resources addObject:resource];
	}
	self.gists = resources;
}

@end
