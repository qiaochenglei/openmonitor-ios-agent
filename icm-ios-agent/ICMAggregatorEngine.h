//
//  ICMAggregatorEngine.h
//  icm-ios-agent
//
//  Created by shinysky on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SecKeyWrapper.h"
#import "ICMWebsite.h"
#import "ICMService.h"

//#define AGGREGATOR_URL @"icm-dev.appspot.com"
#define AGGREGATOR_URL @"aggregator:8000"
//#define AGGREGATOR_URL @"east1.openmonitor.org"

#define AGGR_REGISTER_AGENT @"api/registeragent/"
#define AGGR_LOGIN @"api/loginagent/"
#define AGGR_LOGIN2 @"api/loginagent2/"
#define AGGR_LOGOUT @"api/logoutagent/"
#define AGGR_GET_PEER_LIST @"api/getpeerlist/"
#define AGGR_GET_PEER_SUPER_LIST @"api/getsuperpeerlist/"
#define AGGR_GET_EVENTS @"api/getevents/"
#define AGGR_SEND_WEBSITE_REPORT @"api/sendwebsitereport/"
#define AGGR_SEND_SERVICE_REPORT @"api/sendservicereport/"
#define AGGR_CHECK_VERSION @"api/checkversion/"
#define AGGR_CHECK_TESTS @"api/checktests/"
#define AGGR_WEBSITE_SUGGESTION @"api/websitesuggestion/"
#define AGGR_SERVICE_SUGGESTION @"api/servicesuggestion/"
#define AGGR_TESTS @"api/tests/"
#define AGGR_CHECK_AGGREGATOR @"api/checkaggregator/"
#define AGGR_GET_NETLIST @"api/get_netlist/"
#define AGGR_GET_BANLIST @"api/get_banlist/"
#define AGGR_GET_BANNETS @"api/get_bannets/"

#define AGGR_MSG_KEY @"msg"
#define AGGR_KEY_KEY @"key"
#define AGGR_AGENT_ID_KEY @"agentID"
//#define RSAKEY_MOD @"109916896023924130410814755146"
#define RSAKEY_EXP @"65537"
#define AGENT_ID_KEY @"AgentID"

typedef enum {
    kStatusNormal=1,
    kStatusDown,
    kStatusContentChanged
} ICMTestStatus;

typedef enum {
    kWebsiteTest=1,
    kServiceTest,
    kThrottlingTest
} ICMTestType;


@protocol ICMAggregatorEngineDelegate;

@interface ICMAggregatorEngine : MKNetworkEngine
{
    SecKeyWrapper * crypto;
    int _agentId;
}

@property (nonatomic, assign) int agentId;

+ (ICMAggregatorEngine *)sharedEngine;

#pragma mark REST API methods

// ======================================================================================================
// ICM Aggregator REST API methods
// All methods below return a unique connection identifier.
// ======================================================================================================

- (void)registerAgent; // registeragent
- (void)loginStep1;
//- (void)loginStep2; // called by loginStep1(), should not be publicly visible
- (void)getEvents;
- (void)sendWebsiteReport:(ICMWebsite*)site;
- (void)sendServiceReport:(ICMService*)service;
- (void)checkNewTests;

@end

@protocol ICMAggregatorEngineDelegate

- (void)agentRegistered:(NSString*)response withError:(NSError*)error;

@end
