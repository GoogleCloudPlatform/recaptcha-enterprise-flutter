//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<integration_test/IntegrationTestPlugin.h>)
#import <integration_test/IntegrationTestPlugin.h>
#else
@import integration_test;
#endif

#if __has_include(<recaptcha_enterprise_flutter/RecaptchaEnterprisePlugin.h>)
#import <recaptcha_enterprise_flutter/RecaptchaEnterprisePlugin.h>
#else
@import recaptcha_enterprise_flutter;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [RecaptchaEnterprisePlugin registerWithRegistrar:[registry registrarForPlugin:@"RecaptchaEnterprisePlugin"]];
}

@end
