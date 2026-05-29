PORTNAME=		endless-sky
DISTVERSION=	g20260528
CATEGORIES=		games
MASTER_SITES=   GH
PKGNAMESUFFIX=  -dev

MAINTAINER=		nope@nothere
COMMENT=		Space exploration and combat game similar to Escape Velocity
WWW=			https://endless-sky.github.io/

LICENSE=				GPLv3+ GPLv2 CC-BY-2.0 CC-BY-3.0 CC-BY-4.0 CC-BY-SA-3.0 CC-BY-SA-4.0 PD CC0-1.0
LICENSE_COMB=			multi
LICENSE_FILE=			${WRKSRC}/copyright
LICENSE_FILE_GPLv3+ =	${WRKSRC}/license.txt

LIB_DEPENDS=	libmad.so:audio/libmad \
				libuuid.so:misc/libuuid \
				libminizip.so:archivers/minizip \
				libavif.so:graphics/libavif \
				libpng16.so:graphics/png \
				libFLAC++.so:audio/flac \
				libSDL2-2.0.so:devel/sdl20

USES=			cmake compiler:c++11-lang jpeg openal pkgconfig gl #sdl
USE_GITHUB=		yes
GH_ACCOUNT=		endless-sky
GH_PROJECT=		endless-sky
GH_TAGNAME=		52eb37a88fb0956ff7629e5d334b696f1ad13a16

#USE_SDL=		sdl2
USE_GL=			opengl glew
CMAKE_OFF=		ES_USE_VCPKG \
				CMAKE_CXX_SCAN_FOR_MODULES
CMAKE_ARGS=		-DCMAKE_INSTALL_DOCDIR="${DOCSDIR}" \
				-DCMAKE_INSTALL_PREFIX="/usr/local"

CONFLICTS=		endless-sky

OPTIONS_DEFINE=			DEBUG DOCS TEST

DEBUG_DESC=				Select Debug build by -DCMAKE_BUILD_TYPE=Debug
DEBUG_ON_CMAKE_ARGS+=	-DCMAKE_BUILD_TYPE="Debug"
DEBUG_OFF_CMAKE_ARGS+=	-DCMAKE_BUILD_TYPE="Release"
TEST_CMAKE_BOOL=		BUILD_TESTING
TEST_BUILD_DEPENDS=		catch2>=0:devel/catch2

post-build:
	@${REINPLACE_CMD} -e 's|/usr/local/|${PREFIX}/|; s|share/games|share|' \
		${WRKSRC}/source/Files.cpp

do-test-TEST-on:
	@cd ${TEST_WRKSRC} && ${SETENV} ${TEST_ENV} ${LOCALBASE}/bin/ctest -V

.include <bsd.port.mk>
