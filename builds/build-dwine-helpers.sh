#!/bin/bash

cd ~/Development/ewsldc/ldc-wine

echo "   ********************************************"
echo "   ****"
echo "   **** removing dwine container"
echo "   ****"
echo "   ********************************************"
echo
docker stop ldc-wine-dwine-helpers-0.1.0-b1 > /dev/null 2>&1
docker rm ldc-wine-dwine-helpers-0.1.0-b1 > /dev/null 2>&1

echo "   ********************************************"
echo "   ****"
echo "   **** removing dwine image"
echo "   ****"
echo "   ********************************************"
echo
docker rmi ewsdocker/ldc-wine:dwine-helpers-0.1.0-b1 > /dev/null 2>&1

# ===========================================================================
#
#    ldc-wine:dwine-helpers-0.1.0-b1
#
# ===========================================================================

echo "   ***************************************************"
echo "   ****"
echo "   **** building ewsdocker/ldc-wine:dwine-helpers-0.1.0-b1 image "
echo "   ****"
echo "   ***************************************************"
echo

docker build \
  --build-arg RUN_APP="iw-helpers" \
  \
  --build-arg BUILD_DAEMON="1" \
  --build-arg BUILD_TEMPLATE="gui" \
  \
  --build-arg BUILD_NAME="ldc-wine" \
  --build-arg BUILD_VERSION="dwine-helpers" \
  --build-arg BUILD_VERS_EXT="-0.1.0" \
  --build-arg BUILD_EXT_MOD="-b1" \
  \
  --build-arg FROM_REPO="ewsdocker" \
  --build-arg FROM_PARENT="ldc-wine" \
  --build-arg FROM_VERS="dwine" \
  --build-arg FROM_EXT="-0.1.0" \
  --build-arg FROM_EXT_MOD="-b1" \
  \
  --build-arg WINETRICKS_HOST="http://alpine-nginx-pkgcache" \
  --build-arg WINETRICKS_VERSION="0.0+20190912-1" \
  \
  --build-arg MONO_HOST="http://alpine-nginx-pkgcache" \
  --build-arg MONO_VERSION="4.9.2" \
  \
  --build-arg LIB_INSTALL="0" \
  --build-arg LIB_VERSION="0.1.6" \
  --build-arg LIB_VERS_MOD="-b1" \
  \
  --build-arg LIB_HOST="http://alpine-nginx-pkgcache" \
  --network=pkgnet \
  \
  --file Dockerfile.dwine-helpers \
-t ewsdocker/ldc-wine:dwine-helpers-0.1.0-b1  .
[[ $? -eq 0 ]] ||
 {
 	echo "build ewsdocker/ldc-wine:dwine-helpers-0.1.0-b1 failed."
 	exit 1
 }

echo "   ***********************************************"
echo "   ****"
echo "   **** installing ldc-wine-dwine-helpers-0.1.0-b1 container"
echo "   ****"
echo "   ***********************************************"
echo

docker run \
  -it \
  -e LRUN_APP="/bin/bash" \
  \
  -e LMS_BASE="${HOME}/.local" \
  -e LMS_HOME="${HOME}" \
  -e LMS_CONF="${HOME}/.config" \
  \
  -v ${HOME}/bin:/userbin \
  -v ${HOME}/.local:/usrlocal \
  -v ${HOME}/.config/docker:/conf \
  -v ${HOME}/.config/docker/ldc-wine-dwine-helpers-0.1.0:/root \
  -v ${HOME}/.config/docker/ldc-wine-dwine-helpers-0.1.0/workspace:/workspace \
  -v ${HOME}/.config/docker/ldc-wine-dwine-helpers-0.1.0/workspace/opt:/opt \
  \
  -v ${HOME}/source:/repo \
  -v ${HOME}/Downloads:/Downloads \
  \
  -e DISPLAY=unix${DISPLAY} \
  -v ${HOME}/.Xauthority:/root/.Xauthority \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev/shm:/dev/shm \
  --device /dev/snd \
  \
  --network=pkgnet \
  \
  -it \
  --name=ldc-wine-dwine-helpers-0.1.0-b1 \
ewsdocker/ldc-wine:dwine-helpers-0.1.0-b1
[[ $? -eq 0 ]] ||
 {
 	echo "build container ldc-wine-dwine-helpers-0.1.0-b1 failed."
 	exit 1
 }

echo "   ********************************************"
echo "   ****"
echo "   **** ldc-wine:dwine-helpers successfully installed."
echo "   ****"
echo "   ********************************************"
echo

exit 0

