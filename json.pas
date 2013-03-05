
unit JSon;
interface

{
  Automatically converted by H2Pas 1.0.0 from json.h
  The following command line parameters were used:
    -d
    -c
    -p
    -S
    -o
    json.pas
    -u
    JSon
    json.h
}

{$IFDEF FPC}
{$calling cdecl}
{$DEFINE DELPHI}
{$PACKRECORDS C}
{$ENDIF}

type
  Pbyte = ^byte;
  Pword = ^word;
  Pcardinal = ^cardinal;
{$IFDEF __GPC__}
  size_t = SizeType;
{$ELSE}
  size_t = PtrUInt;
{$ENDIF}

const
  JSON_MAJOR = 1;
  JSON_MINOR = 0;
  JSON_VERSION = (JSON_MAJOR * 100 + JSON_MINOR);

    type
      Pjson_type = ^json_type;
      json_type = (JSON_NONE,JSON_ARRAY_BEGIN,JSON_OBJECT_BEGIN,
        JSON_ARRAY_END,JSON_OBJECT_END,JSON_INT,
        JSON_FLOAT,JSON_STRING,JSON_KEY,JSON_TRUE,
        JSON_FALSE,JSON_NULL);

      Pjson_error = ^json_error;
      json_error = (JSON_ERROR_OK, JSON_ERROR_NO_MEMORY,JSON_ERROR_BAD_CHAR,
        JSON_ERROR_POP_EMPTY,JSON_ERROR_POP_UNEXPECTED_MODE,
        JSON_ERROR_NESTING_LIMIT,JSON_ERROR_DATA_LIMIT,
        JSON_ERROR_COMMENT_NOT_ALLOWED,JSON_ERROR_UNEXPECTED_CHAR,
        JSON_ERROR_UNICODE_MISSING_LOW_SURROGATE,
        JSON_ERROR_UNICODE_UNEXPECTED_LOW_SURROGATE,
        JSON_ERROR_COMMA_OUT_OF_STRUCTURE,
        JSON_ERROR_CALLBACK,JSON_ERROR_UTF8
        );

    const
      LIBJSON_DEFAULT_STACK_SIZE = 256;
      LIBJSON_DEFAULT_BUFFER_SIZE = 4096;

    type
      json_parser_callback = function (userdata:pointer; _type:longint; data:Pchar; _length:cardinal):longint;

      json_printer_callback = function (userdata:pointer; s:Pchar; _length:cardinal):longint;

      Pjson_config = ^json_config;
      json_config = record
          buffer_initial_size : cardinal;
          max_nesting : cardinal;
          max_data : cardinal;
          allow_c_comments : longint;
          allow_yaml_comments : longint;
          user_calloc : function (nmemb:size_t; size:size_t):pointer;
          user_realloc : function (_ptr:pointer; size:size_t):pointer;
        end;

      Pjson_parser = ^json_parser;
      json_parser = record
          config : json_config;
          callback : json_parser_callback;
          userdata : pointer;
          state : byte;
          save_state : byte;
          expecting_key : byte;
          utf8_multibyte_left : byte;
          unicode_multi : word;
          _type : json_type;
          stack : Pbyte;
          stack_offset : cardinal;
          stack_size : cardinal;
          buffer : Pchar;
          buffer_size : cardinal;
          buffer_offset : cardinal;
        end;

      Pjson_printer = ^json_printer;
      json_printer = record
          callback : json_printer_callback;
          userdata : pointer;
          indentstr : Pchar;
          indentlevel : longint;
          afterkey : longint;
          enter_object : longint;
          first : longint;
        end;

function json_parser_init(parser:Pjson_parser; cfg:Pjson_config; callback:json_parser_callback; userdata:pointer):json_error;external 'json';

function json_parser_free(parser:Pjson_parser):longint;external 'json';

function json_parser_string(parser:Pjson_parser; _string:Pchar; _length:cardinal; processed:Pcardinal):json_error;external 'json';

function json_parser_char(parser:Pjson_parser; next_char:char):json_error;external 'json';

function json_parser_is_done(parser:Pjson_parser):bytebool;external 'json';

function json_print_init(printer:Pjson_printer; callback:json_printer_callback; userdata:pointer):longint;external 'json';

function json_print_free(printer:Pjson_printer):longint;external 'json';

function json_print_pretty(printer:Pjson_printer; _type:longint; data:Pchar; _length:cardinal):longint;external 'json';

function json_print_raw(printer:Pjson_printer; _type:longint; data:Pchar; _length:cardinal):longint;external 'json';

type
  json_print_args_callback = function(_para1:pjson_printer;_para2:longint;_para3:pchar;_para4:cardinal):longint;

{$IFDEF DELPHI}
function json_print_args(_para1:Pjson_printer; f:json_print_args_callback; args:array of const):longint;external 'json';
{$ELSE}
{$IFDEF __GPC__}
function json_print_args(_para1:Pjson_printer; f:json_print_args_callback; ...):longint;external 'json';
{$ENDIF}
{$ENDIF}

    type
      Pjson_parser_dom_create_structure = ^json_parser_dom_create_structure;
      json_parser_dom_create_structure = function (_para1:longint; _para2:longint):pointer;

      Pjson_parser_dom_create_data = ^json_parser_dom_create_data;
      json_parser_dom_create_data = function (_para1:longint; _para2:Pchar; _para3:cardinal):pointer;

      json_parser_dom_append = function (_para1:pointer; _para2:Pchar; _para3:cardinal; _para4:pointer):longint;

      PStackRec = ^TStackRec;
      TStackRec = record
        _val: pointer;
        key: Pchar;
        key_length: cardinal;
      end;
      Pjson_parser_dom = ^json_parser_dom;
      json_parser_dom = record
          stack : PStackRec;
          stack_size : cardinal;
          stack_offset : cardinal;
          user_calloc : function (nmemb:size_t; size:size_t):pointer;
          user_realloc : function (_ptr:pointer; size:size_t):pointer;
          root_structure : pointer;
          create_structure : json_parser_dom_create_structure;
          create_data : json_parser_dom_create_data;
          _append : json_parser_dom_append;
        end;

function json_parser_dom_init(helper:Pjson_parser_dom; create_structure:json_parser_dom_create_structure; create_data:json_parser_dom_create_data; _append:json_parser_dom_append):longint;external 'json';

function json_parser_dom_free(ctx:Pjson_parser_dom):longint;external 'json';

function json_parser_dom_callback(userdata:pointer; _type:longint; data:Pchar; _length:cardinal):longint;external 'json';

implementation

end.
