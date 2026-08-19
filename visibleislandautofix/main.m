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

int main(int argc, char *argv[])
{
    return 0;
}
