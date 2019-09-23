#!/bin/bash

cd ~/Development/ewsldc/ldc-wine

echo "   ********************************************"
echo "   ****"
echo "   **** removing dwine container"
echo "   ****"
echo "   ********************************************"
echo
docker stop ldc-wine-dwine-0.1.0 > /dev/null 2>&1
docker rm ldc-wine-dwine-0.1.0 > /dev/null 2>&1

echo "   ********************************************"
echo "   ****"
echo "   **** removing dwine image"
echo "   ****"
echo "   ********************************************"
echo
docker rmi ewsdocker/ldc-wine:dwine-0.1.0 > /dev/null 2>&1

# ===========================================================================
#
#    ldc-wine:dwine-0.1.0
#
# ===========================================================================

echo "   ***************************************************"
echo "   ****"
echo "   **** building ewsdocker/ldc-wine:dwine-0.1.0 image "
echo "   ****"
echo "   ***************************************************"
echo

docker build \
  --build-arg RUN_APP="" \
  --build-arg BUILD_DAEMON="1" \
  --build-arg BUILD_TEMPLATE="gui" \
  \
  --build-arg BUILD_NAME="ldc-wine" \
  --build-arg BUILD_VERSION="dwine" \
  --build-arg BUILD_VERS_EXT="-0.1.0" \
  --build-arg BUILD_EXT_MOD="" \
  \
  --build-arg FROM_REPO="ewsdocker" \
  --build-arg FROM_PARENT="ldc-lang" \
  --build-arg FROM_VERS="dgtk" \
  --build-arg FROM_EXT="-0.1.0" \
  --build-arg FROM_EXT_MOD="-gtk2" \
  \
  --build-arg MONO_INSTALL="1" \
  --build-arg MONO_HOST="http://alpine-nginx-pkgcache" \
  \
  --build-arg WINETRICKS_INSTALL="1" \
  --build-arg WINETRICKS_HOST="http://alpine-nginx-pkgcache" \
  \
  --build-arg LIB_INSTALL="0" \
  --build-arg LIB_HOST="http://alpine-nginx-pkgcache" \
  \
   --network=pkgnet \
  \
  --file Dockerfile.dwine \
  -t ewsdocker/ldc-wine:dwine-0.1.0  .
[[ $? -eq 0 ]] ||
 {
 	echo "build ewsdocker/ldc-wine:dwine-0.1.0 failed."
 	exit 1
 }

echo "   ***********************************************"
echo "   ****"
echo "   **** installing ldc-wine-dwine-0.1.0 container"
echo "   ****"
echo "   ***********************************************"
echo

docker run \
  -e LRUN_APP="/bin/bash" \
  \
  -e LMS_BASE="${HOME}/.local" \
  -e LMS_HOME="${HOME}" \
  -e LMS_CONF="${HOME}/.config" \
  \
  -e WMONO_HOST="http://alpine-nginx-pkgcache" \
  -e WMONO_INST="1" \
  \
  -e WTRICKS_HOST="http://alpine-nginx-pkgcache" \
  -e WTRICKS_INST="1" \
  \
  -v ${HOME}/bin:/userbin \
  -v ${HOME}/.local:/usrlocal \
  -v ${HOME}/.config/docker:/conf \
  -v ${HOME}/.config/docker/ldc-wine-dwine-0.1.0:/root \
  -v ${HOME}/.config/docker/ldc-wine-dwine-0.1.0/workspace:/workspace \
  \
  -v ${HOME}/source:/repo \
  -v ${HOME}/Downloads:/Downloads \
  \
  --network=pkgnet \
  \
  -e DISPLAY=unix${DISPLAY} \
  -v ${HOME}/.Xauthority:/root/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev/shm:/dev/shm \
  --device /dev/snd \
  \
  -it \
  --name=ldc-wine-dwine-0.1.0 \
ewsdocker/ldc-wine:dwine-0.1.0
[[ $? -eq 0 ]] ||
 {
 	echo "build container ldc-wine-dwine-0.1.0 failed."
 	exit 1
 }

echo "   ********************************************"
echo "   ****"
echo "   **** ldc-wine:dwine successfully installed."
echo "   ****"
echo "   ********************************************"
echo

exit 0

