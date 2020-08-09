-ifndef(_tutorial_types_included).
-define(_tutorial_types_included, yeah).
-include("shared_types.hrl").


-define(TUTORIAL_OPERATION_ADD, 1).
-define(TUTORIAL_OPERATION_SUBTRACT, 2).
-define(TUTORIAL_OPERATION_MULTIPLY, 3).
-define(TUTORIAL_OPERATION_DIVIDE, 4).

%% struct 'Work'

-record('Work', {'num1' = 0 :: integer(),
                 'num2' :: integer(),
                 'op' :: integer(),
                 'comment' :: string() | binary()}).
-type 'Work'() :: #'Work'{}.

%% struct 'InvalidOperation'

-record('InvalidOperation', {'whatOp' :: integer(),
                             'why' :: string() | binary()}).
-type 'InvalidOperation'() :: #'InvalidOperation'{}.

-endif.
