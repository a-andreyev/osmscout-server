# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = osmscout-server

QT = core network sql xml

CONFIG += c++11

CONFIG += use_map_qt
#CONFIG += use_map_cairo

!disable_mapnik {
   CONFIG += use_mapnik
}
!disable_valhalla {
   CONFIG += use_valhalla
}
!disable_systemd {
   CONFIG += use_systemd
}

# installs
stylesheets.files = stylesheets
stylesheets.path = /usr/share/$${TARGET}
INSTALLS += stylesheets

data.files = data
data.path = /usr/share/$${TARGET}
INSTALLS += data

# defines
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += IS_CONSOLE_QT

SOURCES += src/dbmaster.cpp \
    src/main.cpp \
    src/requestmapper.cpp \
    src/appsettings.cpp \
    src/dbmaster_search.cpp \
    src/dbmaster_map.cpp \
    src/osmscout-server_console.cpp \
    src/searchresults.cpp \
    src/infohub.cpp \
    src/consolelogger.cpp \
    src/dbmaster_route.cpp \
    src/routingforhuman.cpp \
    src/geomaster.cpp \
    src/config.cpp \
    src/mapmanager.cpp \
    src/filedownloader.cpp \
    src/mapmanagerfeature.cpp \
    src/mapmanagerfeature_packtaskworker.cpp \
    src/mapnikmaster.cpp \
    src/valhallamaster.cpp \
    src/mapmanager_deleterthread.cpp \
    src/modulechecker.cpp \
    src/systemdservice.cpp \
    src/util.cpp

OTHER_FILES += \
    osmscout-server.desktop

include(src/uhttp/uhttp.pri)
include(src/geocoder-nlp/geocoder-nlp.pri)

HEADERS += \
    src/dbmaster.h \
    src/requestmapper.h \
    src/appsettings.h \
    src/config.h \
    src/searchresults.h \
    src/infohub.h \
    src/consolelogger.h \
    src/routingforhuman.h \
    src/geomaster.h \
    src/mapmanager.h \
    src/filedownloader.h \
    src/mapmanagerfeature.h \
    src/mapmanagerfeature_packtaskworker.h \
    src/mapnikmaster.h \
    src/valhallamaster.h \
    src/mapmanager_deleterthread.h \
    src/modulechecker.h \
    src/systemdservice.h \
    src/util.hpp

use_map_qt {
    DEFINES += USE_OSMSCOUT_MAP_QT
    QT += gui
    LIBS += -losmscout_map_qt
}

use_map_cairo {
    DEFINES += USE_OSMSCOUT_MAP_CAIRO
    LIBS += -losmscout_map_cairo
    CONFIG += link_pkgconfig
    PKGCONFIG += pango cairo
}

use_mapnik {
    DEFINES += USE_MAPNIK
    #DEFINES += MAPNIK_FONTS_DIR=\\\"$$system(mapnik-config --fonts)\\\"
    DEFINES += MAPNIK_FONTS_DIR=\\\"modules/fonts/fonts\\\"
    DEFINES += MAPNIK_INPUT_PLUGINS_DIR=\\\"$$system(mapnik-config --input-plugins)\\\"
    LIBS += -lmapnik -licuuc
}

use_valhalla {
    DEFINES += USE_VALHALLA
    DEFINES += VALHALLA_EXECUTABLE=\\\"../valhalla/install/bin/valhalla_route_service\\\"
    DEFINES += VALHALLA_CONFIG_TEMPLATE=\\\"modules/route/data/valhalla.json\\\"
    CONFIG += use_curl
}

use_curl {
    DEFINES += USE_LIBCURL
    CONFIG += link_pkgconfig
    PKGCONFIG += libcurl
}

use_systemd {
    DEFINES += USE_SYSTEMD
    CONFIG += link_pkgconfig
    PKGCONFIG += libsystemd
}

LIBS += -losmscout_map -losmscout -lmarisa -lkyotocabinet -lz -lsqlite3

QMAKE_CXXFLAGS += -fopenmp
LIBS += -fopenmp

CONFIG(release, debug|release) {
    DEFINES += QT_NO_WARNING_OUTPUT QT_NO_DEBUG_OUTPUT
}
