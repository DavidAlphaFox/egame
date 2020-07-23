-module(rpc_server).
-export([start_server/1,
         start_link/4,
         init/2]).


-record(state,{transport,
               socket,
               buffer}).

start_server(Port)->
  ranch:start_listener(?MODULE,ranch_tcp,
                       [{port, Port}],
                       ?MODULE,undefined).

start_link(Ref, _Socket,Transport,_Opts) ->
  Pid = spawn_link(?MODULE, init, [Ref, Transport]),
  {ok, Pid}.

init(Ref, Transport) ->
  {ok, Socket} = ranch:handshake(Ref),
  Buffer = rpc_protocol:new(),
  loop(#state{transport = Transport,
              socket = Socket,
              buffer = Buffer}).

loop(ok) -> ok;
loop(#state{transport = Transport,
           socket = Socket} = State)->
  {OK, Closed, Error} = Transport:messages(),
  Transport:setopts(Socket,[{active,once}]),
  Result =
    receive
      {OK, Socket, Data} ->
        {Resp,State0} = handle_data(Data,State),
        reply(Resp,State0);
      {Closed, Socket}-> ok;
      {Error, Socket, _Reason}-> ok
    end,
  loop(Result).

handle_data(Data,#state{buffer = Buffer} = State)->
  {Reqs,Buffer0} = rpc_protocol:decode(Data, Buffer),
  Reps = handle_request(Reqs),
  {Reps,State#state{buffer = Buffer0}}.

handle_request([]) -> undefined;
handle_request(Reqs) ->
  handle_request(Reqs,[]).
handle_request([],Acc)-> lists:reverse(Acc);
handle_request([{Module,Function,Params}|T],Acc)->
  Rep = erlang:apply(Module,Function, Params),
  handle_request(T,[Rep|Acc]).

reply([],State)-> State;
reply([Rep|T],#state{transport = Transport,
                     socket = Socket} = State) ->
  Frame = rpc_protocol:encode(Rep),
  case Transport:send(Socket,Frame) of
    ok -> reply(T,State);
    _ -> ok
  end.
