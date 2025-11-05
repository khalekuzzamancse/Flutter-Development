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

#if __has_include(<kz_platform/KzPlatformPlugin.h>)
#import <kz_platform/KzPlatformPlugin.h>
#else
@import kz_platform;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [IntegrationTestPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntegrationTestPlugin"]];
  [KzPlatformPlugin registerWithRegistrar:[registry registrarForPlugin:@"KzPlatformPlugin"]];
}

@end
