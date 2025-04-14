#include <lauxlib.h>
#include <lualib.h>

extern char *lua_version_helper(void);
extern char *lua_version_major_helper(void);
extern char *lua_version_minor_helper(void);
extern char *lua_version_release_helper(void);
extern char *lua_release_helper(void);
extern char *lua_copyright_helper(void);
extern char *lua_authors_helper(void);
extern char *lua_signature_helper(void);

extern int luaL_newlibtable_helper(lua_State *L, const luaL_Reg *l, int nup);
extern int luaL_error_helper(lua_State *L, const char *fmt, const char **args,
                             int num_args);
