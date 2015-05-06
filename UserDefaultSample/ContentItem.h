

#import <Foundation/Foundation.h>

@interface ContentItem : NSObject

@property (nonatomic,copy) NSString *contentId;
@property (nonatomic,copy) NSString *contentTitle;
@property (nonatomic,assign) BOOL isAlreadyRead;

@end
