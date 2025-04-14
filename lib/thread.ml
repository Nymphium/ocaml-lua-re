type status =
  | OK
  | YIELD
  | ERRRUN
  | ERRSYNTAX
  | ERRMEM
  | ERRGCMM
  | ERRERR
[@@deriving show, enum, eq]
