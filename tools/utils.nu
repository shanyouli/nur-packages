# Shared helpers for the `ci` / `devci` apps generated in nix/commands.nix.
# The generated scripts load this module via `use <store-path> *`; only
# run-build / fix-hashes are exported. Callers must prepend the bin dirs of
# nix-fast-build and gnused to $env.PATH before invoking them.

# Pad an incomplete version string ("2", "2.20") into a 3-part semver string
def to-semver-str []: string -> string {
  let v = $in
  let parts = ($v | split row ".")
  match ($parts | length) {
    1 => { $"($parts.0).0.0" }
    2 => { $"($parts.0).($parts.1).0" }
    _ => { $v }
  }
}

# Check whether the current nix version is >= the given one (e.g. 2.20.0).
# Uses builtins.nixVersion instead of parsing the `nix --version` banner: the
# banner reports the implementation's own version (e.g. Lix 2.94), while
# builtins.nixVersion reports the compatible Nix version (e.g. "2.18.3-lix"),
# which matches the actually available CLI surface (`nix hash convert` only
# exists in Nix >= 2.20, while Lix only ships `nix hash to-base32`).
def nixVersion>= [v: string]: nothing -> bool {
  let cur_str = (nix eval --raw --expr builtins.nixVersion | str trim)
  # keep the leading semver only: Lix appends "-lix", dev builds "pre..."
  let cur = ($cur_str | parse --regex '^(?<v>\d+\.\d+(?:\.\d+)?)' | get v | first | to-semver-str | split row "." | each { into int })
  let tgt = ($v | to-semver-str | split row "." | each { into int })
  $cur.0 > $tgt.0 or (
    $cur.0 == $tgt.0 and (
      $cur.1 > $tgt.1 or (
        $cur.1 == $tgt.1 and $cur.2 >= $tgt.2
      )
    )
  )
}

# Run nix-fast-build on .#packages.<system> (or a single --pkg) and return its exit code
export def run-build [
  system: string  # flake system, e.g. x86_64-linux
  logfile: string # file to save the build log to
  --pkg: string   # build only .#packages.<system>.<pkg>
  --debug         # pass --debug to nix-fast-build
]: nothing -> int {
  let target = if $pkg == null {
    $".#packages.($system)"
  } else {
    $".#packages.($system).($pkg)"
  }
  let debug_args = (if $debug { ["--debug"] } else { [] })
  try {
    nix-fast-build -f $target --skip-cached --no-nom ...$debug_args out+err>| tee { save -f $logfile }
    $env.LAST_EXIT_CODE
  } catch {
    $env.LAST_EXIT_CODE
  }
}

# Handle a failed nix-fast-build run: extract the "specified:"/"got:" hashes
# from the log and rewrite the old hashes (nix32 form included) inside
# pkgs/**/*.nix. Exits with 1 when the log contains no hash (non-hash error).
export def fix-hashes [logfile: string, exit_code: int] {
  print $"nix-fast-build failed with exit code ($exit_code), Will check HASH"
  let SPECIFIED_HASH = (grep "specified:" $logfile | lines | each {|line| $line | split row ":" | get 1 | str trim})
  if ($SPECIFIED_HASH | is-empty) {
    print $"Please check the script for problems, non-hash errors"
    # rm -rf $logfile
    exit 1
  }
  let GOT_HASH = (grep "got:" $logfile | lines | each {|line| $line | split row ":" | get 1 | str trim})
  for i in 0..(($SPECIFIED_HASH | length) - 1) {
    let old_hash = $SPECIFIED_HASH | get $i
    let new_hash = $GOT_HASH | get $i
    let old_hashx = (if (nixVersion>= 2.20.0) {
          nix hash convert --to nix32 $old_hash
        } else {
          nix hash to-base32 $old_hash
        })
    print $"::group::Auto replace ($old_hash) with ($new_hash)"
    for f in (^find pkgs -name "*.nix" | lines) {
      if (open $f | str contains $old_hash) {
        sed -i $"s#($old_hash)#($new_hash)#g" $f
      } else if (open $f | str contains $old_hashx) {
        sed -i $"s#($old_hashx)#($new_hash)#g" $f
      }
    }
    print "::endgroup::"
  }
  # rm -f $logfile
}
