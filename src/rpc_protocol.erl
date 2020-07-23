-module(rpc_protocol).
-export([encode/3,encode/1,decode/2]).
-export([new/0]).

-record(rpc_protocol,{ buffer}).

new() ->
  #rpc_protocol{
     buffer = <<>>
    }.

%% int
%% packet lengh: 4
%% module name length: 2
%% module name: variable
%% function name length: 2
%% function name: variable
%% parameter size: 4
%% parameters ....
-spec encode(atom(),atom(),list()) -> binary().
encode(Module,Function,Params)->
  Module0 = erlang:atom_to_binary(Module, utf8),
  Function0 = erlang:atom_to_binary(Function, utf8),
  ParamSize = erlang:length(Params),
  ModuleLen = erlang:byte_size(Module0),
  FunctionLen = erlang:byte_size(Function0),
  E = <<ModuleLen:16/big-integer,Module0/binary,
        FunctionLen:16/big-integer,Function0/binary,
        ParamSize:32/big-integer>>,
  E0 = lists:foldl(fun(Param,Acc)->
                       <<Acc/binary,Param/big-integer>>
                   end,E,Params),
  ELen = erlang:byte_size(E0) + 1,
  <<ELen:32/big-integer,0:8/big-integer,E0/binary>>.

-spec encode(integer()) -> binary().
encode(Result)->
  Result0 = erlang:integer_to_binary(Result),
  ELen = erlang:byte_size(Result0) + 1,
  <<ELen:32/big-integer,1:8/big-integer,Result0/binary>>.

-spec decode(binary(),term())-> {list(),term()}.
decode(Packet,#rpc_protocol{buffer = Buffer})->
  Buffer0 = <<Buffer/binary,Packet/binary>>,
  {Requests,Rem} = decode(Buffer0),
  {Requests,#rpc_protocol{buffer = Rem}}.

decode(Buffer)->
  decode_buffer(Buffer,[]).
decode_buffer(<<>>,Acc) ->
  {lists:reverse(Acc),<<>>};
decode_buffer(<<Len:32/big-integer,Payload/binary>> = Buffer,Acc)
  when erlang:byte_size(Payload) < Len ->
  {lists:reverse(Acc),Buffer};
decode_buffer(<<Len:32/big-integer,Type:8/big-integer,Payload/binary>>,Acc)->
  decode_buffer(Len,Type,Payload,Acc).

decode_buffer(_,0, Payload,Acc)->
  <<ModuleLen:16/big-integer,Module:ModuleLen/binary,
    FunctionLen:16/big-integer,Function:FunctionLen/binary,
    ParamSize:32/big-integer,Rest/binary>> = Payload,
  {Params,Rest0} = lists:foldl(
                     fun(_,{ParamsAcc,Binary})->
                         <<Param/big-integer,Binary0/binary>> = Binary,
                         {[Param|ParamsAcc],Binary0}
                     end,{[],Rest}, lists:seq(0,ParamSize - 1)),
  decode_buffer(Rest0,[{erlang:binary_to_atom(Module, utf8),
                        erlang:binary_to_atom(Function,utf8),
                        lists:reverse(Params)
                       }|Acc]);
decode_buffer(Len,1,Payload,Acc) ->
  Len0 = (Len - 1) * 8,
  <<Result:Len0/bits,Rest/bits>> = Payload,
  decode_buffer(Rest,[erlang:binary_to_integer(Result)|Acc]).
