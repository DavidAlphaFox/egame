-module(egame).
%% API
-export([start/0]).

start() ->
  ok = application:start(crypto),
  ok = application:start(asn1),
  ok = application:start(public_key),
  ok = application:start(ssl),
  ok = application:start(inets),
  ok = application:start(xmerl),
    %% cowboy
  ok = application:start(ranch),
  ok = application:start(cowlib),
  ok = application:start(cowboy),

  ok = application:start(jiffy),
  ok = application:start(bcrypt),

  ok = application:start(ailib),
  ok = application:start(aiconf),
  ok = application:start(aicow),
  ok = application:start(egame).
