set -eu -o pipefail

cleanup() {
  if [[ -d /homeless-shelter ]]; then
    rm -rf /homeless-shelter
  fi
}
trap cleanup EXIT

export PATH
add_path() {
  PATH="$PATH:$1"
}
add_path "$coreutils/bin"
add_path "$findutils/bin"
add_path "$git/bin"
add_path "$sbcl/bin" 
add_path "$curl/bin" 

mkdir -p "$out"/bin/multicall

BUILD_DIR="$out/build"
mkdir "$BUILD_DIR"
cd "$BUILD_DIR"

cp -R "$src" "$BUILD_DIR/src"
chmod -R +rwX "$BUILD_DIR/src"
ls -dl $PWD
mkdir build quicklisp

cd "$BUILD_DIR/src"

curl -O https://beta.quicklisp.org/quicklisp.lisp
sbcl \
  --eval "(require :asdf)" \
  --eval "(setf asdf:*user-cache* (truename #p\"$BUILD_DIR/build/\"))" \
  --load quicklisp.lisp \
  --eval "(quicklisp-quickstart:install :path (truename \"$BUILD_DIR/quicklisp/\"))"

sbcl \
  --eval "(require :asdf)" \
  --eval "(setf asdf:*user-cache* (truename #p\"$BUILD_DIR/build/\"))" \
  --load "$BUILD_DIR/quicklisp/setup.lisp" \
  --eval '(ql:quickload :buildapp)' \
  --eval '(buildapp:build-buildapp)'

./buildapp \
  --output "$out/bin/multicall/uclip" \
  --eval "(require :asdf)" \
  --eval "(setf asdf:*user-cache* (truename #p\"$BUILD_DIR/build/\"))" \
  --eval "(format t \"~3&ASDF:*user-cache*: ~s~3%\" asdf:*user-cache*)" \
  --load "$BUILD_DIR/quicklisp/setup.lisp" \
  --asdf-tree "$BUILD_DIR/src/" \
  --eval "(ql:quickload :uclip)" \
  --dispatched-entry /uclip::paste \
  --dispatched-entry ucopy/uclip::copy \
  --dispatched-entry upaste/uclip::paste \
  --dispatched-entry uswitch/uclip::switch-clipboards \
  --dispatched-entry upop/uclip::pop-clipboard \
  --dispatched-entry uls/uclip::list-clipboards \
  --dispatched-entry ushow/uclip::show-clipboard-contents \
  --dispatched-entry uclear/uclip::clear-clipboard

cd "$out/bin"

xargs  -n1  ln -fsv multicall/uclip <<EOF
ucopy
upaste
uswitch
upop
uls
ushow
uclear
EOF

