//
//  FeedbackKitDiagosticInfo.h
//  AppticsFeedbackKit
//
//  Created by Saravanan S on 26/07/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Segment, Property;

@interface FeedbackDiagosticInfo : NSObject

@property (nonatomic, strong) NSArray<Segment*> *segments;

- (instancetype)initWithSegments:(NSArray<Segment*> *)segments;
- (id) jsonify;

@end

@interface Segment : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray<Property*> *properties;

- (instancetype)initWithTitle:(NSString *)title properties:(NSArray<Property*> *)properties;

@end

@interface Property : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *status;

- (instancetype)initWithName:(NSString *)name status:(NSString *)status;
- (id)jsonify;

@end

NS_ASSUME_NONNULL_END
