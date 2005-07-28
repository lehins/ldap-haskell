{- -*- Mode: haskell; -*-
Haskell LDAP Interface
Copyright (C) 2005 John Goerzen <jgoerzen@complete.org>

This code is under a 3-clause BSD license; see COPYING for details.
-}

import Data.Char
import Data.List

const2HS (x:xs) =
    x : c2hs xs
    where c2hs [] = []
          c2hs ('_':x:xs) = x : c2hs xs
          c2hs (x:xs) = toLower x : c2hs xs

getC const = "#{const " ++ const ++ "}"

errorClause =
    "data LDAPErrorCode = \n " ++
    concat (intersperse "\n |" (map toDecl errorConsts)) ++
    "\n deriving (Eq, Bounded, Show)" ++
    "\n\ninstance Enum LDAPErrorCode where\n" ++
    concat (intersperse "\n" (map toenums errorConsts)) ++
    "\n toEnum x = error $ \"Code \" ++ show x ++ \" is not a valid LDAPErrorCode\"\n" ++
    "\n" ++ concat (intersperse "\n" (map fromenums errorConsts)) ++ "\n" ++
    "instance Ord LDAPErrorCode where\n" ++
    " compare x y = compare (fromEnum x) (fromEnum y)\n\n"
    where
    toDecl = const2HS
    toenums i = 
        " toEnum " ++ getC i ++ " = " ++ (const2HS i)
    fromenums i = 
        " fromEnum " ++ (const2HS i) ++ " = " ++ getC i

modHeader = "module LDAP.Data (module LDAP.Data) where\n\n#include \"ldap.h\"\n\n"

main = 
    do putStrLn modHeader
       putStrLn errorClause

errorConsts = [
      "LDAP_SUCCESS", "LDAP_OPERATIONS_ERROR", "LDAP_PROTOCOL_ERROR", 
      "LDAP_TIMELIMIT_EXCEEDED", "LDAP_SIZELIMIT_EXCEEDED", "LDAP_COMPARE_FALSE", 
      "LDAP_COMPARE_TRUE", "LDAP_AUTH_METHOD_NOT_SUPPORTED", 
      "LDAP_STRONG_AUTH_NOT_SUPPORTED", "LDAP_STRONG_AUTH_REQUIRED", 
      "LDAP_PARTIAL_RESULTS", "LDAP_REFERRAL", "LDAP_ADMINLIMIT_EXCEEDED", 
      "LDAP_UNAVAILABLE_CRITICAL_EXTENSION", "LDAP_CONFIDENTIALITY_REQUIRED", 
      "LDAP_SASL_BIND_IN_PROGRESS", "LDAP_NO_SUCH_ATTRIBUTE", "LDAP_UNDEFINED_TYPE",
      "LDAP_INAPPROPRIATE_MATCHING", "LDAP_CONSTRAINT_VIOLATION", 
      "LDAP_TYPE_OR_VALUE_EXISTS", "LDAP_INVALID_SYNTAX", "LDAP_NO_SUCH_OBJECT",
      "LDAP_ALIAS_PROBLEM", "LDAP_INVALID_DN_SYNTAX", "LDAP_IS_LEAF",
      "LDAP_ALIAS_DEREF_PROBLEM", "LDAP_PROXY_AUTHZ_FAILURE",
      "LDAP_INAPPROPRIATE_AUTH", "LDAP_INVALID_CREDENTIALS", 
      "LDAP_INSUFFICIENT_ACCESS", "LDAP_BUSY", "LDAP_UNAVAILABLE", 
      "LDAP_UNWILLING_TO_PERFORM", "LDAP_LOOP_DETECT", 
      "LDAP_NAMING_VIOLATION", "LDAP_OBJECT_CLASS_VIOLATION", 
      "LDAP_NOT_ALLOWED_ON_NONLEAF", "LDAP_NOT_ALLOWED_ON_RDN",
      "LDAP_ALREADY_EXISTS", "LDAP_NO_OBJECT_CLASS_MODS",
      "LDAP_RESULTS_TOO_LARGE", "LDAP_AFFECTS_MULTIPLE_DSAS",
      "LDAP_OTHER", "LDAP_SERVER_DOWN", "LDAP_LOCAL_ERROR", "LDAP_ENCODING_ERROR",
      "LDAP_DECODING_ERROR", "LDAP_TIMEOUT", "LDAP_AUTH_UNKNOWN",
      "LDAP_FILTER_ERROR", "LDAP_USER_CANCELLED", "LDAP_PARAM_ERROR",
      "LDAP_NO_MEMORY", "LDAP_CONNECT_ERROR",
      "LDAP_NOT_SUPPORTED", "LDAP_CONTROL_NOT_FOUND", "LDAP_NO_RESULTS_RETURNED",
      "LDAP_MORE_RESULTS_TO_RETURN", "LDAP_CLIENT_LOOP", 
      "LDAP_REFERRAL_LIMIT_EXCEEDED"]