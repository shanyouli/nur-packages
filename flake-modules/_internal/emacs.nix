{inputs, ...}: {
  flake.overlays.emacs = final: prev: {
    emacsGit = inputs.emacs-overlay.packages.emacs-git;
    emacs = inputs.emacs-overlay.packages.emacs-unstable;
  };
  perSystem = {inputs', ...}: {
    packages.emacsGit = inputs'.emacs-overlay.packages.emacs-git;
    packages.emacs = inputs'.emacs-overlay.packages.emacs-unstable;
  };
}
