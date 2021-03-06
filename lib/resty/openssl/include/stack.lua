--[[
  The OpenSSL stack library. Note `safestack` is not usable here in ffi because
  those symbols are eaten after preprocessing.
  Instead, we should do a Lua land type checking by having a nested field indicating
  which type of cdata its ctx holds.
]]

local ffi = require "ffi"
local C = ffi.C

require "resty.openssl.include.ossl_typ"
local OPENSSL_10 = require("resty.openssl.version").OPENSSL_10
local OPENSSL_11 = require("resty.openssl.version").OPENSSL_11

local _M = {}

if OPENSSL_11 then
  ffi.cdef [[
    typedef struct stack_st OPENSSL_STACK;

    OPENSSL_STACK *OPENSSL_sk_new_null(void);
    int OPENSSL_sk_push(OPENSSL_STACK *st, const void *data);
    void OPENSSL_sk_pop_free(OPENSSL_STACK *st, void (*func) (void *));
    int OPENSSL_sk_num(const OPENSSL_STACK *);
    void *OPENSSL_sk_value(const OPENSSL_STACK *, int);
  ]]
  _M.OPENSSL_sk_pop_free = C.OPENSSL_sk_pop_free

  _M.OPENSSL_sk_new_null = C.OPENSSL_sk_new_null
  _M.OPENSSL_sk_push = C.OPENSSL_sk_push
  _M.OPENSSL_sk_pop_free = C.OPENSSL_sk_pop_free
  _M.OPENSSL_sk_num = C.OPENSSL_sk_num
  _M.OPENSSL_sk_value = C.OPENSSL_sk_value
elseif OPENSSL_10 then
  ffi.cdef [[
    typedef struct stack_st _STACK;
    // i made this up
    typedef struct stack_st OPENSSL_STACK;

    _STACK *sk_new_null(void);
    int sk_push(_STACK *st, void *data);
    void sk_pop_free(_STACK *st, void (*func) (void *));
    int sk_num(const _STACK *);
    void *sk_value(const _STACK *, int);
  ]]
  _M.OPENSSL_sk_pop_free = C.sk_pop_free

  _M.OPENSSL_sk_new_null = C.sk_new_null
  _M.OPENSSL_sk_push = C.sk_push
  _M.OPENSSL_sk_pop_free = C.sk_pop_free
  _M.OPENSSL_sk_num = C.sk_num
  _M.OPENSSL_sk_value = C.sk_value
end


return _M
