# A simple clipboard utility

This wraps <https://github.com/Shinmera/ubiquitous> to provide a handy suite of
utilities to manage a set of named clipboards.

# Installation

```(lang=sh)
sbcl --load ~/quicklisp/setup.lisp --eval '(ql:quickload :buildapp)' --eval '(buildapp:build-buildapp)'

./buildapp --output ~/bin/multicall/uclip --asdf-tree ~/quicklisp/quicklisp --asdf-path `pwd` --load-system uclip \
           --dispatched-entry /uclip::paste \
           --dispatched-entry ucopy/uclip::copy \
           --dispatched-entry upaste/uclip::paste \
           --dispatched-entry uswitch/uclip::switch-clipboards \
           --dispatched-entry upop/uclip::pop-clipboard \
           --dispatched-entry uls/uclip::list-clipboards \
           --dispatched-entry ushow/uclip::show-clipboard-contents \
           --dispatched-entry uclear/uclip::clear-clipboard

xargs  -n1  ln -fs multicall/uclip <<EOF
ucopy
upaste
uswitch
upop
uls
ushow
uclear
EOF
```
