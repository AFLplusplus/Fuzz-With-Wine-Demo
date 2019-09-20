all:
	gcc -m32 -fPIC -shared unsigaction.c -o unsigaction32.so
	gcc -fPIC -shared unsigaction.c -o unsigaction64.so
