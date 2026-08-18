#import <Foundation/Foundation.h>
#import <roothide.h>
#import <unistd.h>

static NSString *mobileGestaltPath(void)
{
    return jbroot(
        @"/var/containers/Shared/SystemGroup/"
         @"systemgroup.com.apple.mobilegestaltcache/"
         @"Library/Caches/"
         @"com.apple.MobileGestalt.plist"
    );
}

static BOOL enableDynamicIsland(void)
{
    NSString *path = mobileGestaltPath();

    if (!path) {
        return NO;
    }

    NSMutableDictionary *plist =
        [NSMutableDictionary dictionaryWithContentsOfFile:path];

    if (!plist) {
        return NO;
    }

    NSMutableDictionary *cacheExtra =
        [plist[@"CacheExtra"] mutableCopy];

    if (!cacheExtra) {
        return NO;
    }

    NSMutableDictionary *deviceInfo =
        [cacheExtra[@"oPeik/9e8lQWMszEjbPzng"] mutableCopy];

    if (!deviceInfo) {
        return NO;
    }

    NSNumber *current =
        deviceInfo[@"ArtworkDeviceSubType"];

    if ([current intValue] == 2556) {
        return YES;
    }

    deviceInfo[@"ArtworkDeviceSubType"] = @2556;

    cacheExtra[@"oPeik/9e8lQWMszEjbPzng"] = deviceInfo;
    plist[@"CacheExtra"] = cacheExtra;

    return [plist writeToFile:path atomically:YES];
}

int main(int argc, char *argv[])
{
    @autoreleasepool {

        /*
         * LaunchDaemon 可能早于 MobileGestalt cache 完全可访问。
         * 不退出，短时间重试。
         *
         * 最多等待约 30 秒。
         */
        for (int i = 0; i < 30; i++) {

            if (enableDynamicIsland()) {
                break;
            }

            sleep(1);
        }
    }

    return 0;
}
