PROJECT = egame
PROJECT_DESCRIPTION = A web MUD game
PROJECT_VERSION = 0.1.0

ERLC_OPTS = -Werror +debug_info +warn_export_vars +warn_shadow_vars +warn_obsolete_guard


DEPS = cowboy jiffy bcrypt aiconf aicow

dep_cowboy_commit = 2.7.0
dep_bcrypt_commit = 1.0.2
dep_jiffy_commit = 1.0.1

dep_aiconf = git https://github.com/DavidAlphaFox/aiconf.git v0.1.5
dep_aicow = git https://github.com/DavidAlphaFox/aicow.git v0.1.4

include erlang.mk
