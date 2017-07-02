with (import <nixpkgs> {});
derivation {
  name = "uclip";
  builder = "${bash}/bin/bash";
  args = [ ./builder.sh ];
  inherit sbcl curl coreutils git findutils;
  src = ./.;
  system = builtins.currentSystem;
}

