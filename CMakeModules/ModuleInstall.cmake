# INSTALL and SOURCE_GROUP commands for libcoin Modules

# Required Vars:
# ${LIB_NAME}
# ${TARGET_H}

SET(INSTALL_INCDIR include)
SET(INSTALL_BINDIR bin)
IF(WIN32)
    SET(INSTALL_LIBDIR bin)
    SET(INSTALL_ARCHIVEDIR lib)
ELSE()
    SET(INSTALL_LIBDIR lib${LIB_POSTFIX})
    SET(INSTALL_ARCHIVEDIR lib${LIB_POSTFIX})
ENDIF()

SET(HEADERS_GROUP "Header Files")

#SOURCE_GROUP(
#    ${HEADERS_GROUP}
#    FILES ${TARGET_H}
#)

IF(MSVC AND LIBCOIN_MSVC_VERSIONED_DLL)
    HANDLE_MSVC_DLL()
ENDIF()

IF(ANDROID)
    INSTALL (
        FILES        ${TARGET_H}
        DESTINATION ${INSTALL_INCDIR}/${LIB_NAME}
        COMPONENT libcoin-dev
    )
ELSE(ANDROID)

INSTALL(
    TARGETS ${LIB_NAME}
    RUNTIME DESTINATION ${INSTALL_BINDIR} COMPONENT libcoin
    LIBRARY DESTINATION ${INSTALL_LIBDIR} COMPONENT libcoin
    ARCHIVE DESTINATION ${INSTALL_ARCHIVEDIR} COMPONENT libcoin-dev    
)

IF(NOT LIBCOIN_COMPILE_FRAMEWORKS)
    INSTALL (
        FILES        ${TARGET_H}
        DESTINATION ${INSTALL_INCDIR}/${LIB_NAME}
        COMPONENT libcoin-dev
    )
ELSE()
    SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    SET(CMAKE_INSTALL_RPATH "${LIBCOIN_COMPILE_FRAMEWORKS_INSTALL_NAME_DIR}")
    
    SET_TARGET_PROPERTIES(${LIB_NAME} PROPERTIES
         FRAMEWORK TRUE
         FRAMEWORK_VERSION ${OPENSCENEGRAPH_SOVERSION}
         PUBLIC_HEADER  "${TARGET_H}"
         INSTALL_NAME_DIR "${LIBCOIN_COMPILE_FRAMEWORKS_INSTALL_NAME_DIR}"
    )
    # MESSAGE("${LIBCOIN_COMPILE_FRAMEWORKS_INSTALL_NAME_DIR}")
ENDIF()

ENDIF(ANDROID)
