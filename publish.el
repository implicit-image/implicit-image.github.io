
(if (bound-and-true-p straight-use-package-mode)
    (error "straight active")
  (princ "publishing..."))

(setq user-emacs-directory "~/.emacs.script" )

(require 'package)

(add-to-list 'package-archives
             '("elpy" . "http://jorgenschaefer.github.io/packages/"))

(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)

(add-to-list 'load-path (format "%s/site-lisp/" user-emacs-directory))
(package-initialize)

(use-package htmlize
  :ensure t)

(use-package ox-html)
(use-package ox-publish)

(setq debug-on-error t)

;; sitemap entry format function
(defun +org-publish-sitemap-custom-entry (entry style project)
  "Format PROJECT sitemap ENTRY in STYLE.  Add first 100 characters, FILE tags,\
publish date, edit date and author."
  (if (eq style 'list)
      (let ((title (or (org-publish-find-title entry project) entry))
            (tags (apply 'concat (org-export-get-tags entry project)))
            (date (org-publish-find-date entry project))
            (author (org-publish-property :author project))
            (email (org-publish-property :email project))
            (header (or (org-element-property :contents (org-element-parent-element entry)) "")))
        (format (concat "- %s \n"
                        "- tags: %s\n"
                        "- published: %s\n"
                        "- by %s\n"
                        "- %s")
                title tags date author email header)))
  (org-publish-sitemap-default-entry entry style project))


(defun make-item (type _depth &optional c)
  (concat (if (eq _depth 1)
              "#+ATTR_HTML: class:sitemap-entry\n* "
            "- ")
          (and c (format "[@%d] " (car (string-split c "\n"))))))

(defun make-subitem (type _depth &optional c)
  (and c (format "- [@%d] " (car (string-split c "\n")))))

(defun +org-publish-make-sitemap (title list)
  (concat "#+TITLE: " title "\n"
          "#+OPTIONS: toc:nil" "\n\n"
          ;; (format "%S" list)))
          (org-list-to-org list)))

;; preamble
(setq website-default-html-preamble "
<ul class=\"navigation\">
<li><a href=\"/index.html\">about</a></li>
<li><a href=\"/projects.html\">projects</a></li>
<li><a href=\"/writing.html\">writing</a></li>
<li><a href=\"/theindex.html\">index</a></li>
</ul>"
      website-default-html-postamble "")

(setq org-html-htmlize-output-type 'css)

(setq project-info
      `("posts"
        :author "Błażej Niewiadomski"
        :email "blaz.nie@protonmail.com"
        :base-directory "./src"
        :base-extension "org"
        :recursive t
        :publishing-directory "./dist"
        :publishing-function org-html-publish-to-html
        :with-author t
        :with-creator nil
        :with-date t
        :with-email nil
        :with-emphasize t
        :with-entities t
        :with-latex t
        :with-sub-superscript t
        :with-tags t
        :with-title t
        :with-toc t
        :section-numbers nil
        :headline-levels 1
        :html-head ,(concat "<link rel=\"stylesheet\" href=\"/css/style.css\">\n"
                            "<script src=\"/js/org.js\" defer></script>")
        :html-preamble ,website-default-html-preamble
        :html-postamble ,website-default-html-postamble
        :html5-fancy t
        :html-inline-images t
        :auto-sitemap t
        :sitemap-style list
        :sitemap-sort-file chronologically
        :sitemap-format-entry +org-publish-sitemap-custom-entry
        :sitemap-function +org-publish-make-sitemap
        :makeindex t))

(org-publish-project project-info t)
