PROJECT = egame
PROJECT_DESCRIPTION = A web MUD game
PROJECT_VERSION = 0.1.0

ERLC_OPTS = -Werror +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard


DEPS = cowboy jiffy bcrypt ailib aiconf aihtml aidb

dep_cowboy_commit = 2.7.0
dep_bcrypt_commit = 1.0.2
dep_jiffy_commit = 1.0.1

dep_ailib = git https://github.com/DavidAlphaFox/ailib.git tag-0.4.1
dep_aiconf = git https://github.com/DavidAlphaFox/aiconf.git tag-0.1.3
dep_aidb = git https://github.com/DavidAlphaFox/aidb.git v0.3.4
dep_aihtml = git https://github.com/DavidAlphaFox/aihtml.git v0.3.4

include erlang.mk
