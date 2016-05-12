;;; paradox-mode.el --- Major mode for editing Paradox mod files

;; Copyright (C) 2016 Gabriel Radanne
;; Licensed under the GNU General Public License.

;; Author: Gabriel Radanne
;; Keywords: paradox modding
;; Version: 0.1.0
;; URL: https://github.com/Drup/paradox.el

;; This file is *NOT* part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

(require 'rx)
(require 'smie)

(defgroup paradox nil
  "Major mode to edit Paradox modding files."
  :group 'languages)

(defcustom paradox-mode-hook nil
  "Hook called after `paradox-mode' is initialized."
  :type 'hook
  :group 'paradox)

(defvar paradox-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map [(backspace)] 'backward-delete-char-untabify)
    (define-key map [remap newline-and-indent] 'tuareg-newline-and-indent)
    map)
  "Keymap for Paradox major mode")

(defconst paradox-mode-quoted-string-re
  (rx (group (char ?\")
             (0+ (not (any ?\")))
             (char ?\"))))
(defconst paradox-mode-number-re
  (rx (group (optional ?\-)
             (1+ digit)
             (optional ?\. (1+ digit)))))
(defconst paradox-mode-keyword-re
  (rx (group (or "yes" "no"))))

(defvar paradox-font-lock-keywords
  (list
   (list paradox-mode-quoted-string-re 1 font-lock-string-face)
   (list paradox-mode-keyword-re 1 font-lock-keyword-face)
   (list paradox-mode-number-re 1 font-lock-constant-face)
   )
  "Keyword highlighting specification for `paradox-mode'.")

(defvar paradox-syntax-table
  (let ((st (make-syntax-table)))

    (modify-syntax-entry ?\{ "(}" st)
    (modify-syntax-entry ?\} "){" st)

    ; Comment starts with # and ends in newline
    (modify-syntax-entry ?#  "<" st)
    (modify-syntax-entry ?\n ">" st)

    ;; Make things simpler with floating numbers
    (modify-syntax-entry ?. "_" st)

    st)
  "Syntax table for paradox-mode")

;; Indentation
;; Similar to json modes
(defconst paradox-grammar
  (smie-prec2->grammar
    (smie-bnf->prec2
     '((prim)
       (object ("{" decl "}"))
       (decl (prim "=" elem))
       (elem (object) (prim)))
     )))
(defun paradox-smie-rules (kind token)
  (pcase (cons kind token)
    (`(:elem . args) (- (current-indentation) (current-column)))
    (`(:elem . basic) tab-width)
    ))

(define-derived-mode paradox-mode prog-mode "Paradox"
  "Major mode for editing Paradox files"

  :syntax-table paradox-syntax-table

  (setq-local font-lock-defaults '(paradox-font-lock-keywords))

  ;; Paradox files are indented with tabs
  (setq-default indent-tabs-mode t)

  ;; Comments
  (setq-local comment-start "#")
  (setq-local comment-end "")
  (setq-local comment-start-skip "#+\\s-*")

  (smie-setup paradox-grammar #'paradox-smie-rules)
  (setq-local electric-indent-chars '( ?\n ?} ?{ ))

  (run-mode-hooks 'paradox-mode-hook)
  )

(provide 'paradox)
