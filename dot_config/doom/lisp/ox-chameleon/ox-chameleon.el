;;; ox-chameleon.el --- Make documents match your theme -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 TEC
;;
;; Author: TEC <https://github.com/tecosaur>
;; Maintainer: TEC <tec@tecosaur.com>
;; Created: August 15, 2021
;; Modified: August 15, 2021
;; Version: 0.0.1
;; Keywords: convenience faces
;; Homepage: https://github.com/tecosaur/ox-chameleon
;; Package-Requires: ((emacs "26.3") (engrave-faces "0.1.0"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Make documents match your theme
;;
;;; Code:

(defvar ox-chameleon--p nil
  "Used to indicate whether the current export is trying to blend in. Set just before being accessed.")

(defun ox-chameleon-org-latex-detect (orig-fun info)
  (setq ox-chameleon--p (when (equal (plist-get info :latex-class)
                                     "chameleon")
                          (plist-put info :latex-class
                                     (if (plist-get info :beamer-theme) "beamer"
                                       org-latex-default-class))
                          t))
  (funcall orig-fun info))
(advice-add 'org-export-install-filters :around #'ox-chameleon-org-latex-detect)

(defun ox-chameleon-org-latex-export (orig-fn info &optional template snippet?)
  (if (and ox-chameleon--p (not snippet?))
      (concat (funcall orig-fn info template snippet?)
              (ox-chameleon-generate-colourings info))
    (funcall orig-fn info template snippet?)))
(advice-add 'org-latex-make-preamble :around #'ox-chameleon-org-latex-export)

(defun ox-chameleon-engrave-wrapper (orig-fun backend &rest args)
  ;; Require modes that provide faces used in `engrave-faces-generate-preset'.
  (require 'highlight-numbers nil t)
  (require 'highlight-quoted nil t)
  (require 'rainbow-delimiters nil t)
  (if (and ox-chameleon--p (org-export-derived-backend-p backend 'latex))
      ;; For some reason a `let' block doesn't seem to work here.
      (unwind-protect
          (progn (setq ox-chameleon--ef-styles--old engrave-faces-preset-styles
                       engrave-faces-preset-styles (engrave-faces-generate-preset))
                 (apply orig-fun backend args))
        (setq engrave-faces-preset-styles ox-chameleon--ef-styles--old)
        (makunbound 'ox-chameleon--ef-styles--old))
    (apply orig-fun backend args)))
(advice-add 'org-export-as :around #'ox-chameleon-engrave-wrapper)

(defun ox-chameleon-generate-colourings (info)
  (concat
   "\n%% make document follow Emacs theme\n"
   (ox-chameleon--generate-fgbg-colours)
   (if (plist-get info :beamer-theme)
       (concat (ox-chameleon--generate-beamer-colourings)
               (ox-chameleon--generate-beamer-list-colourings))
     (concat "\n\\pagecolor{obg}\n\\color{ofg}\n"
             (ox-chameleon--generate-list-colourings)
             (ox-chameleon--generate-koma-structural-colourings)))
   (ox-chameleon--generate-text-colourings)
   (ox-chameleon--generate-src-colourings)
   "\n%% end customisations\n\n"))

(defun ox-chameleon--generate-fgbg-colours ()
  (apply #'format
         "\n\\definecolor{obg}{HTML}{%s}\n\\definecolor{ofg}{HTML}{%s}\n"
         (mapcar (lambda (hex) (substring hex 1))
                 (list
                  (face-attribute 'default :background)
                  (face-attribute 'default :foreground)))))

(defun ox-chameleon--generate-text-colourings ()
  (apply #'format
         "
%% textual elements

\\definecolor{link}{HTML}{%s}
\\definecolor{cite}{HTML}{%s}
\\definecolor{itemlabel}{HTML}{%s}
\\definecolor{code}{HTML}{%s}
\\definecolor{verbatim}{HTML}{%s}

\\renewcommand{\\labelitemi}{\\textcolor{itemlabel}{\\textbullet}}
\\renewcommand{\\labelitemii}{\\textcolor{itemlabel}{\\normalfont\\bfseries \\textendash}}
\\renewcommand{\\labelitemiii}{\\textcolor{itemlabel}{\\textasteriskcentered}}
\\renewcommand{\\labelitemiv}{\\textcolor{itemlabel}{\\textperiodcentered}}

\\renewcommand{\\labelenumi}{\\textcolor{itemlabel}{\\theenumi.}}
\\renewcommand{\\labelenumii}{\\textcolor{itemlabel}{(\\theenumii)}}
\\renewcommand{\\labelenumiii}{\\textcolor{itemlabel}{\\theenumiii.}}
\\renewcommand{\\labelenumiv}{\\textcolor{itemlabel}{\\theenumiv.}}

\\DeclareTextFontCommand{\\texttt}{\\color{code}\\ttfamily}
\\makeatletter
\\def\\verbatim@font{\\color{verbatim}\\normalfont\\ttfamily}
\\makeatother
"
         (mapcar (lambda (hex) (substring hex 1))
                 (list
                  (face-attribute 'link :foreground nil 'default)
                  (face-attribute 'org-cite :foreground nil 'default)
                  (face-attribute 'org-list-dt :foreground nil 'default)
                  (face-attribute 'org-code :foreground nil 'default)
                  (face-attribute 'org-verbatim :foreground nil 'default)))))

(defun ox-chameleon--generate-list-colourings ()
  (format "
%% list labels

\\definecolor{itemlabel}{HTML}{%s}

\\renewcommand{\\labelitemi}{\\textcolor{itemlabel}{\\textbullet}}
\\renewcommand{\\labelitemii}{\\textcolor{itemlabel}{\\normalfont\\bfseries \\textendash}}
\\renewcommand{\\labelitemiii}{\\textcolor{itemlabel}{\\textasteriskcentered}}
\\renewcommand{\\labelitemiv}{\\textcolor{itemlabel}{\\textperiodcentered}}

\\renewcommand{\\labelenumi}{\\textcolor{itemlabel}{\\theenumi.}}
\\renewcommand{\\labelenumii}{\\textcolor{itemlabel}{(\\theenumii)}}
\\renewcommand{\\labelenumiii}{\\textcolor{itemlabel}{\\theenumiii.}}
\\renewcommand{\\labelenumiv}{\\textcolor{itemlabel}{\\theenumiv.}}
"
          (substring (face-attribute 'org-list-dt :foreground nil 'default) 1)))

(defun ox-chameleon--generate-src-colourings ()
  (apply #'format
         "
%% code blocks

\\definecolor{codebackground}{HTML}{%s}
\\colorlet{EFD}{ofg}
\\definecolor{codeborder}{HTML}{%s}
"
         (mapcar (lambda (hex) (substring hex 1))
                 (cond
                  ((and (featurep 'doom-themes) (featurep 'solaire-mode))
                   (list
                    (face-attribute 'solaire-default-face :background nil 'default)
                    (doom-blend (face-attribute 'solaire-default-face :background nil 'default)
                                (face-attribute 'default :foreground nil 'default)
                                0.95)))
                  ((featurep 'doom-themes)
                   (list
                    (doom-blend (face-attribute 'default :background nil 'default)
                                (face-attribute 'default :foreground nil 'default)
                                0.98)
                    (doom-blend (face-attribute 'default :background nil 'default)
                                (face-attribute 'default :foreground nil 'default)
                                0.95)))
                  (t (list
                      (face-attribute 'default :background nil 'default)
                      (face-attribute 'shadow :foreground nil 'default)))))))

(defun ox-chameleon--generate-koma-structural-colourings ()
  (apply #'format
         "
%% structural elements

\\definecolor{documentTitle}{HTML}{%s}
\\definecolor{documentInfo}{HTML}{%s}
\\definecolor{level1}{HTML}{%s}
\\definecolor{level2}{HTML}{%s}
\\definecolor{level3}{HTML}{%s}
\\definecolor{level4}{HTML}{%s}
\\definecolor{level5}{HTML}{%s}
\\definecolor{level6}{HTML}{%s}
\\definecolor{level7}{HTML}{%s}
\\definecolor{level8}{HTML}{%s}

\\addtokomafont{title}{\\color{documentTitle}}
\\addtokomafont{author}{\\color{documentInfo}}
\\addtokomafont{date}{\\color{documentInfo}}
\\addtokomafont{section}{\\color{level1}}
\\newkomafont{sectionprefix}{\\color{level1}}
\\addtokomafont{subsection}{\\color{level2}}
\\newkomafont{subsectionprefix}{\\color{level2}}
\\addtokomafont{subsubsection}{\\color{level3}}
\\newkomafont{subsubsectionprefix}{\\color{level3}}
\\addtokomafont{paragraph}{\\color{level4}}
\\newkomafont{paragraphprefix}{\\color{level4}}
\\addtokomafont{subparagraph}{\\color{level5}}
\\newkomafont{subparagraphprefix}{\\color{level5}}
"
         (mapcar (lambda (hex) (substring hex 1))
                 (list
                  (face-attribute 'org-document-title :foreground nil 'default)
                  (face-attribute 'org-document-info :foreground nil 'default)
                  (face-attribute 'outline-1 :foreground nil 'default)
                  (face-attribute 'outline-2 :foreground nil 'default)
                  (face-attribute 'outline-3 :foreground nil 'default)
                  (face-attribute 'outline-4 :foreground nil 'default)
                  (face-attribute 'outline-5 :foreground nil 'default)
                  (face-attribute 'outline-6 :foreground nil 'default)
                  (face-attribute 'outline-7 :foreground nil 'default)
                  (face-attribute 'outline-8 :foreground nil 'default)))))

(defun ox-chameleon--generate-beamer-colourings ()
  (format
   "
%% beamer

\\definecolor{builtin}{HTML}{%s}

\\NewCommandCopy{\\oldusetheme}{\\usetheme}
\\renewcommand*{\\usetheme}[2][]{\\oldusetheme[#1]{#2}
  \\setbeamercolor{normal text}{fg=ofg, bg=obg}
  \\setbeamercolor{alerted text}{fg=builtin}
  \\setbeamercolor{progress bar}{fg=builtin}
  \\setbeamercolor{title separator}{fg=builtin}
  \\setbeamercolor{progress bar in head/foot}{fg=builtin}
  \\setbeamercolor{progress bar in section page}{fg=builtin}}
"
   (substring (face-attribute 'font-lock-builtin-face :foreground nil 'default) 1)))

(defun ox-chameleon--generate-beamer-list-colourings ()
  (format "
%% beamer list labels

\\definecolor{itemlabel}{HTML}{%s}
\\setbeamercolor*{item}{fg=itemlabel}
"
          (substring (face-attribute 'org-list-dt :foreground nil 'default) 1)))

(provide 'ox-chameleon)
;;; ox-chameleon.el ends here
