# Emacs mode to edit [paradox](http://wikis.paradoxplaza.com/) mod files

Tested with stellaris, but should work fine with EU4 and CK2 too.

To install, copy `paradox.el` in `~/.emacs.d/lisp/` and put in your `.emacs`:
```elisp
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'paradox)

;; Spellchecking in comments and strings
(add-hook 'paradox-mode-hook 'flyspell-prog-mode)
```

You can use [local variables][] to make it load automatically. Put in your mod files:

```
# Local Variables:
# mode: paradox
# End:
```
[local variables]:https://www.gnu.org/software/emacs/manual/html_mono/elisp.html#File-Local-Variables
