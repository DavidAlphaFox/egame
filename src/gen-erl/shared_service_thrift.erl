%%
%% Autogenerated by Thrift Compiler (0.11.0)
%%
%% DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
%%

-module(shared_service_thrift).
-behaviour(thrift_service).


-include("shared_service_thrift.hrl").

-export([struct_info/1, function_info/2, function_names/0]).

struct_info(_) -> erlang:error(function_clause).
%%% interface
% getStruct(This, Key)
function_info('getStruct', params_type) ->
  {struct, [{1, i32}]}
;
function_info('getStruct', reply_type) ->
  {struct, {'shared_types', 'SharedStruct'}};
function_info('getStruct', exceptions) ->
  {struct, []}
;
function_info(_Func, _Info) -> erlang:error(function_clause).

function_names() -> 
  ['getStruct'].

