{ system ? builtins.currentSystem # TODO: Get rid of this system cruft
, iosSdkVersion ? "10.2"
}:
with import ./.obelisk/impl { inherit system iosSdkVersion; };
project ./. ({ ... }: {
  android.applicationId = "systems.obsidian.obelisk.examples.minimal";
  android.displayName = "Obelisk Minimal Example";
  ios.bundleIdentifier = "systems.obsidian.obelisk.examples.minimal";
  ios.bundleName = "Obelisk Minimal Example";

  overrides = self: super:
    let
      pkgs = import <nixpkgs> {};
      r-all =
        import (pkgs.fetchFromGitHub {
          owner = "dfordivam";
          repo = "reflex-websocket-interface";
          rev = "160c2da048b63f5b38343b8a06fc0d426796f66e";
          sha256 = "1gf7rjqgkzvs28gjmg4ssp9149kyyq9rsx9f2z0qwpsjkg35pqgz";
        }) self;
    in rec {

      reflex-websocket-interface = r-all.reflex-websocket-interface;

      reflex-websocket-interface-shared = r-all.reflex-websocket-interface-shared;

      reflex-websocket-interface-server = r-all.reflex-websocket-interface-server;
      };
})
