#include <lauxlib.h>
#include <lualib.h>
#include <stdio.h>
#include <string.h>

// constant helpers which cannot be passed to `Ctypes.Foreign.constant`

#pragma inline
extern char *lua_version_helper(void) { return LUA_VERSION; }
#pragma inline
extern char *lua_version_major_helper(void) { return LUA_VERSION_MAJOR; }

#pragma inline
extern char *lua_version_minor_helper(void) { return LUA_VERSION_MINOR; }

#pragma inline
extern char *lua_version_release_helper(void) { return LUA_VERSION_RELEASE; }

#pragma inline
extern char *lua_release_helper(void) { return LUA_RELEASE; }

#pragma inline
extern char *lua_copyright_helper(void) { return LUA_COPYRIGHT; }

#pragma inline
extern char *lua_authors_helper(void) { return LUA_AUTHORS; }

#pragma inline
extern char *lua_signature_helper(void) { return LUA_SIGNATURE; }

#pragma inline
extern int luaL_newlibtable_helper(lua_State *L, const luaL_Reg *l, int nup) {
  luaL_Reg regs[nup];
  memcpy(regs, l, nup * sizeof(luaL_Reg));
  luaL_newlibtable(L, regs);
  return 0;
}

#pragma inline
extern int luaL_error_helper(lua_State *L, const char *fmt, const char **args,
                             int num_args) {
  // Create a buffer to hold the formatted message
  char buffer[1024];
  int offset = 0;

  // Format the message using the format string and the array of arguments
  for (int i = 0; i < num_args; i++) {
    offset += snprintf(buffer + offset, sizeof(buffer) - offset, fmt, args[i]);
    if (offset >= sizeof(buffer)) {
      // Buffer overflow protection
      break;
    }
  }

  // Call luaL_error with the formatted message
  return luaL_error(L, "%s", buffer);
}
