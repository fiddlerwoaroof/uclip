;;;; ubiquitous-clipboard.asd

(asdf:defsystem #:uclip
  :description "Describe uclip here"
  :author "fiddlerwoaroof <fiddlerwoaroof+uc@gmail.com>"
  :license "GPL2"
  :depends-on (#:alexandria
                #:anaphora
                #:ubiquitous)
  :serial t
  :components ((:file "package")
               (:file "uclip")))

