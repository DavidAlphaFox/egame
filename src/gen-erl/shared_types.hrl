-ifndef(_shared_types_included).
-define(_shared_types_included, yeah).

%% struct 'SharedStruct'

-record('SharedStruct', {'key' :: integer(),
                         'value' :: string() | binary()}).
-type 'SharedStruct'() :: #'SharedStruct'{}.

-endif.
