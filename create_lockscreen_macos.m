#import <objc/runtime.h>
#import <Foundation/Foundation.h>

// src: https://apple.stackexchange.com/questions/80058/lock-screen-command-one-liner/123738#123738
// compile with 
// clang -framework Foundation main.m -o lockscreen

int main () {
    NSBundle *bundle = [NSBundle bundleWithPath:@"/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"];

    Class principalClass = [bundle principalClass];

    id instance = [[principalClass alloc] init];

    [instance performSelector:@selector(_lockScreenMenuHit:) withObject:nil];

    return 0;
}