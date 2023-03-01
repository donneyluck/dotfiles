;; -*- no-byte-compile: t; -*-

;; [[file:config.org::*Rotate (window management)][Rotate (window management):1]]
;;(package! rotate :pin "4e9ac3ff800880bd9b705794ef0f7c99d72900a6")
;; Rotate (window management):1 ends here

;; [[file:config.org::*Emacs Everywhere][Emacs Everywhere:1]]
;;(package! emacs-everywhere :recipe (:local-repo "lisp/emacs-everywhere"))
;;(unpin! emacs-everywhere)
;; Emacs Everywhere:1 ends here

;; [[file:config.org::*Very large files][Very large files:1]]
;;(package! vlf :recipe (:host github :repo "m00natic/vlfi" :files ("*.el"))
;;  :pin "cc02f2533782d6b9b628cec7e2dcf25b2d05a27c" :disable t)
;; Very large files:1 ends here

;; [[file:config.org::*EVIL][EVIL:2]]
;;(package! evil-escape :disable t)
;; EVIL:2 ends here

;; [[file:config.org::*Magit delta][Magit delta:2]]
;; (package! magit-delta :recipe (:host github :repo "dandavison/magit-delta") :pin "56cdffd377279589aa0cb1df99455c098f1848cf")
;; Magit delta:2 ends here

;; [[file:config.org::*Auto activating snippets][Auto activating snippets:1]]
(package! aas :recipe (:host github :repo "ymarco/auto-activating-snippets")
  :pin "1699bec4d244a1f62af29fe4eb8b79b6d2fccf7d")
;; Auto activating snippets:1 ends here

;; [[file:config.org::*Screenshot][Screenshot:1]]
(package! screenshot :recipe (:local-repo "lisp/screenshot"))
;; Screenshot:1 ends here

;; [[file:config.org::*Etrace][Etrace:1]]
;;(package! etrace :recipe (:host github :repo "aspiers/etrace"))
;; Etrace:1 ends here

;; [[file:config.org::*Etrace][Etrace:2]]
;;(use-package! etrace
;;  :after elp)
;; Etrace:2 ends here

;; [[file:config.org::*String inflection][String inflection:1]]
(package! string-inflection :pin "fd7926ac17293e9124b31f706a4e8f38f6a9b855")
;; String inflection:1 ends here

;; [[file:config.org::*Tabnine][Tabnine:1]]
(package! company-tabnine :recipe (:host github :repo "TommyX12/company-tabnine"))
;; Tabnine:1 ends here

;; [[file:config.org::*Beacon][Beacon:1]]
(package! beacon)
;; Beacon:1 ends here

;; [[file:config.org::*Info colours][Info colours:1]]
(package! info-colors :pin "47ee73cc19b1049eef32c9f3e264ea7ef2aaf8a5")
;; Info colours:1 ends here

;; [[file:config.org::*Modus themes][Modus themes:1]]
(package! modus-themes :pin "392ebb115b07f8052d512ec847619387d109edd6")
;; Modus themes:1 ends here

;; [[file:config.org::*Theme magic][Theme magic:1]]
(package! theme-magic :pin "844c4311bd26ebafd4b6a1d72ddcc65d87f074e3")
;; Theme magic:1 ends here

;; [[file:config.org::*Keycast][Keycast:1]]
(package! keycast :pin "04ba7519f34421c235bac458f0192c130f732f12")
;; Keycast:1 ends here

;; [[file:config.org::*Screencast][Screencast:1]]
(package! gif-screencast :pin "5517a557a17d8016c9e26b0acb74197550f829b9")
;; Screencast:1 ends here

;; [[file:config.org::*Prettier page breaks][Prettier page breaks:1]]
(package! page-break-lines :recipe (:host github :repo "purcell/page-break-lines"))
;; Prettier page breaks:1 ends here

;; [[file:config.org::*xkcd][xkcd:1]]
(package! xkcd :pin "66e928706fd660cfdab204c98a347b49c4267bdf")
;; xkcd:1 ends here

;; [[file:config.org::*Selectric][Selectric:1]]
(package! selectric-mode :pin "1840de71f7414b7cd6ce425747c8e26a413233aa")
;; Selectric:1 ends here

;; [[file:config.org::*Wttrin][Wttrin:1]]
(package! wttrin :recipe (:local-repo "lisp/wttrin"))
;; Wttrin:1 ends here

;; [[file:config.org::*Spray][Spray:1]]
(package! spray :pin "74d9dcfa2e8b38f96a43de9ab0eb13364300cb46")
;; Spray:1 ends here

;; [[file:config.org::*Elcord][Elcord:1]]
;;(package! elcord :pin "64545671174f9ae307c0bd0aa9f1304d04236421")
;; Elcord:1 ends here

;; [[file:config.org::*Systemd][Systemd:1]]
(package! systemd :pin "b6ae63a236605b1c5e1069f7d3afe06ae32a7bae")
;; Systemd:1 ends here

;; [[file:config.org::*Stan][Stan:1]]
;;(package! stan-mode :pin "9bb858b9f1314dcf1a5df23e39f9af522098276b")
;;(package! company-stan :pin "9bb858b9f1314dcf1a5df23e39f9af522098276b")
;;(package! eldoc-stan :pin "9bb858b9f1314dcf1a5df23e39f9af522098276b")
;;(package! flycheck-stan :pin "9bb858b9f1314dcf1a5df23e39f9af522098276b")
;;(package! stan-snippets :pin "9bb858b9f1314dcf1a5df23e39f9af522098276b")
;; Stan:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:1]]
;;(package! calibredb :pin "cb93563d0ec9e0c653210bc574f9546d1e7db437")
;; Ebooks:1 ends here

;; [[file:config.org::*Ebooks][Ebooks:2]]
;;(package! nov :pin "b3c7cc28e95fe25ce7b443e5f49e2e45360944a3")
;; Ebooks:2 ends here

;; [[file:config.org::*CalcTeX][CalcTeX:1]]
(package! calctex :recipe (:host github :repo "johnbcoughlin/calctex"
                           :files ("*.el" "calctex/*.el" "calctex-contrib/*.el" "org-calctex/*.el" "vendor"))
  :pin "784cf911bc96aac0f47d529e8cee96ebd7cc31c9")
;; CalcTeX:1 ends here

;; [[file:config.org::*Dictionary][Dictionary:1]]
(package! lexic :recipe (:local-repo "lisp/lexic"))
;; Dictionary:1 ends here

;; [[file:config.org::*Terminal viewing][Terminal viewing:1]]
(package! pdftotext :recipe (:local-repo "lisp/pdftotext"))
;; Terminal viewing:1 ends here

;; [[file:config.org::*Beancount][Beancount:1]]
(package! beancount :recipe (:host github :repo "beancount/beancount-mode")
  :pin "ea8257881b7e276e8d170d724e3b2e179f25cb77")
;; Beancount:1 ends here
