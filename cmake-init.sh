export CAKE_ROOT="$PWD/.cake_root"
export PATH="$PWD/.cake_root/bin":$PATH

if test ! -f "$CAKE_ROOT/Cake.cmake" ; then
    git clone https://github.com/tamaskenez/cake ${CAKE_ROOT}
fi

for package in ZLIB PNG OpenSSL CURL glfw3 libuv libjpeg libzip sqlite3 #GLEW nunicode
do
    if ! cakepkg INSTALL $package; then
        echo "cakepkg error with package $package"
        break
    fi
    #echo "cakepkg INSTALL $package"
done


