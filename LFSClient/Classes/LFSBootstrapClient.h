//
//  LFSBootstrapClient.h
//  
//
//  Created by Eugene Scherba on 8/20/13.
//
//

#import "LFSBaseClient.h"

@interface LFSBootstrapClient : LFSBaseClient

/**
 * @property init - Init response object (JSON)
 * @see -getInitForSite:article:onSuccess:onFailure:
 */
@property (nonatomic, strong) NSDictionary *infoInit;

/**
 * Get the initial bootstrap data for a collection.
 *
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/StreamHub-API-Reference#wiki-init
 *
 * @param articleId The Id of the collection's article.
 * @param siteId The Id of the article's site.
 * @param success   Success callback
 * @param failure   Failure callback
 * @return void
 */
- (void)getInitForSite:(NSString *)siteId
               article:(NSString *)articleId
             onSuccess:(LFSSuccessBlock)success
             onFailure:(LFSFailureBlock)failure;

/** @name Content Retrieval */

/**
 * The init data for a collection contains information about that collection's number of pages and where to fetch the content for those pages.
 *
 * @param pageIndex The page to fetch content for. The pages are numbered from zero. If the page index provided is outside the bounds of what the init data knows about the error callback will convey that failure.
 * @param success   Success callback
 * @param failure   Failure callback
 * @return void
 */
- (void)getContentForPage:(NSInteger)pageIndex
                onSuccess:(LFSSuccessBlock)success
                onFailure:(LFSFailureBlock)failure;

/** @name User Information */

/**
 * Fetches the user's content history
 *
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/User-Content-API
 *
 * @param userId The Id of the user whose content is to be fetched.
 * @param userToken (optional) The lftoken of the user whose content is to be fetched. This parameter is required by default unless the network specifies otherwise.
 * @param statuses (optional) array of comment states to return.
 * @param offset (optional) Number of results to skip, defaults to 0. 25 items are returned at a time.
 * @param success   Success callback
 * @param failure   Failure callback
 * @return void
 */
- (void)getUserContentForUser:(NSString *)userId
                        token:(NSString *)userToken
                     statuses:(NSArray*)statuses
                       offset:(NSInteger)offset
                    onSuccess:(LFSSuccessBlock)success
                    onFailure:(LFSFailureBlock)failure;

/** @name Heat Index Trends */

/**
 * Polls for hottest Collections
 *
 * For more information see:
 * https://github.com/Livefyre/livefyre-docs/wiki/Heat-Index-API
 *
 * @param site (optional) Site ID to filter on.
 * @param tag (optional) Tag to filter on.
 * @param numberOfResults (optional) Number of results to be returned. The default is 10 and the maximum is 100.
 * @param success   Success callback
 * @param failure   Failure callback
 * @return void
 */
- (void)getHottestCollectionsForSite:(NSString *)siteId
                                 tag:(NSString *)tag
                      desiredResults:(NSUInteger)number
                           onSuccess:(LFSSuccessBlock)success
                           onFailure:(LFSFailureBlock)failure;

@end
