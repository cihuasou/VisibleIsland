#import <Foundation/Foundation.h>
#import <roothide.h>
#import <unistd.h>

static NSString *mobileGestaltPath(void)
{
    return rootfs(
        @"/var/containers/Shared/SystemGroup/"
         @"systemgroup.com.apple.mobilegestaltcache/"
         @"Library/Caches/"
         @"com.apple.MobileGestalt.plist"
    );
}

int main(int argc, char *argv[])
{
    @autoreleasepool {

        NSString *path = mobileGestaltPath();

        NSMutableDictionary *plist =
            [NSMutableDictionary dictionaryWithContentsOfFile:path];

        if (!plist) {
            return 0;
        }

        NSMutableDictionary *cacheExtra =
            [plist[@"CacheExtra"] mutableCopy];

        if (!cacheExtra) {
            cacheExtra = [NSMutableDictionary dictionary];
            plist[@"CacheExtra"] = cacheExtra;
        }

        NSMutableDictionary *deviceInfo =
            [cacheExtra[@"oPeik/9e8lQWMszEjbPzng"] mutableCopy];

        if (!deviceInfo) {
            deviceInfo = [NSMutableDictionary dictionary];
            cacheExtra[@"oPeik/9e8lQWMszEjbPzng"] = deviceInfo;
        }

        NSNumber *current =
            deviceInfo[@"ArtworkDeviceSubType"];

        if ([current intValue] == 2556) {
            return 0;
        }

        deviceInfo[@"ArtworkDeviceSubType"] = @2556;

        [plist writeToFile:path atomically:YES];
    }

    return 0;
}
