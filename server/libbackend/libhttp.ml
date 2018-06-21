open Core_kernel
open Libexecution

open Runtime
open Lib

let fns : Lib.shortfn list = [
  { pns = ["Http::respond"]
  ; ins = []
  ; p = [par "response" TAny; par "code" TInt]
  ; r = TResp
  ; d = "Respond with HTTP status `code` and `response` body"
  ; f = InProcess
        (function
          | (_, [dv; DInt code]) -> DResp (Response (code, []), dv)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;
  (* TODO(ian): merge Http::respond with Http::respond_with_headers
   * -- need to figure out how to deprecate functions w/o breaking
   * user code
   *)

  { pns = ["Http::respondWithHeaders"]
  ; ins = []
  ; p = [par "response" TAny; par "headers" TObj; par "code" TInt]
  ; r = TResp
  ; d = "Respond with HTTP status `code` and `response` body and `headers` headers"
  ; f = InProcess
        (function
          | (_, [dv; DObj _ as obj; DInt code]) ->
            let pairs = Dval.to_string_pairs obj in
            DResp (Response (code, pairs), dv)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::success"]
  ; ins = []
  ; p = [par "response" TAny]
  ; r = TResp
  ; d = "Respond with HTTP status 200 and `response` body"
  ; f = InProcess
        (function
          | (_, [dv]) -> DResp (Response (200, []), dv)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::respondWithHtml"]
  ; ins = []
  ; p = [par "response" TAny; par "code" TInt]
  ; r = TResp
  ; d = "Respond with HTTP status `code` and `response` body, with `content-type` set to \"text/html\""
  ; f = InProcess
        (function
          | (_, [dv; DInt code]) -> DResp (Response (code, ["Content-Type", "text/html"]), dv)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }
  ;

  { pns = ["Http::respondWithJson"]
  ; ins = []
  ; p = [par "response" TAny; par "code" TInt]
  ; r = TResp
  ; d = "Respond with HTTP status `code` and `response` body, with `content-type` set to \"application/json\""
  ; f = InProcess
        (function
          | (_, [dv; DInt code]) -> DResp (Response (code, ["Content-Type", "application/json"]), dv)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }
  ;

  { pns = ["Http::redirectTo"]
  ; ins = []
  ; p = [par "url" TStr]
  ; r = TResp
  ; d = "Redirect to url"
  ; f = InProcess
        (function
          | (_, [DStr url]) -> DResp (Redirect url, DNull)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::badRequest"]
  ; ins = []
  ; p = [par "error" TStr]
  ; r = TResp
  ; d = "Respond with a 400 and an error message"
  ; f = InProcess
        (function
          | (_, [DStr msg]) -> DResp (Response (400, []), DStr msg)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::notFound"]
  ; ins = []
  ; p = []
  ; r = TResp
  ; d = "Respond with 404 Not Found"
  ; f = InProcess
        (function
          | (_, []) -> DResp (Response (404, []), DNull)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::unauthorized"]
  ; ins = []
  ; p = []
  ; r = TResp
  ; d = "Respond with 401 Unauthorized"
  ; f = InProcess
        (function
          | (_, []) -> DResp (Response (401, []), DNull)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

  ;

  { pns = ["Http::forbidden"]
  ; ins = []
  ; p = []
  ; r = TResp
  ; d = "Respond with 403 Forbidden"
  ; f = InProcess
        (function
          | (_, []) -> DResp (Response (403, []), DNull)
          | (_, args) -> fail args)
  ; pr = None
  ; ps = true
  }

]
