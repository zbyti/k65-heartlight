K65=${K65_HOME}/bin/k65

all: main

main:
	$(K65) @main.k65proj

build:
	scripts/lv_bin.pl

save:
	cp /dev/shm/main.xex bin/game.xex