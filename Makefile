# Portname block -------------------------------------
PORTNAME=		endless-sky
DISTVERSION=		g20260927
CATEGORIES=		games
MASTER_SITES=		GH
PKGNAMESUFFIX=  	-dev

# Maintainer block -----------------------------------
MAINTAINER=		nope@nothere
COMMENT=		Space exploration and combat game similar to Escape Velocity
WWW=			https://endless-sky.github.io/

# License block --------------------------------------
LICENSE=		GPLv3+ GPLv2 CC-BY-2.0 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-3.0 CC-BY-SA-4.0 PD CC0-1.0
LICENSE_COMB=		multi
LICENSE_FILE_GPLv3+ =	${WRKSRC}/license.txt
LICENSE_FILE=		${WRKSRC}/copyright

# Dependencies ---------------------------------------
LIB_DEPENDS=		libmad.so:audio/libmad \
			libuuid.so:misc/libuuid \
			libminizip.so:archivers/minizip \
			libavif.so:graphics/libavif \
			libpng16.so:graphics/png \
			libFLAC++.so:audio/flac \
			libSDL2-2.0.so:devel/sdl20

# USES block -----------------------------------------
USES=			cmake compiler:c++11-lang jpeg openal pkgconfig gl sdl
USE_GITHUB=		yes
GH_ACCOUNT=		endless-sky
GH_PROJECT=		endless-sky
GH_TAGNAME=		4dcdc5a9ae6faa7be427976e4affffea25d28373

USE_GL=			opengl glew
USE_SDL=		sdl

# USES=cmake related variables -----------------------
CMAKE_ARGS=		-DCMAKE_INSTALL_DOCDIR="${DOCSDIR}" \
			-DCMAKE_INSTALL_PREFIX="${LOCALBASE}" \
			-DCMAKE_CXX_SCAN_FOR_MODULES="OFF"

# Conflicts ------------------------------------------
CONFLICTS=		endless-sky

# Options definitions --------------------------------
OPTIONS_DEFINE=		DEBUG DOCS GLES SDL3 TEST
OPTIONS_DEFAULT=	DOCS GLES SDL3

# Options descriptions -------------------------------
DEBUG_DESC=		Select Debug build by -DCMAKE_BUILD_TYPE=Debug
GLES_DESC=		Build the game with OpenGL ES
#STEAM_DESC=		Build the game for the Steam Linux runtime
SDL3_DESC=		Use the newer SDL3 libraries instead of SDL2

# Options helpers ------------------------------------
DEBUG_CMAKE_ON=		-DCMAKE_BUILD_TYPE="Debug"
DEBUG_CMAKE_OFF=	-DCMAKE_BUILD_TYPE="Release"
GLES_USE=		GL+=glesv2
GLES_CMAKE_BOOL=	ES_GLES
SDL3_CMAKE_BOOL=	ES_USE_SDL3
#STEAM_CMAKE_BOOL=	ES_STEAM
#STEAM_BUILD _DEPENDS=	ES_STEAM
TEST_BUILD_DEPENDS=	catch2>=0:devel/catch2
TEST_CMAKE_BOOL=	BUILD_TESTING

.include <bsd.port.options.mk>

.if !${PORT_OPTIONS:MSDL3}
USE_SDL=sdl2
.endif

.if ${PORT_OPTIONS:MSDL3}
USE_SDL=sdl3
.endif

#------------------------------------------------------------------------------
# BUILD_TESTING:BOOL=ON
# CMAKE_BUILD_TYPE:STRING=
# CMAKE_CONFIGURATION_TYPES:STRING=Debug;Release
# CMAKE_CXX_STANDARD:STRING=20
# CMAKE_INSTALL_PREFIX:PATH=/usr/local
# Catch2_DIR:PATH=/usr/local/lib/cmake/Catch2
# ES_GLES:BOOL=OFF
# ES_STEAM:BOOL=OFF
# ES_USE_SDL3:BOOL=OFF
# ES_USE_VCPKG:BOOL=OFF
# FLAC_DIR:PATH=FLAC_DIR-NOTFOUND
# GLEW_DIR:PATH=GLEW_DIR-NOTFOUND
# LIBMAD_INCLUDE_DIR:PATH=/usr/local/include
# LIBMAD_LIB_DEBUG:FILEPATH=/usr/local/lib/libmad.so
# LIBMAD_LIB_RELEASE:FILEPATH=/usr/local/lib/libmad.so
# MINIZIP_LIBRARIES:FILEPATH=/usr/local/lib/libminizip.so
# OpenAL_DIR:PATH=/usr/local/lib/cmake/OpenAL
# SDL2_DIR:PATH=/usr/local/lib/cmake/SDL2
# UUID_LIB:FILEPATH=/usr/local/lib/libuuid.so
# libavif_DIR:PATH=/usr/local/lib/cmake/libavif
#------------------------------------------------------------------------------

post-build:
	@${REINPLACE_CMD} -e 's|/usr/local/|${PREFIX}/|; s|share/games|share|' \
		${WRKSRC}/source/Files.cpp

do-test-TEST-on:
	@cd ${TEST_WRKSRC} && ${SETENV} ${TEST_ENV} ${LOCALBASE}/bin/ctest -V

.include <bsd.port.mk>
